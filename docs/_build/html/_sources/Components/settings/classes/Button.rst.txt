Button
===========

A button is the most basic of settings. You click the button, and it calls 
the function defined in the callback field. A number of more advanced 
button classes extend this class.

Parent Class: `Setting`_

Button Subclasses:
-------------------
* `OnOffButton`_

* `YesNoButton`_

* `KeyBinder`_



Fields:
-------

label (string)
    Text shown next to the button.

    *Optional.*

buttonText (string)
    Text shown inside the button.

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
    page:createButton{
        label = "Reset Actors",
        buttonText = "Okay",
        inGameOnly = true,
        callback = (
            function(self)
                tes3.messageBox("Resetting Actors")
                tes3.runLegacyScript({command = "ResetActors"})
            end
        ),       
    }

    --Adding to a non-easyMCM element
    block = e:createBlock()
    EasyMCM.createButton{
        block,
        {
            buttonText = "Okay"        
        }
    }


.. _`OnOffButton`: OnOffButton.html
.. _`YesNoButton`: YesNoButton.html
.. _`KeyBinder`: KeyBinder.html
.. _`Setting`: ../settings.html
.. _`SideBarPage`: ../../pages/SideBarPage.html
