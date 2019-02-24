--Parent class
local Parent = require("easyMCM.variables.Variable")
--Class object
local GlobalVar = Parent:new()
GlobalVar.inGameOnly = true

function GlobalVar:checkExists()
    local global tes3.findGlobal(self.id)
    if not global then
        mwse.log("ERROR: Global %s does not exist")
    end
end

function GlobalVar:get()
    return tes3.findGlobal(self.id).value
end

function GlobalVar:set(newValue)
    tes3.findGlobal(self.id).value = newValue
end

return GlobalVar 