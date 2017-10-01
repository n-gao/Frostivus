interface PlayerScoredData {
    player_id : number,
    team : number,
    new_points : number,
    total_points : number,
    team_points : number,
    points_remaining : number,
    victory : boolean,
    close_to_victory : boolean,
    very_close_to_victory : boolean
}

interface Speechbubble {
    position : [number, number, number],
    text : string,
    duration : number,
    params : string[],
    shout : boolean,
    entIndex : number
}
