
local ZAM = ZiiM_Admin_Menu
local dropShadow = false


function ZAM:SpawnLocalCar(x, y, z, car, carhash, heading, prim, sec, teleport)
    local tp = teleport or true
    RequestModel(carhash)
    local timer = GetGameTimer()
    while not HasModelLoaded(carhash) do
        Wait(1)
        if GetGameTimer() > timer + 30000 then
            print("Error: Spawning car!")
            return
        end
    end
    local vehicle = CreateVehicle(GetHashKey(car), x, y, z, heading, true, true)
    SetVehicleColours(vehicle, prim, sec)
    if tp then
        SetPedIntoVehicle(GetPlayerPed(PlayerId()), vehicle, -1)
    end
    SetVehicleNumberPlateText(vehicle, "TMP " .. GetPlayerName(PlayerId()))
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 65)
end

function getNearestVeh()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 12294, GetPlayerPed(-1), 0)
    local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
    return vehicleHandle
end

function DrawText3Dme(x,y,z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = ((1/dist)*2)*(1/GetGameplayCamFov())*100

    if onScreen then

        -- Formalize the text
        SetTextColour(255, 255, 255, 215)
        SetTextScale(0.0*scale, 0.35*scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextCentre(1)
        if dropShadow then
            SetTextDropshadow(10, 100, 100, 100, 255)
        end

        -- Calculate width and height
        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55*scale, font)
        local width = EndTextCommandGetWidth(font)

        -- Diplay the text
        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)

        DrawRect(_x, _y+scale/45, width+0.01, height+0.015, 41, 11, 41 , 68)

    end
end

function alert(msg) 
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end

function GetPlayersInArea(coords, area)
	local players       = ESX.Game.GetPlayers()
	local playersInArea = {}

	for i=1, #players, 1 do
		local target       = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)
		local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(playersInArea, players[i])
		end
	end

	return playersInArea
end

function GetPlayers()
	local maxPlayers = 32
	local players    = {}

	for i=0, maxPlayers, 1 do

		local ped = GetPlayerPed(i)

		if DoesEntityExist(ped) then
			table.insert(players, i)
		end
	end

	return players
end