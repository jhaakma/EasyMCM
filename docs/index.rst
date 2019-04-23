.. EasyMCM documentation master file, created by
   sphinx-quickstart on Sat Apr  6 20:43:42 2019.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

===================================
EasyMCM
===================================

.. toctree::
   :maxdepth: 1
   :glob:

   components/*
   variables/*

EasyMCM is a UI Library for Morrowind, 
allowing modders to quickly generate Mod Config 
Menus and preconfigured UI elements without touching UI code.


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
        local template = EasyMCM.createTemplate{ name = "Basic MCM" }
        local page = template:createPage()
        local category = page:createCategory{ label = "Settings" }
        category:createButton{ buttonText = "Press" }
        EasyMCM.register(template)
    end
    event.register("modConfigReady", registerModConfig)

An MCM needs, at minimum, a template, at least one page, and 
probably a setting or two. 

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
            description = "This text is shown on the sidebar"
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


Adding EasyMCM Components to non-MCM Menus
==============================================

EasyMCM components can also be added to non-easyMCM elements,
using the following format::

    local block = element:createBlock()

    EasyMCM.createSlider{
        block, 
        {
            label = "Time Scale",
            description = "Changes the speed of the day/night cycle.",
            variable = EasyMCM:createGlobal{ id = "timeScale" }
        }
    }

Be warned, however, that easyMCM components require the parent 
element to have the correct formatting to appear. They tend to 
work best with menus that utilise widthProportional and autoHeight. 