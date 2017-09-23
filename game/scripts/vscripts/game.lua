require("player");

GAMESTATE_PREPARATION = 0;
GAMESTATE_RUNNING = 1;
GAMESTATE_END = 2;

Game = class({
    _gameState = GAMESTATE_PREPARATION,
    _gameTimer = nil,
    players = {},
    roshan = nil,

    constructor = function(self)
        self._gameTimer = Timers:CreateTimer(0, function()
            return self:OnThink();
        end);
        ListenToGameEvent("player_connect_full", Dynamic_Wrap(Game, "OnPlayerConnectFull"), self);
        ListenToGameEvent('player_disconnect', Dynamic_Wrap(Game, 'OnPlayerDisconnect'), self)
        ListenToGameEvent("npc_spawned", Dynamic_Wrap(Game, "OnNpcSpawned"), self);
        instance = self;
    end
}, {
    instance = nil
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
    if (roshan == nil) then
        error("Roshan can not be set to null.");
    end
    self.roshan = roshan;
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

Game.instance = Game();
