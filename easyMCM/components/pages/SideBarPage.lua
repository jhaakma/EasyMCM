--[[
    Top level category with a side bar that shows text for any component
    hovered over. 
]]--

local Parent = require ("easyMCM.components.pages.Page")
local SideBarPage = Parent:new()

function SideBarPage:createSideBar(parentBlock)
    local sideBarBlock = parentBlock:createBlock()
    sideBarBlock.widthProportional = 1.0
    sideBarBlock.heightProportional = 1.0
    sideBarBlock.paddingAllSides = 8
    
    description = self.description or ""
    local sideBarLabel = sideBarBlock:createLabel({text = description})
    sideBarLabel.widthProportional = 1.0
    sideBarLabel.heightProportional = 1.0
    sideBarLabel.wrapText = true
    sideBarLabel.paddingLeft = 2
    self.elements.sideBarBlock = sideBarBlock
    self.elements.sideBarLabel = sideBarLabel

    local function updateSideBar(setting)
        local sideBarLabel = self.elements.sideBarLabel
        local newText
        if setting and setting.label and setting.description then
            newText = (
                setting.label .. 
                ":\n\n" ..    
                setting.description
            )
        else
            newText = self.description or ""
        end
        sideBarLabel.text = newText
    end
    event.register("MCM:ComponentMouseOver", updateSideBar)
    event.register("MCM:ComponentMouseLeave", updateSideBar)
    sideBarBlock:register("destroy",
        function()
            event.unregister("MCM:ComponentMouseOver", updateSideBar)
            event.unregister("MCM:ComponentMouseLeave", updateSideBar)
        end
    )
end

function SideBarPage:createOuterContainer(parentBlock)

    local sideToSideBlock = parentBlock:createBlock()
    sideToSideBlock.flowDirection = "left_to_right"
    sideToSideBlock.heightProportional = 1.0
    sideToSideBlock.widthProportional = 1.0


    --Lefthand window containing settings
    local scrollPane = sideToSideBlock:createVerticalScrollPane({ id = tes3ui.registerID("Page_OuterContainer") })
    scrollPane.heightProportional = 1.0
    scrollPane.widthProportional = 1.0

    local outerContainer = scrollPane:createBlock()
    outerContainer.flowDirection = "top_to_bottom"
    outerContainer.autoHeight = true
    outerContainer.widthProportional = 1.0
    outerContainer.paddingLeft = self.indent

    self.elements.outerContainer = outerContainer   

    --Righthand window containing mouse-hover info
    local rightColumn = sideToSideBlock:createThinBorder()
    rightColumn.heightProportional = 1.0
    rightColumn.widthProportional = 1.0
    self:createSideBar(rightColumn)

end


return SideBarPage