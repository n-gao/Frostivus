modifier_roshan_invulnerable_lua = modifier_roshan_invulnerable_lua or class({});

function modifier_roshan_invulnerable_lua:IsDebuff()
    return false
end

function modifier_roshan_invulnerable_lua:IsStunDebuff()
    return false
end

function modifier_roshan_invulnerable_lua:IsHidden()
    return true
end

function modifier_roshan_invulnerable_lua:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true
    };
    return state;
end
