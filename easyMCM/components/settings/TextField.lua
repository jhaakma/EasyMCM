--Parent Class
local Parent = require("easyMCM.components.settings.Setting")
--Class Object
local TextField = Parent:new()

function TextField:enable()
    self.elements.inputField.text = self.variable.value
    local function registerTextInput(parent)
        parent:register(
            "mouseClick", 
            function()
                tes3ui.acquireTextInput(self.elements.inputField)
            end
        )
        if parent.children then
            for _, element in ipairs(parent.children) do
                registerTextInput(element)
            end
        end
    end
    registerTextInput(self.elements.border)
end

function TextField:disable()
    Parent.disable(self)
    self.elements.inputField.color = tes3ui.getPalette("disabled_color")
end


function TextField:update()
    self.variable.value = self.elements.inputField.text
    --Do this after changing the variable so the callback is correct
    Parent.update(self)
end

function TextField:callback()
    tes3.messageBox("New value: '%s'", self.variable.value)
end


function TextField:createOuterContainer(parentBlock)
    local outerContainer = parentBlock:createBlock()
    outerContainer.flowDirection = "top_to_bottom"
    outerContainer.widthProportional = 1.0
    outerContainer.autoHeight = true
    outerContainer.paddingBottom = self.paddingBottom
    outerContainer.paddingRight = (self.indent * 2)
    outerContainer.paddingLeft = self.indent
    self.elements.outerContainer = outerContainer   
end


function TextField:createInputField(parentBlock)
    local border = parentBlock:createThinBorder()
    border.widthProportional = 1.0
    border.autoHeight = true

    local inputField = border:createTextInput()
    inputField.text = self.variable.defaultSetting
    inputField.widthProportional = 1.0
    inputField.autoHeight = true
    inputField.widget.lengthLimit = nil
    inputField.widget.eraseOnFirstKey = true
    inputField.borderLeft = 5
    inputField.borderRight = 5
    inputField.borderTop = 2
    inputField.borderBottom = 4
    inputField.consumeMouseEvents = false

    inputField:register("keyEnter",
        function()
            self:update()
        end
    )
    self.elements.border = border
    self.elements.inputField = inputField

    table.insert(self.mouseOvers, self.elements.border)
    table.insert(self.mouseOvers, self.elements.inputField)
    table.insert(self.mouseOvers, self.elements.label)
end

function TextField:createComponent(parentBlock)
    self:createLabel(parentBlock)
    self:createInputField(parentBlock)
end


return TextField