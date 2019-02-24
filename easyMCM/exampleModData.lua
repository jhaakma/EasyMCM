
--[[
    Using EasyMCM
]]-- 
    --in your main.lua:
    local function registerModConfig()
        --get easyMCM
        local easyMCM = require("easyMCM.modConfig")
        --get your MCM data file (put it somewhere in your own mod folder)
        local mcmData = require ("easyMCM.exampleModData")
        --Create your MCM
        local mcm = easyMCM.registerModData( mcmData ) 
        --And register the config
        mwse.registerModConfig("ExampleMod", mcm)
    end
    event.register("modConfigReady", registerModConfig)

--[[

    Here we define the actual modData file. The basic structure of this is:
    {
        template =  {
            pages = {
                components = {
                    setting = {
                        variable
                    }
                    category = {
                        components = {...}
                    }
                }
            }
        }
    }

    Components:

    EasyMCM menus are made of "components". Components come in 3 types:
        -Category: an indented list of other components
        -Setting: something the player interacts with, such as a button or slide
        -Info: A non-interactive component such as a text box or image


    Variables:

    Most Settings have Variables, which define how the data is stored and retrieved.
        Settings come in the following types:
            -Global: refers to vanilla or custom global variables must be defined in the CS)
            -GlobalBoolean: Global but with special logic for treating the global as a boolean (>0 == true)
            -ConfigVariable: A variable inside a config file, located in mwse/config.
            -PlayerData: Stores the variable on the player referencs. Save-file specific, like globals.
            -Custom: define your own getters and setters in the mcmData file


    The following is a working example of a modData file. Feel free to make an MCM with it
    and experiment with it.
]]--


