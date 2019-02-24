--[[
    Displays settings side by side instead of vertically
    Best used for small buttons with no labels
]]--

local Parent = require ("easyMCM.components.categories.Category")

local SideBySideBlock = Parent:new()


function SideBySideBlock:createContentsContainer(parentBlock)
    Parent.createContentsContainer(self, parentBlock)
    self.elements.contentsContainer.flowDirection = "left_to_right"
    self.elements.contentsContainer.autoWidth = true
    self.elements.contentsContainer.widthProportional = false
end

return SideBySideBlock