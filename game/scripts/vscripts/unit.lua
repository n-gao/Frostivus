Unit = Unit or class({
    npc = nil,
    timer = nil,

    constructor = function(self, npc)
        self.npc = npc;
        npc.unit = self;
        self.timer = Timers:CreateTimer(0, function ()
            return self:OnThink();
        end);
        Timers:CreateTimer(FrameTime(), function ()
            self:GetNpc():StartGesture(ACT_DOTA_SPAWN);
        end);
    end,
    OnDied = function(self, murderer) end,
    OnKilled = function(self, victim) end,
    OnThink = function(self) end,
    GetNpc = function(self) return self.npc end,
    IsAlive = function(self) return not self.npc:IsNull() and self.npc:IsAlive() end,
    GetAbsOrigin = function(self)
        if self.npc then
            return self.npc:GetAbsOrigin();
        else
            return Vector(0, 0, 0);
        end
    end
});
