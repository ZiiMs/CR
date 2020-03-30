local ZA = ZiiM_Accounts
local Player = {}

function ZA:debug(...)
    local arg ={...}
    if self.debugEnable then
        local result = ""
        for i, v in ipairs(arg) do
            result = result .. tostring(v) .. "\t"
        end
        print("^1[S-ZA-debug:" .. debug.getinfo(2).currentline .. "]:^0 " .. tostring(result))
    end
end

MySQL.ready(function ()
    print(MySQL.Sync.fetchScalar('SELECT @parameters', {
        ['@parameters'] =  'string'
    }))

    -- print(MySQL.Sync.fetchScalar("SELECT money FROM users WHERE id = 'yolo' "))

    -- MySQL.Async.fetchAll("SELECT money FROM users WHERE id = 'yolo' ", {}, function (result)
    --     print(#result)
    -- end)

    -- MySQL.Async.fetchAll('SELECT "hello2" as world', {}, function(result)
    --     print(result[1].world)
    -- end)

end)

AddEventHandler("playerConnecting", function(playerName, kickReason, deferrals)
    local src = source
    ZA:debug(source)
	local joinTime = os.time()
	deferrals.defer()
    deferrals.update("Checking Your Information, please wait...")
    SetTimeout(2500, function()
        MySQL.Async.fetchAll('SELECT * FROM users WHERE `identifier` = @identifier', {['@identifier'] = PlayerIdentifier("license", src)}, function(results)
            if #results >= 1 then
                local player = results[1]
                ZA:debug(player.identifier)
                ZA:debug(player.name)
                ZA:debug(player.lastip)
                deferrals.done()
            else
                --local year, month, day, hour, minute, second = GetUtcTime(int* year, int* month, int* day, int* hour, int* minute, int* second)
                local query = "INSERT INTO users (`identifier`, `name`, `lastip`) VALUES (@identifier, @name, @lastip)"
				local parameters = {
                    ['identifier'] = PlayerIdentifier("license", src),
                    ['name'] = GetPlayerName(src),
                    ['lastip'] = GetPlayerEndpoint(src)
                    
				}
                MySQL.Async.insert(query, parameters, function(id)
					deferrals.done()
                end) 
            end
            
            TriggerClientEvent('SendToTable', -1)
            ZA:debug("Player loaded!")
        end)
    end)
end)


RegisterServerEvent('AddToTable')
AddEventHandler('AddToTable', function()
    local src= source
    ZA:debug("AddToTable", "Source: " .. tostring(src))
    MySQL.Async.fetchAll('SELECT * FROM users WHERE `identifier` = @identifier', {['@identifier'] = PlayerIdentifier("license", src)}, function(results)
        table.insert(Player, {id = src, identifier = results[1].identifier, cash = results[1].cash, bank = results[1].bank, name = results[1].name, wanted = results[1].wantedlevel})
        TriggerClientEvent('UICashSync', src, results[1].cash, results[1].bank, results[1].wantedlevel)
        ZA:debug(results[1].name)
    end)
end)

RegisterServerEvent('UpdateSql')
AddEventHandler('UpdateSql', function(source, data)
    local src= source
    ZA:debug(src, data.name)
    MySQL.Async.fetchAll('UPDATE users SET `cash` = @cash, `bank` = @bank, `wantedlevel` = @wanted  WHERE `identifier` = @identifier', {
        ['@cash'] = data.cash,
        ['@bank'] = data.bank,
        ['@wanted'] = data.wanted,
        ['@identifier'] = data.identifier
    })
end)

RegisterServerEvent('SendData')
AddEventHandler('SendData', function(src, type, stat, amount)
    ZA:debug("Source: " .. tostring(src) .. " | Source2: " .. tostring(source))
    local id = src
    if stat ~= nil and type ~= nil then
        if type == 'cash' then
            TriggerClientEvent('GetData', id, Player:Cash(id, stat, amount))
        elseif type == 'bank' then
            TriggerClientEvent('GetData', id, Player:Bank(id, stat, amount))
        elseif  type == 'wanted' then
            TriggerClientEvent('GetData', id, Player:Wanted(id, stat, amount))
        end
    end
end)

function Player:GetPlayerData(ID)
    for i = 1, #self do
        ZA:debug(self[i].id, ID)
        if self[i].id == ID then
            return self[i]
        end
    end
    return false
end

function Player:Cash(ID, type, amount)
    local value = amount or 0
    for i = 1, #self do
        ZA:debug("Terwtop")
        if self[i].id == ID then
            if self[i].cash == nil or self[i].cash == "NULL" then
                return false
            end
            if type == 'get' then
                ZA:debug(type,value)
                TriggerEvent('UpdateSql', ID, self[i])
                return self[i].cash
            elseif type == 'set' then
                ZA:debug(type,value)
                self[i].cash = value
                TriggerEvent('UpdateSql', ID, self[i])
                TriggerClientEvent('UICashSync', ID, self[i].cash)
                return true
            end
        end
        
    end
    return false
end

function Player:Bank(ID ,type ,amount)
    local value = amount or 0
    for i = 1, #self do
        ZA:debug("Terwtop")
        if self[i].id == ID then
            if self[i].bank == nil or self[i].bank == "NULL" then
                return false
            end
            if type == 'get' then
                ZA:debug(type,value)
                TriggerEvent('UpdateSql', ID, self[i])
                return self[i].bank
            elseif type == 'set' then
                ZA:debug(type,value)
                self[i].bank = value
                TriggerEvent('UpdateSql', ID, self[i])
                return true
            end
        end
    end
    return false
end

function Player:Wanted(ID ,type ,amount)
    local value = amount or 0
    for i = 1, #self do
        ZA:debug("Terwtop")
        if self[i].id == ID then
            if self[i].wanted == nil or self[i].wanted == "NULL" then
                return false
            end
            if type == 'get' then
                ZA:debug(type,value)
                TriggerEvent('UpdateSql', ID, self[i])
                return self[i].wanted
            elseif type == 'set' then
                ZA:debug(type,value)
                self[i].wanted = value
                TriggerEvent('UpdateSql', ID, self[i])
                return true
            end
        end
    end
    return false
end

RegisterCommand('cash', function(source, args, rawCommand)
    local src = source
    ZA:debug(Player:Cash(src, 'get'))
end)

RegisterCommand('setcash', function(source, args, rawCommand)
    local src = source
    ZA:debug(Player:Cash(src, "set", tonumber(args[1])))
end)


AddEventHandler('playerDropped', function (reason)
    local src = source
    print('Player ' .. GetPlayerName(src) .. ' dropped (Reason: ' .. reason .. '')
    TriggerEvent('UpdateSql', src, Player:GetPlayerData(src))
  end)



function PlayerIdentifier(type, id)
    local identifiers = {}
    local numIdentifiers = GetNumPlayerIdentifiers(id)

    for a = 0, numIdentifiers do
        table.insert(identifiers, GetPlayerIdentifier(id, a))
    end

    for b = 1, #identifiers do
        if string.find(identifiers[b], type, 1) then
            return identifiers[b]
        end
    end
    return false
end