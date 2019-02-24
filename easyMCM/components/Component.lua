--[[
    Base Object for all MCM components, such as categories and settings
]]--

local Component = {}
Component.paddingBottom = 4
Component.indent = 4
function Component:new(data)
    local t = data or {}
    setmetatable(t, self)
    self.__index = self
    return t
end

function Component:getComponent(className)
    local component
    local classPaths = {
        "easyMCM/components/templates/",
        "easyMCM/components/pages/",
        "easyMCM/components/categories/",
        "easyMCM/components/settings/",
        "easyMCM/components/infos/",
        "easyMCM/components/",
        "easyMCM/components/templates/userdefined/",
        "easyMCM/components/pages/userdefined/",
        "easyMCM/components/categories/userdefined/",
        "easyMCM/components/settings/userdefined/",  
        "easyMCM/components/userdefined/",
    }
    for _, path in ipairs(classPaths) do
        local classPath = (path .. className)
        component = include(classPath)
        if component then break end
    end
    if component then
        return component
    else
        mwse.log("Error: class %s not found", className)
    end
end


function Component:registerMouseOverElements(mouseOverList)
    if mouseOverList then
        for _, element in ipairs(mouseOverList) do
            element:register(
                "mouseOver",
                function()
                    event.trigger("MCM:ComponentMouseOver", self)
                end
            )
            element:register(
                "mouseLeave",
                function()
                    event.trigger("MCM:ComponentMouseLeave")
                end
            )
        end
    end
end

function Component:createLabel(parentBlock)
    if self.label then
        local block = parentBlock:createBlock()
        block.flowDirection = "top_to_bottom"
        block.widthProportional = 1.0
        block.autoHeight = true
        block.paddingAllSides = 0
        self.elements.labelBlock = block

        local id =  ("Label: " .. self.label )
        local label = block:createLabel({ id = tes3ui.registerID(id), text = self.label })
        label.borderLeft = self.indent
        label.borderBottom = self.paddingBottom
        label.borderAllSides = 0
        label.wrapText = true
        label.widthProportional = 1.0
        self.elements.label = label
        table.insert(self.mouseOvers, label)
    end
end

function Component:disable()
    if self.elements.label then
        self.elements.label.color = tes3ui.getPalette("disabled_color")
    end
end

function Component:enable()
    if self.elements.label then
        self.elements.label.color = tes3ui.getPalette("normal_color")
    end
end

function Component:checkDisabled()
    local disabled = (
        self.inGameOnly == true and 
        not tes3.player
    )
    return disabled
end

function Component:createOuterContainer(parentBlock)
    local outerContainer
    outerContainer = parentBlock:createBlock({ id = tes3ui.registerID("OuterContainer") })
    outerContainer.flowDirection = "top_to_bottom"
    outerContainer.widthProportional = 1.0
    outerContainer.autoHeight = true
    outerContainer.paddingLeft = self.indent
    outerContainer.paddingBottom = self.paddingBottom
    self.elements.outerContainer = outerContainer
    table.insert(self.mouseOvers, outerContainer)
end

function Component:createComponent(parentBlock)
    --ABSTRACT CLASS
    mwse.log("ERROR: No createComponent function implemented")
end

function Component:create(parentBlock)
    self.elements = {}
    self.mouseOvers = {}

    self:createOuterContainer(parentBlock)
    
    self:createComponent(self.elements.outerContainer)

    if self:checkDisabled() then
        self:disable()
    else
        self:enable()
    end
    
    --Register mouse overs
    self:registerMouseOverElements(self.mouseOvers)

    --Can define a custom formatting function to make adjustments to any element saved
    -- in self.elements
    if self.formatElements then
        self:formatElements()
    end
end

return Component