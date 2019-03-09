--[[
    A very specialised, but still flexible page type that allows you
    to create filters on objects, plugins and more, and move them
    between allowed and blocked lists.
]]--

local Parent = require("easyMCM.components.pages.Page")

local ExclusionsPage = Parent:new()
--public fields
ExclusionsPage.label = "Exclusions"
ExclusionsPage.rightListLabel = "Allowed"
ExclusionsPage.leftListLabel = "Blocked"
ExclusionsPage.toggleText = "Toggle Filtered"

--private fields
local itemID = tes3ui.registerID("ExclusionListItem")
local placeholderText = "Search..."


--Constructor
function ExclusionsPage:new(data)
    local t = {}
    if data then
        t = data
        local tabUID = ( "Page_" .. t.label)
        t.tabUID = tes3ui.registerID(tabUID)

        --create variable
        local typePath = ("easyMCM.variables." .. t.variable.class)
        t.variable = require(typePath):new(t.variable)
        if t.variable.value == nil then
            t.variable.value = { }
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
        --Check that all filters match
        if params.objectFilters then
            for field, value in pairs(params.objectFilters) do
                if obj[field] ~= value then
                    doAdd = false
                end
            end
        end
        if params.noScripted and obj.script ~= nil then
            doAdd = false
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
        self.variable.value[text] = nil
	else
		list = self.elements.leftList
		self.variable.value[text] = true
	end
    mwse.log("Saving %s value %s to %s", text, self.variable.value[text], self.configPath)

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
            if item.text:lower():find(searchString:lower(), 1, true) then
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

    for i, name in pairs(items) do
		if self.variable.value[name] then
			self.elements.leftList:createTextSelect{ id = itemID, text=name}:register("mouseClick",  function(e) self:toggle(e) end )
		else
			self.elements.rightList:createTextSelect{ id = itemID, text=name}:register("mouseClick",  function(e) self:toggle(e) end)
		end
    end

    self:resetSearchBars()
end


function ExclusionsPage:toggleFiltered(listName)
    --Move all items currently filtered to opposite list

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
    
end


function ExclusionsPage:clickFilter(filter)

    --Turn all filters off
    for id, button in pairs(self.elements.filterList.children) do
        button.widget.state = 1
    end
    --turn this filter back on
    filter.widget.state = 4

end


--UI creation functions


function ExclusionsPage:createSearchBar(parentBlock, listName)
    
    local searchBlock = parentBlock:createBlock()
    searchBlock.flowDirection = "left_to_right"
    searchBlock.autoHeight = true
    searchBlock.widthProportional = 1.0
    searchBlock.borderBottom = self.indent

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
        pressedTab = (inputController:isKeyDown(tes3.scanCode.tab))
        backspacedNothing = (
            (   
                inputController:isKeyDown(tes3.scanCode.delete) or
                inputController:isKeyDown(tes3.scanCode.backspace) 
            ) 
            and input.text == placeholderText
        )

        if pressedTab then
            -- Prevent alt-tabbing from creating spacing.
            return
        elseif backspacedNothing then
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
    --toggleButton.alignY = 0.0
    toggleButton.borderAllSides = 0
    toggleButton.paddingAllSides = 2
    toggleButton:register("mouseClick", function() self:toggleFiltered(listName) end )

    --Set a table to contain both search bars
    self.elements.searchBar = self.elements.searchBar or {}
    self.elements.searchBarInput = self.elements.searchBarInput or {}
    self.elements.searchBar[listName] = searchBar
    self.elements.searchBarInput[listName] = input

end


