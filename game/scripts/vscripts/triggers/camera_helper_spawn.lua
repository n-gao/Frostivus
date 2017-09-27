require("game")

LinkLuaModifier("modifier_set_movement_speed_lua", "abilities/modifier_set_movement_speed_lua.lua", LUA_MODIFIER_MOTION_NONE);

function Spawn(entity)
    thisEntity:AddNewModifier(thisEntity, nil, "modifier_invulnerable", {});
    thisEntity:AddNewModifier(thisEntity, nil, "modifier_set_movement_speed_lua", {
        movementSpeed = 1000
    });
end
