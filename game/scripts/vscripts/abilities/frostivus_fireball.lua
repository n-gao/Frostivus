frostivus_fireball = frostivus_fireball or class({});

function frostivus_fireball:OnSpellStart(args)
    self:GetParent():EmitSound("Hero_Jakiro.Macropyre.Cast");
    self.damage = self:GetAbilityDamage();
    self.damageType = self:GetAbilityDamageType();
    self.duration = self:GetSpecialValueFor("duration");
    self.interval = self:GetSpecialValueFor("burn_interval");
    self.teamNumber = self:GetParent():GetTeamNumber();
    self.radius = self:GetSpecialValueFor("radius");

    DeepPrintTable(args);
    local position = self:GetParent():GetAbsOrigin();
	local particleName = "particles/units/heroes/hero_jakiro/jakiro_macropyre.vpcf";
    self.particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, position);
	ParticleManager:SetParticleControl(self.partcile, 0, position);
	ParticleManager:SetParticleControl(self.partcile, 1, position);
    ParticleManager:SetParticleControl(self.particle, 2, Vector(self.duration, 0, 0));
	ParticleManager:SetParticleControl(self.partcile, 3, position);

    Timers:CreateTimer(self.interval,function ()
        local targets = FindUnitsInRadius(self.teamNumber, 
            position, 
            nil, 
            self.radius, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_ALL, 
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_ANY_ORDER, 
            false);
        for _, target in pairs(targets) do
            ApplyDamage({
                victim = target,
                attacker = self:GetParent(),
                damage = self.damage / self.interval,
                damage_type = self.damageType,
                damage_flags = DOTA_DAMAGE_FLAG_NONE,
                ability = self
            });
        end
        return self.interval;
    end);
end
