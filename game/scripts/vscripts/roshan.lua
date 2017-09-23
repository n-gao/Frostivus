require("Unit")

Roshan = class({
    constructor = function(self, npc)
        Unit.constructor(self, npc);
        
        unit:AddNewModifier(nil, nil, "modifier_invulnerable", {});
    end
}, {}, Unit);

function Roshan:OnThink()
    print("Roshan thinking");
    return 0.5;
end

function Spawn(entity)
    Game.instance:SetRoshan(Roshan(thisEntity));
end
