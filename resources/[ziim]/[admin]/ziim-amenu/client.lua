local ZAM = ZiiM_Admin_Menu
local VList = {}
local SentData = nil
local tempValue, tempStat

function ZAM:debug(...)
    local arg ={...}
    if self.debugEnable then
        local result = ""
        for i, v in ipairs(arg) do
            result = result .. tostring(v) .. "\t"
        end
        print("^1[C-ZAM-debug:" .. debug.getinfo(2).currentline .. "]:^0 " .. tostring(result))
    end
end

RegisterCommand('menu', function(source, args, rawCommand)
    RageUI.Visible(RMenu:Get('adminmenu', 'main'), not RageUI.Visible(RMenu:Get('adminmenu', 'main')))
end, true)

RegisterCommand('cash2', function(source, args, rawCommand)
    local amount = args[3] or 0
    TriggerServerEvent('SendData', source, args[1], args[2], amount)
    ZAM:debug("SentDat: " .. tostring(SentData))
    while SentData == nil do
        Wait(0)
    end
    ZAM:debug(SentData)
    SentData = nil
end)

RMenu.Add('adminmenu', 'main', RageUI.CreateMenu("Admin Menu", "Admin Menu by ZiiM", 1330))
-- RMenu.Add('adminmenu', 'players', RageUI.CreateMenu("Player List", "~b~Admin Menu", 1330))
RMenu:Get('adminmenu', 'main'):SetSubtitle("~b~Admin Menu")
RMenu:Get('adminmenu', 'main').Closed = function()
    -- TODO Perform action
end;

RMenu.Add('adminmenu', 'carspawning', RageUI.CreateSubMenu(RMenu:Get('adminmenu', 'main'), "Vehicle Spawning", "~b~Admin Menu"))
RMenu.Add('adminmenu', 'tpmenu', RageUI.CreateSubMenu(RMenu:Get('adminmenu', 'main'), "Teleports", "~b~Admin Menu"))
RMenu.Add('adminmenu', 'players', RageUI.CreateSubMenu(RMenu:Get('adminmenu', 'main'),"Player List", "~b~Admin Menu"))
RMenu.Add('adminmenu', 'devmenu', RageUI.CreateSubMenu(RMenu:Get('adminmenu', 'main'), "Developer Menu", "~b~Admin Menu"))
RMenu.Add('adminmenu', 'carmenu', RageUI.CreateSubMenu(RMenu:Get('adminmenu', 'main'), "Vehicle Options", "~b~Admin Menu"))
RMenu.Add('adminmenu', 'pmenu', RageUI.CreateSubMenu(RMenu:Get('adminmenu', 'players'), "Player Options", "~b~Admin Menu"))
RMenu.Add('adminmenu', 'vehlist', RageUI.CreateSubMenu(RMenu:Get('adminmenu', 'carspawning'), "Vehicle List", "~b~Admin Menu"))
RMenu.Add('adminmenu', 'vmenu', RageUI.CreateSubMenu(RMenu:Get('adminmenu', 'vehlist'), "Vehicle Menu", "~b~Admin Menu"))
RMenu.Add('adminmenu', 'paint', RageUI.CreateSubMenu(RMenu:Get('adminmenu', 'carmenu'), "Vehicle Options", "~b~Admin Menu"))
RMenu.Add('adminmenu', 'estats', RageUI.CreateSubMenu(RMenu:Get('adminmenu', 'pmenu'),"Edit Stats", "~b~Admin Menu"))
RMenu.Add('adminmenu', 'editmenu', RageUI.CreateSubMenu(RMenu:Get('adminmenu', 'pmenu'),"Edit Menu", "~b~Admin Menu"))
RMenu.Add('adminmenu', 'storemenu', RageUI.CreateSubMenu(RMenu:Get('adminmenu', 'devmenu'), "Store Menu", "~b~Admin Menu"))

