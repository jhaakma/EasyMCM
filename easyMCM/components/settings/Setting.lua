--[[
    A setting is a component that can be interacted with, such as a button or text input. 
    It can have, but doesn't require, an associated variable.
]]--
local Parent = require("easyMCM.components.Component")
local Setting = Parent:new()
Setting.componentType = "Setting"

function Setting:new(settingData) 
    local t = settingData or {}
    if settingData and settingData.variable then
        local typePath = ("easyMCM.variables." .. t.variable.class)
        t.variable = require(typePath):new(t.variable)
    end
    setmetatable(t, self)
    self.__index = self

    return t
end

function Setting:update()
    if self.callback then
        self:callback()
    end
end

function Setting:createLabel(parentBlock)
    Parent.createLabel(self, parentBlock)
    if self.elements.label then
        self.elements.label.borderTop = 0
        self.elements.label.paddingTop = 0
        self.elements.labelBlock.borderTop = 0
        self.elements.labelBlock.paddingTop = 0
        self.elements.label.borderLeft = 0
        self.elements.label.borderBottom = self.paddingBottom / 2
    end
end


function Setting:createOuterContainer(parentBlock)
    Parent.createOuterContainer(self, parentBlock)
    self.elements.outerContainer.flowDirection = "left_to_right"
    self.elements.outerContainer.autoWidth = true
    
end

function Setting:checkDisabled()
    --For components with no variable
    if self.inGameOnly ~= nil then
        return not tes3.player and self.inGameOnly
    end
    --Components with variable
    local disabled = (
        self.variable and
        self.variable.inGameOnly == true and 
        not tes3.player
    )
    return disabled
end

return Setting