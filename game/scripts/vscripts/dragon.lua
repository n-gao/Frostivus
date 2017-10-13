require("Greevil");

if not Dragon then
    Dragon = class({
        fireballAbility = nil,
        constructor = function(self, npc)
            Greevil.constructor(self, npc);
            self.fireballAbility = npc:GetAbilityByIndex(0);
            self.fireballAbility:StartCooldown(4 + math.random() * 3);
            self:SetBounty(3);
        end
    }, {
        
    }, Greevil);
end

function Dragon:OnThink()
    local result = Greevil.OnThink(self);
    if result then
        self:CastFireball();
    end
    return result;
end

function Dragon:CastFireball()
    if not self.fireballAbility:IsCooldownReady() or math.random() < 0.5 then
        return
    end
    local npc = self:GetNpc()
    local position = npc:GetAbsOrigin();
    local forward = npc:GetForwardVector();
    local target = position + forward * 125;
    npc:CastAbilityOnPosition(target, self.fireballAbility, -1);
end
