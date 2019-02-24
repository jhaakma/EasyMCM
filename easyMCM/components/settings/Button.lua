

--parent
local Parent = require("easyMCM.components.settings.Setting")
--Class object
local Button = Parent:new()

--Determines what text is displayed on the button
function Button:getText()
    return self.buttonText
end
 

function Button:setText(newText)
    self.elements.button.text = newText
end


function Button:disable()
    Parent.disable(self)
    self.elements.button.widget.state = 2
end

function Button:enable()
    Parent.enable(self)
    self.elements.button.text = self:getText()
    self.elements.button:register(
        "mouseClick", 
        function(e)
            self:update()
        end
    )
end

function Button:createLabel(parentBlock)
    Parent.createLabel(self, parentBlock)
    if self.elements.label then
        self.elements.label.heightProportional = 1.0
        self.elements.label.alignY = 0.5
    end
end

function Button:createButton(parentBlock)
    local buttonText = self.buttonText or "---"
    local button = parentBlock:createButton({ id = tes3ui.registerID("Button"), text = buttonText })
    self.elements.button = button
    self.elements.button.borderAllSides = 0
    self.elements.button.borderTop = 2
    self.elements.button.borderRight = self.indent
end

function Button:createComponent(parentBlock)
    self:createButton(parentBlock)
    self:createLabel(parentBlock)
end



return Button