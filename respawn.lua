script_name("respawn")
script_author("OD")

local sampev = require 'lib.samp.events'
local imgui = require 'imgui'

function main()
    repeat wait(0) until isSampAvailable()
    
    sampRegisterChatCommand("respawn", function(arg)
        local id = tonumber(arg:match("%d+"))
        local x, y, z = getCharCoordinates(PLAYER_PED)
        local world = 0
        local reconInfo = {
            ['status'] = imgui.ImBool(false),
        }
        if reconInfo['status'].v then 
            z = z - 19
        end
        
        local function handleWorldMessage(color, text)
            if text:find("Current world:") then
                world = text:match("Current world:%s*(%d+)")
                return false
            end
        end
        
        sampev.onServerMessage = handleWorldMessage

        interior = getCharActiveInterior(PLAYER_PED)
        
        sampSendChat("/setvw")
        sampSendChat("/spplayer " .. id)    
        
        lua_thread.create(function()
            wait(500)
            sampSendChat("/plpos " .. id .. " " .. x .. " " .. y .. " " .. z .. " " .. world .. " " .. interior)
            wait(100)
            sampev.onServerMessage = nil
        end)
    end)
end