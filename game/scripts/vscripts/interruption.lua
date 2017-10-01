if not Interruption then
    Interruption = class({
        timeStamp = 0,
        duration = -1,
        players = {},

        constructor = function(self, duration, players)
            self.timeStamp = GameRules:GetGameTime();
            self.duration = duration;
            self.players = players;
            self:Start();
        end,
    });
end

function Interruption:Start()
    for _, player in pairs(self.players) do
        local hero = player:GetHero();
        if hero and hero:HasModifier("modifier_interruption_lua") then
            hero:AddNewModifier(hero, nil, "modifier_interruption_lua", {
                duration = self.duration
            });
        end
    end
end

function Interruption:Stop()
    for _, player in pairs(self.players) do
        local hero = player:GetHero();
        if hero then
            hero:RemoveModifierByName("modifier_interruption_lua");
        end
    end
end

function Interruption:GetStartTime()
    return self.timeStamp;
end
