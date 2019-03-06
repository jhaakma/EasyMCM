--[[
    Info field that shows mouseover information for settings
]]--


local Parent = require("easyMCM.components.infos.Info")

local MouseOverInfo = Parent:new()
MouseOverInfo.triggerOn = "MCM:ComponentMouseOver"
MouseOverInfo.triggerOff = "MCM:ComponentMouseLeave"


function MouseOverInfo:createComponent(parentBlock)

    Parent.createComponent(self, parentBlock)
    local info = self.elements.info

    local function updateInfo(setting)
        --If component has a description, update mouseOver
        --Or return to original text on mouseLeave
        local newText = (
            setting and  setting.description or 
            self.text or 
            ""
        )
        info.text = newText
    end
    
    --Register events
    event.register(self.triggerOn, updateInfo)
    event.register(self.triggerOff, updateInfo)
    parentBlock:register("destroy",
        function()
            event.unregister(self.triggerOn, updateInfo)
            event.unregister(self.triggerOff, updateInfo)
        end
    )
end

return MouseOverInfo