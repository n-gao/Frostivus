require("interruption");

frostivus_roshan_demand_gifts = frostivus_roshan_demand_gifts or class({});

function frostivus_roshan_demand_gifts:OnAbilityPhaseStart()
    self.interruption = Interruption(-1, Game.GetInstance():GetPlayers());
    self.roshan = Game.GetInstance():GetRoshan();
    self.roshan:ShowSpeechubble("frostivus_roshan_more_gifts", {}, 10, true);
    self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_1);
    Timers:CreateTimer(0, function ()
        if self.interruption:GetStartTime() - GameRules:GetGameTime() > 10 then
            
        end
        return 0.1;
    end);
    return true;
end
