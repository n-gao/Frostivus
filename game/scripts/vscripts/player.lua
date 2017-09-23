Player = class({
    playerId = 0,
    userId = 0,
    team = 0,
    hero = nil,
    playerEntity = nil,
    disconnected = false,
    fullfilledQuests = {}

    constructor = function(self, ent, id)
        self:SetPlayerEntity(ent);
        userId = id;
        playerId = self.playerEntity:GetPlayerID();
    end
});

function Player:SetPlayerEntity(entity)
    self.playerEntity = entity;
    self.disconnected = entity ~= nil;
end

function Player:SetHero(hero)
    self.hero = hero;
end

function Player:GetPlayerId()
    return playerId;
end

function Player:GetTeamNumber()
    return PlayerResource:GetTeam(self:GetPlayerId());
end

function Player:GetPoints()
    local result = 0;
    for _, quest in pairs(fullfilledQuests) do
        result += quest:GetPoints();
    end
    return result;
end

function Player:FullfilledQuest(quest)
    if (quest == nil) then
        error("Quest can not be null");
    end
    table.insert(self.fullfilledQuests, quest);
    FireGameEvent("quest_fullfilled", {
        playerId = self:GetPlayerId(),
        questName = quest.name,
        points = quest:GetPoints()
    });
end

function Player:Disconnect()
    self.disconnected = true;
end
