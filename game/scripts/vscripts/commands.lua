
if not CommandEngine then
    CommandEngine = class({});
end

function CommandEngine:OnPlayerChat(keys)
    DeepPrintTable(keys);
    local text = keys.text or "";
    if string.sub(text, 1, 1) == "-" then
        local lwText = string.lower(string.sub(text, 2));
        local parts = string.split(lwText);
        local command = parts[1];
        local params = parts;
        DeepPrintTable(params);
        if type(self[command]) == "function" then
            self[command](self, keys, params);
        end
    end
end

function CommandEngine:suicide(keys, params)
    local player = Game.GetInstance():GetPlayer(keys.playerid);
    player:GetHero():ForceKill(false);
end

function CommandEngine:gift(keys, params)
    local player = Game.GetInstance():GetPlayer(keys.playerid);
    local amount = tonumber(params[1]);
    if amount then
        player:FullfillQuest(GiftQuest(amount));
    end
end

function CommandEngine:roshan_demand(keys, params)
    Game.GetInstance():GetRoshan():DemandGifts();
end

function CommandEngine:roshan_strike(keys, params)
    Game.GetInstance():GetRoshan():Sunstrike();
end
