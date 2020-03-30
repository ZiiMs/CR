local ZAM = ZiiM_Admin_Menu
local vehicles = {}

function ZAM:debug(...)
    local arg ={...}
    if self.debugEnable then
        local result = ""
        for i, v in ipairs(arg) do
            result = result .. tostring(v) .. "\t"
        end
        print("^1[S-ZAM-debug:" .. debug.getinfo(2).currentline .. "]:^0 " .. tostring(result))
    end
end

RegisterServerEvent('UpdateVehList')
AddEventHandler('UpdateVehList', function(vehName, pName, veh)
    local src = source
    if vehName ~= nil and pName ~= nil and veh ~= nil then
        local tempTbl = {
            vName =  vehName,
            Player = pName,
            veh = veh
        }
        table.insert(vehicles, tempTbl)
        TriggerClientEvent('GetVehList', -1, vehicles)
    end 
end)

RegisterServerEvent('DeleteVehList')
AddEventHandler('DeleteVehList', function(vID)
    local src = source
    if vID ~= nil then
        for k, i in pairs(vehicles) do
            if i.veh == vID then
                table.remove(vehicles, k)
                TriggerClientEvent('GetVehList', -1, vehicles)
            end
        end
    end 
end)

RegisterServerEvent("SaveCoords")
AddEventHandler("SaveCoords", function( PlayerName , x, y, z, heading)
 	local file = io.open("../server-data/Coords/SavedCoords.json", "a")
	if file then
        file:write(PlayerName .. ": {" .. x .. ", " .. y .. ", " .. z .. ", " .. heading .."} Date: " .. os.date("%c") .. ", \n")
    end
    file:close()
end)