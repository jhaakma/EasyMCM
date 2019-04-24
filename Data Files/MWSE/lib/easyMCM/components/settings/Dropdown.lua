local Parent = require("easyMCM.components.settings.Setting")

local Dropdown = Parent:new()
Dropdown.idleColor = tes3ui.getPalette("normal_color")
Dropdown.overColor = tes3ui.getPalette("normal_over_color")
Dropdown.pressedColor = tes3ui.getPalette("normal_pressed_color")

function Dropdown:enable()
    Parent.enable(self)
    local currentValue = self.variable.value
    local skillLabel
    for _, option in ipairs(self.options) do
        if option.value == currentValue then
            label = option.label
            break
        end
    end
    self.elements.textBox.text = label
    self.elements.textBox.color = self.idleColor
    self.elements.textBox:register("mouseClick", function()
        self:createDropdown()
    end)
end


function Dropdown:update()
    for _, option in ipairs(self.options) do
        if option.label == self.elements.textBox.text then
            self.variable.value = option.value
        end
    end
    Parent.update(self)
end


function Dropdown:selectOption(option)
    self.elements.dropdownParent:destroyChildren()
    self.variable.value = option.value
    self.elements.textBox.text = option.label
    self.dropdownActive = false

    self:update()
end


function Dropdown:createDropdown()
    if not self.dropdownActive then
        self.dropdownActive = true
        --Create dropdown
        local dropdown = self.elements.dropdownParent:createThinBorder()
        dropdown.flowDirection = "top_to_bottom"
        dropdown.autoHeight = true
        dropdown.widthProportional = 1.0
        dropdown.paddingAllSides = 6
        dropdown.borderTop = 0
        for _, option in ipairs(self.options) do
            if option.value ~= self.variable.value then
                
                local listItem = dropdown:createTextSelect({ text = option.label })
                
                listItem.widthProportional = 1.0
                listItem.autoHeight = true
                listItem.borderBottom = 3
                listItem.widget.idle = tes3ui.getPalette("normal_color")
                listItem.widget.over = tes3ui.getPalette("normal_over_color")
                listItem.widget.pressed = tes3ui.getPalette("normal_pressed_color")

                listItem:register("mouseClick", function()
                    self:selectOption(option)
                end)
            end
        end
        self.elements.dropdown = dropdown
        dropdown:getTopLevelParent():updateLayout()

    --Destroy dropdown
    else
        self.elements.dropdownParent:destroyChildren()
        self.dropdownActive = false
        self.elements.dropdownParent:getTopLevelParent():updateLayout()
    end

end


function Dropdown:makeComponent(parentBlock)

    local border = parentBlock:createThinBorder()
    border.widthProportional = 1.0
    border.autoHeight = true
    border.paddingLeft = 4
    border.paddingTop = 2
    border.paddingBottom = 4
    border.borderTop = 2
    self.elements.border = border
    

    local textBox = border:createTextSelect({ text = "---" })
    self.elements.textBox = textBox

    textBox.color = tes3ui.getPalette("disabled_color")
	textBox.widget.idle = self.idleColor
	textBox.widget.over = self.overColor
	textBox.widget.pressed = self.pressedColor
    textBox.widthProportional = 1.0
    textBox.borderAllSides = 2


    local dropdownParent = parentBlock:createBlock()
    dropdownParent.flowDirection = "top_to_bottom"
    dropdownParent.widthProportional = 1.0
    dropdownParent.autoHeight = true
    self.elements.dropdownParent = dropdownParent

end


function Dropdown:createOuterContainer(parentBlock)
    Parent.createOuterContainer(self, parentBlock)
    self.elements.outerContainer.paddingRight = self.indent -- * 2
end


function Dropdown:createContentsContainer(parentBlock)
    self:createLabel(parentBlock)
    self:createInnerContainer(parentBlock)
    self:makeComponent(self.elements.innerContainer)
end

return Dropdown