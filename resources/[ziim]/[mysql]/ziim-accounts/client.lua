local ZA = ZiiM_Accounts

local SentData = nil



function ZA:debug(...)
    local arg ={...}
    if self.debugEnable then
        local result = ""
        for i, v in ipairs(arg) do
            result = result .. tostring(v) .. "\t"
        end
        print("^1[C-ZA-debug:" .. debug.getinfo(2).currentline .. "]:^0 " .. tostring(result))
    end
end

function ZA:Awake(...)
    TriggerServerEvent('AddToTable')
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            ZA:Awake()
            return
        end
    end
end)

RegisterNetEvent('SendToTable')
AddEventHandler('SendToTable', function()
    TriggerServerEvent('AddToTable')
    ZA:debug("SendingToTable")
end)


