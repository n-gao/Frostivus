require("player");

GAMESTATE_PREPARATION = 0;
GAMESTATE_RUNNING = 1;
GAMESTATE_END = 2;

Game = Game or class({
    _gameState = GAMESTATE_PREPARATION,
    _gameTimer = nil,
    players = {},
    greevils = {},
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

        mapData = LoadKeyValues("scripts/maps/"..GetMapName()..".txt");

        Timers:CreateTimer(FrameTime(), function()
            GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(Game, "ExecuteOrderFilter"), self);
            GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(Dynamic_Wrap(Game, "ItemAddedFilter"), self)
        end);
    end
}, {
    _instance = nil,
});

function Game:OnThink()
    if self._gameState == GAMESTATE_PREPARATION then
        self:OnThinkPreparation();
    end
    if self._gameState == GAMESTATE_RUNNING then
        self:OnThinkRunning();
    end 
    if self._gameState == GAMESTATE_END then
        self:OnThinkEnd();
    end
    return 0.5;
end

function Game:OnThinkPreparation()

end

function Game:OnThinkRunning()

end

function Game:OnThinkEnd()

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

function Game:GetWaypoints()
    return self.mapData.waypoints;
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

function Game:SetGameState(newState)
    if type(newState) ~= number then
        error("GameState must be a number.");
    end
    if (newState < 0 or newState > 2) then
        error("Invalid value for GameState.");
    end
    self._gameState = newState;
end

function Game:GetGameState()
    return self._gameState;
end

function Game.GetInstance()
    if Game._instance == nil then
        Game._instance = Game();
    end
    return Game._instance;
end

Game.GetInstance();
