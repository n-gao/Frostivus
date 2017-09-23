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
