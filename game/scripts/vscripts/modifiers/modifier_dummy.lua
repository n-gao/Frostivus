modifier_dummy = modifier_dummy or class({});

function modifier_dummy:IsDebuff()
    return false
end

function modifier_dummy:IsStunDebuff()
    return false
end

function modifier_dummy:IsHidden()
    return true
end

function modifier_dummy:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true
    };
    return state;
end
