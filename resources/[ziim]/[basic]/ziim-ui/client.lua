function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

local cash, bank, wanted = nil

-- Speedometer
local SPEEDO = {
	Speed 			= 'mph', -- "kmh" or "mph"
    SpeedIndicator 	= true,
}
local UI = { 
    x =  0.000 ,
    y = -0.001 ,
}

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

Citizen.CreateThread(function()
    while true do Citizen.Wait(1)
    
        local MyPed = GetPlayerPed(-1)
            
        if(IsPedInAnyVehicle(MyPed, false))then

			local MyPedVeh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
			local PlateVeh = GetVehicleNumberPlateText(MyPedVeh)
			local VehStopped = IsVehicleStopped(MyPedVeh)
			local VehEngineHP = GetVehicleEngineHealth(MyPedVeh)
			local VehBodyHP = GetVehicleBodyHealth(MyPedVeh)
            local VehBurnout = IsVehicleInBurnout(MyPedVeh)
            
                
			if SPEEDO.Speed == 'mph' then
				Speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 2.236936
			else
				Speed = 0.0
			end
        
            if SPEEDO.SpeedIndicator then
                local safeZoneOffset = (GetSafeZoneSize() / 2.5) - 0.4
                if SPEEDO.Speed == 'mph' then
                    local y = 1.432 + safeZoneOffset
                    local x = 0.655 - safeZoneOffset
                    drawTxt(x, 	y, 1.0,1.0,0.64 , "~w~" .. math.ceil(Speed), 255, 255, 255, 255)
                    y = 1.439 + safeZoneOffset
                    x = 0.672 - safeZoneOffset
                    drawTxt(x, 	y, 1.0,1.0,0.4, "~w~ mp/h", 255, 255, 255, 255)
                else
                    local y = 1.438 + safeZoneOffset
                    local x = 0.81 - safeZoneOffset
                    drawTxt(x, y, 1.0,1.0,0.64 , [[Carhud ~r~ERROR~w~ ~c~in ~w~SPEEDO Speed~c~ config (something else than ~y~'kmh'~c~ or ~y~'mph'~c~)]], 255, 255, 255, 255)
                end
            end
        end
    end
end)


-- Player Location Display

local zones = { ['AIRP'] = "LS International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['GALLI'] = "Vinewood Sign", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['golf'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['BAYTRE'] = "Vinewood Hills", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }

local directions = { [0] = 'North', [45] = 'North West', [90] = 'West', [135] = 'South West', [180] = 'South', [225] = 'South East', [270] = 'East', [315] = 'North East', [360] = 'North', } 

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())

		for k,v in pairs(directions)do
			direction = GetEntityHeading(GetPlayerPed(-1))
			if(math.abs(direction - k) < 22.5)then
				direction = v
				break;
			end
        end
        if (GetVehiclePedIsIn(GetPlayerPed(-1),false) ~= 0 ) then
            if (GetStreetNameFromHashKey(var1)) and (GetStreetNameFromHashKey(var2)) and GetNameOfZone(pos.x, pos.y, pos.z) then
                local safeZoneOffset = (GetSafeZoneSize() / 2.5) - 0.4
                if var2 == nil or tostring(GetStreetNameFromHashKey(var2)) == "" then 
                    if zones[GetNameOfZone(pos.x, pos.y, pos.z)] and tostring(GetStreetNameFromHashKey(var1)) then
                        local y = 1.472 + safeZoneOffset
                        local x = 0.655 - safeZoneOffset
                        drawTxt(x, y, 1.0,1.0,0.4, direction .. "~w~ | ~w~" .. tostring(GetStreetNameFromHashKey(var1)) .. "~w~" .. "~w~ | ~w~" .. zones[GetNameOfZone(pos.x, pos.y, pos.z)], 255, 255, 255, 255)
                    end 
                else
                    if zones[GetNameOfZone(pos.x, pos.y, pos.z)] and tostring(GetStreetNameFromHashKey(var1)) and tostring(GetStreetNameFromHashKey(var2)) then
                        local y = 1.472 + safeZoneOffset
                        local x = 0.655 - safeZoneOffset
                        drawTxt(x, y, 1.0,1.0,0.4, direction .. "~w~ | ~w~" .. tostring(GetStreetNameFromHashKey(var2)) .. "~w~ | ~w~" .. tostring(GetStreetNameFromHashKey(var1)) .. "~w~" .. "~w~ | ~w~" .. zones[GetNameOfZone(pos.x, pos.y, pos.z)], 255, 255, 255, 255)
                        --print("Zones: " .. zones[GetNameOfZone(pos.x, pos.y, pos.z)] .. " | StreetName: " .. tostring(GetStreetNameFromHashKey(var1)))
                    end 
                end
            end
		end
	end
