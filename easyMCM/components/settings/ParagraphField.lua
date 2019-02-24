local Parent = require("easyMCM.components.settings.TextField")
local ParagraphField = Parent:new()

function ParagraphField:enable()
    self.elements.inputField.text = self.variable.value
    self.elements.textFrame:register(
        "mouseClick", 
        function()
            tes3ui.acquireTextInput(self.elements.inputField)
        end
    )
end

function ParagraphField:createInputField(parentBlock)
    local border = parentBlock:createBlock()
    border.widthProportional = 1.0
    border.autoHeight = true

    local inputField = border:createParagraphInput()
    inputField.color = tes3ui.getPalette("disabled_color")
    inputField.text = "(In-Game Only)"
    inputField.widthProportional = 1.0
    inputField.widget.lengthLimit = nil


    if self.minHeight then
        inputField.minHeight = self.minHeight
    end

    inputField:register("keyEnter",
         function()
            self:update()
        end
    )
    self.elements.border = border
    self.elements.inputField = inputField
    self.elements.textFrame = inputField:findChild(tes3ui.registerID("PartScrollPane_outer_frame"))
    --mouseOvers
    local function applyMouseovers(children)
        for _, element in ipairs(children) do
            table.insert(self.mouseOvers, element)
            if element.children then
                applyMouseovers(element.children)
            end
        end
    end
    applyMouseovers(inputField.children)
    table.insert(self.mouseOvers, self.elements.label)
end



return ParagraphField