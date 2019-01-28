local this = {}


    


--Setup local configs. 
--Call this in your initial loaded event before you start using config values
function this.initialiseLocalSettings(modData )
    --set up tables on player data
    tes3.player.data[modData.playerDataTable] = (
        tes3.player.data[modData.playerDataTable] or 
        { mcmSettings = {} }
    )
    local data = tes3.player.data[modData.playerDataTable]
    data.mcmSettings = data.mcmSettings or {}

    for _, category in pairs(modData.categories) do
        if category.inGameOnly then
            for _, subcategory in pairs(category.subcategories) do
                for _, setting in pairs(subcategory.settings) do
                    if data.mcmSettings[setting.id] == nil then
                        data.mcmSettings[setting.id] = setting.defaultSetting
                        mwse.log( "Initialising local config %s to %s", setting.id, setting.defaultSetting )
                    end
                end
            end
        end
    end
end


function this.registerModData(modData) -- params: name, modDataPath, configPath

    --object returned to be used in modConfigMenu
    local modConfig = {}

    --function for formatting logs and asserts
    local logLevels = {
        error = "ERROR",
        info = "INFO",
        none = ""
    }
    local function getLogMessage(message, logLevel)
        logLevel = logLevel or logLevels.info
        formattedMessage = string.format("[%s MCM: %s] %s", modData.name, logLevel, message)
        return formattedMessage
    end

    --Check mod data has necessary values
    assert(modData, getLogMessage("No modData!", logLevels.none) )
    assert(modData.name, getLogMessage("No name given!", logLevels.none))
    assert(modData.categories, getLogMessage("Mod Data has no categories table!", logLevels.none))
    assert( ( modData.configPath or modData.playerDataTable ) , getLogMessage("No config path or player data path given!", logLevels.none))
    
    --Setup config file
    if modData.configPath then
        modData.config = json.loadfile(modData.configPath)
        if (not modData.config) then
            modData.config = {}
        end   
        json.savefile(modData.configPath, modData.config, { indent = true })
    end
    --initilaise config defaults
    for _, category in pairs(modData.categories) do
        if not category.inGameOnly then
            for _, subcategory in pairs(category.subcategories) do
                for _, setting in pairs(subcategory.settings) do
                    if modData.config[setting.id] == nil then
                        modData.config[setting.id] = setting.defaultSetting
                        mwse.log( "Initialising global config %s to %s", setting.id, setting.defaultSetting )
                    end
                end
            end
        end
    end


    --Initialise other variables

    --Stores which category is currently being viewed
    local currentCategory
    --outer UI container for MCM
    local mcmContainer
    --create uids with name of mod
    local uidNames = {
        sideBarText = ( modData.name .. ":MCM_SidebarText"),
        leftColumn = ( modData.name .. ":MCM_leftColumn"),
        tabsBlock = ( modData.name .. ":MCM_tabsBlock"),
    }
    --register uis
    local uids = {
        sideBarText = tes3ui.registerID(  uidNames.sideBarText ),
        leftColumn =  tes3ui.registerID(  uidNames.leftColumn ),
        tabsBlock = tes3ui.registerID( uidNames.tabsBlock ),
    }



    --FUNCTIONS--

    --return config from player data if local setting, otherwise from file
    local function getConfig()
        if currentCategory.inGameOnly then  
            assert( 
                tes3.player, 
                getLogMessage( "Toggled ingame only setting while not in game", logLevels.none) 
            )
            assert(
                tes3.player.data[modData.playerDataTable],
                getLogMessage("Player data table has not been configured", logLevels.none)
            )
            assert(
                tes3.player.data[modData.playerDataTable].mcmSettings,
                getLogMessage("mcmSettings on Player data table has not been configured", logLevels.none)
            )

            return tes3.player.data[modData.playerDataTable].mcmSettings
        else
            assert( 
                modData.config, 
                getLogMessage( "No config file set", logLevels.none) 
            )
            return modData.config
        end   
    end

    local function initaliseSettingData(setting)
        local data = getConfig()
        if data[setting.id] == nil then
            data[setting.id] = setting.defaultSetting
            mwse.log( getLogMessage("Initialising local config: %s = %s"), setting.id, data[setting.id] )
        end
        return data[setting.id]
    end

    local function updateSettingData(setting, newValue)
        local data = getConfig()
        data[setting.id] = newValue
        mwse.log( getLogMessage("Saving new local config: %s = %s"), setting.id, data[setting.id] )
    end


    local function getTextFromBool (bool, buttonType)
        if bool == nil then
            mwse.log( getLogMessage("No bool given", logLevels.error) )
        end
        assert(buttonType, getLogMessage("No button type given", logLevels.error))
        --Returns "On" for true or "Off" for false--
        if buttonType == "OnOff" then 
            return bool and tes3.findGMST(tes3.gmst.sOn).value or tes3.findGMST(tes3.gmst.sOff).value
        elseif buttonType == "YesNo" then
            return bool and tes3.findGMST(tes3.gmst.sYes).value or tes3.findGMST(tes3.gmst.sNo).value
        end
    end
    

    local function toggleButton(e, setting)
        local data = getConfig()
        local newValue = ( not data[setting.id] )
        mwse.log("Toggle: new value %s", newValue)
        updateSettingData(setting, newValue)

        
        e.source.text = getTextFromBool (newValue, setting.type)

        if setting.callback then 
            setting.callback()
        end
    end

    local function formatBlock(block)
        block.layoutWidthFraction = 1.0
        block.autoHeight = true
        block.flowDirection = "top_to_bottom"
        block.paddingAllSides = 2
    end

    local function checkDoDisable()
        return ( currentCategory.inGameOnly and not tes3.player )
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
            newText = currentCategory.sidebarText or ""
        end

        sideBarText.text = newText 
        mcmContainer:updateLayout()
    end


    local function createSideBar(parentBlock)
        local sideBarBlock = parentBlock:createBlock()
        sideBarBlock.widthProportional = 1.0
        sideBarBlock.heightProportional = 1.0
        sideBarBlock.borderAllSides = 10
        sideBarText = currentCategory.sidebarText or ""
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
        assert( params, getLogMessage("No params given", logLevels.error) )
        assert( params.parentBlock, getLogMessage("No block given", logLevels.error) )
        assert( (params.label or params.description ), getLogMessage("No label or description given", logLevels.error))

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
    local function makeOnOffButton(params) --params: {parent, setting}
        assert(params)
        assert(params.parent)
        assert(params.setting)

        local parent = params.parent
        local setting = params.setting
        
        local buttonBlock
        buttonBlock = parent:createBlock({})
        buttonBlock.flowDirection = "left_to_right"
        buttonBlock.widthProportional = 1.0
        buttonBlock.autoHeight = true

        local button = buttonBlock:createButton({ text = "---"})
        
        local label = buttonBlock:createLabel({ text = setting.label })
        label.borderAllSides = 4
        label.wrapText = true
        label.widthProportional = 1.0

        if setting.description then
            registerMouseOvers({block = buttonBlock,  label = setting.label, description = setting.description})
            registerMouseOvers({block = label,  label = setting.label, description = setting.description})
        end
        
        if checkDoDisable() then
            button.widget.state = 2
            label.color = tes3ui.getPalette("disabled_color")
        else
            
            local startingValue = initaliseSettingData(setting)
            local bool = startingValue

            local buttonText = getTextFromBool (bool, setting.type)
            button.text = buttonText
            button:register(
                "mouseClick", 
                function(e)
                    toggleButton(e, setting )
                end
            )		
        end

        return { buttonBlock = buttonBlock, label = label, button = button }
    end

    local function updateSliderSetting(params)
        assert(params)
        assert(params.newValue)
        assert(params.setting)
        assert(params.sliderValueId)
        newValue = params.newValue
        setting = params.setting
        sliderValueId = params.sliderValueId

        local sliderValueLabel = mcmContainer:findChild(sliderValueId)
        sliderValueLabel.text = newValue

        updateSettingData(setting, newValue)
    end

    local function makeSlider(params) -- { params: parent, setting }
        assert(params)
        assert(params.parent)
        assert(params.setting)
        local parent = params.parent
        local setting = params.setting

    
        local outerSliderBlock
        outerSliderBlock = parent:createBlock({})
        outerSliderBlock.flowDirection = "top_to_bottom"
        outerSliderBlock.widthProportional = 1.0
        outerSliderBlock.autoHeight = true


        
        local labelBlock
        labelBlock = outerSliderBlock:createBlock({})
        labelBlock.flowDirection = "left_to_right"
        labelBlock.widthProportional = 1.0
        labelBlock.autoHeight = true
        labelBlock.borderLeft = 10
        labelBlock.borderBottom = 2

        local label = labelBlock:createLabel({ text = setting.label })
        label.wrapText = true
        label.widthProportional = 1.0



        local sliderBlock 
        sliderBlock = outerSliderBlock:createBlock()
        sliderBlock.flowDirection = "left_to_right"
        sliderBlock.autoHeight = true
        sliderBlock.widthProportional = 1.0
        sliderBlock.borderLeft = 12
        sliderBlock.borderBottom = 4


        
        
        local slider 
        slider = sliderBlock:createSlider({
            current = 0,
            max = setting.sliderMax
        })
        slider.widthProportional = 1.0
        slider.borderAllSides = 4
        
        local sliderValueIdText = ( modData.name .. "_" .. setting.id .. "_sliderValue" )
        local sliderValueId = tes3ui.registerID( sliderValueIdText )
        local sliderValueLabel = sliderBlock:createLabel({id = sliderValueId, text = "--" })
        sliderValueLabel.minWidth = 40

        
        if setting.sliderStep then
            slider.widget.step = setting.sliderStep 
        end
        if setting.sliderJump then
            slider.widget.jump = setting.sliderJump
        end


        if checkDoDisable() then
            slider.children[2].children[1].visible = false
            label.color = tes3ui.getPalette("disabled_color")
        else
            --If no data yet, get from default and update config
            local startingValue = initaliseSettingData(setting)
            slider.widget.current = startingValue
            sliderValueLabel.text = startingValue



            slider:register(
                "PartScrollBar_changed", 
                function(e) 
                    updateSliderSetting({
                        newValue = slider:getPropertyInt("PartScrollBar_current"),
                        setting = setting,
                        sliderValueId = sliderValueId
                    }) 
                end 
            )
        end

        if setting.description then
            registerMouseOvers({block = outerSliderBlock, label = setting.label, description = setting.description})
            registerMouseOvers({block = sliderBlock, label = setting.label, description = setting.description})
            registerMouseOvers({block = sliderValueLabel, label = setting.label, description = setting.description})
            registerMouseOvers({block = label, label = setting.label, description = setting.description})
            for _, sliderElement in ipairs(slider.children) do
                registerMouseOvers({block = sliderElement, label = setting.label, description = setting.description})
                for _, innerElement in ipairs(sliderElement.children) do
                    registerMouseOvers({block = innerElement, label = setting.label, description = setting.description})
                end
            end
        end
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
            if setting.type == "OnOff" or setting.type == "YesNo" or setting.type == "button" then
                makeOnOffButton({ parent = params.parentBlock, setting = setting })
            elseif setting.type == "slider" then
                makeSlider({ parent = params.parentBlock, setting = setting })
            end
        end
    end

    local function createCategoryBlock (category)
        local parentBlock = mcmContainer:findChild(uids.leftColumn)
        currentCategory = category
        local categoryBlock = parentBlock:createBlock()
        categoryBlock.flowDirection = "top_to_bottom"
        categoryBlock.widthProportional = 1.0
        categoryBlock.autoHeight = true
        categoryBlock.borderAllSides = 10
        
        local categoryHeading = category.label
        if checkDoDisable() then
            categoryHeading = categoryHeading .. " (In-Game Only)"
        end

        local mainIntro = createBlockIntro{
            parentBlock = categoryBlock,
            label = categoryHeading,
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
        for id, category in pairs(modData.categories) do
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
        mcmContainer = e
        local outerBlock = mcmContainer:createThinBorder()
        outerBlock.flowDirection = "top_to_bottom"
        outerBlock.paddingAllSides = 4
        outerBlock.widthProportional = 1.0
        outerBlock.heightProportional = 1.0
        
        --header image
        local imagePath = modData.headerImagePath
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


        if table.getn(modData.categories) > 1 then
            for _, category in ipairs(modData.categories) do
                createTabButton(category)
            end
            --highlight first button
            mcmContainer:findChild(modData.categories[1].buttonUID).widget.state = 4
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

        createCategoryBlock(modData.categories[1])

        --Righthand window containing mouse-hover info
        local rightColumn = sideBySideBlock:createThinBorder()
        rightColumn.heightProportional = 1.0
        rightColumn.widthProportional = 1.0
        rightColumn.borderAllSides = 2
        createSideBar(rightColumn)

        mcmContainer:updateLayout()
    end

    --Save config when closing MCM--
    function modConfig.onClose(mcmContainer)
        if modData.configPath then
            mwse.log( getLogMessage("Saving mod configuration:") )
            mwse.log(json.encode(modData.config, { indent = true }))
            json.savefile(modData.configPath, modData.config, { indent = true })
        end
    end
    --mwse.log( getLogMessage("returning modConfig: %s"))
    return modConfig
end



return this