--Define config path
local configPath = "name_of_config file" 
--Define path to player data variables, relative to tes3.player.data
local playerDataPath = "modName.mcmSettings"
local this = {
    --Name of your mod
    name = "My Mod Name",

    --[[
        The template is the outer structure of your MCM. 
        This field is optional, and if unset will default to the default Template class
        The default Template will display the name of your mod followed by buttons for each page.
        
    ]]--
    template = "Template",

    --For Template class, defining headerImagePath will show this image at the top instead of the title.
    --headerImagePath = "textures.modName.header.tga",

    --[[
        Settings are divided up into pages, which can be selected by pressing tabs at the top of the template.
        A template requires at least one page.
    ]]--
    pages = {
        --[[
            The default class is Page, which is a simple thinBorder container.
        ]]--
        {
            --Each page in your template must have a unique ID
            id = "page1",
            class = "Page",
            description = "This is a Sidebar page. This text will be displayed on the sidebar until a component with its own description is moused over.",
            --The name of this page, displayed in the page tab.
            label = "Settings Page",
            --Page is a special type of category. Categories and pages can have lists
            --of child components, which can themselves be categories, settings or infos. 
            --Pages themselves should only be children of templates, however. 
            components = {
                {   
                    --[[
                        Group similar settings into categories. They will be put under a 
                        header and indented.
                    ]]-- 
                    class = "Category",
                    label = "Category Label",
                    --[[
                        formatElements() function (OPTIONAL)
                        If defined, the formatElements function is run after a component has been created. 
                        This is useful if you want to make small changes to the formatting of any element
                        stored in the self.elements table. In this simple example, we want to change the color of 
                        the category label to that of a hyporlink.
                    ]]--
                    formatElements = (
                        function(self)
                            self.elements.label.color = tes3ui.getPalette("link_color")
                        end
                    ),
                    --[[
                        Method overrides (OPTIONAL)
                        Another way we can customise classes is to override a function. 
                        This is very easy to do; simply define the override function, making
                        sure to pass self as a parameter. You can override any function belonging
                        to the class, including any functions inherited from parent classe. 
                        In this example, we are adding a log message whenever this category is
                        enabled by overriding the enable() function. 
                    ]]--
                    enable = (
                        function(self)
                            mwse.log("Enabling category")
                            self.elements.label.color = tes3ui.getPalette("header_color")
                        end
                    ),

                    --[[
                        Categories contain lists of components, which themselves can be categories, 
                        allowing infinite nesting of components. 
                    ]]--
                    components = {      

                       --[[
                            Settings
                            This is the meat and bones of your MCM menu: the settings!
                        ]]--
                        {

                            --[[
                                This setting is an OnOffButton, which is a subclass of Button that
                                automatically set the button text to "On" when the variable is true, 
                                or "Off" when false. A similar class is YesNoButton. 
                            ]]--
                            label = "Button Setting",
                            class = "OnOffButton",

                            --[[
                                Defining the correct variable is very important. Some variables
                                are only available in-game, so selecting them will grey out the
                                setting when accessing MCM from the main menu.
                                It is also important to make sure all variables used in MCM have been
                                initialised elsewhere. Some variable types will create them if they don't
                                exist, but this is not reliable as the easyMCM code only runs when
                                you open the MCM menu.
                            ]]--
                            variable = {
                                --[[
                                    This is a ConfigVariable, which stores the variable in a json
                                    file defined in 'path'. Here we defined path at the top of the 
                                    data file so it can be reused throughout. 
                                ]]--
                                id = "enabled",
                                class = "ConfigVariable",
                                --[[
                                    defaultSetting (OPTIONAL)
                                    If no config is found, it will initialise to this value. 
                                    If you want to make sure your variables are properly initialised, 
                                    do not include this setting. It is handy for generating your default
                                    config file though.
                                ]]--
                                defaultSetting = true,
                                --path of config file, relative to /mwse/config/
                                path = configPath,
                                --[[
                                    Even though the variable we are using is not
                                    in-game only, we can override it easily enough.
                                    Notice how when all settings under a category are
                                    in-game only, the category will grey itself out. 
                                    If all settings in a page are in-game only, the page
                                    title will have the string (In-Game Only) attached.
                                ]]--
                                inGameOnly = true,
                            },
                        },
                        
                        --[[
                            Another useful setting is the slider. Here we are using it to set the timeScale global. 
                        ]]--
                        {   
                            label = "Time Scale",
                            class = "Slider",
                            description = "Changes the speed of the day/night cycle. A value of 1 makes the day go at real-time speed; an in-game day would last 24 hours in real life. A value of 10 will make it ten times as fast as real-time (i.e., one in-game day lasts 2.4 hours), etc. The default timescale is 30 (1 in-game day = 48 real minutes).",
                            
                            min = 5, --default 0
                            max = 50, --default 100
                            step = 1, --default 1
                            --jump = 5, --default 5
                            --[[
                                TimeScale is a global. If it were a global that is treated like a boolean, 
                                where 0 is false and >= 1 is true, we would set the class to GlobalBoolean.
                            ]]--
                            variable = {
                                restartRequired = true,
                                id = "timeScale",
                                class = "Global",
                            },
                        },

                        --[[
                            This is an example of a TextField Setting, using a variable
                            on the player reference. 
                        ]]--
                        {
                            label = "Your pet's name",
                            class = "TextField",
                            description = "Enter the name of your beloved pet!",
                            variable = {
                                id = "petName",                                
                                path = playerDataPath,
                                class = "PlayerData",
                                defaultSetting = "Scruffy",
                            },
                            --[[
                                By default, updating the textfield will result in a messageBox
                                saying "New Value: '{new text}'". You can override this message
                                in the callback
                            ]]--
                            callback = (
                                function(self)
                                    tes3.messageBox("Your pet's new name is %s", self.variable.value)
                                end
                            ),
                        },

                        {
                            label = "Story Time",
                            class = "ParagraphField",
                            description = "Write us a story.",
                            variable = {
                                id = "story",                                
                                path = playerDataPath,
                                class = "PlayerData",
                                defaultSetting = "",
                            },
                            --[[
                                By default, updating the textfield will result in a messageBox
                                saying "New Value: '{new text}'". You can override this message
                                in the callback
                            ]]--
                            callback = (
                                function(self)
                                    tes3.messageBox("Your story has been saved.")
                                end
                            ),
                        },
                    },
                },
            },
        },--/page1
        --[[
            This is another kind of Page. Instead of a simple thinBorder, this page displays components on the left-handside, 
            with a sidebar on the right hand side. The sidebar displays descriptions of any component that you mouse over. 
        ]]--
        {

            id = "page2",
            class = "SideBarPage",
            label = "Settings",
            --[[
                The description of the page will show in the sidebar by default, replaced by the description of any component that
                is moused over.
            ]]--
            description = "Welcome to the example mod! Mouse over other settings to see more information :)",
            components = {
                --[[
                    SideBySideBlock is useful for multiple buttons with no labels. 
                ]]--
                {
                    class = "SideBySideBlock",
                    label = "Buttons",
                    components = {
                        {
                            --[[
                                Not all settings require Variables. In this example, we use a Button
                                to simply call the reset actors function. 
                            ]]--
                            buttonText = "Reset Actors",
                            description = "Call the ResetActors command to set NPCs back to their original positions.",
                            class = "Button",
                            --[[
                                Usually inGameOnly is defined at the variable level, but as this button has
                                no variable, we set it directly here. As reseting actors is only useful in-game, 
                                we will set it to true
                            ]]--
                            inGameOnly = true,
                            --Callback is run whever the button is pressed. 
                            callback = (
                                function(self)
                                    tes3.messageBox("Reseting Actors")
                                    tes3.runLegacyScript({command = "ResetActors"})
                                end
                            ),
                            formatElements = (
                                function(self)
                                    self.elements.outerContainer.alignX = 0.5
                                end
                            ),
                        },--/Reset Actors Button
                        {
                            --[[
                                Not all settings require Variables. In this example, we use a Button
                                to simply call the reset actors function. 
                            ]]--
                            buttonText = "Fix Me",
                            description = "Call the ResetActors command to set NPCs back to their original positions.",
                            class = "Button",
                            --[[
                                Usually inGameOnly is defined at the variable level, but as this button has
                                no variable, we set it directly here. As reseting actors is only useful in-game, 
                                we will set it to true
                            ]]--
                            inGameOnly = true,
                            --Callback is run whever the button is pressed. 
                            callback = (
                                function(self)
                                    tes3.messageBox("Calling Fix me")
                                    tes3.runLegacyScript({command = "fixme"})
                                end
                            ),
                            formatElements = (
                                function(self)
                                    self.elements.outerContainer.alignX = 0.5
                                end
                            ),
                        },--/Fix Me Button

                    }--/Buttons components
                },--/Buttons block


                {
                    label = "Other Settings",
                    class = "Category",
                    components = {
                        --[[{
                            label = "Story Time",
                            class = "ParagraphField",
                            description = "Write us a story.",
                            variable = {
                                id = "story",                                
                                path = playerDataPath,
                                class = "PlayerData",
                                defaultSetting = "",
                            },
                            --[[
                                By default, updating the textfield will result in a messageBox
                                saying "New Value: '{new text}'". You can override this message
                                in the callback
                            
                            callback = (
                                function(self)
                                    tes3.messageBox("Your story has been saved.")
                                end
                            ),
                        },]]----/ParagraphField

                        --[[
                            This is an info, which does nothing except display information.
                        ]]--
                        {
                            label = "Info",
                            class = "Info",
                            inGameOnly = true,
                            text = "This is an info box. It should wrap text if the window is too small"
                        },--/Info
                    },
                },--/Other Settings

                        


                {
                    label = "Info",
                    class = "Info",
                    --inGameOnly = true,
                    text = "You can mix settings and categories in your components list.",
                    formatElements = function(self)
                        self.elements.label.color = tes3ui.getPalette("link_color")

                    end
                },--/Info
                {
                    label = "List of Fruit",
                    class = "Dropdown",

                    options = {
                        { label = "Apple", value = "apple" },
                        { label = "Banana", value = "banana" },
                        { label = "Orange", value = "orange" },
                    },
                    variable = {
                        id = "fruitList",
                        path = playerDataPath,
                        class = "PlayerData",
                        defaultSetting = "banana",
                        restartRequired = true,
                    }
                },
                
            },--/page2 components
        },--/page2
        --[[
            The ExclusionsPage is a special page that does away with categories/settings. 
            Instead it has it's own entire interface for moving items into a blacklist. 

            You can search through objects in either list with the searchbox, then
            press the "Apply Filtered" button or press enter to transfer all currently
            filters objects to the opposite list. 

            Items moved into the left list are added to the exclusions config file.
        ]]--
        {
            id = "page3",
            class = "ExclusionsPage",         
            description = (
                "Mod Exclusions Page\n" ..
                "This text will be displayed at the top of the page. " ..
                "Give a nice description of what your exclusions list does."
            ),
            label = "Exclusions",

            --[[
                toggleText/leftListLabel/rightListLabel (OPTIONAL)
                You can set the labels for each list, as well as the 
                label for the button that toggles all currently filtered items
            ]]--
            toggleText = "Apply", --default "Toggle Filtered"
            leftListLabel = "Blacklist", --default "Blocked"
            rightListLabel = "Whitelist", --default = "Allowed"

            --location of exclusions config file
            configPath = exclusionsConfigPath,

            --[[
                The right list is populated with objects according to the filter. 
            ]]--
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
            }--/filters
        }--/page3
    },--/pages
}

--Make sure to return the mcmData object!
return this