ESX = exports["es_extended"]:getSharedObject()
local playerRPScores = {}

ESX.RegisterServerCallback('rpscore:getPlayerScore', function(source, cb, targetId)
    local player = ESX.GetPlayerFromId(targetId) 

    if player then
        local playerID = player.identifier

        exports.oxmysql:scalar('SELECT rp_score FROM users WHERE identifier = @identifier', {
            ['@identifier'] = playerID
        }, function(score)
            if score then
                cb(score)  
            else
                cb('C')  
            end
        end)
    else
        cb('C')  
    end
end)

RegisterServerEvent('rpscore:getScore', function()
    local _source = source
    local player = ESX.GetPlayerFromId(_source)

    if player then
        local playerID = player.identifier

        exports.oxmysql:scalar('SELECT rp_score FROM users WHERE identifier = @identifier', {
            ['@identifier'] = playerID
        }, function(score)
            if score then
                TriggerClientEvent('rpscore:returnScore', _source, score)
            else
                TriggerClientEvent('rpscore:returnScore', _source, 'C')
            end
        end)
    else
    end
end)

function ModifyRPScore(playerId, newScore)
    local player = ESX.GetPlayerFromId(playerId)

    if player then
        local playerID = player.identifier
        playerRPScores[playerID] = newScore

        exports.oxmysql:update('UPDATE users SET rp_score = @newRPScore WHERE identifier = @identifier', {
            ['@newRPScore'] = newScore,
            ['@identifier'] = playerID
        }, function(affectedRows)
            if affectedRows > 0 then
                print(("Player %s's RP score has been successfully updated in the database to %s"):format(playerID, newScore))
            else
                print("Failed to update RP score in the database for player: " .. playerID)
            end
        end)
    else
        print("Error: Player not found with ID " .. playerId)
    end
end

RegisterNetEvent('rpscore:modify', function(serverId, newRPScore)
    if newRPScore and debug and tostring(newRPScore):match("^[SABCDE]$") then
        ModifyRPScore(serverId, newRPScore)
    else
        print("Error: the new RP score is invalid.")
    end
end)

RegisterNetEvent('rpscore:setScore', function(newScore)
    local _source = source
    local player = ESX.GetPlayerFromId(_source)

    if player and tostring(newScore):match("^[SABCDE]$") then
        local playerID = player.identifier

        exports.oxmysql:update('UPDATE users SET rp_score = @rp_score WHERE identifier = @identifier', {
            ['@rp_score'] = newScore,
            ['@identifier'] = playerID
        }, function(rowsChanged)
            if rowsChanged > 0 then
                if newScore == 'E' then
                    BanPlayer(_source)  
                end
            else
            end
        end)
    else
    end
end)

function BanPlayer(playerId)
    local player = ESX.GetPlayerFromId(playerId)
    
    if player then
        local playerID = player.identifier
        
        DropPlayer(playerId, "BANNED FROM YOUR SERVER NAME \n Reason: RP SCORE E \n Duration: 48h \n ERROR CODE (B008).")

        local banDuration = 48 * 60 * 60 
        local expireTimestamp = os.time() + banDuration 

        exports.oxmysql:update('INSERT INTO bans (identifier, reason, duration, expire_time) VALUES (@identifier, @reason, @duration, FROM_UNIXTIME(@expire_time))', {
            ['@identifier'] = playerID,
            ['@reason'] = 'RP score of "E"',
            ['@duration'] = banDuration,
            ['@expire_time'] = expireTimestamp 
        }, function(affectedRows)
            if affectedRows > 0 then
                print(("Player %s has been banned for 48 hours."):format(playerID))
                ResetRPScore(playerID, 'D')
            else
                print("Error recording the ban in the database.")
            end
        end)
    else
        print("Error: Player not found with ID " .. playerId)
    end
end

function CheckScores()
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local player = ESX.GetPlayerFromId(playerId)
        if player then
            local playerID = player.identifier
            exports.oxmysql:scalar('SELECT rp_score FROM users WHERE identifier = @identifier', {
                ['@identifier'] = playerID
            }, function(score)
                if score == 'E' then
                    BanPlayer(playerId) 
                end
            end)
        end
    end
end

CreateThread(function()
    while true do
        Wait(1000) 
        CheckScores()
    end
end)

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local playerId = ESX.GetIdentifier(source) or ""

    deferrals.defer()

    if playerId ~= "" then
        print("Checking ban for player: " .. playerId)
        exports.oxmysql:scalar('SELECT expire_time FROM bans WHERE identifier = @identifier AND expire_time > NOW()', {
            ['@identifier'] = playerId
        }, function(expireTime)
            if expireTime then
                local expireTimestamp = tonumber(expireTime) / 1000 
                local formattedExpireTime = os.date('%d-%m-%Y %H:%M:%S', expireTimestamp) 

                local message = string.format("\nConnection impossible ❌\n You are banned until %s \n Reason: RP score E \n ERROR CODE (B008) 🏴‍☠️", formattedExpireTime)
                print("Player " .. playerId .. " is banned until " .. formattedExpireTime)
                deferrals.done(message)
            else
                print("Player " .. playerId .. " is not banned, connection allowed.")
                deferrals.done()
            end
        end)
    else
        print("Error: Identifier not found for player.")
        deferrals.done("Connection error: identifier not found.")
    end
end)

function ResetRPScore(playerID, newScore)
    exports.oxmysql:update('UPDATE users SET rp_score = @rp_score WHERE identifier = @identifier', {
        ['@rp_score'] = newScore,
        ['@identifier'] = playerID
    }, function(rowsChanged)
        if rowsChanged > 0 then
            print(("Player %s's RP score has been reset to %s."):format(playerID, newScore))
        else
            print("Error resetting RP score for player " .. playerID)
        end
    end)
end












