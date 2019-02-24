--[[
    Base class for variables used by EasyMCM
    To create a subclass, simply create it using Variable:new() 
    and override the get/set functions.
    Within get/set functions, use self.id to get the variable id.

    e.g
        local Subclass = require("easyMCM.variables.Variable"):new()
        function Subclass:get()
            --DO STUFF
        end
        function Subvlass:set(newValue)
            --DO STUFF
        end
        return Subclass
]]--

local Variable = {}
Variable.inGameOnly = false

function Variable:new(variable)
    local t = variable or {}
    setmetatable(t, self)
    self.__index = Variable.__index
    self.__newindex = Variable.__newindex
    return t
end



function Variable:get()
    return rawget(self, value)
end

function Variable:set(newValue)
    rawset(self, "value", newValue)
end


function Variable.__index(tbl, key)
    local meta = getmetatable(tbl)
    if key == "value" then
        return tbl:get()
    end
    return meta[key]
end

function Variable.__newindex(table, key, value)
   meta = getmetatable(table)
   if key == "value" then
        if table.restartRequired then
            tes3.messageBox{
                message = "The game must be restarted before this change will come into effect.",
                buttons = {"Okay"}
            }
        end
       table:set(value)
   else
      rawset(table, key, value)
   end
end

return Variable