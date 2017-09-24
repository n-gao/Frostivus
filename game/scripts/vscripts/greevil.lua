require("unit");
require("giftquest");

Greevil = Greevil or class({
    id = 0,
    waypoint = nil,

    constructor = function(self, npc)
        Unit.constructor(self, npc);

        self.id = Greevil.nextId;
        Greevil.nextId = Greevil.nextId + 1;

        self:SetNextWaypoint();
    end
}, {
    nextId = 0
}, Unit);

function Greevil:OnThink()
    if not self:IsAlive() then
        print("[Greevil] Greevil "..self:GetId().." died.");
        return nil;
    end
    if self:GetNpc():IsIdle() then
        self:MoveToWaypoint();
    end
    if self:DistanceToWaypoint() < 50 then
        print("[Greevil] "..self:GetId().." is moving to next waypoint.");
        self:SetNextWaypoint();
    end
    return 0.5;
end

function Greevil:OnDied(murderer)
    self:DropGift();
end

function Greevil:DropGift()
    print("[Greevil] "..self:GetId().." is dropping a gift.");
    GiftQuest.DropGift(self:GetDropPosition());
end

function Greevil:GetWaypoint()
    return self.waypoint;
end

function Greevil:GetId()
    return self.id;
end

function Greevil:IsAlive()
    return not self.npc:IsNull() and self.npc:IsAlive();
end

function Greevil:DistanceToWaypoint()
    return (self:GetWaypoint():GetAbsOrigin() - self:GetNpc():GetAbsOrigin()):Length2D();
end

function Greevil:GetDropPosition()
    if self.npc:IsNull() then
        return self:GetWaypoint():GetAbsOrigin();
    end
    return self:GetNpc():GetAbsOrigin();
end

function Greevil:SetNextWaypoint()
    local waypoints = Game.GetInstance():GetWaypoints();
    if waypoints == nil or type(waypoints) ~= "table" or waypoints == 0 then
        error("Game does not have any waypoints");
    end
    self.waypoint = waypoints[math.random(#waypoints)];
    Timers:CreateTimer(0, function ()
        self:MoveToWaypoint();
    end)
end

function Greevil:MoveToWaypoint()
    self:GetNpc():MoveToPosition(self:GetWaypoint():GetAbsOrigin());
end
