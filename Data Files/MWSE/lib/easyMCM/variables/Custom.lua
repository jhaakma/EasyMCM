--Parent class
local Parent = require("easyMCM.variables.Variable")
--Class object
local Custom = Parent:new()


function Custom:get()
    return self:getter()
end

function Custom:set(newValue)
    self:setter(newValue)
end

return Custom