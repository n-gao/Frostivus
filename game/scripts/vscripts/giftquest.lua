require("quest");

GiftQuest = GiftQuest or class({
    name = "gift",
    giftsGiven = 0,
    constructor = function(self, count)
        self.giftsGiven = count
    end
}, {

}, Quest);

function GiftQuest:GetPoints()
    return self.giftsGiven + math.floor(self.giftsGiven/3);
end

function GiftQuest.DropGift(position)
    if position == nil then
        error("Position must not be null.");
    end
    print("[Gift] Dropping a gift at "..position:__tostring()..".");
    local gift = CreateItem("item_gift", nil, nil);
    gift:SetPurchaseTime(0);
    local drop = CreateItemOnPositionSync(position, gift);
    local offset = Vector(math.random(-200, 200), math.random(-200, 200), 0);
    gift:LaunchLoot(false, 300, 0.75, position + offset);
end

function GiftQuest.DropGifts(position, amount)
    if type(amount) ~= "number" or amount <= 0 then
        error("Amount must be a number bigger than 0.");
    end
    for i = 0, amount do
        GiftQuest.DropGift(position);
    end
end

function GiftQuest.GiveGifts(player)
    local count = player:GetGiftCount();
    if count == 0 then
        return;
    end
    player:RemoveGifts();
    player:FullfillQuest(GiftQuest(count));
    local roshan = Game.GetInstance():GetRoshan();
    roshan:LookAt(player:GetHero():GetAbsOrigin());
    roshan:ThankPlayer(player);
    roshan:StartHappyGesture();
end
