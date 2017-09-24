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
    FireGameEvent("quest_fullfilled", {
        playerId = self:GetPlayerId(),
        questName = quest.name,
        points = quest:GetPoints()
    });
    print("[Player] "..self:GetPlayerId().." has "..self:GetPoints().." points now.");
end

function Player:Disconnect()
    self.disconnected = true;
end
