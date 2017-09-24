require("Unit");

LinkLuaModifier("modifier_roshan_invulnerable_lua", "abilities/modifier_roshan_invulnerable_lua.lua", LUA_MODIFIER_MOTION_NONE);

Roshan = Roshan or class({
    constructor = function(self, npc)
        Unit.constructor(self, npc);
        
        self.npc:AddNewModifier(nil, nil, "modifier_roshan_invulnerable_lua", {});
    end
}, {}, Unit);

function Roshan:OnThink()
    return 0.5;
end
