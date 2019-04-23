######################
Tutorial
######################

This tutorial will demonstrate how to create a mod config menu 
using EasyMCM. 

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
create a file called ``main.lua``. Leave it empty for 
now, we'll add to it in the next section. 


Getting Started
================

Example::

    local function registerModConfig()
        EasyMCM = require("easyMCM.EasyMCM")
        local template = EasyMCM.createTemplate{ name = "My Mod" }
        local page = template:createPage()
        local category = page:createCategory{ label = "Settings" }
        local button = page:createButton{ buttonText = "Hello" }
        EasyMCM.register(template)
    end
    event.register("modConfigReady", registerModConfig)



.. _`Template`: components/templates/Template.html
.. _`Page`: components/classes/Page.html
.. _`Pages`: components/classes/Page.html
.. _`Setting`: components/settings/classes/Setting.html
.. _`Slider`: components/settings/classes/Slider.html
.. _`Category`: components/categories/Category.html
.. _`Categories`: components/categories/Category.html
