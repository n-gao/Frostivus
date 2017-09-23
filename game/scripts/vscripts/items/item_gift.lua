require("giftquest")

item_gift = item_gift or class({});
LinkLuaModifier("modifier_item_gift_lua", "items/item_gift.lua", LUA_MODIFIER_MOTION_NONE);

function item_gift:GetAbilityTextureName()
   return "alchemist_goblins_greed";
end


modifier_item_gift_lua = class({});
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
    return true;
end

function modifier_item_gift_lua:OnDestroy()
    GiftQuest.DropGifts(self.owner:GetAbsOrigin(), self:GetStackCount());
end
