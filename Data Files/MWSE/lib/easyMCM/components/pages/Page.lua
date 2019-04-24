--[[
    A basic Page. Components are displayed in a vertical scroll pane. 
]]--

local Parent = require ("easyMCM.components.categories.Category")

local Page = Parent:new()
Page.componentType = "Page"
Page.indent = 6

function Page:new(data)
    local t = Parent:new(data)
    if data then
        --register ID for the page tab
        local tabUID = ( "Page_" .. t.label)
        t.tabUID = tes3ui.registerID(tabUID)
    end
    setmetatable(t, self)
    self.__index = self
    return t

end

function Page:createLabel(parentBlock)
    if self.showHeader then
        Parent.createLabel(self, parentBlock)
    end
end


function Page:disable()
    --Update and grey out page label
    if self.elements.label then
        self.elements.label.text = (self.elements.label.text .. " (In-Game Only)")
        self.elements.label.color = tes3ui.getPalette("disabled_color")
    end
    --Grey out all child elements
    for _, element in ipairs(self.elements.subcomponentsContainer.children) do
        if element.color then 
            element.color = tes3ui.getPalette("disabled_color")
        end
    end
end



function Page:createOuterContainer(parentBlock)
    local scrollPane = parentBlock:createVerticalScrollPane({ id = tes3ui.registerID("Page_ScrollPane") })
    scrollPane.heightProportional = 1.0
    scrollPane.widthProportional = 1.0

    local outerContainer = scrollPane:createBlock({ id = tes3ui.registerID("Page_OuterContainer") })
    outerContainer.flowDirection = "top_to_bottom"
    outerContainer.autoHeight = true
    outerContainer.widthProportional = 1.0
    outerContainer.paddingLeft = self.indent
    outerContainer.paddingTop = self.indent

    self.elements.outerContainer = outerContainer
end


return Page