end)

-- Time Display
local hour = GetClockHours()
local minute = GetClockMinutes()

function CalculateTimeToDisplay()
	hour = GetClockHours()
    minute = GetClockMinutes()

        if hour == 0 or hour == 24 then
            hour = 12
        end
		if hour >= 13 then
			hour = hour - 12
        end
        
	if hour <= 9 then
		hour = "0" .. hour
	end
	if minute <= 9 then
		minute = "0" .. minute
	end
end



Citizen.CreateThread(function()
	while true do
		Wait(1)
		timeAndDateString = ""
		
        if tonumber(GetClockHours()) >= 13 then
            CalculateTimeToDisplay()
			timeAndDateString = timeAndDateString .. hour .. ":" .. minute .. " PM" -- Example: Time: 00:00
        else
            CalculateTimeToDisplay()
			timeAndDateString = timeAndDateString .. hour .. ":" .. minute .. " AM" -- Example: Time: 00:00
        end
        local safeZoneOffset = (GetSafeZoneSize() / 2.5) - 0.4
        if (GetVehiclePedIsIn(GetPlayerPed(-1),false) ~= 0 ) then
            if IsThisModelACar(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1),false))) then
                if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1),false), -1) ~= GetPlayerPed(-1) then
                    local y = 1.408 + safeZoneOffset
                    local x = 0.655 - safeZoneOffset
                    drawTxt(x,y, 1.0,1.0,0.4, timeAndDateString, 255, 255, 255, 255)
                else
                    local y = 1.408 + safeZoneOffset
                    local x = 0.655 - safeZoneOffset
                    drawTxt(x, y, 1.0,1.0,0.4, timeAndDateString, 255, 255, 255, 255)
                end
            else
                if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1),false), -1) ~= GetPlayerPed(-1) then
                    local y = 1.408 + safeZoneOffset
                    local x = 0.655 - safeZoneOffset
                    drawTxt(x, y, 1.0,1.0,0.4, timeAndDateString, 255, 255, 255, 255)
                else
                    local y = 1.408 + safeZoneOffset
                    local x = 0.655 - safeZoneOffset
                    drawTxt(x, y, 1.0,1.0,0.4, timeAndDateString, 255, 255, 255, 255)
                end
            end
        else
            local y = 1.472 + safeZoneOffset
            local x = 0.655 - safeZoneOffset
            --print(x)
            drawTxt(x, y, 1.0,1.0,0.4, timeAndDateString, 255, 255, 255, 255)
        end
	end
end)

RegisterNetEvent('UICashSync')
AddEventHandler('UICashSync', function(Cash, Bank, Wanted)
    if Cash ~= nil then
        cash = Cash
    end
    if Bank ~= nil then
        bank = Bank
    end
    if Wanted ~= nil then
        wanted = Wanted
    end
end)

function comma_value(n) -- credit http://richard.warburton.it
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

