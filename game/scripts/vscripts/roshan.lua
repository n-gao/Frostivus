require("Unit");

LinkLuaModifier("modifier_roshan_invulnerable_lua", "abilities/modifier_roshan_invulnerable_lua.lua", LUA_MODIFIER_MOTION_NONE);

Roshan = Roshan or class({
    constructor = function(self, npc)
        Unit.constructor(self, npc);
        
        self.npc:AddNewModifier(nil, nil, "modifier_roshan_invulnerable_lua", {});
        Timers:CreateTimer(0, function()
            self:GetNpc():StartGesture(ACT_DOTA_IDLE);
        end);
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
    if target.x and target.y and target.z then
        vec = target;
    end
    if type(target.GetAbsOrigin) == "function" then
        vec = target:GetAbsOrigin();
    end
    print(vec);
    local pos = self.npc:GetAbsOrigin();
    local delta = vec - pos;
    print(delta);
    self:GetNpc():SetAngles(0, AngleFromVector(delta), 0);
    -- self.npc:SetAngles(VectorToAngles(delta));
    -- DeepPrintTable(VectorToAngles(delta));
end

function Roshan:ThankPlayer(player)
    local pos = self:GetNpc():GetAbsOrigin();
    CustomGameEventManager:Send_ServerToAllClients("show_speechbubble", {
        position = {
            x = pos.x,
            y = pos.y,
            z = pos.z + 400
        },
        text = "#1 #2!",
        duration = 5,
        params = {
            [1] = "froivus_roshan_thank_you",
            [2] = player:GetHero():GetName()
        }
    });
end

function AngleFromVector(vec)
    vec = vec:Normalized();
    local angle = math.acos(vec.x);
    if (vec.y < 0) then
        angle = -angle;
    end
    return angle/math.pi * 180;
end
