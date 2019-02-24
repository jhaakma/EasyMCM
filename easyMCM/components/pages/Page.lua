local Parent = require ("easyMCM.components.categories.Category")
local Page = Parent:new()
Page.componentType = "Page"


function Page:new(categoryData)
    local t = {}
    if categoryData then
        t = categoryData
        local tabUID = ( "Page_" .. t.label)
        t.tabUID = tes3ui.registerID(tabUID)
    end
    setmetatable(t, self)
    self.__index = self
    return t
end

function Page:disable()
    for _, element in ipairs(self.elements.contentsContainer.children) do
        if element.color then 
            element.color = tes3ui.getPalette("disabled_color")
        end
    end
    if self.elements.label then
        self.elements.label.text = (self.elements.label.text .. " (In-Game Only)")
        self.elements.label.color = tes3ui.getPalette("disabled_color")
    end
end

function Page:createOuterContainer(parentBlock)
    --Lefthand window containing settings
    local scrollPane = parentBlock:createVerticalScrollPane({ id = tes3ui.registerID("Page_OuterContainer") })
    scrollPane.heightProportional = 1.0
    scrollPane.widthProportional = 1.0

    local outerContainer = scrollPane:createBlock()
    outerContainer.flowDirection = "top_to_bottom"
    outerContainer.autoHeight = true
    outerContainer.widthProportional = 1.0
    outerContainer.paddingLeft = self.indent

    self.elements.outerContainer = outerContainer
end


return Page