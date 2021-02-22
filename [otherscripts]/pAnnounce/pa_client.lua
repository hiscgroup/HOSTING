local p = {} -- NO TOUCHY TOUCHY
-----------[ CONFIG ]---------------------------------------------------

-- Delay in minutes between messages
p.delay = 20


p.prefix = '^1[Apocalypse RP]'
p.suffix = '^1.'

p.messages = {   
'^6Ο Server μας έχει αυτόματα ^*^6ΕΠΑΝΕΚΚΙΝΗΣΗ^0^r της εξής ώρες : 0:00, 04:00 , 08:00 , 12:00 , 16:00 , 20:00',
'^6Παντα να παιζετε σοβαρο rp.',
'^6Διάβασε τους κανόνες!',
'^6Όταν έχετε χάσει τις αισθήσεις σας και περιμένετε Ε.Κ.Α.Β. μπορείτε να κάνετε report μόνο πατώντας το F8 και γράφοντας χωρίς το slash (/) το report σας. Π.χ. (report me ekanan vdm)',
}

p.ignore = { 
    'ip:127.0.1.5',
    'steam:123456789123456',
    'license:1654687313215747944131321',
}
--------------------------------------------------------------------------


















-----[ CODE, DON'T TOUCH THIS ]-------------------------------------------
local playerIdentifiers
local enableMessages = true
local timeout = p.delay * 1000 * 60 -- from ms, to sec, to min
local playerOnIgnore = false
RegisterNetEvent('pa:setPlayerIdentifiers')
AddEventHandler('pa:setPlayerIdentifiers', function(identifiers)
    playerIdentifiers = identifiers
end)
Citizen.CreateThread(function()
    while playerIdentifiers == {} or playerIdentifiers == nil do
        Citizen.Wait(1000)
        TriggerServerEvent('pa:getPlayerIdentifiers')
    end
    for iid in pairs(p.ignore) do
        for pid in pairs(playerIdentifiers) do
            if p.ignore[iid] == playerIdentifiers[pid] then
                playerOnIgnore = true
                break
            end
        end
    end
    if not playerOnIgnore then
        while true do
            for i in pairs(p.messages) do
                if enableMessages then
                    chat(i)
                    print('[pAnnounce] Message #' .. i .. ' sent.')
                end
                Citizen.Wait(timeout)
            end
            
            Citizen.Wait(0)
        end
    else
        print('[pAnnounce] Player is on ignore list, no announcements will be received.')
    end
end)
function chat(i)
    TriggerEvent('chatMessage', '', {255,255,255}, p.prefix .. p.messages[i] .. p.suffix)
end
RegisterCommand('pannounce', function()
    enableMessages = not enableMessages
    if enableMessages then
        status = '^2enabled^5.'
    else
        status = '^1disabled^5.'
    end
    TriggerEvent('chatMessage', '', {255, 255, 255}, '^5[pAnnounce] automessages are now ' .. status)
end, false)
--------------------------------------------------------------------------