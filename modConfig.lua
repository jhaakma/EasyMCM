local thisMod = {
    name = "",
    modData = {},
    configPath = "",
    playerDataPath = ""
}

--local thisMod.modData = require ( "mer.ashfall.MCM.thisMod.modData")
--local configPath = "config/ashfall/mcm_config"

local modConfig = {}
local currentCategoryTab = "generalSettings"
local mcmContainer


local config = {}

local uids = {
    sideBarText = tes3ui.registerID( thisMod.name .. ":MCM_SidebarText"),
    leftColumn =  tes3ui.registerID( thisMod.name .. ":MCM_leftColumn"),
    tabsBlock = tes3ui.registerID( thisMod.name .. ":MCM_tabsBlock"),
}


--FUNCTIONS--

--[[
    Returns config data of an Setting. If it's a local setting, data is stored on Player reference, 
    otherwise it's stored in config file
]]--
local function getSettingData()
    if thisMod.modData.categories[currentCategoryTab].inGameOnly then  
        if not tes3.player then 
            mwse.log("[".. thisMod.name .. ".modConfig ERROR] toggleYesNoButton(): Toggled ingame only setting while not in game")
            return
        end

        local data = tes3.player.data
        data[thisMod.playerDataPath] = data[thisMod.playerDataPath] or {}
        local modData = data[thisMod.playerDataPath]
        modData.mcmOptions = modData.mcmOptions or {}
        modPlayerData = modPlayerData or {}

        return modPlayerData
    else
        return config
    end   
end

local function getOnOffFromBool (bool)
    --Returns "On" for true or "Off" for false--
    return bool and tes3.findGMST(tes3.gmst.sOn).value or tes3.findGMST(tes3.gmst.sOff).value
end

local function toggleYesNoButton(e, setting)
    local data = getSettingData(setting)

    data[setting.id] = not data[setting.id]
    e.source.text = getOnOffFromBool (data[setting.id])
end

local function formatBlock(block)
    block.layoutWidthFraction = 1.0
    block.autoHeight = true
    block.flowDirection = "top_to_bottom"
    block.paddingAllSides = 2
end


local function updateSideBar(params)-- params(optional): { label, description }
    local sideBarText = mcmContainer:findChild(uids.sideBarText)
    local newText

    if params then
        newText = (
            params.label .. 
            ":\n\n" ..    
            params.description
        )
    else
        newText = thisMod.modData.categories[currentCategoryTab].sidebarText or ""
    end

    sideBarText.text = newText 
    mcmContainer:updateLayout()
end


local function createSideBar(parentBlock)
    local sideBarBlock = parentBlock:createBlock()
    sideBarBlock.widthProportional = 1.0
    sideBarBlock.heightProportional = 1.0
    sideBarBlock.borderAllSides = 10
    sideBarText = thisMod.modData.categories[currentCategoryTab].sidebarText or ""
    local words = sideBarBlock:createLabel({id= uids.sideBarText, text = sideBarText})
    words.widthProportional = 1.0
    words.heightProportional = 1.0
    words.wrapText = true
    
end


local function registerMouseOvers(params) -- params: {block, label, description}
    params.block:register("mouseOver", function() updateSideBar({label = params.label, description = params.description}) end )
    params.block:register("mouseLeave", function() updateSideBar() end )
end


local function createBlockIntro(params) -- params: {block, label, description(optional)}

    if not params.parentBlock then
        mwse.log("[".. thisMod.name .. ".modConfig ERROR] createBlockIntro(): no block given")
        return
    elseif not params.label and not params.description then
        mwse.log("[".. thisMod.name .. ".modConfig ERROR] createBlockIntro(): no label or description given")
        return
    end

    local block = params.parentBlock:createBlock()
    formatBlock(block)

    local label = nil
    if params.label then
        label = params.parentBlock:createLabel({text = params.label})
        label.color = tes3ui.getPalette("header_color")
        label.borderBottom = 5
        if params.description then
            registerMouseOvers({ block = label, label = params.label, description = params.description})
        end
    end
    return { block = block, label = label }
   
