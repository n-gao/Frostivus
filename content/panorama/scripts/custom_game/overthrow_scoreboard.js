"use strict";

var timeLimit = 0;

function UpdateTimer( data )
{
	//$.Msg( "UpdateTimer: ", data );
	//var timerValue = Game.GetDOTATime( false, false );

	//var sec = Math.floor( timerValue % 60 );
	//var min = Math.floor( timerValue / 60 );

	//var timerText = "";
	//timerText += min;
	//timerText += ":";

	//if ( sec < 10 )
	//{
	//	timerText += "0";
	//}
	//timerText += sec;

	var timerText = "";
	timerText += data.timer_minute_10;
	timerText += data.timer_minute_01;
	timerText += ":";
	timerText += data.timer_second_10;
	timerText += data.timer_second_01;

	$( "#Timer" ).text = timerText;

	//$.Schedule( 0.1, UpdateTimer );
}

function ShowTimer( data )
{
	$( "#Timer" ).AddClass( "timer_visible" );
}

function AlertTimer( data )
{
	$( "#Timer" ).AddClass( "timer_alert" );
}

function HideTimer( data )
{
	$( "#Timer" ).AddClass( "timer_hidden" );
}

function UpdateKillsToWin()
{
	var victory_condition = CustomNetTables.GetTableValue( "game_state", "victory_condition" );
	if ( victory_condition )
	{
		$("#VictoryPoints").text = victory_condition.points_to_win;
	}
}

function OnGameStateChanged( table, key, data )
{
    $.Msg( "Table '", table, "' changed: '", key, "' = ", data );
    if (key == "time_limit") {
        timeLimit = data.seconds;
    }
	UpdateKillsToWin();
}

function UpdateTimeLimit(args) {
    self.timeLimit = args.time_limit;
}

function RefreshTime() {
	$( "#Timer" ).text = FormatTime(timeLimit - Game.GetGameTime());
    $.Schedule(0.1, RefreshTime);
}

function FormatTime(time) {
    if (typeof(time) != "number") {
        return "--:--";
    }
    var minutes = String(Math.abs(Math.floor(time/60)));
    var seconds = String(Math.abs(Math.floor(time) % 60));
    if (time < 0) {
        minutes = "-" + minutes;
    }
    return "00".substring(0, 2 - minutes.length) + minutes + ":" + "00".substring(0, 2 - seconds.length) + seconds;
}

(function()
{
	// We use a nettable to communicate victory conditions to make sure we get the value regardless of timing.
	UpdateKillsToWin();
	CustomNetTables.SubscribeNetTableListener( "game_state", OnGameStateChanged );

    GameEvents.Subscribe( "countdown", UpdateTimer );
    GameEvents.Subscribe( "show_timer", ShowTimer );
    GameEvents.Subscribe( "timer_alert", AlertTimer );
    GameEvents.Subscribe( "overtime_alert", HideTimer );

    RefreshTime();
    var limit = CustomNetTables.GetTableValue("game_state", "time_limit");
    if (limit) {
        timeLimit = limit.seconds;
    }
	//UpdateTimer();
})();

