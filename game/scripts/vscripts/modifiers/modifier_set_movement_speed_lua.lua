modifier_set_movement_speed_lua = modifier_set_movement_speed_lua or class({});

function modifier_set_movement_speed_lua:IsDebuff()
    return true;
end

function modifier_set_movement_speed_lua:IsStunDebuff()
    return false;
end

function modifier_set_movement_speed_lua:IsHidden()
    return true;
end

function modifier_set_movement_speed_lua:DestroyOnExpire()
    return false;
end

function modifier_set_movement_speed_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_MOVESPEED_MAX
    };
    return funcs;
end

function modifier_set_movement_speed_lua:GetModifierMoveSpeed_Limit()
    return self.movementSpeed;
end

function modifier_set_movement_speed_lua:GetModifierMoveSpeed_Absolute()
    return self.movementSpeed;
end

function modifier_set_movement_speed_lua:GetModifierMoveSpeed_Max()
    return self.movementSpeed;
end

function modifier_set_movement_speed_lua:OnCreated(kv)
    self.movementSpeed = kv.movementSpeed;
end
