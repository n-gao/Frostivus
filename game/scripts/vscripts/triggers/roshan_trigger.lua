function OnEnterRoshan(trigger)
    local hero = trigger.activator;
    GiftQuest.DropGift(hero:GetAbsOrigin());
    if instanceof(hero.player, Player) then
        GiftQuest.GiveGifts(hero.player);
    end
end
