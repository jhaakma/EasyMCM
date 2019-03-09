--[[
    Top level category with a side bar that shows text for any component
    hovered over. 
]]--

local Parent = require ("easyMCM.components.pages.Page")
local SideBarPage = Parent:new()
SideBarPage.triggerOn = "MCM:MouseOver"
SideBarPage.triggerOff = "MCM:MouseLeave"

function SideBarPage:createSidetoSideBlock(parentBlock)
    local sideToSideBlock = parentBlock:createBlock()
    sideToSideBlock.flowDirection = "left_to_right"
    sideToSideBlock.heightProportional = 1.0
    sideToSideBlock.widthProportional = 1.0
    self.elements.sideToSideBlock = sideToSideBlock
end


function SideBarPage:createLeftColumn(parentBlock)
    --Lefthand window containing settings
    local scrollPane = parentBlock:createVerticalScrollPane({ id = tes3ui.registerID("Page_OuterContainer") })
    scrollPane.heightProportional = 1.0
    scrollPane.widthProportional = 1.0

    local outerContainer = scrollPane:createBlock({ id = tes3ui.registerID("SBP_OuterContainer")})
    outerContainer.flowDirection = "top_to_bottom"
    outerContainer.autoHeight = true
    outerContainer.widthProportional = 1.0
    outerContainer.paddingLeft = self.indent
    outerContainer.paddingTop = self.indent
    self.elements.outerContainer = outerContainer   
end


function SideBarPage:createRightColumn(parentBlock)
    --Righthand window containing mouse-hover info
    local rightColumn = parentBlock:createThinBorder({ id = tes3ui.registerID("SideBar")})
    rightColumn.heightProportional = 1.0
    rightColumn.widthProportional = 1.0
    rightColumn.flowDirection = "top_to_bottom"
    rightColumn.paddingTop = self.indent + 4
    rightColumn.paddingLeft = self.indent + 4

    --ContentsBlock is hidden on mouseOver
    local defaultContentsBlock = rightColumn:createBlock()
    defaultContentsBlock.heightProportional = 1.0
    defaultContentsBlock.widthProportional = 1.0
    defaultContentsBlock.flowDirection = "top_to_bottom"

    if self.sidebarComponents then
        self:createSubcomponents(defaultContentsBlock, self.sidebarComponents)
    else
        --By default, sidebar is a mouseOver description pane
        local sidebarInfo = self:getComponent({
            --label = self.label,
            text = self.description or "",
            class = "Info"
        })
        sidebarInfo:create(defaultContentsBlock)
    end

    --mouseover shows descriptions of settings
    local mouseOver = self:getComponent({
        --label = self.label,
        text = self.description or "",
        class = "MouseOverInfo"
    })
    mouseOver:create(rightColumn)
    mouseOver.elements.outerContainer.visible = false
    self.elements.mouseOver = mouseOver

    --event to hide default and show mouseover
    local function doMouseOver(component)
        if component.description then
            mouseOver.elements.outerContainer.visible = true
            defaultContentsBlock.visible = false
        end
    end

    --event to hide mouseover and show default
    local function doMouseLeave()
        mouseOver.elements.outerContainer.visible = false
        defaultContentsBlock.visible = true
    end

    --register events
    event.register(self.triggerOn, doMouseOver)
    event.register(self.triggerOff, doMouseLeave)
    parentBlock:register("destroy",
    function()
        event.unregister(self.triggerOn, doMouseOver)
        event.unregister(self.triggerOff, doMouseLeave)
    end
)
end


function SideBarPage:createOuterContainer(parentBlock)
    self:createSidetoSideBlock(parentBlock)
    self:createLeftColumn(self.elements.sideToSideBlock)
    self:createRightColumn(self.elements.sideToSideBlock)
end


return SideBarPage