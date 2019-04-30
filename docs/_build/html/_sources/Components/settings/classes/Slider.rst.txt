Slider
===========

A slider for setting numerical values. 

Parent Class: `Setting`_



Fields:
-------

label (string)
    Text shown next to the button.
    If left as a normal string, it will be shown in 
    the form: `[label]: [value]`. If the string contains  
    a '%s' format operator, the value will be formatted into it. 

    *Optional.*

variable (`Variable`_)
    The variable which stores the setting value.

min (number)
    Minimum value of slider.

    *Optional: default 0*

max (number)
    Maximum value of slider

    *Optional: default 100*

step (number)
    How far the slider moves when you press the 
    arrows.

    *Optional: default 1*

jump (number)
    How far the slider jumps when you click an 
    area inside the slider.

    *Optional: default 5*

description (string)
    If in a `SideBarPage`_, description will be shown on mouseover.

    *Optional.*

callback (function)
    Function that is called when the button is pressed.

inGameOnly (boolean)
    If true, this setting is disabled in main menu.

    *Optional.*

restartRequired (boolean)
    If true, a message will display prompting the user 
    to restart their game when the setting changes. 

    *Optional.*

restartRequiredMessage (boolean)
    The message shown if restartRequired is triggered.

    *Optional.*

Example::

    --EasyMCM:
    local template = EasyMCM.createTemplate("My mod")
    local page = template:createPage()
    page:createSlider{
            label = "Time Scale",
            description = "Changes the speed of the day/night cycle.",
            min = 0,
            max = 50,
            step = 1,
            jump = 5,
            variable = EasyMCM:createGlobal{ id = "timeScale"}
        }   
    }

    --Adding to a non-easyMCM element
    block = e:createBlock()
    EasyMCM.createButton{
        block,
        {
            label = "Time Scale",
            description = "Changes the speed of the day/night cycle.",
            min = 0,
            max = 50,
            step = 1,
            jump = 5,
            variable = EasyMCM:createGlobal{ id = "timeScale"}
        }   
    }


.. _`OnOffButton`: OnOffButton.html
.. _`YesNoButton`: YesNoButton.html
.. _`KeyBinder`: KeyBinder.html
.. _`Setting`: ../settings.html
.. _`SideBarPage`: ../../pages/SideBarPage.html
.. _`Variable`: ../../../variables/Variable.html
