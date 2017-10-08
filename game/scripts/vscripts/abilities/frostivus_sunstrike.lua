frostivus_sunstrike = frostivus_sunstrike or class({});

function frostivus_sunstrike:OnSpellStart()
    if not IsServer() then return end;
    local damage = self:GetAbilityDamage();
    local damageType = self:GetAbilityDamageType();
    local radius = self:GetSpecialValueFor("radius");
    local delay = self:GetSpecialValueFor("delay");
    local particleName = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_immortal1.vpcf";
    local endParticlename = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf";
    local caster = self:GetCaster();

    local players = Game.GetInstance():GetPlayers();
    for _, player in pairs(players) do
        local hero = player:GetHero();
        if hero and hero:IsAlive() then
            local target = hero:GetAbsOrigin();
            --visual and sound
            local dummy = CreateUnitByName("frostivus_dummy", target, false, nil, nil, caster:GetTeamNumber());
            dummy:EmitSound("Hero_Invoker.SunStrike.Charge");
            local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, dummy);
            ParticleManager:SetParticleControl(particle, 0, target);
            ParticleManager:SetParticleControl(particle, 1, Vector(radius,0,0));
            
            Timers:CreateTimer(delay, function()
                ParticleManager:DestroyParticle(particle, false);
                --dealing damage to units in radius
                local targets = FindUnitsInRadius(
                    caster:GetTeamNumber(), 
                    target, 
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
                        damage = damage,
                        damage_type = damageType,
                        damage_flags = DOTA_DAMAGE_FLAG_NONE,
                        ability = self
                    });
                end
                --visual and sound
                local endParticle = ParticleManager:CreateParticle(endParticlename, PATTACH_ABSORIGIN, dummy);
                ParticleManager:SetParticleControl(endParticle, 0, target);
			    ParticleManager:SetParticleControl(endParticle, 1, Vector(radius,0,0));
                dummy:EmitSound("Hero_Invoker.SunStrike.Ignite");
                --destroy the dummy
                Timers:CreateTimer(1, function()
                    dummy:ForceKill(false);
                end);
            end);
        end
    end
end
