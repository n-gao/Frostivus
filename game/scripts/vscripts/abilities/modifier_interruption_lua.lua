modifier_interruption_lua = modifier_interruption_lua or class({});

function modifier_interruption_lua:IsDebuff()
    return true;
end

function modifier_interruption_lua:IsStunDebuff()
    return true;
end

function modifier_interruption_lua:IsHidden()
    return true;
end

function modifier_interruption_lua:DestroyOnExpire()
    return true;
end

function modifier_interruption_lua:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_STUNNED] = true
    };
    return state;
end

function modifier_interruption_lua:OnCreated(kv)
    if not IsServer() then
        return;
    end
    local hero = self:GetParent();
    if not hero:IsRealHero() or not instanceof(hero.player, Player) then
        self:Destroy();
        return;
    end
    self.player = hero.player;
    self.cameraUnit = CreateUnitByName("frostivus_camera_helper", hero:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS);
    self.cameraUnit.player = self.player;
    PlayerResource:SetCameraTarget(self.player:GetPlayerId(), self.cameraUnit);
    if kv.duration >= 0 then
        self:SetDuration(kv.duration, true);
    end
    local roshan = Game.GetInstance():GetRoshan():GetNpc();
    self.timer = Timers:CreateTimer(0, function()
        if self.cameraUnit:IsNull() then
            return;
        end
        self.cameraUnit:MoveToPosition(roshan:GetAbsOrigin());
        if (self.cameraUnit:GetAbsOrigin() - roshan:GetAbsOrigin()):Length2D() < 10 then
            PlayerResource:SetCameraTarget(self.player:GetPlayerId(), roshan);
            self.cameraUnit:Destroy();
            return;
        end
        return 0.1;
    end);
end

function modifier_interruption_lua:OnRemoved()
    if not IsServer() then
        return;
    end
    if not self.cameraUnit == nil and not self.cameraUnit:IsNull() then
        self.cameraUnit:Destroy();
    end
    if self.timer ~= nil then
        Timers:RemoveTimer(self.timer);
    end
    if self.player ~= nil then
        PlayerResource:SetCameraTarget(self.player:GetPlayerId(), nil);
    end
end
