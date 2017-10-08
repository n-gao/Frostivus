frostivus_fireball = frostivus_fireball or class({});

function frostivus_fireball:OnSpellStart(args)
    if not IsServer() then return end
    local caster = self:GetCaster();
    local damage = self:GetAbilityDamage();
    local damageType = self:GetAbilityDamageType();
    local duration = self:GetSpecialValueFor("duration");
    local interval = self:GetSpecialValueFor("burn_interval");
    local teamNumber = caster:GetTeamNumber();
    local radius = self:GetSpecialValueFor("radius");
    local position = caster:GetAbsOrigin();

    --visual and sound
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_1);
    caster:EmitSound("Hero_Jakiro.Macropyre.Cast");
    --particle
    local dummy = CreateUnitByName("frostivus_dummy", position, false, nil, nil, caster:GetTeamNumber());
	local particleName = "particles/units/heroes/hero_jakiro/jakiro_macropyre.vpcf";
    local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, dummy);
    local forward = caster:GetForwardVector();
	ParticleManager:SetParticleControl(particle, 0, position - forward * radius/2);
	ParticleManager:SetParticleControl(particle, 1, position);
    ParticleManager:SetParticleControl(particle, 2, Vector(duration, 0, 0));
	ParticleManager:SetParticleControl(particle, 3, position + forward * radius/2);
    --Damage ticks
    local damageTimer = Timers:CreateTimer(interval, function ()
        local targets = FindUnitsInRadius(teamNumber, 
            position, 
            nil, 
            radius, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_ALL, 
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_ANY_ORDER, 
            false);
        for _, target in pairs(targets) do
            ApplyDamage({
                victim = target,
                attacker = caster,
                damage = damage / interval,
                damage_type = damageType,
                damage_flags = DOTA_DAMAGE_FLAG_NONE,
                ability = self
            });
        end
        return interval;
    end);
    --Destroy everything after the timer ends
    Timers:CreateTimer(duration, function()
        dummy:Destroy();
        Timers:RemoveTimer(damageTimer);
    end);
end
