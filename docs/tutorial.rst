######################
Tutorial
######################

This tutorial will demonstrate how to create a mod config menu 
using EasyMCM. First thing we'll do is get an MCM into your game 
so you can see what it looks like. Then we'll explain step by
step how it works. 

****************
Prerequisites
****************

MWSE
-----

MWSE dev version >2.1 is required for EasyMCM. 
You can find documentation on MWSE 
`here <https://mwse.readthedocs.io/en/latest/installation.html>`_.

A Mod folder
--------------

If you have an MWSE mod you want to add a menu to, then great! 
If not, create a new folder in ``Data Files/MWSE/mods``, and 
call it the name of your mod. Then in your new folder, 
create a file called ``main.lua``. Leave it empty for 
now, we'll add to it in the next section. 

****************
Getting Started
****************

Create an mcmData file
--------------------------

In EasyMCM, your menu is defined in an "mcmData" table. In your 
mod folder, create a new file called ``mcmData.lua`` and add the 
following::

    local mcmData = {
        name = "Simple MCM",
        class = "Template",
        pages = { }
    }
    return mcmData

Right now, our mcmData is simply a `Template`_. A template is the top-level 
component of an EasyMCM menu. The ``name`` field is the name of your mod. 
The ``class`` field is what we use to tell EasyMCM what kind of component 
we are using.
Go ahead and change the ``name`` field to 
the name of your mod.

Now we will add a `Page`_ to the ``pages`` table in our templates::

    local mcmData = {
        name = "Simple MCM",
        class = "Template",
        pages = { 
            label = "Page 1",
            class = "Page",
            components = {}
        }
    }
    return mcmData

A `Page`_ is a bit like a webpage in your browser. you can select pages 
by clicking on tabs at the top of your menu. The ``name`` field 
determines the text shown in the tab for this page. Rename it if you 
like. 

Now for the fun part! Let's add our first `Setting`_::

    local mcmData = {
        name = "Simple MCM",
        class = "Template",
        pages = { 
            label = "Page 1",
            class = "Page",
            components = {
                }
                    label = "An On Off Button",
                    class = "OnOffButton",
                    variable = {
                        id = "variableID",
                        class = "ConfigVariable",
                        path = "path_to_config_file",
                    },
                }
            }
        }
    }
    return mcmData    





.. _`Template`: components/templates/template.html
.. _`Page`: components/pages/Page.html
.. _`Pages`: components/pages/Page.html
.. _`Setting`: components/settings/Setting.html