
--parent
local Parent = require("easyMCM.components.Component")
--Class object
local Template = Parent:new()

function Template:new(modData)
    local t = modData or {}
    if modData then 
        --Create Pages
        local pages = {}
        for _, page in ipairs(modData.pages) do
            local pageClass = page.class or "Page"
            local newPage = self:getComponent(pageClass):new(page)
            table.insert(pages, newPage )
        end
        t.pages = pages
    end
    setmetatable(t, self)
    self.__index = self
    return t
end

function Template:createOuterContainer(parentBlock)
    Parent.createOuterContainer(self, parentBlock)
    self.elements.outerContainer.heightProportional = 1.0
    self.elements.outerContainer.paddingBottom = 0
    self.elements.outerContainer.paddingLeft = self.indent
    self.elements.outerContainer.paddingRight = self.indent
   --[[local outerContainer = parentBlock:createBlock()
    outerContainer.flowDirection = "top_to_bottom"
    --outerContainer.paddingAllSides = 5
    outerContainer.widthProportional = 1.0
    outerContainer.heightProportional = 1.0
    self.elements.outerContainer = outerContainer]]--
end

function Template:createLabel(parentBlock)
    --header image
    local headerBlock = parentBlock:createBlock()
    headerBlock.autoHeight = true
    headerBlock.widthProportional = 1.0
    local imagePath = self.headerImagePath
    if imagePath then
        local headerImage = headerBlock:createImage({path = imagePath })
        headerImage.absolutePosAlignX = 0.5
        headerImage.autoHeight = true
        headerImage.widthProportional = 1.0
        headerImage.imageScaleX = 0.5
        headerImage.imageScaleY = 0.5
    elseif self.label then
        headerBlock.borderAllSides = 10
        local title = headerBlock:createLabel({text = self.label})
        title.color = tes3ui.getPalette("header_color")
    end

end


function Template:clickTab( thisPage )
    local pageBlock = self.elements.pageBlock
    local tabsBlock = self.elements.tabsBlock
    --Clear previous page
    pageBlock:destroyChildren()
    --Create new page
    thisPage:create(pageBlock)
    --Set new page to current
    self.currentPage = thisPage
    --enable/disable page buttons
    for id, page in pairs(self.pages) do
        tabsBlock:findChild(page.tabUID).widget.state = 1
    end
    tabsBlock:findChild(thisPage.tabUID).widget.state = 4
    pageBlock:updateLayout()
end


function Template:createTab(page) 
    local button = self.elements.tabsBlock:createButton({id = page.tabUID, text = page.label})
    button.borderAllSides = 0
    button.paddingTop= 4
    button.paddingLeft= 8
    button.paddingRight = 8
    button.paddingBottom = 6
    button:register(
        "mouseClick",
        function ()
            self:clickTab( page )
        end
    )
end

function Template:createTabsBlock(parentBlock)
    --Create page tab buttons
    local tabsBlock = parentBlock:createBlock()
    self.elements.tabsBlock = tabsBlock
    tabsBlock.autoHeight = true
    tabsBlock.widthProportional = 1.0

    --Create a tab for each page (no need if only one page)
    if table.getn(self.pages) > 1 then
        for _, page in ipairs(self.pages) do
            self:createTab(page)
        end
        --highlight first button
        local firstTab = parentBlock:findChild(self.pages[1].tabUID)
        firstTab.widget.state = 4
    end
    
end

function Template:createContentsContainer(parentBlock)
    local pageBlock = parentBlock:createBlock()
    pageBlock.heightProportional = 1.0
    pageBlock.widthProportional = 1.0
    self.currentPage = self.pages[1]
    self.currentPage:create(pageBlock)
    self.elements.pageBlock = pageBlock
end

function Template:createComponent(parentBlock)

    self:createLabel(parentBlock)

    self:createTabsBlock(parentBlock)

    self:createContentsContainer(parentBlock)

end

return Template