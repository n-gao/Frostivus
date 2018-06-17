-- Generated from template
require("lib/timers");
require("game");
require("roshan");

local teamIds = {
    DOTA_TEAM_GOODGUYS,
    DOTA_TEAM_BADGUYS,
    DOTA_TEAM_CUSTOM_1,
    DOTA_TEAM_CUSTOM_2,
    DOTA_TEAM_CUSTOM_3,
    DOTA_TEAM_CUSTOM_4,
    DOTA_TEAM_CUSTOM_5,
    DOTA_TEAM_CUSTOM_6,
    DOTA_TEAM_CUSTOM_7,
    DOTA_TEAM_CUSTOM_8
};

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
    ]]
    PrecacheUnitByNameAsync("frostivus_greevil", context);
    PrecacheUnitByNameAsync("frostivus_dragon", context);
    PrecacheItemByNameAsync("item_gift", context);
end

-- Create the game mode when we activate
function Activate()
    local teamCount = Game.GetInstance():GetTeamCount();
    local playersPerTeam = 3;
    for i = 1, teamCount do
        GameRules:SetCustomGameTeamMaxPlayers(teamIds[i], playersPerTeam);
    end
  GameRules:SetShowcaseTime(0)
  GameRules:SetStrategyTime(0)
end