Citizen.CreateThread(function()
	while true do
        Wait(1)
        
        local safeZoneOffset = (GetSafeZoneSize() / 2.5) - 0.4
        if cash ~= nil then
            local cashString = string.format("~g~$~w~" .. comma_value(cash))
            if (GetVehiclePedIsIn(GetPlayerPed(-1),false) ~= 0 ) then
                if IsThisModelACar(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1),false))) then
                    if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1),false), -1) ~= GetPlayerPed(-1) then
                        local y = 1.383 + safeZoneOffset
                        local x = 0.655 - safeZoneOffset
                        drawTxt(x,y, 1.0,1.0,0.4, cashString, 255, 255, 255, 255)
                    else
                        local y = 1.383 + safeZoneOffset
                        local x = 0.655 - safeZoneOffset
                        drawTxt(x, y, 1.0,1.0,0.4, cashString, 255, 255, 255, 255)
                    end
                else
                    if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1),false), -1) ~= GetPlayerPed(-1) then
                        local y = 1.383 + safeZoneOffset
                        local x = 0.655 - safeZoneOffset
                        drawTxt(x, y, 1.0,1.0,0.4, cashString, 255, 255, 255, 255)
                    else
                        local y = 1.383 + safeZoneOffset
                        local x = 0.655 - safeZoneOffset
                        drawTxt(x, y, 1.0,1.0,0.4, cashString, 255, 255, 255, 255)
                    end
                end
            else
                local y = 1.447 + safeZoneOffset
                local x = 0.655 - safeZoneOffset
                --print(x)
                drawTxt(x, y, 1.0,1.0,0.4, cashString, 255, 255, 255, 255)
            end

        end
	end
end)

-- Speed Restricter(Limits speed, for realistic driving)
-- local useMph = true -- if false, it will display speed in kph

-- local useMph = true -- if false, it will display speed in kph

-- Citizen.CreateThread(function()
--   local resetSpeedOnEnter = true
--   local cruiseEnabled = false
--   while true do
--         Wait(0)
--         local playerPed = GetPlayerPed(-1)
--         local vehicle = GetVehiclePedIsIn(playerPed,false)
--         if GetPedInVehicleSeat(vehicle, -1) == playerPed and IsPedInAnyVehicle(playerPed, false) then
--         -- This should only happen on vehicle first entry to disable any old values
--         if resetSpeedOnEnter then
--             maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
--             SetEntityMaxSpeed(vehicle, maxSpeed)
--             resetSpeedOnEnter = false
--             cruiseEnabled = false
--         end
--         -- Disable speed limiter
--         local safeZoneOffset = (GetSafeZoneSize() / 2.5) - 0.4
--         if IsControlJustReleased(0,246) and cruiseEnabled == true then
--             cruiseEnabled = false
--             maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
--             SetEntityMaxSpeed(vehicle, maxSpeed)
--             --drawTxt(0.670, 1.460, 1.0,1.0,0.4, "Cruise Control: ~r~Disabled", 255,255,255,255)
--         -- Enable speed limiter
--         elseif IsControlJustReleased(0,246) and cruiseEnabled == false then
--             cruiseEnabled = true
--             cruise = GetEntitySpeed(vehicle)
--             SetEntityMaxSpeed(vehicle, cruise)
--             if useMph then
--                 cruise = math.floor(cruise * 2.23694 + 0.5)
--                 --drawTxt(0.670, 1.460, 1.0,1.0,0.4,"Cruise Control: ~g~Enabled", 255,255,255,255)
--             end
--         end
--         if (GetVehiclePedIsIn(GetPlayerPed(-1),false) ~= 0 ) then
--             if IsThisModelACar(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1),false))) then
--                 local y = 1.408 + safeZoneOffset
--                 local x = 0.7135 - safeZoneOffset
--                 if cruiseEnabled then
--                     drawTxt(x, y, 1.0,1.0,0.4, "~g~CRUISE", 255,255,255,255)
--                 else
--                     drawTxt(x, y, 1.0,1.0,0.4, "~r~CRUISE", 255,255,255,255)
--                 end
--             else
--                 local y = 1.408 + safeZoneOffset
--                 local x = 0.7135 - safeZoneOffset
--                 if cruiseEnabled then
--                     drawTxt(x, y, 1.0,1.0,0.4, "~g~CRUISE", 255,255,255,255)
--                 else
--                     drawTxt(x, y, 1.0,1.0,0.4, "~r~CRUISE", 255,255,255,255)
--                 end
--             end
--         end
--     else 
--         resetSpeedOnEnter = true
--     end
--   end
-- end)

-- seatbelt

