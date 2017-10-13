"use strict";

function ShowSpeechbubble(data : Speechbubble) {
    $.Msg("[Speechbubble] Created with:");
    $.Msg(data);
    var bubble = $.CreatePanel("Panel", $("#FrostivusSpeechbubbleRoot"), "Speechbubble");
    bubble.BLoadLayout("file://{resources}/layout/custom_game/frostivus_Speechbubble.xml", false, false);
    var label = bubble.FindChildInLayoutFile("SpeechbubbleText") as LabelPanel;
    var text = FormatText(data.text, data.params);
    if (data.shout) {
        text = text.toUpperCase();
    }
    label.text = text;
    $.Schedule(data.duration, function() {
        bubble.RemoveAndDeleteChildren();
    });
    RefreshPosition(bubble, data);
    if (data.shout) {
        SimulateShout(bubble.FindChildInLayoutFile("Speechbubble"));
    }
}

function SimulateShout(panel : Panel) {
    if (panel == null) {
        return;
    }
    var x = Math.round(Math.random() * 30) - 15;
    var y = Math.round(Math.random() * 30) - 15;
    panel.style.marginLeft = x + "px";
    panel.style.marginTop = y + "px";
    $.Schedule(0.05, function (){
        SimulateShout(panel);
    });
}

function RefreshPosition(panel : Panel, data : Speechbubble) {
    if (panel == null) {
        return;
    }
    var x,y : number;
    if (data.entIndex < 0) {
        var gamePos = data.position;
        x = Game.WorldToScreenX(gamePos[0], gamePos[1], gamePos[2]);
        y = Game.WorldToScreenY(gamePos[0], gamePos[1], gamePos[2]);
    } else {
        var pos = Entities.GetAbsOrigin(data.entIndex);
        var offset = data.position;
        x = Game.WorldToScreenX(pos[0] + offset[0], pos[1] + offset[1], pos[2] + offset[2]);
        y = Game.WorldToScreenY(pos[0] + offset[0], pos[1] + offset[1], pos[2] + offset[2]);
    }
    // y -= panel.contentheight;
    if (x == -1 && y == -1) {
        panel.style.visibility = "collapse";
    } else {
        panel.style.visibility = "visible";
    }
    var width = Game.GetScreenWidth();
    var height = Game.GetScreenHeight();
    var aspectCorrection = (width/height) / (16/9);
    x -= panel.contentwidth * 0.25 * aspectCorrection;
    x *= aspectCorrection;
    y *= aspectCorrection;
    panel.style.marginLeft = x + "px";
    panel.style.marginTop = y + "px";
    $.Schedule(0.01, function(){
        RefreshPosition(panel, data);
    });
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


(function() {
    GameEvents.Subscribe("show_Speechbubble", ShowSpeechbubble);
    // ShowSpeechbubble({ 
    //     position : {x : 0, y : 0, z : 300},
    //     text : "this is a test 2",
    //     duration : 30000,
    //     params : []
    // });
})();