end


--Creates On/Off MCM setting with label on the left and button on the right--
local function makeOnOffButton(params) --params: {block, setting}

    if not params.block then
        mwse.log("[".. thisMod.name .. ".modConfig ERROR] makeOnOffButton(): no block given")
        return
    elseif not params.setting then
        mwse.log("[".. thisMod.name .. ".modConfig ERROR] makeOnOffButton(): no setting given")
        return
    end
    local block = params.block
    local setting = params.setting
    
    local buttonBlock
    buttonBlock = block:createBlock({})
    buttonBlock.flowDirection = "left_to_right"
    buttonBlock.widthProportional = 1.0
    buttonBlock.autoHeight = true

    local button = buttonBlock:createButton({ text = "---"})
    
    local label = buttonBlock:createLabel({ text = setting.label })
    label.borderAllSides = 4
    label.wrapText = true
    label.widthProportional = 1.0

    if setting.description then
        registerMouseOvers({block = label,  label = setting.label, description = setting.description})
    end
    
    local general = tes3.player
    --Disable in menu for local settings
    if thisMod.modData.categories[currentCategoryTab].inGameOnly and not general then
        button.widget.state = 2
        label.color = tes3ui.getPalette("disabled_color")
    else
        --not disabled, so activate button
        local data = getSettingData(setting)
        local bool = data[setting.id]

        local buttonText = getOnOffFromBool (bool)
        button.text = buttonText
        button:register(
            "mouseClick", 
            function(e)
                toggleYesNoButton(e, setting )
            end
        )		
    end

    return { buttonBlock = buttonBlock, label = label, button = button }
end


local function createSubCategoryBlock(params)-- params: {parentBlock, subcategory}

    if params.subcategory.label then
        local intro = createBlockIntro{
            parentBlock = params.parentBlock,
            label = params.subcategory.label,
            description = params.subcategory.description
        }
    end
    for _, setting in ipairs( params.subcategory.settings ) do
        makeOnOffButton( {block = params.parentBlock, setting = setting} )
    end
end

local function createCategoryBlock (category)
    local parentBlock = mcmContainer:findChild(uids.leftColumn)
    currentCategoryTab = category.id
    local categoryBlock = parentBlock:createBlock()
    categoryBlock.flowDirection = "top_to_bottom"
    categoryBlock.widthProportional = 1.0
    categoryBlock.autoHeight = true
    categoryBlock.borderAllSides = 10
    
    local mainIntro = createBlockIntro{
        parentBlock = categoryBlock,
        label = category.label,
        description = category.description
    }
    mainIntro.label.absolutePosAlignX = 0.5

    for _, subcategory in pairs(category.subcategories) do
        createSubCategoryBlock({parentBlock = categoryBlock, subcategory = subcategory})
    end


    --Grey out label/description if not in game
    if category.inGameOnly and not tes3.player then
        for _, element in ipairs(categoryBlock.children) do
            if element.color then 
                element.color = tes3ui.getPalette("disabled_color")
            end
        end
    end
end


local function mouseClickTab( tab )
    local leftColumn = mcmContainer:findChild(uids.leftColumn)


    leftColumn:destroyChildren()
    createCategoryBlock(tab)

    updateSideBar()

    --enable/disable tab buttons
    for id, category in pairs(thisMod.modData.categories) do
        if currentCategoryTab == id then
            mcmContainer:findChild(category.buttonUID).widget.state = 4
        else
            mcmContainer:findChild(category.buttonUID).widget.state = 1
        end
    end
    mcmContainer:updateLayout()
    leftColumn.parent:updateLayout()
    
end

local function createTabButton(tab)
    local tabsBlock = mcmContainer:findChild(uids.tabsBlock)
    local button = tabsBlock:createButton({id = tab.buttonUID, text = tab.label})
    button:register(
        "mouseClick",
        function ()
            mouseClickTab( tab )
        end
    )
end


