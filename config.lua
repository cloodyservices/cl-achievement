Config = {}

Config.Position = 'middle-right'
Config.Margin = 0
Config.Scale = 0.8
Config.Duration = 5000
Config.Sound = { name = 'RANK_UP', set = 'HUD_AWARDS' }

Config.AllowClientAward = true
Config.Table = 'player_achievements'
Config.Debug = true

Config.Achievements = {
    ride_scootie = {
        label = 'Ride Scootie',
        points = 100,
        icon = 'scooter',
    },

    first_paycheck = {
        label = 'Honest Work',
        points = 50,
        icon = 'money',
    },

    big_catch = {
        label = 'Big Catch',
        points = 250,
        icon = 'fish',
    },

    licence_to_drive = {
        label = 'Licence to Drive',
        points = 100,
        icon = 'car',
    },

    take_flight = {
        label = 'Take Flight',
        points = 500,
        icon = 'plane',
    },

    close_call = {
        label = 'Close Call',
        points = 150,
        icon = 'heart',
    },
}
