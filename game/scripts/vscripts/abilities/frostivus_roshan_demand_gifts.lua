require("interruption");

frostivus_roshan_demand_gifts = frostivus_roshan_demand_gifts or class({});

function frostivus_roshan_demand_gifts:OnAbilityPhaseStart()
    self.interruption = Interruption(10, Game.GetInstance():GetPlayers());
    self.roshan = Game.GetInstance():GetRoshan();
    self.roshan:ShowSpeechubble("frostivus_roshan_more_gifts", {}, 10, true);
    self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_1);
    self.particle = ParticelManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf", PATTACH_EYES_FOLLOW, self:GetParent());
    Timers:CreateTimer(10, function ()
        ParticleManager:DestroyParticle(self.particle, false);
    end)
    return true;
end
