local cache = {}
local seen = {}

local function getCid(src)
    local cid

    if GetResourceState('qbx_core') == 'started' then
        local player = exports.qbx_core:GetPlayer(src)
        if player then cid = player.PlayerData.citizenid end
    elseif GetResourceState('qb-core') == 'started' then
        local QBCore = exports['qb-core']:GetCoreObject()
        local player = QBCore.Functions.GetPlayer(src)
        if player then cid = player.PlayerData.citizenid end
    end

    if not cid then
        cid = GetPlayerIdentifierByType(src, 'license')
    end
    if not cid then return end

    seen[src] = seen[src] or {}
    seen[src][cid] = true

    return cid
end

local function getUnlocked(cid)
    if cache[cid] then return cache[cid] end

    local rows = MySQL.query.await('SELECT achievement FROM '..Config.Table..' WHERE citizenid = ?', { cid })

    local unlocked = {}
    for _, row in ipairs(rows or {}) do
        unlocked[row.achievement] = true
    end

    cache[cid] = unlocked
    return unlocked
end

local function award(src, id)
    local ach = Config.Achievements[id]
    if not ach then
        print('^1[cl-achievement] unknown achievement: '..tostring(id)..'^0')
        return false
    end

    local cid = getCid(src)
    if not cid then return false end

    local unlocked = getUnlocked(cid)
    if unlocked[id] then return false end

    local affected = MySQL.update.await('INSERT IGNORE INTO '..Config.Table..' (citizenid, achievement) VALUES (?, ?)', { cid, id })
    unlocked[id] = true

    if not affected or affected == 0 then return false end

    TriggerClientEvent('cl-achievement:client:unlock', src, {
        id = id,
        label = ach.label or id,
        points = ach.points or 0,
        icon = ach.icon,
    })

    return true
end

local function has(src, id)
    local cid = getCid(src)
    if not cid then return false end
    return getUnlocked(cid)[id] == true
end

local function getAll(src)
    local cid = getCid(src)
    if not cid then return {} end

    local list = {}
    for id in pairs(getUnlocked(cid)) do
        list[#list+1] = id
    end
    return list
end

local function reset(src, id)
    local cid = getCid(src)
    if not cid then return false end

    if id then
        MySQL.update.await('DELETE FROM '..Config.Table..' WHERE citizenid = ? AND achievement = ?', { cid, id })
        getUnlocked(cid)[id] = nil
    else
        MySQL.update.await('DELETE FROM '..Config.Table..' WHERE citizenid = ?', { cid })
        cache[cid] = {}
    end

    return true
end

exports('Award', award)
exports('Has', has)
exports('GetUnlocked', getAll)
exports('Reset', reset)

RegisterNetEvent('cl-achievement:server:award', function(id)
    local src = source
    if not Config.AllowClientAward then return end
    if type(id) ~= 'string' then return end
    award(src, id)
end)

AddEventHandler('playerDropped', function()
    local src = source
    if not seen[src] then return end

    for cid in pairs(seen[src]) do
        cache[cid] = nil
    end
    seen[src] = nil
end)

local function msg(src, text)
    TriggerClientEvent('chat:addMessage', src, {
        color = { 242, 229, 12 },
        args = { 'Achievement', text }
    })
end

local function idList()
    local ids = {}
    for id in pairs(Config.Achievements) do ids[#ids+1] = id end
    table.sort(ids)
    return table.concat(ids, ', ')
end

RegisterCommand('testachievement', function(source, args)
    local src = source
    if src == 0 then
        print('run this in game, or use: achievement <playerId> <id>')
        return
    end

    local arg = args[1]

    if not arg or arg == 'list' then
        msg(src, '/testachievement <id>  |  /testachievement reset [id]')
        msg(src, 'ids: '..idList())
        return
    end

    if arg == 'reset' then
        local id = args[2]
        if id and not Config.Achievements[id] then
            msg(src, 'unknown id '..id)
            return
        end
        reset(src, id)
        msg(src, id and ('reset '..id) or 'reset all your achievements')
        return
    end

    if not Config.Achievements[arg] then
        msg(src, 'unknown id '..arg..' - '..idList())
        return
    end

    if award(src, arg) then
        msg(src, 'unlocked '..arg)
    else
        msg(src, 'you already have '..arg..', do /testachievement reset '..arg..' to get it again')
    end
end, true)

RegisterCommand('achievement', function(source, args)
    if source ~= 0 and not IsPlayerAceAllowed(source, 'command.achievement') then return end

    local target = tonumber(args[1])
    local id = args[2]

    if not target or not id then
        print('achievement <playerId> <id>')
        return
    end

    if award(target, id) then
        print('gave '..id..' to '..target)
    else
        print(target..' already has '..id..' (or bad id)')
    end
end, false)

MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `]]..Config.Table..[[` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `citizenid` VARCHAR(64) NOT NULL,
            `achievement` VARCHAR(64) NOT NULL,
            `unlocked_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            UNIQUE KEY `citizen_achievement` (`citizenid`, `achievement`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
end)
