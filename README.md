# cl-achievement

Achievement popups for qbox / qb. Unlocks get saved to the db per character so you only ever get each one once, calling it again just does nothing.

Needs oxmysql. Works on qbx_core and qb-core, falls back to license if neither is running.

## Install

- drop it in resources
- `ensure cl-achievement` somewhere after oxmysql
- start the server, the table gets made on its own. sql file is in `sql/` if you'd rather run it yourself

## Config

```lua
Config.Position = 'middle-right'
Config.Margin = 0
Config.Scale = 0.8
Config.Duration = 5000
Config.Sound = { name = 'RANK_UP', set = 'HUD_AWARDS' }

Config.AllowClientAward = true
Config.Table = 'player_achievements'
Config.Debug = false
```

**Position** - top-left, top-center, top-right, middle-left, middle-right, bottom-left, bottom-center, bottom-right

**Margin** - px from the screen edge. 0 puts it right against the edge

**Scale** - 1 is full size (440px wide), 0.8 is 80% and so on

**Duration** - how long it stays up in ms

**Sound** - frontend sound on unlock, set to false for none

**AllowClientAward** - lets client scripts call the Award export. Turn it off if you only award from server side, clients can fake events so anyone could unlock stuff otherwise

**Debug** - turns on /achievementpreview

## Adding achievements

```lua
Config.Achievements = {
    ride_scootie = {
        label = 'Ride Scootie',
        points = 100,
        icon = 'scooter',
    },
}
```

The key is what goes in the db so don't rename it after people have it or they lose it.

points = 0 hides the yellow bar.

icon can be one of these or a url / nui:// path to your own image:

trophy, star, medal, crown, scooter, car, bike, plane, boat, fish, skull, money, heart, gun, wrench, pill, flag, camera, fire, key

## Exports

server

```lua
exports['cl-achievement']:Award(source, 'ride_scootie')  -- true first time, false after
exports['cl-achievement']:Has(source, 'ride_scootie')
exports['cl-achievement']:GetUnlocked(source)              -- list of ids
exports['cl-achievement']:Reset(source, 'ride_scootie')    -- leave the id out to wipe all
```

client

```lua
exports['cl-achievement']:Award('ride_scootie')  -- needs AllowClientAward
exports['cl-achievement']:Show({ label = 'Ride Scootie', points = 100, icon = 'scooter' })  -- popup only, nothing saved
```

You don't need to check Has before Award, it already does that.

```lua
RegisterNetEvent('myscript:server:boughtScooter', function()
    exports['cl-achievement']:Award(source, 'ride_scootie')
end)
```

## Commands

`/testachievement` - admin only. does the real thing on yourself so you can check the db save and the popup.

```
/testachievement                  lists ids
/testachievement ride_scootie     popup + saved
/testachievement ride_scootie     nothing, you have it
/testachievement reset ride_scootie
/testachievement reset            wipes all yours
```

`/achievementpreview [id]` - popup only, nothing saved. only there when Config.Debug is on.

`achievement <playerId> <id>` - server console, gives it to someone.
"# cl-achievement" 
