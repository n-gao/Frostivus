function OnEnterRoshan(trigger)
    local hero = trigger.activator;
    if instanceof(hero.player, Player) then
        local game = Game.GetInstance();
        local roshan = game:GetRoshan();
        local delay = game:GetGiftTakeDelay();
        local lastGift = GameRules:GetGameTime();
        Timers:CreateTimer(0, function()
            if not trigger.caller:IsTouching(hero) then
                return;
            end
            local time = GameRules:GetGameTime();
            if time - lastGift > delay then
                roshan:GiveGifts(hero.player, 1);
                lastGift = time;
            end
            return 0.2;
        end);
    end
end
