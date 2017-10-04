frostivus_fireball = frostivus_fireball or class({});

function frostivus_fireball:OnSpellStart(args)
    if not IsServer() then return end
    local caster = self:GetCaster();
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_1);
    caster:EmitSound("Hero_Jakiro.Macropyre.Cast");
    self.damage = self:GetAbilityDamage();
    self.damageType = self:GetAbilityDamageType();
    self.duration = self:GetSpecialValueFor("duration");
    self.interval = self:GetSpecialValueFor("burn_interval");
    self.teamNumber = caster:GetTeamNumber();
    self.radius = self:GetSpecialValueFor("radius");

    local position = caster:GetAbsOrigin();
    local dummy = CreateUnitByName("frostivus_dummy", position, false, nil, nil, caster:GetTeamNumber());
	local particleName = "particles/units/heroes/hero_jakiro/jakiro_macropyre.vpcf";
    self.particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, dummy);
    local forward = caster:GetForwardVector();
	ParticleManager:SetParticleControl(self.particle, 0, position - forward * self.radius);
	ParticleManager:SetParticleControl(self.particle, 1, position);
    ParticleManager:SetParticleControl(self.particle, 2, Vector(self.duration, 0, 0));
	ParticleManager:SetParticleControl(self.particle, 3, position + forward * self.radius);

    local damageTimer = Timers:CreateTimer(self.interval, function ()
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
                attacker = caster,
                damage = self.damage / self.interval,
                damage_type = self.damageType,
                damage_flags = DOTA_DAMAGE_FLAG_NONE,
                ability = self
            });
        end
        return self.interval;
    end);

    Timers:CreateTimer(self.duration, function()
        dummy:Destroy();
        Timers:RemoveTimer(damageTimer);
    end);
end
