--[[
    Base Object for all MCM components, such as categories and settings
]]--

local Component = {}
Component.componentType = "Component"
Component.paddingBottom = 4
Component.indent = 12
Component.sOK = tes3.findGMST(tes3.gmst.sOK).value
Component.sCancel = tes3.findGMST(tes3.gmst.sCancel).value
Component.sYes = tes3.findGMST(tes3.gmst.sYes).value
Component.sNo = tes3.findGMST(tes3.gmst.sNo).value


--CONTROL METHODS

function Component:new(data)
    local t = data or {}
    setmetatable(t, self)
    self.__index = self
    return t
end

function Component:__index(key)
    return self[key]
end

--Prints the component table to the log
function Component:printComponent(component)
    mwse.log("{")
    for key, val in pairs(component or self) do
        if type(val) ~= "table" and type(val) ~= "function" then
            local maxLength = 50
            local shortenedValue = ( 
                string.len(val) < maxLength ) and 
                val or  ( string.sub(val, 1, maxLength) .. "..." 
            )
            mwse.log("    %s: %s", key, shortenedValue ) 
        end
    end
    mwse.log("}")
end


function Component:getComponent(componentData)

    --if componentType field is set then we've already built it
    if componentData.componentType then return componentData end

    if not componentData.class then
        mwse.log("ERROR: No class found for component:")
        self:printComponent(componentData)
    end
    local component
    local classPaths = require("easyMCM.classPaths").components
    for _, path in pairs(classPaths) do
        local classPath = (path .. componentData.class) 
        local fullPath = lfs.currentdir() .. "/Data Files/MWSE/lib/" .. classPath .. ".lua"
        local fileExists = lfs.attributes(fullPath, "mode") == "file"

        if fileExists then 
            component = require(classPath)
            break 
        end
    end
    if component then
        return component:new(componentData)
    else
        mwse.log("Error: class %s not found", componentData.class)
    end
end


function Component:registerMouseOverElements(mouseOverList)
    if mouseOverList then
        for _, element in ipairs(mouseOverList) do
            element:register(
                "mouseOver",
                function(e)
                    event.trigger("MCM:MouseOver", self)
                    e.source:forwardEvent(e)
                end
            )
            element:register(
                "mouseLeave",
                function()
                    event.trigger("MCM:MouseLeave")
                    e.source:forwardEvent(e)
                end
            )
        end
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


--UI METHODS


function Component:createLabelBlock(parentBlock)
    local block = parentBlock:createBlock({ id = tes3ui.registerID("LabelBlock") })
    block.flowDirection = "top_to_bottom"
    --if parentBlock.flowDirection == "top_to_bottom" then
        block.widthProportional = 1.0
    --else
    --    block.autoWidth = true
    --end
    block.autoHeight = true
    
    self.elements.labelBlock = block
    table.insert(self.mouseOvers, block)
end


function Component:createLabel(parentBlock)
    if self.label then
        self:createLabelBlock(parentBlock)

        local id =  ("Label: " .. self.label )
        local label = self.elements.labelBlock:createLabel({ id = tes3ui.registerID(id), text = self.label })
        label.borderBottom = self.paddingBottom
        label.borderAllSides = 0
        label.paddingAllSides = 0
        label.wrapText = true
        label.widthProportional = 1.0
        label.alignY = 0.5

        self.elements.label = label
        table.insert(self.mouseOvers, label)
    end
end
 
--[[
    Wraps up the entire component 
]]
function Component:createOuterContainer(parentBlock)
    local outerContainer
    outerContainer = parentBlock:createBlock({ id = tes3ui.registerID("OuterContainer") })
    outerContainer.flowDirection = "top_to_bottom"

    outerContainer.autoWidth = true

    outerContainer.widthProportional = 1.0


    outerContainer.autoHeight = true
    outerContainer.paddingBottom = self.paddingBottom * 2

    self.elements.outerContainer = outerContainer
    table.insert(self.mouseOvers, outerContainer)
end

function Component:createInnerContainer(parentBlock)
    local innerContainer = parentBlock:createBlock({id = tes3ui.registerID("InnerContainer")})
    innerContainer.widthProportional = parentBlock.widthProportional
    innerContainer.autoWidth = true-- parentBlock.autoWidth
    innerContainer.heightProportional = parentBlock.heightProportional
    innerContainer.autoHeight = parentBlock.autoHeight
    innerContainer.flowDirection = parentBlock.flowDirection
    if self.label then
        innerContainer.paddingLeft = self.indent
    end
    self.elements.innerContainer = innerContainer
end


function Component:create(parentBlock)

    self.elements = {}
    self.mouseOvers = {}

    self:createOuterContainer(parentBlock)
    
    self:createContentsContainer(self.elements.outerContainer)

    if self:checkDisabled() then
        self:disable()
    else
        self:enable()
    end
    
    --Register mouse overs
    self:registerMouseOverElements(self.mouseOvers)

    --Can define a custom formatting function to make adjustments to any element saved
    -- in self.elements
    if self.postCreate then
        self:postCreate()
    end
end



return Component