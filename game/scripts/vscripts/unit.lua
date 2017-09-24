Unit = Unit or class({
    npc = nil,
    timer = nil,

    constructor = function(self, npc)
        self.npc = npc;
        npc.unit = self;
        self.timer = Timers:CreateTimer(0, function ()
            return self:OnThink();
        end);
    end,
    OnDied = function(self, murderer) end,
    OnKilled = function(self, victim) end,
    OnThink = function(self) end,
    GetNpc = function(self) return self.npc end
});
