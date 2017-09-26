require("lib/physics")

function OnEnterRiver(trigger)
    local hero = trigger.activator;
    if instanceof(hero.player, Player) then
        Physics:Unit(hero);
        hero.shouldSlide = true;
        Timers:CreateTimer(0, function ()
            hero:Slide(hero.shouldSlide);
            if not hero.shouldSlide then
                return;
            end
            return 0.1;
        end)
    end
end

function OnLeftRiver(trigger)
    local hero = trigger.activator;
    if instanceof(hero.player, Player) then
        hero.shouldSlide = false;
        hero:Slide(false);
    end
end