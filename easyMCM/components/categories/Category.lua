
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



function Category:disable()
    Parent.disable(self)
    for _, element in ipairs(self.elements.contentsContainer.children) do
        if element.color then 
            element.color = tes3ui.getPalette("disabled_color")
        end
    end
end


function Category:enable()
    if self.label then
        self.elements.label.color = tes3ui.getPalette("header_color")
    end
end


function Category:checkDisabled()
    --If all are inGameOnly, disable Category
    local isDisabled = true
    for _, component in ipairs(self.components) do
        if component.componentType == "Setting" then
            if component.variable and component.variable.inGameOnly == false then
                isDisabled = false
            end
        elseif component.componentType == "Category" then
            isDisabled = component:checkDisabled()
        end
    end
    return ( not tes3.player and isDisabled)
end


--UI creation functions

function Category:createContentsContainer(parentBlock)
    local contentsContainer = parentBlock:createBlock({ id = tes3ui.registerID("Category_ContentsContainer") })
    contentsContainer.flowDirection = "top_to_bottom"
    contentsContainer.widthProportional = 1.0
    contentsContainer.borderLeft = self.indent
    contentsContainer.paddingLeft = self.indent
    --contentsContainer.paddingBottom = self.paddingBottom
    contentsContainer.autoHeight = true
    self.elements.contentsContainer = contentsContainer
end


function Category:createSubcomponents(parentBlock)
    if self.components then
        for _, component in pairs(self.components) do
            local newComponent = self:getComponent(component.class):new(component)
            newComponent:create(parentBlock)
        end
    end
end


function Category:createComponent(parentBlock)

    self:createLabel(self.elements.outerContainer)

    self:createContentsContainer(self.elements.outerContainer)

    self:createSubcomponents(self.elements.contentsContainer)

    table.insert(self.mouseOvers, self.elements.label)
end



return Category