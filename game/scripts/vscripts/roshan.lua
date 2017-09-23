Roshan = class({
    unit = nil,
    thinker = nil,

    constructor = function(self, npc)
        unit = npc;
        thinker = Timers:CreateTimer(0, function()
            self:OnThink();
        end);
        unit:AddNewModifier(nil, nil, "modifier_invulnerable", {});
        Game.instance:SetRoshan(self);
    end
});

function Roshan:OnThink()
    print("Roshan thinking");
    return 0.5;
end

function Spawn(entity)
    Roshan(thisEntity)
end