RMenu:Get('adminmenu', 'main').EnableMouse = true
RMenu:Get('adminmenu', 'carmenu').EnableMouse = true
RMenu:Get('adminmenu', 'paint').EnableMouse = true
RMenu:Get('adminmenu', 'carspawning').EnableMouse = true

local vSpawning = {
    primColor = {0,0,0},
    secColor = {0,0,0},
    PrimaryColorIndex_One = 1,
    PrimaryColorIndex_Two = 1,
    SecondaryColorIndex_One = 1,
    SecondaryColorIndex_Two = 1,
    SelectedCar = "Panto"
}

local sMenu = {
    crter = false,
}

local vOptions = {
    red = 0,
    green = 0,
    blue = 0
}

local pMenu = {
    GM = false,
    SPName = GetPlayerName(PlayerId()),
    SP = PlayerId(),
    SPServer = GetPlayerServerId(PlayerId()),
    Freeze = false,
    stat = nil
}

local vMenu = {
    vName,
    vID,
    vOwner 
}

local dMenu = {
    crdInfo = false,
}


RageUI.CreateWhile(1.0, true , function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'main')) then
        RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
            RageUI.Button("Teleports", "List of teleports!", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected) end, RMenu:Get('adminmenu', 'tpmenu'))

            -- RageUI.Button("Player Options", "Player Options!", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected) 
            --     if (Selected) then
            --         RMenu:Get('adminmenu', 'pmenu'):SetSubtitle('~b~Admin Menu')
            --     end
            -- end, RMenu:Get('adminmenu', 'pmenu'))

            RageUI.Button("Player List", "List of Players!", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected) end, RMenu:Get('adminmenu', 'players'))
        
            RageUI.Button("Vehicle Options", "Vehicle Options!", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected) end, RMenu:Get('adminmenu', 'carmenu'))
        
            RageUI.Button("Vehicle Spawning", "Vehicle Spawning!", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected) end, RMenu:Get('adminmenu', 'carspawning'))

            RageUI.Button("Developer Menu", "Developer Options!", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected) end, RMenu:Get('adminmenu', 'devmenu'))
        
        end, function()
        
        end)

    end

    if RageUI.Visible(RMenu:Get('adminmenu', 'tpmenu')) then
        RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
            local ped = GetPlayerPed(PlayerId())
            RageUI.Button("Goto WP", "Teleports you to your WP!", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    local ground = false
                    local WP = GetFirstBlipInfoId(8)

                    if DoesBlipExist(WP) then
                        local cz = 0.0
                        local crds = GetBlipInfoIdCoord(WP)

                        for height = 1, 1000 do
                            SetPedCoordsKeepVehicle(ped, crds.x, crds.y, ToFloat(height), false, false, false)
                            Wait(0)
                            
                            --ZAM:debug(height, GetGroundZFor_3dCoord(crds.x, crds.y, ToFloat(height), false))
                            if GetGroundZFor_3dCoord(crds.x, crds.y, ToFloat(height), false) then
                                cz = ToFloat(height)
                                ground = true
                                break
                            end
                        end
                        if not ground then
                            cz = -300
                        end
                        SetPedCoordsKeepVehicle(ped, crds.x, crds.y, cz)
                    else
                        RageUI.Text({
                            message = "~r~Error: ~s~You have no waypoint placed!"
                        })
                    end
                end
            end)

            RageUI.Button("Goto LS", "Teleports you to LS!", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    SetFocusArea(192.662, -941.161, 30.692, 0.0, 0.0, 0.0)
                    SetPedCoordsKeepVehicle(ped, 192.662, -941.161, 30.692)
                    FreezeEntityPosition(ped, true)
                    Wait(1500)
                    FreezeEntityPosition(ped, false)
                    ClearFocus()
                end
            end)

            RageUI.Button("Goto Mission Row", "Teleports you to your WP!", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    SetFocusArea(412.15878295898, -968.75372314453, 28.748558044434, 0.0, 0.0, 0.0)
                    SetPedCoordsKeepVehicle(ped, 412.15878295898, -968.75372314453, 28.748558044434)
                    FreezeEntityPosition(ped, true)
                    Wait(1500)
                    FreezeEntityPosition(ped, false)
                    ClearFocus()
                end
            end)

            RageUI.Button("Goto LS Pier", "Teleports you to LS Pier!", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    SetFocusArea(-1840.9465332031, -1226.6357421875, 12.760368347168, 0.0, 0.0, 0.0)
                    SetPedCoordsKeepVehicle(ped, -1840.9465332031, -1226.6357421875, 12.760368347168)
                    FreezeEntityPosition(ped, true)
                    Wait(1500)
                    FreezeEntityPosition(ped, false)
                    ClearFocus()
                end
            end)

            RageUI.Button("Goto LSIA", "Teleports you to LSIA!", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    SetFocusArea(-1189.4094238281, -2996.0600585938, 13.680762290955, 0.0, 0.0, 0.0)
                    SetPedCoordsKeepVehicle(ped, -1189.4094238281, -2996.0600585938, 13.680762290955)
                    FreezeEntityPosition(ped, true)
                    Wait(1500)
                    FreezeEntityPosition(ped, false)
                    ClearFocus()
                end
            end)

            RageUI.Button("Goto Sandy", "Teleports you to Sandy Shores!", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    SetFocusArea(1864.8377685547, 3682.048828125, 33.444355010986, 0.0, 0.0, 0.0)
                    SetPedCoordsKeepVehicle(ped, 1864.8377685547, 3682.048828125, 33.444355010986)
                    FreezeEntityPosition(ped, true)
                    Wait(1500)
                    FreezeEntityPosition(ped, false)
                    ClearFocus()
                end
            end)

            RageUI.Button("Goto Grapeseed", "Teleports you to Grapeseed!", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    SetFocusArea(2135.5727539063, 4813.1372070313, 40.923889160156, 0.0, 0.0, 0.0)
                    SetPedCoordsKeepVehicle(ped, 2135.5727539063, 4813.1372070313, 40.923889160156)
                    FreezeEntityPosition(ped, true)
                    Wait(1500)
                    FreezeEntityPosition(ped, false)
                    ClearFocus()
                end
            end)

            RageUI.Button("Goto Paleto", "Teleports you to Paleto Bay!", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    SetFocusArea(48.146488189697, 6451.95703125, 31.053508758545, 0.0, 0.0, 0.0)
                    SetPedCoordsKeepVehicle(ped, 48.146488189697, 6451.95703125, 31.053508758545)
                    FreezeEntityPosition(ped, true)
                    Wait(1500)
                    FreezeEntityPosition(ped, false)
                    ClearFocus()
                end
            end)

            RageUI.Button("Goto Mount Chiliad", "Teleports you to Mount Chiliad!", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    SetFocusArea(498.07211303711, 5590.5151367188, 794.67504882813, 0.0, 0.0, 0.0)
                    SetPedCoordsKeepVehicle(ped, 498.07211303711, 5590.5151367188, 794.67504882813)
                    FreezeEntityPosition(ped, true)
                    Wait(1500)
                    FreezeEntityPosition(ped, false)
                    ClearFocus()
                end
            end)

            RageUI.Button("Goto fort Zancudo", "Teleports you to fort Zancudo!", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    SetFocusArea(-2167.9624023438, 3127.9416503906, 32.548179626465, 0.0, 0.0, 0.0)
                    SetPedCoordsKeepVehicle(ped, -2167.9624023438, 3127.9416503906, 32.548179626465)
                    FreezeEntityPosition(ped, true)
                    Wait(1500)
                    FreezeEntityPosition(ped, false)
                    ClearFocus()
                end
            end)
        end, function()
        
        end)

    end
    function GetGMText()
        if (pMenu.GM) then return "~g~ON" else return "~r~OFF" end
    end

    if RageUI.Visible(RMenu:Get('adminmenu', 'pmenu')) then
        RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
            local ped = GetPlayerPed(pMenu.SP)
            RageUI.Checkbox("Godmode", "Enables godmode!", pMenu.GM,{}, function(Hovered, Active, Selected) 
                if (Selected) then
                    pMenu.GM = not pMenu.GM
                    SetPlayerInvincible(pMenu.SP, pMenu.GM)
                    ZAM:debug(GetPlayerInvincible(pMenu.SP))
                end
            end)

            RageUI.Button("Heal", "Heals the player!", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    SetEntityHealth(ped, 200)
                    RageUI.Text({
                        message = string.format("You have healed ~r~" .. pMenu.SPName)
                    })
                end
            end)

            RageUI.Button("Armor", "Gives the player armor!", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    AddArmourToPed(ped, 200)
                    RageUI.Text({
                        message = string.format("You have given armour to ~r~" .. pMenu.SPName)
                    })
                end
            end)

            RageUI.Button("Goto", "Goto the selected player!", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    local pos = GetEntityCoords(ped)
                    SetEntityCoords(GetPlayerPed(PlayerId()), pos.x, pos.y, pos.z, false,false,false)
                    RageUI.Text({
                        message = "You have teleported to ~r~" .. pMenu.SPName
                    })
                end
            end)

            RageUI.Button("Bring", "Bring the selected player to you!", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    local pos = GetEntityCoords(GetPlayerPed(PlayerId()))
                    SetEntityCoords(ped, pos.x, pos.y, pos.z, false,false,false)
                    RageUI.Text({
                        message = "You have teleported ~r~" .. pMenu.SPName .. "~s~ to you!"
                    })
                end
            end)

            RageUI.Checkbox("Freeze", "Freezes/Unfreezes selected player!", pMenu.Freeze,{}, function(Hovered, Active, Selected) 
                if (Selected) then
                    pMenu.Freeze = not pMenu.Freeze
                    FreezeEntityPosition(ped, pMenu.Freeze)
                end
            end)

            RageUI.Button("Wanted", "Set wanted level!",{}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    SetFakeWantedLevel(3)
                end
            end)

            RageUI.Button("Edit Stats", "Opens the edit stats menu",{}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    RMenu:Get('adminmenu', 'estats'):SetSubtitle('~b~Selected Player: ~r~' .. pMenu.SPName)
                end
            end, RMenu:Get('adminmenu', 'estats'))
        end, function()
        
        end)

    end
    if RageUI.Visible(RMenu:Get('adminmenu', 'estats')) then
        RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()

            RageUI.Button("Cash", "Sets the players cash", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    pMenu.stat = 'cash'
                    tempStat = 'cash'
                end
            end, RMenu:Get('adminmenu', 'editmenu'))

            RageUI.Button("Bank", "Sets the players bank", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    pMenu.stat = 'bank'
                    tempStat = 'bank'
                end
            end, RMenu:Get('adminmenu', 'editmenu'))

            RageUI.Button("Wanted", "Sets the players wanted level", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    pMenu.stat = 'wanted'
                    tempStat = 'wanted'
                end
            end, RMenu:Get('adminmenu', 'editmenu'))
        end, function()
        
        end)

    end

    if RageUI.Visible(RMenu:Get('adminmenu', 'editmenu')) then
        RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
            if SentData == nil and tempStat == pMenu.stat then
                TriggerServerEvent('SendData', pMenu.SPServer, pMenu.stat, 'get')
                while SentData == nil do
                    RageUI.Text({
                        time_display = 1,
                        message = "Waiting on data: ~r~" .. tostring(SentData)
                    })
                    Wait(0)
                end
                ZAM:debug("SentData: " .. tostring(SentData))
                RMenu:Get('adminmenu', 'editmenu'):SetSubtitle('~b~Selected Player: ~r~' .. pMenu.SPName .. '~b~ | ' .. pMenu.stat .. ': ~r~' .. tostring(SentData))
                tempValue = SentData
                ZAM:debug("KeepoAnal: " .. tempValue)
                tempStat = nil
                SentData = nil
            end
            RageUI.Button("Set", "Sets the stat", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    local amount = KeyboardInput("stat to set", "", 32)
                    TriggerServerEvent('SendData', pMenu.SPServer, pMenu.stat, 'set', math.floor(tonumber(amount)))
                    while SentData == nil do
                        RageUI.Text({
                            time_display = 1,
                            message = "Waiting on data: ~r~" .. tostring(SentData)
                        })
                        Wait(0)
                    end
                    ZAM:debug("SentData: " .. tostring(SentData))
                    SentData = nil
                    RageUI.GoBack()
                end
            end)
            RageUI.Button("Remove", "Removes amount from the current stat", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    local amount = KeyboardInput("stat to remove", "", 32)
                    local cash = tempValue - amount
                    TriggerServerEvent('SendData', pMenu.SPServer, pMenu.stat, 'set', math.floor(cash))
                    while SentData == nil do
                        RageUI.Text({
                            time_display = 1,
                            message = "Waiting on data: ~r~" .. tostring(SentData)
                        })
                        Wait(0)
                    end
                    ZAM:debug("SentData: " .. tostring(SentData))
                    SentData = nil
                    RageUI.GoBack()
                end
            end)
            RageUI.Button("Add", "Adds amount to the players stat", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    local amount = KeyboardInput("stat to add", "", 32)
                    ZAM:debug("TwoTime: " .. tostring(tempValue))
                    local cash = tempValue + amount
                    
                    TriggerServerEvent('SendData', pMenu.SPServer, pMenu.stat, 'set', math.floor(cash))
                    while SentData == nil do
                        RageUI.Text({
                            time_display = 1,
                            message = "Waiting on data: ~r~" .. tostring(SentData)
                        })
                        Wait(0)
                    end
                    ZAM:debug("SentData: " .. tostring(SentData))
                    SentData = nil
                    RageUI.GoBack()
                end
            end)
        end, function()
        
        end)

    end

    if RageUI.Visible(RMenu:Get('adminmenu', 'players')) then
        RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
            local pList = GetActivePlayers()
            for _, i in pairs(pList) do 
                local ServID = GetPlayerServerId(i)
                RageUI.Button(GetPlayerName(i), "", {}, true, function(Hovered, Active, Selected) 
                    if (Selected) then
                        pMenu.SPName = GetPlayerName(i)
                        pMenu.SP = i
                        pMenu.SPServer = ServID
                        RMenu:Get('adminmenu', 'pmenu'):SetSubtitle('~b~Selected Player: ~r~' .. pMenu.SPName)
                    end
                end, RMenu:Get('adminmenu', 'pmenu'))
            end
        end, function()
        
        end)

    end

    if RageUI.Visible(RMenu:Get('adminmenu', 'carspawning')) then
        RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
        RageUI.Button("Vehicle Model: ~r~" .. vSpawning.SelectedCar, "Put Veh name or leave blank for panto", {}, true, function(Hovered, Active, Selected)
            if (Selected) then
                local result = KeyboardInput("Vehicle Model:", "", 20)
                if not IsModelInCdimage(result) or not IsModelAVehicle(result) then
                    vSpawning.SelectedCar = "Panto"
                    RageUI.Text({
                        message = string.format("~r~" .. tostring(result) .. "~w~ does not exist, please make sure you inputted it correctly.")
                    })
                else
                    vSpawning.SelectedCar = result
                    RageUI.Text({
                        message = string.format("Selected vehicle is ~r~" .. result)
                    })
                end
                
            end
        end)

        RageUI.Button("Spawn Vehicle", "Spawns the vehicle", {}, true, function(Hovered, Active, Selected)
            if (Selected) then
                local ped = GetPlayerPed(PlayerId())
                local coords = GetEntityCoords(ped)
                local heading = GetEntityHeading(ped)
                ZAM:SpawnLocalCar(coords.x, coords.y, coords.z, vSpawning.SelectedCar, GetHashKey(vSpawning.SelectedCar), heading, vSpawning.primColor, vSpawning.secColor, true)
                RageUI.Text({
                    message = string.format("Spawned vehicle: ~r~" .. vSpawning.SelectedCar)
                })
            end
        end)

        RageUI.Button("Vehicle List", "Opens the vehicle list", {}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('adminmenu', 'vehlist'))
        
        end, function()
            
            local pc = RageUI.PanelColour
            local Tbl = pc.HairCut
            RageUI.ColourPanel("Primary Colors", Tbl, vSpawning.PrimaryColorIndex_One, vSpawning.PrimaryColorIndex_Two, function(Hovered, Active, MinimumIndex, CurrentIndex)
                vSpawning.PrimaryColorIndex_One = MinimumIndex
                vSpawning.PrimaryColorIndex_Two = CurrentIndex
                vSpawning.primColor = Tbl[CurrentIndex]
                --ZAM:debug(table.unpack(primColor))
            end)
            RageUI.ColourPanel("Secondary Colors", Tbl, vSpawning.SecondaryColorIndex_One, vSpawning.SecondaryColorIndex_Two, function(Hovered, Active, MinimumIndex, CurrentIndex)
                vSpawning.SecondaryColorIndex_One = MinimumIndex
                vSpawning.SecondaryColorIndex_Two = CurrentIndex
                vSpawning.secColor = Tbl[CurrentIndex]
            
            end)
        end)
    end

    if RageUI.Visible(RMenu:Get('adminmenu', 'vehlist')) then
        RageUI.DrawContent({header = true, glare = false, instructionalButton = true}, function()
            for k, i in pairs(VList) do 
                local vName = i.vName
                local owner = i.Player
                local veh = i.veh
                RageUI.Button("~r~" .. vName .. "~s~ Owned by: ~g~".. owner, nil, {RightLabel = "~b~" ..veh}, true, function(Hovered, Active, Selected) 
                    if (Selected) then
                        vMenu.vName = vName
                        vMenu.vOwner = owner
                        vMenu.vID = veh
                        RMenu:Get('adminmenu', 'vmenu'):SetSubtitle('~b~Selected car: ~r~' .. vMenu.vName .. "~b~ | Owner: ~r~" .. vMenu.vOwner .. "~b~ | ID: ~r~".. vMenu.vID)
                    end
                end, RMenu:Get('adminmenu', 'vmenu'))
            end
            RageUI.Button("~h~Total Cars: ", nil, {RightLabel = tostring(#VList)}, true, function(Hovered, Active, Selected) 

            end)
        end, function()

        end)
    end

    if RageUI.Visible(RMenu:Get('adminmenu', 'vmenu')) then
        RageUI.DrawContent({header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("Goto", "Goto selected car", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    local ped = GetPlayerPed(PlayerId())
                    local coords = GetEntityCoords(vMenu.vID)

                    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, false)
                    if AreAnyVehicleSeatsFree(vMenu.vID) then
                        for i = -1, 4 do
                            if IsVehicleSeatFree(vMenu.vID, i) then
                                SetPedIntoVehicle(ped, vMenu.vID, i)
                                break
                            end
                        end
                    end
                end
            end)

            RageUI.Button("Bring", "Bring selected car", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    local ped = GetPlayerPed(PlayerId())
                    local coords = GetEntityCoords(ped)
                    SetEntityCoords(vMenu.vID, coords.x, coords.y, coords.z, false, false, false, false)
                end
            end)

            RageUI.Button("Delete", "Delete selected car", {}, true, function(Hovered, Active, Selected) 
                if (Selected) then
                    DeleteEntity(vMenu.vID)
                    TriggerServerEvent("DeleteVehList", vMenu.vID)
                    RageUI.GoBack()
                end
            end)
        end, function()

        end)
    end

    if RageUI.Visible(RMenu:Get('adminmenu', 'carmenu')) then
        RageUI.DrawContent({header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("Repair", "Repairs current vehicle", {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local ped = GetPlayerPed(PlayerId())
                    local veh = GetVehiclePedIsIn(ped)
                    if veh ~= 0 then
                        SetVehicleFixed(veh)
                        SetVehicleDirtLevel(veh, 0)
                        RageUI.Text({
                            message = "Vehicle repaired"
                        })
                    else
                        RageUI.Text({
                            message = "You are not in a vehicle!"
                        })
                    end
                end
            end)

            RageUI.Button("Ls Customs", "Opens LS Customs menu", {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local ped = GetPlayerPed(PlayerId())
                    local veh = GetVehiclePedIsIn(ped)
                    if veh ~= 0 then
                        RageUI.CloseAll()
                        TriggerEvent("lsCustomsCmd")
                    else
                        RageUI.Text({
                            message = "You are not in a vehicle!"
                        })
                    end
                end
            end)

            RageUI.Button("Paint", "Paint current vehicle!", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected) end, RMenu:Get('adminmenu', 'paint'))
        
        
        end, function()
        
        
        end)
    end

    if RageUI.Visible(RMenu:Get('adminmenu', 'paint')) then
        RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
            RageUI.SliderProgress("Red", vOptions.red, 255, "Slider for Red", {
                RightLabel = "~r~" .. vOptions.red,
                ProgressColor = { R = vOptions.red, G = 0, B = 0, A = 255 },
                ProgressBackgroundColor = { R = 255, G = 255, B = 255, A = 100 }
            }, true, function(Hovered, Selected, Active, Index)
                local color = Index
                if (Active) then
                    local result = KeyboardInput("Red:", vOptions.red, 4)
                    result = tonumber(result)
                    if result ~= nil then
                        if result >= 0 and result <= 255 then
                            color = result
                        end
                    end
                end
                vOptions.red = color
            end)
            RageUI.SliderProgress("Blue", vOptions.blue, 255, "Slider for Red", {
                RightLabel = "~b~" .. vOptions.blue,
                ProgressColor = { R = 0, G = 0, B = vOptions.blue, A = 255 },
                ProgressBackgroundColor = { R = 255, G = 255, B = 255, A = 100 }
            }, true, function(Hovered, Selected, Active, Index)
                local color = Index
                if (Active) then
                    local result = KeyboardInput("Blue:", vOptions.blue, 4)
                    result = tonumber(result)
                    if result ~= nil then
                        if result >= 0 and result <= 255 then
                            color = result
                        end
                    end
                end
                vOptions.blue = color
            end)
            RageUI.SliderProgress("Green", vOptions.green, 255, "Slider for Red", {
                RightLabel = "~g~" .. vOptions.green,
                ProgressColor = { R = 0, G = vOptions.green, B = 0, A = 255 },
                ProgressBackgroundColor = { R = 255, G = 255, B = 255, A = 100 }
            }, true, function(Hovered, Selected, Active, Index)
                local color = Index
                if (Active) then
                    local result = KeyboardInput("Green:", vOptions.green, 4)
                    result = tonumber(result)
                    if result ~= nil then
                        if result >= 0 and result <= 255 then
                            color = result
                        end
                    end
                end
                vOptions.green = color
            end)
            local r, g, b = vOptions.red, vOptions.green, vOptions.blue
            RageUI.Button("~m~Paint Primary", "Sets the primary color to that of the RGB", {
                Color = {
                    BackgroundColor = {r,g,b}
                }
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local ped = GetPlayerPed(PlayerId())
                    local veh = GetVehiclePedIsIn(ped)
                    if veh ~= 0 then
                        SetVehicleCustomPrimaryColour(veh, r,g,b)
                    else
                        RageUI.Text({
                            message = "You are not in a vehicle!"
                        })
                    end
                end
            end)

            RageUI.Button("~m~Paint Secondary", "Sets the secondary color to that of the RGB", {
                Color = {
                    BackgroundColor = {r,g,b}
                }
            }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    local ped = GetPlayerPed(PlayerId())
                    local veh = GetVehiclePedIsIn(ped)
                    if veh ~= 0 then
                        SetVehicleColours(veh, 0,0)
                        SetVehicleCustomSecondaryColour(veh, r,g,b)
                    else
                        RageUI.Text({
                            message = "You are not in a vehicle!"
                        })
                    end
                end
            end)
        end, function()
        
        end)
    end

    if RageUI.Visible(RMenu:Get('adminmenu', 'devmenu')) then
        RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
            -- RageUI.Button("Delete Vehicle", "Deletes the vehicle you are in or the vehicle infront of you.", {}, true, function(Hovered, Active, Selected)
            --     if (Selected) then
            --         local ped = GetPlayerPed(PlayerId())
            --         local veh = GetVehiclePedIsIn(ped, false)
            --         if veh == 0 then
            --             veh = getNearestVeh()
            --         end
            --         ZAM:debug(veh)
            --         DeleteEntity(veh)
            --     end
            -- end)
            RageUI.Checkbox("Coord Info", "Enabled live coord info, aswell as saving coords!", dMenu.crdInfo,{}, function(Hovered, Active, Selected) 
                if (Selected) then
                    dMenu.crdInfo = not dMenu.crdInfo
                end
            end)
            RageUI.Button("Store Menu", "Opens the store menu, allowing you to create and edit stores.", {}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'storemenu'))
        end, function()
        
        end)

    end

    if RageUI.Visible(RMenu:Get('adminmenu', 'storemenu')) then
        RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
            -- RageUI.Button("Delete Vehicle", "Deletes the vehicle you are in or the vehicle infront of you.", {}, true, function(Hovered, Active, Selected)
            --     if (Selected) then
            --         local ped = GetPlayerPed(PlayerId())
            --         local veh = GetVehiclePedIsIn(ped, false)
            --         if veh == 0 then
            --             veh = getNearestVeh()
            --         end
            --         ZAM:debug(veh)
            --         DeleteEntity(veh)
            --     end
            -- end)
            RageUI.Checkbox("Creator", "Allows you to create stores, by pressing F1", sMenu.crter,{}, function(Hovered, Active, Selected) 
                if (Selected) then
                    sMenu.crter = not sMenu.crter
                end
            end)
        end, function()
        
        end)

    end

end)

