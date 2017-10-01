require("quest");

GiftQuest = GiftQuest or class({
    name = "gift",
    giftsGiven = 0,
    constructor = function(self, count)
        Quest.constructor(self);
        self.giftsGiven = count;
    end
}, {

}, Quest);

function GiftQuest:GetPoints()
    return self.giftsGiven + math.floor(self.giftsGiven/3);
end

function GiftQuest:GetGoldBounty()
    local bounties = Game.GetInstance():GetGiftBounty();
    return bounties.gold * self:GetPoints();
end

function GiftQuest:GetExperienceBounty()
    local bounties = Game.GetInstance():GetGiftBounty();
    return bounties.experience * self:GetPoints();
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
