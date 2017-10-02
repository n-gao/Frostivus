require("Unit");

LinkLuaModifier("modifier_roshan_invulnerable_lua", "abilities/modifier_roshan_invulnerable_lua.lua", LUA_MODIFIER_MOTION_NONE);

Roshan = Roshan or class({
    LastGift = 0,

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

function Roshan:GiveGifts(player)
    if not instanceof(player, Player) then
        error("[Roshan] the parameter muss be an instance of Player.");
    end
    local count = player:GetGiftCount();
    if count == 0 then
        return;
    end
    player:RemoveGifts();
    local quest = GiftQuest(count);
    player:FullfillQuest(quest);
    self:LookAt(player:GetHero():GetAbsOrigin());
    self:ThankPlayer(player);
    self:TakeGesture();
    LastGift = GameRules:GetGameTime();
end

function Roshan:TakeGesture()
    local gestures = {
        ACT_DOTA_ATTACK
    };
    self:GetNpc():StartGesture(gestures[math.random(#gestures)]);
    Timers:CreateTimer(0.1, function()
        self:GetNpc():EmitSound("RoshanDT.Attack");
    end)
end

function Roshan:LookAt(target)
    local vec = Vector(0, 0, 0);
    if target.x and target.y and target.z then
        vec = target;
    end
    if type(target.GetAbsOrigin) == "function" then 
        vec = target:GetAbsOrigin();
    end
    local pos = self:GetNpc():GetAbsOrigin();
    local delta = vec - pos;
    self:GetNpc():SetAngles(0, AngleFromVector(delta), 0);
end

function Roshan:ThankPlayer(player)
    self:ShowSpeechubble("#1 #2!", {
        [1] = "frostivus_roshan_thank_you",
        [2] = player:GetHero():GetName()
    }, 5, false);
end

function Roshan:ShowSpeechubble(text, params, duration, shout)
    local pos = self:GetNpc():GetAbsOrigin();
    local forward = self:GetNpc():GetForwardVector();
    CustomGameEventManager:Send_ServerToAllClients("show_speechbubble", {
        position = {
            [0] = 0,
            [1] = 0,
            [2] = 350
        },
        entIndex = self:GetNpc():GetEntityIndex(),
        text = text or "",
        duration = duration or 1,
        params = params or {},
        shout = shout == true
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

function Roshan:DemandGifts()
    local interruption = Interruption(10, Game.GetInstance():GetPlayers());
    Timers:CreateTimer(5, function ()
        self:ShowSpeechubble("frostivus_roshan_more_gifts", {}, 10, true);
        self:GetNpc():StartGesture(ACT_DOTA_CAST_ABILITY_1);
        self.particle = ParticelManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf", PATTACH_EYES_FOLLOW, self:GetParent());
        Timers:CreateTimer(10, function ()
            ParticleManager:DestroyParticle(self.particle, false);
        end)
        self:GetNpc():EmitSound("RoshanDT.Scream");
    end);
end
