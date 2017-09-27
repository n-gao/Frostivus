require("game")

LinkLuaModifier("modifier_no_movement_speed_limit_lua", "abilities/modifier_no_movement_speed_limit_lua.lua", LUA_MODIFIER_MOTION_NONE);

function Spawn(entity)
    thisEntity:AddNewModifier(thisEntity, nil, "modifier_invulnerable", {});
    thisEntity:AddNewModifier(thisEntity, nil, "modifier_no_movement_speed_limit_lua", {
        movementSpeed = 1300
    });
end
