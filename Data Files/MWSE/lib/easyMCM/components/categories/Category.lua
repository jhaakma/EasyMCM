
--[[
    Category
        --Base class for category and page type
    A category is a simple container that holds infos, settings and other categories
    Categories can be nested infinitely
    A basic category has a label and an indented block of components

    An example definition of a category:

            {
                class = "Category",
                label = "Label", --optional but recommended
                description = "This is a category example", --optional, used for mouseOvers
                components = {
                    ... --list of components
                }
            }
        
]]--

local Parent = require("easyMCM.components.Component")
local Category = Parent:new()
Category.componentType = "Category"
--CONTROL METHODS

function Category:disable()
    Parent.disable(self)
    for _, element in ipairs(self.elements.subcomponentsContainer.children) do
        if element.color then 
            element.color = tes3ui.getPalette("disabled_color")
        end
    end
end


function Category:enable()
    if self.elements.label then
        self.elements.label.color = tes3ui.getPalette("header_color")
    end
end

function Category:update()
    for _, component in ipairs(self.components) do
        if component.update then 
            component.update() 
        end
    end
end 

function Category:checkDisabled()
    --If has variables and all are inGameOnly, disable Category
    local isDisabled = true
    local hasSettings = false
    for _, component in ipairs(self.components) do
        if component.componentType == "Setting" and component.variable then
            hasSettings = true 
            if component.variable.inGameOnly == false then
                isDisabled = false
            end
        elseif component.componentType == "Category" then
            componentDisabled = component:checkDisabled()
            isDisabled = component:checkDisabled()
            if componentDisabled then hasSettings = true end
        end
    end
    return ( hasSettings and not tes3.player and isDisabled )
end


--UI METHODS 


function Category:createSubcomponentsContainer(parentBlock)
    local subcomponentsContainer = parentBlock:createBlock({ id = tes3ui.registerID("Category_ContentsContainer") })
    subcomponentsContainer.flowDirection = "top_to_bottom"
    subcomponentsContainer.widthProportional = 1.0
    subcomponentsContainer.autoHeight = true
    subcomponentsContainer.autoWidth = true
    self.elements.subcomponentsContainer = subcomponentsContainer
end


function Category:createSubcomponents(parentBlock, components)
    if components then
        for _, component in pairs(components) do
            local newComponent = self:getComponent(component)
            newComponent:create(parentBlock)
        end
    end
end


function Category:createContentsContainer(parentBlock)
    self:createLabel(parentBlock)
    self:createInnerContainer(parentBlock)
    self:createSubcomponentsContainer(self.elements.innerContainer)
    self:createSubcomponents(self.elements.subcomponentsContainer, self.components)
    parentBlock:getTopLevelParent():updateLayout()
end


return Category