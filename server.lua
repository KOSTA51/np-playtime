RegisterServerEvent('np-playtime:event');
local players = {}


AddEventHandler('np-playtime:event', function()
    players[source] = GetGameTimer()
    local playTimePlayers = json.decode(LoadResourceFile(GetCurrentResourceName(), "./playtime.json"));
    local time = 0;
    local num = GetNumPlayerIdentifiers(source);
    for i=0, num-1 do
        local a = GetPlayerIdentifier(source, i);
        local found = false
        if string.find(a, "steam:") then
            local nerd = a
            for i=1, #playTimePlayers do
                if playTimePlayers[i].identifier == a then
                    playTimePlayers[i].playtime = playTimePlayers[i].playtime + time;
                    found = true;
                    ::skip_to_next::
                end
            end
            if not found then
                playTimePlayers[#playTimePlayers + 1] = {name = GetPlayerName(source), identifier = nerd, playtime = 0}
            end
            SaveResourceFile(GetCurrentResourceName(), "./playtime.json", json.encode(playTimePlayers), -1)
        end
    end
end)
AddEventHandler('playerDropped', function()
    local timer = GetGameTimer()
    local time = timer - players[source]
    local hours = math.floor(time / 3600000)
    local minutes = math.floor((time % 3600000) / 60000)
    local seconds = math.floor((time % 60000) / 1000)
    local time_msg = string.format('%02d:%02d:%02d', hours, minutes, seconds)
    print('Player ' .. GetPlayerName(source) .. ' has played for ' .. time_msg)
    local playTimePlayers = json.decode(LoadResourceFile(GetCurrentResourceName(), "./playtime.json"))
    local num = GetNumPlayerIdentifiers(source)
    for i=0, num-1 do
        local a = GetPlayerIdentifier(source, i) 
        if #playTimePlayers > 0 then
            local found = false
            if string.find(a, "steam:") then
                local nerd = a
                for i=1, #playTimePlayers do
                    if playTimePlayers[i].identifier == a then
                        playTimePlayers[i].playtime = playTimePlayers[i].playtime + time;
                        found = true
                        ::skip_to_next::
                    end
                end
                if not found then
                    playTimePlayers[#playTimePlayers + 1] = {name = GetPlayerName(source), identifier = nerd, playtime = time/1000}
                end
                SaveResourceFile(GetCurrentResourceName(), "./playtime.json", json.encode(playTimePlayers), -1)
                players[source] = nil
            end
        end
    end
end)
-- http://localhost:30120/np-playtime/playtime
SetHttpHandler(function(req,res)
    if req.path == '/playtime.json' then
        res.send(LoadResourceFile(GetCurrentResourceName(), "./playtime.json"));
    end
end)