-- SEATBELT PARAMETERS
-- local seatbeltInput = 29                   -- Toggle seatbelt on/off with K or DPAD down (controller)
-- local seatbeltPlaySound = true              -- Play seatbelt sound
-- local seatbeltDisableExit = true            -- Disable vehicle exit when seatbelt is enabled
-- local seatbeltEjectSpeed = 25.0           -- Speed threshold to eject player (MPH)
-- local seatbeltEjectAccel = 70.0         -- Acceleration threshold to eject player (G's)
-- local seatbeltColorOn = {160, 255, 160}     -- Color used when seatbelt is on
-- local seatbeltColorOff = {255, 96, 96}      -- Color used when seatbelt is off
-- local enableController = true

-- Citizen.CreateThread(function()
--     local currSpeed = 0.0
--     local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}
--     local seatbeltIsOn = false

--     while true do
--         Wait(0)

--         local player = GetPlayerPed(-1)
--         local position = GetEntityCoords(player)
--         local vehicle = GetVehiclePedIsIn(player, false)

--         if IsPedInAnyVehicle(player, false) then
--             pedInVeh = true
--         else
--             -- Reset states when not in car
--             pedInVeh = false
--             seatbeltIsOn = false
--         end
--         if pedInVeh then
--             local prevSpeed = currSpeed
--             local safeZoneOffset = (GetSafeZoneSize() / 2.5) - 0.4
--             currSpeed = GetEntitySpeed(vehicle)

--             -- Set PED flags
--             SetPedConfigFlag(PlayerPedId(), 32, true)
            
--             -- Check if seatbelt button pressed, toggle state and handle seatbelt logic
--             if IsControlJustReleased(0, seatbeltInput) and (enableController or GetLastInputMethod(0)) and vehicleClass ~= 8 then
--                 -- Toggle seatbelt status and play sound when enabled
--                 print("Setting seatbelt")
--                 seatbeltIsOn = not seatbeltIsOn
--                 if seatbeltPlaySound then
--                     PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
--                 end
--             end
--             if not seatbeltIsOn then
--                 -- Eject PED when moving forward, vehicle was going over 45 MPH and acceleration over 100 G's
--                 local vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
--                 local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
--                 --print("PrevSpeed: " .. prevSpeed .. "| Curr Speed: " ..  currSpeed .. "| FrameTime:" .. GetFrameTime())
--                 if (vehIsMovingFwd and (prevSpeed > (seatbeltEjectSpeed/2.237)) and (vehAcc > (seatbeltEjectAccel*9.81))) then
--                     print("Ejecting")
--                     SetEntityCoords(player, position.x, position.y, position.z - 0.47, true, true, true)
--                     SetEntityVelocity(player, prevVelocity.x, prevVelocity.y, prevVelocity.z)
--                     Citizen.Wait(1)
--                     SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
--                 else
--                     -- Update previous velocity for ejecting player
--                     prevVelocity = GetEntityVelocity(vehicle)
--                 end
--             elseif seatbeltDisableExit then
--                 -- Disable vehicle exit when seatbelt is on
--                 DisableControlAction(0, 75)
--             end
--             local ped = GetPlayerPed(-1)
--             if (GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) == ped) then
--                 local y = 1.408 + safeZoneOffset
--                 local x = 0.655 - safeZoneOffset
--                 if seatbeltIsOn then 
--                     drawTxt(x, y, 1.0,1.0,0.4, "~g~BELT", 255,255,255,255)
--                 else 
--                     drawTxt(x, y, 1.0,1.0,0.4, "~r~BELT", 255,255,255,255)
--                 end
--             else

--                 if seatbeltIsOn then 
--                     drawTxt(x, y, 1.0,1.0,0.4, "~g~BELT", 255,255,255,255)
--                 else 
--                     drawTxt(x, y, 1.0,1.0,0.4, "~r~BELT", 255,255,255,255)
--                 end
--             end
--         end
--     end
-- end)

--Vehicle Plate Show
--[[Citizen.CreateThread(function()
    local ped = GetPlayerPed(-1)
    while true do
        Wait(0)
        if IsPedInAnyVehicle(ped, false) then
            
            local veh = GetVehiclePedIsIn(ped)
            print(veh)
            local plate = GetVehicleNumberPlateText(veh)
            
            local safeZoneOffset = (GetSafeZoneSize() / 2.5) - 0.4
            local y = 1.300 + safeZoneOffset
            local x = 0.672 - safeZoneOffset

            drawTxt(x, 	y, 1.0,1.0,0.64 , "~w~" .. plate, 255, 255, 255, 255)
        end
    end
end)]]--

function showHelpNotification(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end