function ExclusionsPage:createFiltersSection(parentBlock)

    local block = parentBlock:createBlock{}
    block.flowDirection = "top_to_bottom"
    block.autoWidth = true
    block.heightProportional = 1.0   
    block.borderTop = 13
    block.borderLeft = self.indent
    block.borderRight = self.indent

    local filterList = block:createBlock{id = tes3ui.registerID("FilterList")}
    filterList.flowDirection = "top_to_bottom"
    filterList.autoWidth = true
    filterList.heightProportional = 1.0

    
    filterList.borderTop = 3

    --Add buttons for each filter
    for _, filter in ipairs(self.filters) do
        local button = filterList:createButton{text=filter.label}
        button.widthProportional = 1.0
        button.borderBottom = 5
        --get callback
        local getItemsCallback
        if filter.type == "Plugin" then
            getItemsCallback = getSortedModList
        elseif filter.type == "Object" then
            getItemsCallback = (
                function() 
                    return getSortedObjectList({
                        objectType = filter.objectType, 
                        objectFilters = filter.objectFilters,
                        noScripted = filter.noScripted
                    }) 
                end
            ) 
        else
            --No type defined, must be custom
            if not filter.callback then
                mwse.log("ERROR: no custom callback defined for %s", self.label)
            end
            getItemsCallback = filter.callback
        end

        --Register clicking filter button
        button:register(
            "mouseClick", 
            function (e)
                local items = getItemsCallback()
                self:clickFilter(button)
                self:distribute(items)
            end
        )

    end

    if #self.filters <= 1 then
        filterList.visible = false
    end

    self.elements.filterList = filterList
end


function ExclusionsPage:createList(parentBlock, listId)

    if listId ~= "leftList" and listId ~= "rightList" then
        mwse.log("ERROR: param 2 of createList must be 'leftList' or 'rightList'.")
        return
    end
    local labelId = ( listId .. "Label" )

    local block = parentBlock:createBlock{}
    block.flowDirection = "top_to_bottom"
    block.widthProportional = 1.0
    block.heightProportional = 1.0

    local labelText = ( self[labelId] .. ":" )
    local label = block:createLabel{text=labelText}
    label.borderBottom = 2
    label.color = tes3ui.getPalette("header_color")

    self:createSearchBar(block, listId)

    --Create actual list
    list = block:createVerticalScrollPane{}
    list.widthProportional = 1.0
    list.heightProportional = 1.0
    list.paddingLeft = 8
    self.elements[listId] = list

end


function ExclusionsPage:createOuterContainer(parentBlock)
    local outerContainer = parentBlock:createThinBorder({ id = tes3ui.registerID("Category_OuterContainer") })
    outerContainer.flowDirection = "top_to_bottom"
    outerContainer.widthProportional = 1.0
    outerContainer.heightProportional = 1.0

    --VerticalScrollPanes add 4 padding
    --Because we are using a thinBorder, we match it here
    outerContainer.paddingLeft = 4 + self.indent
    outerContainer.paddingRight = 4 + self.indent
    outerContainer.paddingBottom = 4
    outerContainer.paddingTop = self.indent + 4
    self.elements.outerContainer = outerContainer   
end


function ExclusionsPage:createLabel(parentBlock)
    Parent.createLabel(self, parentBlock)
    if self.elements.label then
        self.elements.label.color = tes3ui.getPalette("header_color")
    end
end


function ExclusionsPage:createDescription(parentBlock)
    if self.description then
        local description = parentBlock:createLabel{text=self.description}
        --description.heightProportional = -1
        description.autoHeight = true
        description.widthProportional = 1.0
        description.wrapText = true
        description.borderLeft = self.indent
        description.borderRight = self.indent
        self.elements.description = description
    end
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
    self.mouseOvers = {}

    self:createOuterContainer(parentBlock)
    self:createLabel(self.elements.outerContainer)
    self:createDescription(self.elements.outerContainer)
    self:createSections(self.elements.outerContainer)
	self:createList(self.elements.sections, "leftList")
	self:createFiltersSection(self.elements.sections)
    self:createList(self.elements.sections, "rightList")

	-- default to first filter
    self.elements.filterList.children[1]:triggerEvent("mouseClick")
end

return ExclusionsPage