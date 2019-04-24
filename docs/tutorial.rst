######################
Tutorial
######################

Prerequisites
==============

MWSE
-----

MWSE dev version >2.1 is required for EasyMCM. 
You can find documentation on MWSE 
`here <https://mwse.readthedocs.io/en/latest/installation.html>`_.

An MWSE Mod
-------------

If you have an MWSE mod you want to add a menu to, then great! 
If not, create a new folder in ``Data Files/MWSE/mods``, and 
call it the name of your mod. Then in your new folder, 
create a file called ``main.lua``. This is where we will 
create our new MCM. 


Creating an MCM
================

Add the following to your `main.lua`::

    local function registerModConfig()
        EasyMCM = require("easyMCM.EasyMCM")
        local template = EasyMCM.createTemplate("Basic MCM")
        local page = template:createPage()
        local category = page:createCategory("Settings")
        category:createButton{ buttonText = "Press" }
        EasyMCM.register(template)
    end
    event.register("modConfigReady", registerModConfig)

An MCM needs, at minimum, a template, at least one page, and 
probably a setting or two. 

Check out the list of `Components`_ that you can build your MCM 
out of, and the types of `Variables`_ that can be attached to settings. 


Advanced Example::

    --fetch config file
    local confPath = "config_test"
    local config = mwse.loadConfig(confPath)
    if not config then 
        config = { blocked = {} }
    end

    local function registerModConfig()
        --get EasyMCM
        local EasyMCM = require("easyMCM.EasyMCM")
        --create template
        local template = EasyMCM.createTemplate("Advanced MCM")
        --Have our config file save when MCM is closed
        template:saveOnClose(confPath, config)
        --Make a page
        local page = template:createSideBarPage{
            sidebarComponents = {
                EasyMCM.createInfo{ text = "An info field in the sidebar" },
                EasyMCM.createButton{ buttonText = "Press this button" }
            }
        }
        --Make a category inside our page
        local category = page:createCategory("Settings")

        --Make some settings
        category:createButton({ 
            buttonText = "Hello", 
            description = "A useless button",
            callback = function(self)
                tes3.messageBox("Button pressed!")
            end
        })

        category:createSlider{
            label = "Time Scale",
            description = "Changes the speed of the day/night cycle.",
            variable = EasyMCM:createGlobal{ id = "timeScale" }
        }

        --Make an exclusions page
        local exclusionsPage = template:createExclusionsPage{
            label = "Exclusions",
            description = (
                "Use an exclusions page to add items to a blacklist"
            ),
            variable = EasyMCM:createTableVariable{
                id = "blocked",
                table = config,
            },
            filters = {
                {
                    label = "Plugins",
                    type = "Plugin",
                },
                {
                    label = "Food",
                    type = "Object",
                    objectType = tes3.objectType.ingredient,
                }
            }
        }

        --Register our MCM
        EasyMCM.register(template)
    end

    --register our mod when mcm is ready for it
    event.register("modConfigReady", registerModConfig)


Creating Components
====================

There are three ways to create a component with EasyMCM.


You can add the component to another EasyMCM object::

    local page = template:createPage()
    page:createButton{ buttonText = "Hello" }

You can add the component to a vanilla element. Be warned 
that easyMCM components require the parent 
element to have the correct formatting to appear. They tend to 
work best with menus that utilise widthProportional and 
autoHeight::

    local block = e:createThinBorder()
    --note the `.` instead of `:`, very important:
    EasyMCM.createButton{ 
        block, 
        { buttonText = "Hello" }
    }

And you can construct the component object without creating the UI elements, 
then use the create() function later to create the element itself. 
You can see an example of this method in the advanced Example above, 
where we define a `sidebarComponents` table with an info and button, 
but we don't actually create those components yet::

    local button = EasyMCM.createButton{ buttonText = "Hello" }

    --Then create the component element as a child of some vanilla element:
    local block = e:createThinBorder()
    button:create( block )







.. _`Template`: components/templates/Template.html
.. _`Page`: components/classes/Page.html
.. _`Pages`: components/classes/Page.html
.. _`Setting`: components/settings/classes/Setting.html
.. _`Slider`: components/settings/classes/Slider.html
.. _`Category`: components/categories/Category.html
.. _`Categories`: components/categories/Category.html
.. _`Components`: components/components.html
.. _`Variables`: variables/variables.html