---CREATE MCM---
function modConfig.onCreate(e)
    if not dataRegistered then
        mwse.log("[MODCONFIG ERROR] registerModData() has not been called")
        return
    end
    mcmContainer = e
    local outerBlock = mcmContainer:createThinBorder()
    outerBlock.flowDirection = "top_to_bottom"
    outerBlock.paddingAllSides = 4
    outerBlock.widthProportional = 1.0
    outerBlock.heightProportional = 1.0
    
    --header image
    local imagePath = thisMod.modData.headerImagePath
    if imagePath then
        local headerBlock = outerBlock:createBlock()
        headerBlock.autoHeight = true
        headerBlock.widthProportional = 1.0
        local headerImage = headerBlock:createImage({path = imagePath })
        headerImage.absolutePosAlignX = 0.5
        headerImage.imageScaleX = 0.5
        headerImage.imageScaleY = 0.5
    end

    --Tabs block
    local tabsBlock = outerBlock:createBlock({ id = uids.tabsBlock })
    tabsBlock.autoHeight = true
    tabsBlock.widthProportional = 1.0


    if not thisMod.modData.order then
        mwse.log("EasyMCM: no order table found in mod data")
        return
    elseif table.getn(thisMod.modData.order) > 1 then
        for _, category in ipairs(thisMod.modData.order) do
            createTabButton(thisMod.modData.categories[category])
        end
        --highlight first button
        mcmContainer:findChild(thisMod.modData.categories[thisMod.modData.order[1]].buttonUID).widget.state = 4
    end
    
 
    --Container holding lefthand settings and right hand info windows
    local sideBySideBlock = outerBlock:createBlock()
    sideBySideBlock.flowDirection = "left_to_right"
    sideBySideBlock.heightProportional = 1.0
    sideBySideBlock.widthProportional = 1.0

    --Lefthand window containing settings
    local leftScrollPane = sideBySideBlock:createVerticalScrollPane()
    leftScrollPane.heightProportional = 1.0
    leftScrollPane.widthProportional = 1.0
    leftScrollPane.borderAllSides = 2
    
    local leftColumn = leftScrollPane:createBlock({ id = uids.leftColumn })
    leftColumn.autoHeight = true
    leftColumn.widthProportional = 1.0

    createCategoryBlock(thisMod.modData.categories[thisMod.modData.order[1]])

    --Righthand window containing mouse-hover info
    local rightColumn = sideBySideBlock:createThinBorder()
    rightColumn.heightProportional = 1.0
    rightColumn.widthProportional = 1.0
    rightColumn.borderAllSides = 2
    createSideBar(rightColumn)

    mcmContainer:updateLayout()
end

--Save when closing MCM--
function modConfig.onClose(mcmContainer)
	mwse.log("[".. thisMod.name .. " Saving mod configuration:")
	mwse.log(json.encode(config, { indent = true }))
	json.savefile(thisMod.configPath, config, { indent = true })
end

function modConfig.registerModData(params) -- params: name, modDataPath, configPath
    assert(params, "[EasyMCM: modConfig:registerModData()] no params!")
    assert(params.name, "[EasyMCM: modConfig:registerModData()] no name given!")
    assert(params.modDataPath, "[EasyMCM: modConfig:registerModData()] no modDataPath given!")
    assert(( params.configPath or params.playerDataPath) , "[EasyMCM: modConfig:registerModData()] no config path or player data path given!")
    
    thisMod.name = params.name
    thisMod.modData = require ( params.modDataPath )
    assert(thisMod.modData, "[EasyMCM: modConfig:registerModData()] Mod Data file not found!")
    assert(thisMod.modData.categories, "[EasyMCM: modConfig:registerModData()] Mod Data has no categories table!")
    assert(thisMod.modData.order, "[EasyMCM: modConfig:registerModData()] Mod Data has no order table!")

    thisMod.configPath = params.configPath
    thisMod.playerDataPath = params.playerDataPath
    config = json.loadfile(params.configPath)
    if (not config) then
        config = {
        }
    end 
    mwse.log("saving config for " .. thisMod.name)
    json.savefile(thisMod.configPath, config, { indent = true })
    dataRegistered = true
end

return modConfig