
--[[
    Using EasyMCM
]]-- 
    local mcmDataPath = "easyMCM.exampleModData"
    --Change the mcmDataPath to point to your own mcmData file. 
    --The rest you can leave exactly as it is

    local function registerModConfig()
        --get easyMCM
        local easyMCM = require("easyMCM.modConfig")
        --get your MCM data file (put it somewhere in your own mod folder)
        local mcmData = require (mcmDataPath)
        --Create your MCM
        local mcm = easyMCM.registerModData( mcmData ) 
        --And register the config
        mwse.registerModConfig(mcmData.name, mcm)
    end
    --register mcm event
    event.register("modConfigReady", registerModConfig)

--[[
    Components:

    EasyMCM menus are made of "components". Components come in 3 types:
        -Category: an indented list of other components
        -Setting: something the player interacts with, such as a button or slide
        -Info: A non-interactive component such as a text box or image


    Variables:

    Most Settings have Variables, which define how the data is stored and retrieved.
        Settings come in the following types:
            -Variable: Does nothing on its own but you can override the get() and set() functions to implement your own variable type
            -Global: refers to vanilla or custom global variables must be defined in the CS)
            -GlobalBoolean: Global but with special logic for treating the global as a boolean (>0 == true)
            -ConfigVariable: A variable inside a config file, located in mwse/config.
            -PlayerData: Stores the variable on the player referencs. Save-file specific, like globals.


    The following is a working example of a modData file. Feel free to make an MCM with it
    and experiment with it.
]]--

local simpleExample = {
    name = "Simple MCM",
    template = "Template", --Optional: defaults to "Template"
    pages = {
        {
            label = "SideBar Page",
            class = "SideBarPage",
            components = {
                {
                    label = "Category",
                    class = "Category",
                    components = {
                        {
                            label = "An On Off Button",
                            class = "OnOffButton",
                            variable = {
                                id = "variableID",
                                class = "ConfigVariable",
                                path = "path_to_config_file",
                            },
                        }
                    }
                },

                {
                    label = "Second Category",
                    class = "Category",
                    components = {
                        {
                            label = "A Yes No Button using PlayerData",
                            class = "YesNoButton",
                            variable = {
                                id = "variableID2",
                                class = "PlayerData",
                                path = "path_to_player_data",
                            },
                        },
                    }
                }
                
            },
            sidebarComponents = {
                {
                    label = "Info Label",
                    class = "Info",
                    text = "The sidebar will default to a MouseOverInfo, which displays the page's description until a component is moused over, at which point it will show the description for that component. But if we define a sidebarComponents table, it will display them in the same way the lefthand column displays the components table.",
                }
            }
        }
    }
}

--[[
    The following is a comprehensive data table demonstrating many of the features of EasyMCM
]]--

--Define config path
local configPath = "name_of_config file" 
--Define path to player data variables, relative to tes3.player.data
local playerDataPath = "modName.mcmSettings"


--Function to generate buttons for every effect in tes3.effect for our Filter list
local function createFilterSettings()
    local settings = {
    }
    for effect, id in pairs(tes3.effect) do
        table.insert(
            settings,
            {   
                label = effect,
                class = "OnOffButton",
                postCreate = (
                    function(self)
                        event.register(
                            "resetFilterSettings", 
                            function()
                                self.variable.value = self.variable.defaultSetting
                                self:update()
                            end
                        )
                    end
                ),
                variable = {
                    id = effect,
                    class = "ConfigVariable",
                    path = configPath,
                    defaultSetting = true,
                },

            }
        )
    end
    return settings
end

local function getWeatherList()
    local list = {}
    for weather, val in pairs(tes3.weather) do
        table.insert(list, { label = weather, value = val } )
    end
    return list
end
local weatherList = getWeatherList()

