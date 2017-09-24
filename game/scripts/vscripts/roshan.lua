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

function Roshan:StartHappyGesture()
    local gestures = {
        ACT_DOTA_ATTACK,
        ACT_DOTA_CAST_ABILITY_3
    };
    self.npc:StartGesture(gestures[math.random(#gestures)]);
end

function Roshan:LookAt(target)
    local vec = Vector(0, 0, 0);
    if instanceof(target, Vector) then
        vec = target;
    end
    if type(target.GetAbsOrigin) == "function" then
        vec = target:GetAbsOrigin();
    end
    local pos = self.npc:GetAbsOrigin();
    vec.z = pos.z;
    local delta = vec - pos;
    -- self.npc:SetAngles(VectorToAngles(delta));
    -- DeepPrintTable(VectorToAngles(delta));
end
