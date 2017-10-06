require("giftquest")

item_gift = item_gift or class({});
LinkLuaModifier("modifier_item_gift_lua", "items/item_gift.lua", LUA_MODIFIER_MOTION_NONE);

function item_gift:GetAbilityTextureName()
   return "alchemist_goblins_greed";
end

function item_gift:OnSpellStart()
end

modifier_item_gift_lua = modifier_item_gift_lua or class({});
function modifier_item_gift_lua:OnCreated()
    if not IsServer() then return end
    self.owner = self:GetAbility():GetCaster();
    self:SetStackCount(1);
    self:RefreshParticle();
end

function modifier_item_gift_lua:OnRefresh()
    if not IsServer() then return end
    self:SetStackCount(self:GetStackCount() + 1);
    self:RefreshParticle();
end

function modifier_item_gift_lua:RefreshParticle()
    if not IsServer() then return end
    local stackCount = self:GetStackCount();
    if self.particle then
        ParticleManager:DestroyParticle(self.particle, true);
    end
    local target = self:GetParent();
    self.particle = ParticleManager:CreateParticle("particles/gift_counter.vpcf", PATTACH_ABSORIGIN_FOLLOW, target);
    ParticleManager:SetParticleControlEnt(self.particle, 0, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true);
    ParticleManager:SetParticleControl(self.particle, 1, Vector(0, stackCount, 0));
    ParticleManager:SetParticleControl(self.particle, 2, Vector(0, #tostring(stackCount), 0));
    ParticleManager:SetParticleControl(self.particle, 3, Vector(0, 170, 0));
end

function modifier_item_gift_lua:IsDebuff()
    return false;
end

function modifier_item_gift_lua:IsHidden()
    return false;
end

function modifier_item_gift_lua:GetTexture()
    return "alchemist_goblins_greed";
end

function modifier_item_gift_lua:RemoveOnDeath()
    return false;
end

function modifier_item_gift_lua:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH
    };
end

function modifier_item_gift_lua:OnDeath(keys)
    if not IsServer() then return end
    if keys.unit == self:GetParent() then
        Timers:CreateTimer(0, function ()
            GiftQuest.DropGifts(self:GetCaster():GetAbsOrigin(), self:GetStackCount());
            self:Destroy();
        end)
    end
end

function modifier_item_gift_lua:OnRemoved()
    if not IsServer() then return end
    if self.particle then
        ParticleManager:DestroyParticle(self.particle, true);
    end
end
