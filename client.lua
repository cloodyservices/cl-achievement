local queue = {}
local showing = false

local function showNext()
    if showing then return end
    showing = true

    CreateThread(function()
        while #queue > 0 do
            local data = table.remove(queue, 1)

            SendNUIMessage({
                action = 'show',
                label = data.label,
                points = data.points,
                icon = data.icon,
                position = Config.Position,
                margin = Config.Margin,
                scale = Config.Scale
            })

            if Config.Sound then
                PlaySoundFrontend(-1, Config.Sound.name, Config.Sound.set, true)
            end

            Wait(Config.Duration)
            SendNUIMessage({ action = 'hide' })
            Wait(400)
        end

        showing = false
    end)
end

local function show(data)
    if not data or not data.label then return end

    queue[#queue+1] = {
        label = data.label,
        points = data.points or 0,
        icon = data.icon
    }

    showNext()
end

RegisterNetEvent('cl-achievement:client:unlock', show)

exports('Award', function(id)
    TriggerServerEvent('cl-achievement:server:award', id)
end)

exports('Show', show)

TriggerEvent('chat:addSuggestion', '/testachievement', 'Unlock an achievement on yourself (admin)', {
    { name = 'id', help = 'achievement id, list, or reset [id]' }
})

if Config.Debug then
    TriggerEvent('chat:addSuggestion', '/achievementpreview', 'Preview the popup, nothing gets saved', {
        { name = 'id', help = 'achievement id' }
    })

    RegisterCommand('achievementpreview', function(_, args)
        local id = args[1] or next(Config.Achievements)
        local ach = Config.Achievements[id]
        if not ach then
            print('unknown achievement '..tostring(id))
            return
        end
        show({ label = ach.label, points = ach.points, icon = ach.icon })
    end)
end