Citizen.CreateThread(function()
    local x, y, z, ha
    while true do
        Citizen.Wait(0)
        if dMenu.crdInfo then
            local ped = PlayerPedId()
            x, y, z = table.unpack(GetEntityCoords(ped, true))
            ha = GetEntityHeading(ped)
            drawTxt(0.22, 0.80, 0.4,0.4,0.30, "Heading: " .. ha, 255, 255, 255, 255)
            drawTxt(0.22, 0.82, 0.4,0.4,0.30, "Coords: X: " .. x .. ", Y: " .. y .. ", Z:" .. z, 255, 255, 255, 255)

            if IsControlJustReleased(1, 166) then
                local PlayerName = GetPlayerName(PlayerId())
                RageUI.Text({
                    message = "You have just saved your current coords!"
                })
                TriggerServerEvent("SaveCoords", PlayerName , x, y, z, ha)
            end
        end
    end
end)

Citizen.CreateThread(function()
    local x, y, z, ha
    while true do
        Citizen.Wait(0)
        if sMenu.crter then
            local ped = PlayerPedId()
            x, y, z = table.unpack(GetEntityCoords(ped, true))
            ha = GetEntityHeading(ped)
            if IsControlJustReleased(1, 288) then
                local PlayerName = GetPlayerName(PlayerId())
                local name = KeyboardInput("Store Name:", "", 32)
                RageUI.Text({
                    message = "You just added to store, at your current position!"
                })
                --TriggerServerEvent("SaveCoords", PlayerName , x, y, z, ha)
            end
        end
    end
end)


RegisterNetEvent('GetVehList')
AddEventHandler('GetVehList', function(VehTbl)
    VList = VehTbl
end)

RegisterNetEvent('GetData')
AddEventHandler('GetData', function(data)
    ZAM:debug("Data: " .. tostring(data))
    SentData = data
end)