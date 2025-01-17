local playerID = GetPlayerServerId(PlayerId())
local rpScore = 'C'

function UpdateRPScore()
    TriggerServerEvent('rp:getScore')
end

RegisterNetEvent('rp:returnScore')
AddEventHandler('rp:returnScore', function(score)
    if score then
        rpScore = score
    else
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100) 
        if IsPauseMenuActive() then
            UpdateRPScore()
            local color = GetColorForScore(rpScore)

            AddTextEntry('FE_THDR_GTAO', 'YOUR SERVER NAME | RP Score : ~' .. color .. '~' .. rpScore .. '~w~ | ID : ~b~' .. playerID .. ' ~w~| PLAYERS : ')
        end
    end
end)

function AddTextEntry(key, value)
    Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

RegisterNetEvent('rp:SetRPScore')
AddEventHandler('rp:SetRPScore', function(newScore)
    SetRPScore(newScore)
end)

function SetRPScore(newScore)
    local validScores = { 'S', 'A', 'B', 'C', 'D', 'E' }
    for _, score in ipairs(validScores) do
        if newScore == score then
            rpScore = newScore
            TriggerServerEvent('rp:setScore', newScore) 
            return
        end
    end
end

function GetColorForScore(score)
    local colors = {
        S = 'b', 
        A = 'g', 
        B = 'g', 
        C = 'y', 
        D = 'o', 
        E = 'r' 
    }
    return colors[score] or 'w' 
end
