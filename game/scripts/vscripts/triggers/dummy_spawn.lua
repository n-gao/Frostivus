LinkLuaModifier("modifier_dummy", "modifiers/modifier_dummy.lua", LUA_MODIFIER_MOTION_NONE);

function Spawn(entity)
    thisEntity:AddNewModifier(thisEntity, nil, "modifier_dummy", {});
end
