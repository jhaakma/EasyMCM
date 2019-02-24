local Parent = require("easyMCM.components.settings.Setting")

local Dropdown = Parent:new()

function Dropdown:enable()
    local currentValue = self.variable.value
    mwse.log("Current value: %s", currentValue)
    mwse.log("Enable dropdown")
    local label
    mwse.log("Entering for loop")
    for _, option in ipairs(self.options) do
        mwse.log("Checking value")
        if option.value == currentValue then
            mwse.log("option %s", option.value)
            mwse.log("Setting label")
            label = option.label
            break
        end
    end
    mwse.log("Setting text to label %s", label)
    self.elements.textBox.text = label
    self.elements.textBox.color = tes3ui.getPalette("normal_color")
    mwse.log("Registering createDropdown")
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
    mwse.log("Update: new value %s", self.variable.value)
end

function Dropdown:selectOption(option)
    mwse.log("selectOption(%s)", option.label)
    self.elements.dropdownParent:destroyChildren()
    self.variable.value = option.value
    self.elements.textBox.text = option.label
    self.dropdownActive = false

    self:update()
end


function Dropdown:createDropdown()
    mwse.log("createDropdown()")
    --Create dropdown
    if not self.dropdownActive then
        mwse.log("dropdown not active")
        self.dropdownActive = true
        --Create dropdown
        local dropdown = self.elements.dropdownParent:createThinBorder()
        dropdown.flowDirection = "top_to_bottom"
        dropdown.autoHeight = true
        dropdown.widthProportional = 1.0

        for _, option in ipairs(self.options) do
            mwse.log("Option: %s", option.label)
            local listItemBlock = dropdown:createBlock()
            listItemBlock.autoHeight = true
            listItemBlock.widthProportional = 1.0

            local listItem = dropdown:createLabel({ text = option.label })
            listItem.borderAllSides = 6
            listItem.widthProportional = 1.0

            listItem:register("mouseClick", function()
                self:selectOption(option)
            end)
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

function Dropdown:createTextBox(parentBlock)

    local border = parentBlock:createThinBorder()
    border.widthProportional = 1.0
    border.autoHeight = true
    border.paddingTop = 2
    border.paddingBottom = 4
    border.paddingLeft = 4
    border.paddingRight = 4
    self.elements.border = border


    local textBox = border:createLabel({ text = "---" })
    self.elements.textBox = textBox
    textBox.widthProportional = 1.0
    textBox.borderAllSides = 2

    --[[local iconBorder = border:createThinBorder()
    iconBorder.heightProportional = 1.0
    iconBorder.autoWidth = true
    iconBorder.paddingAllSides = 1
    iconBorder.alignX = 1.0
    iconBorder.alignY = 0.5
    local icon = iconBorder:createImage({path = "Textures/menu_scroll_arrow.dds"})
    icon.imageScaleX = 1.6
    icon.imageScaleY = 1.6]]--
    

    local dropdownParent = parentBlock:createBlock()
    dropdownParent.flowDirection = "top_to_bottom"
    dropdownParent.widthProportional = 1.0
    dropdownParent.autoHeight = true
    self.elements.dropdownParent = dropdownParent
end

function Dropdown:createOuterContainer(parentBlock)
    local outerContainer = parentBlock:createBlock()
    outerContainer.flowDirection = "top_to_bottom"
    outerContainer.widthProportional = 1.0
    outerContainer.autoHeight = true
    outerContainer.paddingBottom = self.paddingBottom
    outerContainer.paddingRight = (self.indent * 2)
    outerContainer.paddingLeft = self.indent
    self.elements.outerContainer = outerContainer   
end

function Dropdown:createComponent(parentBlock)
    self:createLabel(parentBlock)
    self:createTextBox(parentBlock)
end

return Dropdown