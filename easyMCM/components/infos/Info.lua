--[[
    An Info is a component that does not have children and can not be
    interacted with. This includes things suchj as text boxes, 
    hyperlinks and images. 

    The default behaviour of an Info is a text box with word wrapping.

    As this uses word wrap, it is strongly recommended you include a propHeight
    value for all parent categories and pages to ensure wrapping works correctly
]]--

--Parent Class
local Parent = require("easyMCM.components.Component")
--Class Object
local Info = Parent:new()
Info.componentType = "Info"

function Info:disable()
    Parent.disable(self)
    self.elements.infoText.color = tes3ui.getPalette("disabled_color")
end

function Info:createLabel(parentBlock)
    Parent.createLabel(self, parentBlock)
    if self.elements.label then
        self.elements.label.borderLeft = 0
    end
end

function Info:createInfo(parentBlock)
    local info = parentBlock:createThinBorder()
    info.flowDirection = "top_to_bottom"
    info.widthProportional = 1.0
    info.autoHeight = true
    info.borderRight = ( self.indent * 2 )

    local infoText = info:createLabel()
    infoText.borderLeft = 5
    infoText.borderRight = 5
    infoText.borderTop = 2
    infoText.borderBottom = 4
    infoText.wrapText = true
    infoText.text = self.text
    infoText.autoHeight = true
    infoText.widthProportional = 1.0

    self.elements.infoText = infoText
    self.elements.info = info
    table.insert(self.mouseOvers, info)
    table.insert(self.mouseOvers, infoText)
end

function Info:createComponent(parentBlock)
    self:createLabel(parentBlock)
    self:createInfo(parentBlock)
end

return Info