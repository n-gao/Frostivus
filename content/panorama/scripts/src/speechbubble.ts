"use strict";

interface SpeechBubble {
    position : Vector,
    text : string,
    duration : number,
    params : string[]
}

function ShowSpeechBubble(data : SpeechBubble) {
    $.Msg("[Speechbubble] Created with:");
    $.Msg(data);
    var bubble = $.CreatePanel("Panel", $("#FrostivusSpeechBubbleRoot"), "Speechbubble");
    bubble.BLoadLayout("file://{resources}/layout/custom_game/frostivus_speechbubble.xml", false, false);
    var label = bubble.FindChildInLayoutFile("SpeechbubbleText") as LabelPanel;
    label.text = FormatText(data.text, data.params);
    $.Schedule(data.duration, function() {
        bubble.RemoveAndDeleteChildren();
    });
    RefreshPosition(bubble, data.position);
}

function FormatText(format : string, params : string[]) {
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

function RefreshPosition(panel : Panel, gamePos : Vector) {
    if (panel == null) {
        return;
    }
    var x = Game.WorldToScreenX(gamePos.x, gamePos.y, gamePos.z + 350);
    var y = Game.WorldToScreenY(gamePos.x, gamePos.y, gamePos.z + 350);
    // x += panel.actuallayoutwidth/2;
    panel.style.marginLeft = "" + x + "px";
    panel.style.marginTop = "" + y + "px";
    if (x == -1 && y == -1) {
        panel.style.visibility = "collapse";
    } else {
        panel.style.visibility = "visible";
    }
    $.Schedule(0.01, function(){
        RefreshPosition(panel, gamePos);
    });
}


(function() {
    $.Msg("test");
    GameEvents.Subscribe("show_speechbubble", ShowSpeechBubble);
    // ShowSpeechBubble({ 
    //     position : {x : 0, y : 0, z : 760},
    //     text : "this is a test 2",
    //     duration : 3000
    // });
})();