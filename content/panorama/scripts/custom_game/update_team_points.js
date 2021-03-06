"use strict";
function PlayerScored(args) {
    var teamDetails = GameUI.CustomUIConfig().teamScores;
    teamDetails[args.team] = args.team_points;
}
(function () {
    var scores = GameUI.CustomUIConfig().teamScores = {};
    for (var i = 0; i < DOTATeam_t.DOTA_TEAM_COUNT; i++) {
        scores[i] = 0;
    }
    GameEvents.Subscribe("player_scored", PlayerScored);
})();
