local Parent = require("easyMCM.components.pages.Page")

local ExclusionsPage = Parent:new()

--public statics
ExclusionsPage.label = "Exclusions"
ExclusionsPage.rightListLabel = "Allowed"
ExclusionsPage.leftListLabel = "Blocked"
ExclusionsPage.toggleText = "Toggle Filtered"
--private statics
local itemID = tes3ui.registerID("ExclusionListItem")
local placeholderText = "Search..."

--Constructor
function ExclusionsPage:new(categoryData)
    local t = {}
    if categoryData then
        t = categoryData
        local tabUID = ( "Page_" .. t.id)
        t.tabUID = tes3ui.registerID(tabUID)
        t.config = mwse.loadConfig(t.configPath)
        if not t.config then
            t.config = {
                blocked = {}
            }
            mwse.saveConfig(t.configPath, t.config)
        end
    end
    setmetatable(t, self)
    self.__index = self
    return t
end


local function getSortedModList()
	local list = tes3.getModList()
	for i, name in pairs(list) do
		list[i] = name:lower()
	end
	table.sort(list)
	return list
end

local function getSortedObjectList(params)
    local list = {}

    for obj in tes3.iterateObjects(params.objectType) do

        local doAdd = true
        if params.objectFilters then
            for field, value in pairs(params.objectFilters) do
                if obj[field] ~= value then
                    doAdd = false
                end
            end
        end

		if doAdd then
			list[#list+1] = obj.id:lower()
        end
        
	end
	table.sort(list)
	return list
end

function ExclusionsPage:resetSearchBars()
    self.elements.searchBarInput.rightList.text = ""
    self.elements.searchBarInput.leftList.text = ""
    self.elements.searchBarInput.rightList:triggerEvent("keyPress")
    self.elements.searchBarInput.leftList:triggerEvent("keyPress")
end


function ExclusionsPage:toggle(e)
    -- toggle an item between blocked / allowed
	-- delete element
	local list = e.source.parent.parent.parent
    local text = e.source.text
	e.source:destroy()

	-- toggle blocked
	if list == self.elements.leftList then
		list = self.elements.rightList
        self.config.blocked[text] = nil
	else
		list = self.elements.leftList
		self.config.blocked[text] = true
	end
    mwse.log("Saving %s value %s to %s", text, self.config.blocked[text], self.configPath)
    mwse.saveConfig(self.configPath, self.config)
	-- create element
	list:createTextSelect{ id = itemID, text=text}:register("mouseClick", function(e) self:toggle(e) end )

	-- update sorting
	local container = list:getContentElement()
	for i, child in pairs(container.children) do
		if child.text > text then
			container:reorderChildren(i-1, -1, 1)
			break
		end
	end
    -- update display
    
    self.elements.outerContainer:getTopLevelParent():updateLayout()
end



function ExclusionsPage:updateSearch(listName)
    local searchString = self.elements.searchBarInput[listName].text
    local thisList = self.elements[listName]
    local child = thisList:findChild(itemID)
    if child then
        local itemList = child.parent.children
        for _, item in ipairs(itemList) do
            

            local foundItem = string.find(
                string.lower(item.text), 
                string.lower(searchString), 
                1, true
            )

            if foundItem then
                item.visible = true
            else
                item.visible = false
            end
        end
    end
    self.elements[listName].widget:contentsChanged()
    self.elements.outerContainer:getTopLevelParent():updateLayout()
end

function ExclusionsPage:distribute(items)
	-- distribute items between blocked / allowed
	self.elements.leftList:getContentElement():destroyChildren()
	self.elements.rightList:getContentElement():destroyChildren()
    local function callback(e)
        self:toggle( e)
    end
    for i, name in pairs(items) do
		if self.config.blocked[name] then
			self.elements.leftList:createTextSelect{ id = itemID, text=name}:register("mouseClick",  function(e) self:toggle(e) end )
		else
			self.elements.rightList:createTextSelect{ id = itemID, text=name}:register("mouseClick",  function(e) self:toggle(e) end)
		end
    end
    self:resetSearchBars()
end

function ExclusionsPage:toggleFiltered(listName)
    local thisList = self.elements[listName]
    local child = self.elements[listName]:findChild(itemID)
    if child then
        local itemList = child.parent.children
        for _, item in ipairs(itemList) do
            if item.visible then
                self:toggle({source = item })
            end
        end
    end
    self:resetSearchBars()
    self.elements[listName].widget:contentsChanged()
    --self.elements.outerContainer:getTopLevelParent():updateLayout()
end


--UI creation functions

function ExclusionsPage:createSearchBar(parentBlock, listName)
    
    local searchBlock = parentBlock:createBlock()
    searchBlock.flowDirection = "left_to_right"
    searchBlock.autoHeight = true
    searchBlock.widthProportional = 1.0
    searchBlock.borderBottom = 5

    local searchBar = searchBlock:createThinBorder({ id = tes3ui.registerID("ExclusionsSearchBar")})
	searchBar.autoHeight = true
	searchBar.widthProportional = 1.0
    
 	-- Create the search input itself.
    local input = searchBar:createTextInput({ id = tes3ui.registerID("ExclusionsSearchInput") })
    input.color = tes3ui.getPalette("disabled_color")
    input.text = placeholderText
    input.borderLeft = 5
    input.borderRight = 5
    input.borderTop = 2
    input.borderBottom = 4
    input.widget.eraseOnFirstKey = true
	input.consumeMouseEvents = false
    
	-- Set up the events to control text input control.
    input:register("keyPress", function(e)
        local inputController = tes3.worldController.inputController
		if (inputController:isKeyDown(tes3.scanCode.tab)) then
			-- Prevent alt-tabbing from creating spacing.
			return
		elseif (inputController:isKeyDown(tes3.scanCode.backspace) and input.text == placeholderText) then
			-- Prevent backspacing into nothing.
			return
		end

		input:forwardEvent(e)

        input.color = tes3ui.getPalette("normal_color")
		self:updateSearch(listName)
        input:updateLayout()
        if input.text == "" then
            input.text = placeholderText
            input.color = tes3ui.getPalette("disabled_color")
        end
    end)
    --Pressing enter applies toggle to all items currenty filtered
    input:register("keyEnter", function(e)
		self:toggleFiltered(listName)
	end)

    searchBar:register("mouseClick", function()
        tes3ui.acquireTextInput(input)
    end)

    --Add button to exclude all currently filtered items
    

    local toggleButton = searchBlock:createButton({ text = self.toggleText })
    toggleButton.heightProportional = 1.0
    toggleButton.alignY = 0.0
    toggleButton.borderAllSides = 0
    toggleButton.paddingAllSides = 2
    toggleButton:register("mouseClick", function() self:toggleFiltered(listName) end )

    --Set a table to contain both search bars
    self.elements.searchBar = self.elements.searchBar or {}
    self.elements.searchBarInput = self.elements.searchBarInput or {}
    self.elements.searchBar[listName] = searchBar
    self.elements.searchBarInput[listName] = input
end



function ExclusionsPage:createLeftList(parentBlock)
    local block = parentBlock:createBlock{}
    block.flowDirection = "top_to_bottom"
    block.widthProportional = 1.0
    block.heightProportional = 1.0

    local labelText = ( self.leftListLabel .. ":" )
    local label = block:createLabel{text=labelText}
    label.borderBottom = 2
    label.color = tes3ui.getPalette("header_color")

    self:createSearchBar(block, "leftList")

    leftList = block:createVerticalScrollPane{}
    leftList.widthProportional = 1.0
    leftList.heightProportional = 1.0
    leftList.paddingLeft = 8

    self.elements.leftList = leftList
end


function ExclusionsPage:clickFilter(filter)
    --enable/disable category buttons
    for id, button in pairs(self.elements.filterList.children) do
        button.widget.state = 1
    end
    filter.widget.state = 4
end


function ExclusionsPage:createFiltersSection(parentBlock)

    local block = parentBlock:createBlock{}
    block.flowDirection = "top_to_bottom"
    --block.widthProportional = 1.0
    block.autoWidth = true
    block.heightProportional = 1.0   
    block.borderTop = 13

    local filterList = block:createBlock{id = tes3ui.registerID("FilterList")}
    filterList.flowDirection = "top_to_bottom"
    filterList.autoWidth = true
    filterList.heightProportional = 1.0
    filterList.borderAllSides = 3

    for _, filter in ipairs(self.filters) do
        local button = filterList:createButton{text=filter.label}
        button.widthProportional = 1.0

        --get callback
        local getItemsCallback
        if filter.type == "Plugin" then
            getItemsCallback = getSortedModList
        elseif filter.type == "Object" then
            getItemsCallback = (
                function() 
                    return getSortedObjectList({
                        objectType = filter.objectType, 
                        objectFilters = filter.objectFilters
                    }) 
                end
            ) 
        else
            --No type defined, must be custom
            if not self.callback then
                mwse.log("ERROR: no custom callback defined for %s", self.id)
            end
            getItemsCallback = self.callback
        end

        button:register(
            "mouseClick", 
            function (e)
                local items = getItemsCallback()
                self:clickFilter(button)
                self:distribute(items)
            end
        )
    end

    self.elements.filterList = filterList
end


function ExclusionsPage:createRightList(parentBlock)

    local block = parentBlock:createBlock{}
    block.flowDirection = "top_to_bottom"
    block.widthProportional = 1.0
    block.heightProportional = 1.0
    
    local labelText = ( self.rightListLabel .. ":")
    local label = block:createLabel{text=labelText}
    label.borderBottom = 2
    label.color = tes3ui.getPalette("header_color")

    self:createSearchBar(block, "rightList")

    allowed = block:createVerticalScrollPane{} 
    allowed.widthProportional = 1.0
    allowed.heightProportional = 1.0
    allowed.paddingLeft = 8
    self.elements.rightList = allowed
end

function ExclusionsPage:createOuterContainer(parentBlock)
    local outerContainer = parentBlock:createThinBorder({ id = tes3ui.registerID("Category_OuterContainer") })
    outerContainer.flowDirection = "top_to_bottom"
    outerContainer.widthProportional = 1.0
    outerContainer.heightProportional = 1.0
    --VerticalScrollPanes add 4 padding
    --Because we are using a thinBorder, we match it here
    outerContainer.paddingLeft = self.indent + 4
    outerContainer.paddingRight = self.indent + 4
    outerContainer.paddingBottom = self.indent + 4
    outerContainer.paddingTop = 4
    self.elements.outerContainer = outerContainer   
end

function ExclusionsPage:createDescription(parentBlock)
	local description = parentBlock:createLabel{text=self.description}
    --description.heightProportional = -1
    description.autoHeight = true
	description.widthProportional = 1.0
	description.wrapText = true
    description.borderBottom = 5
    description.borderLeft = self.indent
    self.elements.description = description
end

function ExclusionsPage:createSections(parentBlock)
    local sections = parentBlock:createBlock{}
	sections.flowDirection = "left_to_right"
	sections.widthProportional = 1.0
    sections.heightProportional = 1.0
    sections.paddingAllSides = self.indent
    self.elements.sections = sections
end

function ExclusionsPage:create(parentBlock)
    self.elements = {}

    self:createOuterContainer(parentBlock)
    
    self:createDescription(self.elements.outerContainer)
    self:createSections(self.elements.outerContainer)
	self:createLeftList(self.elements.sections)

	self:createFiltersSection(self.elements.sections)

    self:createRightList(self.elements.sections)

	-- default to first filter
    self.elements.filterList.children[1]:triggerEvent("mouseClick")
end

return ExclusionsPage