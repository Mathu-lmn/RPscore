local playerID = GetPlayerServerId(PlayerId())
local rpScore = 'C'

RegisterNetEvent('rpscore:returnScore', function(score)
    if score then
        rpScore = score
    end
end)

CreateThread(function()
    while true do
        Wait(100) 
        if IsPauseMenuActive() then
            TriggerServerEvent('rpscore:getScore')
            local color = GetColorForScore(rpScore)

            AddTextEntry('FE_THDR_GTAO', 'YOUR SERVER NAME | RP Score : ~' .. color .. '~' .. rpScore .. '~w~ | ID : ~b~' .. playerID .. ' ~w~| PLAYERS : ')
        end
    end
end)

RegisterNetEvent('rpscore:SetRPScore', function(newScore)
    SetRPScore(newScore)
end)

function SetRPScore(newScore)
    local validScores = { 'S', 'A', 'B', 'C', 'D', 'E' }
    for _, score in ipairs(validScores) do
        if newScore == score then
            rpScore = newScore
            TriggerServerEvent('rpscore:setScore', newScore) 
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
