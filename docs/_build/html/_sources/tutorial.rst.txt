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


    pages = { 
        {
            label = "Page 1",
            class = "Page",
            components = {}
        },
    }

A `Page`_ is a bit like a webpage in your browser. you can select pages 
by clicking on tabs at the top of your menu. The ``name`` field 
determines the text shown in the tab for this page. Rename it if you 
like. 



We're now ready to add our first setting! Add the following to the 
components table in your page::


    components = {
        {
            buttonText = "Reset Actors",
            class = "Button",
            class = "Button",
            inGameOnly = true,
            callback = (
                function(self)
                    tes3.messageBox("Resetting Actors")
                    tes3.runLegacyScript({command = "ResetActors"})
                end
            ),
        }                
    }

Here we have added a component called "Reset Actors", defined 
with the "Button" class. We've set inGameOnly to true, so it 
can only be clicked while in the game. Finally, we've 
defined a ``callback`` which will run when the button is clicked. 
In this callback we are calling the ResetActors command in 
mwscript and showing a message box. 

We'll come back to mcmData for now. Here is what it should look like so far::

    local mcmData = {
        name = "Simple MCM",
        class = "Template",
        pages = { 
            {
                label = "Page 1",
                class = "Page",
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

                    }                
                }
            }
        }
    }
    return mcmData

Now let's get it showing up in-game!

Registering the MCM
====================

Go back to your ``main.lua`` file. First thing we need to do is 
set a local variable ``mcmDataPath`` to point to the mcmData file 
we just made. It should be "{Your mod name}.mcmData"::

    local mcmDataPath = "myModName.mcmData"

Now we want to register the MCM. Below where you've defined your 
mcmData path, type the following::

    local function registerModConfig()
        local easyMCM = require("easyMCM.modConfig")
        local mcmData = require(mcmDataPath)
        local modData = easyMCM.registerModData(mcmData)
        mwse.registerModConfig(mcmData.name, modData)
    end
    --register mcm event
    event.register("modConfigReady", registerModConfig)

This code will register the ``modConfigReady`` event, which 
calls ``registerModConfig()``. This function will get EasyMCM 
to create your MCM using mcmData. 

This is all very well and good, but let's face it. Players are stupid, 
and they can't follow instructions. This means they probably don't have 
EasyMCM installed. Let's change this a bit to send them a message telling 
them to install EasyMCM if they haven't already. Replace the code with 
the following::

    local function placeholderMCM(element)
        element:createLabel{text="This mod requires the EasyMCM library to be installed."}
        local link = element:createTextSelect{text="Go to EasyMCM Nexus Page"}
        link.color = tes3ui.getPalette("link_color")
        link.widget.idle = tes3ui.getPalette("link_color")
        link.widget.over = tes3ui.getPalette("link_over_color")
        link.widget.pressed = tes3ui.getPalette("link_pressed_color")
        link:register("mouseClick", function()
            os.execute("start https://www.nexusmods.com/morrowind/mods/46427?tab=files")
        end)
    end
    
    local function registerModConfig()
        local easyMCM = include("easyMCM.modConfig")
        local mcmData = require(mcmDataPath)
        local modData = easyMCM and easyMCM.registerModData(mcmData)
        mwse.registerModConfig(mcmData.name, modData or {onCreate=placeholderMCM})
    end
    --register mcm event
    event.register("modConfigReady", registerModConfig)

Here, instead of requiring EasyMCM, we simply include it, and if it doesn't 
exist, we instead create a very simple MCM that provides a link to the 
EasyMCM Nexus page.

Try out your MCM
=================

You have your mcmData, and it's been registered, so it should be ready to 
go! You can now boot up the game, open the Mod Config and click on your mod, 
and you should see a button that says "Reset Actors". It will be greyed out, 
but if you enter a game and then go back to the menu, you'll be able to 
click it and reset the actors in the cell. 

Congratulations! You now have a working MCM. Let's explore some more settings 
and features.

Categories
=============

Let's add another setting to our menu. Back in mcmData, in the ``components`` 
table, add the following, after the button::

    {
        label = "Time Scale",
        class = "Slider",
        min = 5,
        max = 50,
        variable = {
            id = "timeScale",
            class = "Global",
        },
    },   

This is a `Slider`_. Take note of the 
``variable`` field. Here we have defined our variable as a "Global" class, 
which means it will point to a global in the game. The global we are pointing 
to is the vanilla global, "timeScale", which determines how fast time passes
in the game. 

There are many types of variables. Have a look at the Variables page for more
information about what kind of variables you can use. 

We now have two settings, but they aren't very related to each other. 
We should separate them into their own `Categories`_. Change your mcmData 
table so it looks like this::

    local mcmData = {
        name = "Simple MCM",
        class = "Template",
        pages = { 
            {
                label = "Page 1",
                class = "Page",
                components = {
                    {
                        label = "Buttons",
                        class = "Category",
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
                            },
                        }
                    },

                    {
                        label = "Sliders",
                        class = "Category", 
                        components = {
                            {
                                label = "Time Scale",
                                class = "Slider",
                                min = 5,
                                max = 50,
                                variable = {
                                    id = "timeScale",
                                    class = "Global",
                                },
                            },   
                        }
                    }

                }
            }
        }
    }
    return mcmData

All we've done here is made two new categories, and placed our settings in 
each one. Now if you go back to your MCM, you will see your settings are 
indented, with labels above them. This is a good way to organise settings 
within a page. 

Conclusion
=============

That's pretty much the gist of EasyMCM! Have a look at the exampleModData.lua 
file for a comprehensive example of classes that you can use, and explore the 
documentation for details about how to use them.

.. _`Template`: components/templates/Template.html
.. _`Page`: components/pages/Page.html
.. _`Pages`: components/pages/Page.html
.. _`Setting`: components/settings/Setting.html
.. _`Slider`: components/settings/Slider.html
.. _`Category`: components/categories/Category.html
.. _`Categories`: components/categories/Category.html
