local ZB = ZiiM_Basic

RegisterCommand('gotols', function(source, args, rawCommand)
    local ped = GetPlayerPed(-1)
    SetFocusArea(192.662, -941.161, 30.692, 0.0, 0.0, 0.0)
    SetPedCoordsKeepVehicle(ped, 192.662, -941.161, 30.692)
    FreezeEntityPosition(ped, true)
    Wait(1500)
    FreezeEntityPosition(ped, false)
end)

