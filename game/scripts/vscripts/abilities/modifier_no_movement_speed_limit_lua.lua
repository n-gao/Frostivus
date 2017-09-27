modifier_no_movement_speed_limit_lua = modifier_no_movement_speed_limit_lua or class({});

function modifier_no_movement_speed_limit_lua:IsDebuff()
    return true;
end

function modifier_no_movement_speed_limit_lua:IsStunDebuff()
    return false;
end

function modifier_no_movement_speed_limit_lua:IsHidden()
    return true;
end

function modifier_no_movement_speed_limit_lua:DestroyOnExpire()
    return false;
end

function modifier_no_movement_speed_limit_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
    };
    return funcs;
end

function modifier_no_movement_speed_limit_lua:GetModifierMoveSpeed_Limit()
    return false;
end

function modifier_no_movement_speed_limit_lua:GetModifierMoveSpeed_Absolute()
    return self.movementSpeed;
end

function modifier_no_movement_speed_limit_lua:OnCreated(kv)
    self.movementSpeed = kv.movementSpeed;
end