local exampleTemplate = {
    name = "My Mod Name",
    pages = {

        --Page
        {
            label = "Normal Page",
            class = "Page",--defaults to "Page"
            components = {--Children of this component go in the components table. Categories can be nested infinitely.
                {  
                    label = "Category Label",
                    class = "Category",--Categories break components into organised groups with labels and indentation.
                    postCreate = (
                        --Optional: override this function for any small formatting changes you want to do
                        --Gets called after the component has been built
                        function(self)
                            self.elements.label.color = tes3ui.getPalette("link_color")
                        end
                    ),
                    enable = (
                        --Optional: You can also override any other field or function belonging to the component
                        function(self)
                            --mwse.log("Enabling category")
                            self.elements.label.color = tes3ui.getPalette("header_color")
                        end
                    ),
                    components = {      
                        {--OnOffButton and YesNoButton are the best way to handle boolean settings
                            label = "Button Setting",
                            class = "OnOffButton",
                            restartRequired = true, --Can be on the setting or variable, when active will prompt the user to restart when the setting changes.
                            variable = {
                                id = "enabled",
                                class = "ConfigVariable",--Saves to a json file
                                defaultSetting = true,--Optional: for OnOffButton defaults to false
                                path = configPath,--Path to config file
                            },
                        },
                        {--Sliders work best for Integer settings
                            label = "Time Scale",
                            class = "Slider",
                            description = "Changes the speed of the day/night cycle. A value of 1 makes the day go at real-time speed; an in-game day would last 24 hours in real life. A value of 10 will make it ten times as fast as real-time (i.e., one in-game day lasts 2.4 hours), etc. The default timescale is 30 (1 in-game day = 48 real minutes).",
                            --slider settings optional, will default to the following
                            min = 5, --default 0
                            max = 50, --default 100
                            step = 1, --default 1
                            jump = 5, --default 5

                            variable = {
                                id = "timeScale",
                                class = "Global",
                            },
                        },
                        {--Text fields are used for changing settings with string variables. 
                            label = "Your pet's name",
                            class = "TextField",
                            description = "Enter the name of your beloved pet!",
                            sNewValue = "Your pet's new name is %s",
                            variable = {
                                class = "PlayerData",--PlayerData is stored on tes3.player.data so the setting value is local to the game save.
                                id = "petName",                                
                                path = playerDataPath,
                                defaultSetting = "Scruffy",--Optional, for TextField defaults to ""
                            },

                        },

                        {
                            label = "A Hyperlink",
                            class = "Hyperlink",
                            text = "A Hyperlink that goes to Google",
                            exec = "start http://google.com"
                        },--/Info
                        
                        {
                            class = "Hyperlink",
                            text = "A no label Hyperlink",
                            exec = "start http://google.com"
                        },--/Info

                    },
                },
            },--/page components
        },--/page1

        --SideBarPage
        {--A Sidebar page displays components on the left column, and a second set of components on the sidebar.
         --If no 'sidebarComponents' table is defined, the sidebar instead displays the description of the page,
         --and the description of any component when moused over. 
            label = "Sidebar Page",
            class = "SideBarPage",
            description = "Here is the sidebar description for our example mod! You can mouse over settings to see more information on each one.",
            components = {

                {--SideBySide block is useful for displaying multiple simple buttons with no labels
                    class = "SideBySideBlock",
                    label = "Console Commands",
                    components = {
                        {
                            buttonText = "Reset Actors",
                            class = "Button",
                            inGameOnly = true,
                            callback = (
                                function(self)
                                    tes3.messageBox("Resetting Actors")
                                    tes3.runLegacyScript({command = "ResetActors"})
                                end
                            ),

                        },--/Reset Actors Button
                        {
                            buttonText = "Fix Me",
                            class = "Button",
                            inGameOnly = true,
                            callback = (
                                function(self)
                                    tes3.messageBox("Calling Fix me")
                                    tes3.runLegacyScript({command = "fixme"})
                                end
                            ),

                        },--/Fix Me Button
                    }--/Buttons components
                },--/SideBySide Buttons block

                {--Keybindings is a special button that lets you set a keybind
                    class = "Category",
                    label = "Bindings",
                    components = {

                        {
                            class = "KeyBinder", 
                            label = "Single Key Binding",
                            allowCombinations = false,--This one only allows single key bindings
                            variable = {
                                id = "keybind2", 
                                class = "ConfigVariable", 
                                path = configPath,
                                defaultSetting = {
                                    keyCode = tes3.scanCode.l,
                                },
                            },--/rebind
                        },

                        {
                            class = "KeyBinder", 
                            label = "Key Combo Binding",
                            allowCombinations = true,--Optional: defaults to true. Allows for Shift, Alt or Ctrl + Key
                            variable = {
                                id = "keybind1", 
                                class = "ConfigVariable", 
                                path = configPath,
                                defaultSetting = {
                                    keyCode = tes3.scanCode.k,
                                    --These default to false
                                    isShiftDown = true,
                                    isAltDown = false,
                                    isControlDown = false,
                                },
                            },--/rebind
                        },
                    }
                },

                { 
                    label = "Other Settings",
                    class = "Category",
                    components = {
                        {
                            label = "An Info Field",
                            class = "Info",
                            inGameOnly = true,
                            text = "This is an info box. It should wrap text if the window is too small"
                        },--/Info

                        {
                            class = "Info",
                            inGameOnly = true,
                            text = "An info box with no label won't indent"
                        },--/Info

                    },
                },--/Other Settings

                --Dropdown using a custom variable. Override get and set functions to get and change the weather
                {
                    label = "Change the Weather",
                    class = "Dropdown", 
                    options = weatherList,
                    inGameOnly = true,
                    variable = {
                        class = "Variable",
                        get = (
                                function(self)
                                
                                return tes3.getCurrentWeather().index or 0
                            end
                        ),
                        set = (
                            function(self, newVal)
                                if tes3.player then
                                    tes3.getWorldController().weatherController:switchImmediate(newVal)
                                end
                            end
                        ),
                    },
                },

                {--Dropdowns allow you to select an option from a list. Good for settings with a small number of predefined possible values.
                    label = "Pick a Fruit",
                    class = "Dropdown",

                    options = {
                        { label = "Apple", value = "apple" },
                        { label = "Banana", value = "banana" },
                        { label = "Orange", value = "orange" },
                    },
                    variable = {
                        id = "fruitList",
                        path = configPath,
                        class = "ConfigVariable",
                        defaultSetting = "banana",
                    },
                },
                
                {
                    label = "Another Info Field",
                    class = "Info",
                    --inGameOnly = true,
                    text = "You can mix settings and categories in your components list.",
                    description = "Mouse over text for Info field"
                },--/Info


            },--/page2 components
        },--/page2

        --Exclusions Page
        {--Exclusions page is a special page type that lets you move plugins or game objects into a blacklist.
            label = "Exclusions Page",
            class = "ExclusionsPage",         
            description = (
                "Mod Exclusions Page\n" ..
                "This text will be displayed at the top of the page. " ..
                "Give a nice description of what your exclusions list does."
            ),
            --You can customise all the text and buttons
            toggleText = "Apply", --Optional: default "Toggle Filtered"
            leftListLabel = "Blacklist", --Optional: default "Blocked"
            rightListLabel = "Whitelist", --Optional: default = "Allowed"

            configPath = configPath,

            --You can have multiple filters to customise what kind of objects can be excluded
            filters = {

                --Filter by plugins to exclude entire mods
                {
                    label = "Plugins",
                    type = "Plugin",
                },

                --Filter by object type
                {
                    label = "Ingredients",
                    type = "Object",
                    objectType = tes3.objectType.ingredient,
                },

                --Define object filters for more specific filters
                {
                    label = "Helmets",
                    type = "Object",
                    objectType = tes3.objectType.armor,
                    objectFilters = {
                        slot = tes3.armorSlot.helmet
                    }
                },
                {
                    label = "Blunt Weapons",
                    type = "Object",
                    objectType = tes3.objectType.weapon,
                    objectFilters = {
                        type = tes3.weaponType.bluntOneHand
                    }
                },
                {
                    label = "Essential NPCs",
                    type = "Object",
                    objectType = tes3.objectType.npc,
                    objectFilters = {
                        isEssential = true
                    }
                },
                {
                    label = "Statics",
                    type = "Object",
                    objectType = tes3.objectType.static,
                },
                --Finally, define your own callback for a purely custom filter
                {
                    label = "GMSTs",
                    callback = (
                        function(self)
                            local gmstNames = {}
                            for gmst, _ in pairs(tes3.gmst) do
                                table.insert(gmstNames, gmst)
                            end
                            return gmstNames
                        end
                    )
                }
            }--/filters
        },--/page3

        --Filter Page
        {
            label = "Filter Page",
            class = "FilterPage",
            components = createFilterSettings(),
            --Rather than use the default mouseOverInfo, we define a sidebarComponents table so we can add a "restore defaults" button
            sidebarComponents = {
                {
                    class = "Info",
                    text = (
                        "This is a Filter Page. You can filter settings by typing in the search bar. " ..
                        "Here we have made list of buttons for each effect in tes3.effect, " ..
                        "and a button that will reset them to their default values. "
                    )
                },
                {
                    class = "Button",
                    buttonText = "Restore default values",
                    callback = (
                        function(self)
                            local function reset(e)
                                if e.button == 0 then
                                    tes3.messageBox{
                                        message = "Default values have been restored.",
                                        buttons = { self.sOK }
                                    }
                                    mwse.saveConfig(path, {})
                                    event.trigger("resetFilterSettings")
                                end
                            end
            
                            tes3.messageBox{
                                message = "Reset all settings to their default values?",
                                buttons = { self.sYes, self.sCancel },
                                callback = reset
                            }
                        end
                    ),
                    postCreate = (
                        function(self)
                            self.elements.innerContainer.alignX = 0.5
                        end
                    ),
                },--//button
            }
        },
    },--/pages
}

--Make sure to return the mcmData object!
--return simpleExample
return exampleTemplate