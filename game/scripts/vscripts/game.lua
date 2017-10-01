require("player");
require("utils");

Game = Game or class({
    _gameState = GAMESTATE_PREPARATION,
    _gameTimer = nil,
    players = {},
    greevils = {},
    waypoints = {},
    mapData = nil,
    roshan = nil,

    constructor = function(self)
        self._gameTimer = Timers:CreateTimer(0, function()
            return self:OnThink();
        end);

        ListenToGameEvent("player_connect_full", Dynamic_Wrap(Game, "OnPlayerConnectFull"), self);
        ListenToGameEvent('player_disconnect', Dynamic_Wrap(Game, 'OnPlayerDisconnect'), self)
        ListenToGameEvent("npc_spawned", Dynamic_Wrap(Game, "OnNpcSpawned"), self);
        ListenToGameEvent("entity_killed", Dynamic_Wrap(Game, "OnNpcKilled"), self);

        LinkLuaModifier("modifier_interruption_lua", "abilities/modifier_interruption_lua.lua", LUA_MODIFIER_MOTION_NONE);

        CustomGameEventManager:RegisterListener("player_scored", WrapObjectFunction(self, "OnPlayerScored"));

        self:LoadMapData();

        Timers:CreateTimer(FrameTime(), function()
            CustomNetTables:SetTableValue("game_state", "victory_condition", {
                points_to_win = self:GetPointLimit()
            });
            CustomNetTables:SetTableValue("game_state", "time_limit", {
                seconds = self:GetTimeLimit()
            });
            GameRules:SetPreGameTime(0);
            GameRules:SetShowcaseTime(0);
            GameRules:SetUseUniversalShopMode(true);
            GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(Game, "ExecuteOrderFilter"), self);
            GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(Dynamic_Wrap(Game, "ItemAddedFilter"), self)
        end);
    end
}, {
    _instance = nil,
});

function Game:LoadMapData()
    self.mapData = LoadKeyValues("scripts/maps/"..GetMapName()..".txt");
    Timers:CreateTimer(FrameTime(), function ()
        local names = self:GetWaypointNames();
        for ind, name in pairs(names) do
            local entity = Entities:FindByName(nil, name);
            if entity then
                table.insert(self.waypoints, entity);
                print("[Game] found waypoint "..name);
            else
                print("[Game] could not find waypoint "..name);
            end
        end
    end);
end

function Game:OnThink()
    local state = GameRules:State_Get();
    if state < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        self:OnThinkPreparation();
    end
    if state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        self:OnThinkRunning();
    end
    if state > DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        self:OnThinkEnd();
    end
    return 0.5;
end

function Game:OnThinkPreparation()

end

function Game:OnThinkRunning()
    if math.random() < 0.05 and #self:GetGreevils() < self:GetMaxGreevils() then
        CreateUnitByName("frostivus_greevil", self:GetRoshan():GetNpc():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS);
    end
    if GameRules:GetGameTime() >= self:GetTimeLimit() then
        self:EndGameByTime();
    end
end

function Game:OnThinkEnd()

end

function Game:EndGameByTime()
    local winner = 2;
    local highscore = 0;
    for i = 0, DOTA_TEAM_COUNT do
        local points = self:GetTeamPoints(i);
        if i > highscore then
            winner = i;
            highscore = points;
        end
    end
    self:EndGame(winner);
end

function Game:EndGame(winner)
    GameRules:SetGameWinner(winner);
end

function Game:SetRoshan(roshan)
    if not instanceof(roshan, Roshan) then
        error("The given value must be an instance of Roshan.");
    end
    self.roshan = roshan;
end

function Game:GetRoshan()
    return self.roshan;
end

function Game:AddGreevil(greevil)
    if not instanceof(greevil, Greevil) then
        error("The given value must be an instance of Greevil.");
    end
    table.insert(self.greevils, greevil:GetId(), greevil);
end

function Game:GetGreevils()
    local result = {};
    for key, greevil in pairs(self.greevils) do
        if greevil:IsAlive() then
            table.insert(result, greevil);
        end
    end
    return result;
end

function Game:GetMaxGreevils()
    return self.mapData.max_greevils;
end

function Game:GetTimeLimit()
    return self.mapData.time_limit_minutes * 60;
end

function Game:GetPointLimit()
    return self.mapData.point_limit;
end

function Game:GetVeryCloseToVictoryLimit()
    return self.mapData.very_close_to_victory;
end

function Game:GetCloseToVictoryLimit()
    return self.mapData.close_to_victory;
end

function Game:GetWaypoints()
    return shallowcopy(self.waypoints);
end

function Game:GetWaypointNames()
    return shallowcopy(self.mapData.waypoints);
end

function Game:GetTeamPoints(team)
    local result = 0;
    for _, player in pairs(self:GetPlayers()) do
        result = player:GetPoints();
    end
    return result;
end

function Game:OnPlayerScored(args)
    if args.victory then
        GameRules:SetGameWinner(args.team);
    end
    print("[Game] Team "..args.team.." has "..args.team_points.." points now.");
end

function Game:OnPlayerConnectFull(keys)
    local entIndex = keys.index + 1;
    local entity = EntIndexToHScript(entIndex);
    local playerId = entity:GetPlayerID();
    if not PlayerResource:IsBroadcaster(playerId) then
        local player = self:GetPlayer(playerId);
        if (player) then
            print("[Game] Player "..playerId.." reconnected.");
            player:SetPlayerEntity(entity);
        else
            print("[Game] Player "..playerId.."connected.");
            self.players[playerId] = Player(entity, keys.userid)
        end
    end
end

function Game:OnPlayerDisconnect(keys)
    for _,player in pairs(self.players) do
        if (player.userId == keys.userid) then
            player:Disconnect();
        end
    end
end

function Game:OnNpcSpawned(keys)
    local npc = EntIndexToHScript(keys.entindex);
    if npc and npc:IsRealHero() then
        local player = self:GetPlayer(npc:GetPlayerID());
        player:SetHero(npc);
    end
end

function Game:OnNpcKilled(keys)
    local victim = EntIndexToHScript(keys.entindex_killed);
    local murderer = EntIndexToHScript(keys.entindex_attacker);
    if instanceof(victim.unit, Unit) then
        victim.unit:OnDied(murderer);
    end
    if instanceof(murderer.unit, Unit) then
        murderer.unit:OnKilled(victim);
    end
end

function Game:ExecuteOrderFilter(keys)
    -- DeepPrintTable(keys);
    return true;
end

function Game:ItemAddedFilter(keys)
    local unit = EntIndexToHScript(keys.inventory_parent_entindex_const);
    local item = EntIndexToHScript(keys.item_entindex_const);
	local itemName = 0;
	if item:GetName() then
		itemName = item:GetName();
	end
    if itemName == "item_gift" then
        if unit:IsRealHero() then
            -- Apply gift modifier
            unit:AddNewModifier(unit, item, "modifier_item_gift_lua", {});
        else
            -- Create a new gift
            GiftQuest.DropGift(unit:GetAbsOrigin());
        end
        -- Destroy the item
        return false;
    end
    return true;
end

function Game:GetPlayer(playerId)
    return self.players[playerId] or nil;
end

function Game:GetPlayers()
    return shallowcopy(self.players);
end

function Game.GetInstance()
    if Game._instance == nil then
        Game._instance = Game();
    end
    return Game._instance;
end

Game.GetInstance();
