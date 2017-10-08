require("giftquest");

Player = Player or class({
    playerId = 0,
    userId = 0,
    hero = nil,
    playerEntity = nil,
    disconnected = false,
    fullfilledQuests = {},
    timer = nil,

    constructor = function(self, ent, id)
        self:SetPlayerEntity(ent);
        self.userId = id;
        self.playerId = self.playerEntity:GetPlayerID();
        self.timer = Timers:CreateTimer(0, function()
            return self:OnThink();
        end);
    end
});

function Player:OnThink( ... )
    
end

function Player:GetPlayerEntity()
    return PlayerResource:GetPlayer(self:GetPlayerId());
end

function Player:SetPlayerEntity(entity)
    self.playerEntity = entity;
    self.disconnected = entity ~= nil;
end

function Player:SetHero(hero)
    self.hero = hero;
    hero.player = self;
end

function Player:GetHero()
    return self.hero;
end

function Player:GetPlayerId()
    return self.playerId;
end

function Player:HasHero()
    return self.hero ~= nil;
end

function Player:GetTeamNumber()
    return PlayerResource:GetTeam(self:GetPlayerId());
end

function Player:GetPoints()
    local result = 0;
    for _, quest in pairs(self.fullfilledQuests) do
        result = result + quest:GetPoints();
    end
    return result;
end

function Player:GetGiftCount()
    if self:GetHero() == nil then
        return 0;
    end
    return self:GetHero():GetModifierStackCount("modifier_item_gift_lua", self:GetHero());
end

function Player:GetTeamPoints()
    return Game.GetInstance():GetTeamPoints(self:GetTeamNumber());
end

function Player:RemoveGifts()
    if self:GetHero() == nil then
        return;
    end
    self:GetHero():RemoveModifierByName("modifier_item_gift_lua");
end

function Player:FullfillQuest(quest)
    if not instanceof(quest, Quest) then
        error("A quest must be used to call this method.");
    end
    table.insert(self.fullfilledQuests, quest);
    local game = Game.GetInstance();
    local bounty = game:GetGiftBounty();
    self:GetHero():AddExperience(quest:GetExperienceBounty(), DOTA_ModifyXP_Unspecified, false, false);
    self:GetHero():ModifyGold(quest:GetGoldBounty(), true, DOTA_ModifyGold_Unspecified);
    self:ShareScored(quest:GetPoints());
end

function Player:ShareScored(points)
    local game = Game.GetInstance();
    local pointLimit = game:GetPointLimit();
    local teamPoints  = self:GetTeamPoints();
    local args = {
        player_id = self:GetPlayerId(),
        team = self:GetTeamNumber(),
        new_points = points,
        total_points = self:GetPoints(),
        team_points = teamPoints,
        points_remaining = pointLimit - teamPoints,
        victory = pointLimit <= teamPoints,
        close_to_victory = game:GetCloseToVictoryLimit() <= teamPoints,
        very_close_to_victory = game:GetVeryCloseToVictoryLimit() <= teamPoints
    };
    CustomGameEventManager:Send_ServerToAllClients("player_scored", args);
    Game.GetInstance():OnPlayerScored(args);
    if pointLimit <= teamPoints then
        game:EndGame(self:GetTeamNumber());
    end
end

function Player:Disconnect()
    self.disconnected = true;
end
