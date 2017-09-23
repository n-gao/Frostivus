GiftQuest = class({
    name = "gift",
    giftsGiven = 0,
    GetPoints = function(self)
        return giftsGiven + math.floor(giftsGiven/3);
    end,
    constructor = function(self, count)
        giftsGiven = count
    end
}, {

}, Quest);

function GiftQuest.DropGift(position)
    if position == nil then
        error("Position must not be null.");
    end
    print("[Gift] Dropping a gift at "..position..".");
    local gift = CreateItem("item_gift", nil, nil);
    gift:SetPurchaser(0);
    local drop = CreateItemOnPositionSync(position, gift);
    local offset = Vector(math.random(0, 50), 0, math.random(0, 50));
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
