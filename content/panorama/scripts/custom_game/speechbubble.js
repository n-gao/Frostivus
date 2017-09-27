"use strict";
function ShowSpeechBubble(data) {
    $.Msg("[Speechbubble] Created with:");
    $.Msg(data);
    var bubble = $.CreatePanel("Panel", $("#FrostivusSpeechBubbleRoot"), "Speechbubble");
    bubble.BLoadLayout("file://{resources}/layout/custom_game/frostivus_speechbubble.xml", false, false);
    var label = bubble.FindChildInLayoutFile("SpeechbubbleText");
    label.text = FormatText(data.text, data.params);
    $.Schedule(data.duration, function () {
        bubble.RemoveAndDeleteChildren();
    });
    RefreshPosition(bubble, data.position);
}
function FormatText(format, params) {
    var result = format;
    var i = 1;
    while (result.indexOf("#" + i) != -1) {
        var replacement = params[i];
        if (replacement == null) {
            return result;
        }
        replacement = $.Localize(replacement);
        result = result.replace("#" + i, replacement);
        i++;
    }
    return result;
}
function RefreshPosition(panel, gamePos) {
    if (panel == null) {
        return;
    }
    var x = Game.WorldToScreenX(gamePos.x, gamePos.y, gamePos.z);
    var y = Game.WorldToScreenY(gamePos.x, gamePos.y, gamePos.z);
    // x += panel.actuallayoutwidth/2;
    panel.style.marginLeft = "" + x + "px";
    panel.style.marginTop = "" + y + "px";
    if (x == -1 && y == -1) {
        panel.style.visibility = "collapse";
    }
    else {
        panel.style.visibility = "visible";
    }
    $.Schedule(0.01, function () {
        RefreshPosition(panel, gamePos);
    });
}
(function () {
    GameEvents.Subscribe("show_speechbubble", ShowSpeechBubble);
    // ShowSpeechBubble({ 
    //     position : {x : 0, y : 0, z : 300},
    //     text : "this is a test 2",
    //     duration : 30000,
    //     params : []
    // });
})();
