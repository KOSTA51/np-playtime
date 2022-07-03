local first = false
AddEventHandler('playerSpawned', function()
    if not first then TriggerServerEvent('np-playtime:event') end
end)