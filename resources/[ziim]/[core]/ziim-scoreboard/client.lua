local ZSB = ZiiM_Scoreboard

function ZSB:debug(...)
    local arg ={...}
    if self.debugEnable then
        local result = ""
        for i, v in ipairs(arg) do
            result = result .. tostring(v) .. "\t"
        end
        print("^1[C-ZSB-debug:" .. debug.getinfo(2).currentline .. "]:^0 " .. tostring(result))
    end
end

-- local tInfo = {
--     SPName,
--     SP,
--     SPServer
-- }

RMenu.Add('playerlist', 'main', RageUI.CreateMenu("Player List", "~b~Player List by ZiiM", 1330))

-- RMenu.Add('playerlist', 'pInfo', RageUI.CreateSubMenu(RMenu:Get('playerlist', 'main'), "Player Info", "~b~Player List"))


RageUI.CreateWhile(1.0, true , function()

    -- Show while pressed
    -- if IsControlPressed(1, 303) then
    --     ZSB:debug("pressed")
    --     RageUI.Visible(RMenu:Get('playerlist', 'main'), true)
    -- else
    --     RageUI.Visible(RMenu:Get('playerlist', 'main'), false)
    -- end

    if IsControlJustPressed(1, 303) then
        RageUI.Visible(RMenu:Get('playerlist', 'main'), not RageUI.Visible(RMenu:Get('playerlist', 'main')))
    end

    -- PlayerList Menu
    if RageUI.Visible(RMenu:Get('playerlist', 'main')) then
        RageUI.DrawContent({header = true, glare = true, instructionalButton = false}, function()
            local pList = GetActivePlayers()
            for _, i in pairs(pList) do 
                local ServID = GetPlayerServerId(i)
                RageUI.Button(GetPlayerName(i), nil, {RightLabel = ServID}, true, function(Hovered, Active, Selected) 

                end)
            end
            RageUI.Button("~h~Total Players: ", nil, {
                Color = {
                    BackgroundColor = {100, 33,29},
                    HightLightColor = {0,0,0, 0}
                },
                RightLabel = tostring(#pList)
            }, true, function(Hovered, Active, Selected) 

            end)
            --Buttons
        end, function()
            --Panels

        end)

    end
end)