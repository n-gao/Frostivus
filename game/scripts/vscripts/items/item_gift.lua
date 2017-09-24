require("giftquest")

item_gift = item_gift or class({});
LinkLuaModifier("modifier_item_gift_lua", "items/item_gift.lua", LUA_MODIFIER_MOTION_NONE);

function item_gift:GetAbilityTextureName()
   return "alchemist_goblins_greed";
end

function item_gift:OnSpellStart()
    print("test");
end

modifier_item_gift_lua = modifier_item_gift_lua or class({});
function modifier_item_gift_lua:OnCreated()
    self.owner = self:GetAbility():GetCaster();
    self:SetStackCount(1);
end

function modifier_item_gift_lua:OnRefresh()
    self:SetStackCount(self:GetStackCount() + 1);
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
    if keys.unit == self:GetParent() then
        Timers:CreateTimer(0, function ()
            GiftQuest.DropGifts(self:GetCaster():GetAbsOrigin(), self:GetStackCount());
            self:Destroy();
        end)
    end
end
