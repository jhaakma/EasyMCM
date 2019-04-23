YesNoButton
===========

Toggles a `Variable`_ between true and false, with the buttonText 
switching between the strings "Yes" and "No". 

Parent Class: `Button`_

Fields:
-------

label (string)
    Text shown next to the button.

    *Optional.*

description
    If in a `SideBarPage`_, description will be shown on mouseover.

    *Optional.*

variable (`Variable`_)
    The Boolean variable being toggled.

callback (function)
    Function that is called when the button is pressed.

    *Optional.*

inGameOnly (boolean)
    If true, this setting is disabled in main menu.

    *Optional.*

restartRequired (boolean)
    If true, a message will display prompting the user 
    to restart their game when the setting changes. 

    *Optional.*

restartRequiredMessage
    The message shown if restartRequired is triggered.

    *Optional.*

Example::

    --EasyMCM:
    local template = EasyMCM.createTemplate("My mod")
    local page = template:createPage()
    page:createYesNofButton{
        label = "Yes or No?",
        variable = EasyMCM.createTableVariable{
            id = "enabled",
            table = config
        }
    }

    --Adding to a non-easyMCM element
    block = e:createBlock()
    EasyMCM.createYesNofButton{
        block,
        label = "Yes or No?",
        variable = EasyMCM.createTableVariable{
            id = "enabled",
            table = config
        }
    }

.. _`Button`: Button.html
.. _`Setting`: ../settings.html
.. _`SideBarPage`: ../../pages/SideBarPage.html
.. _`Variable`: ../../../variables/classes/Variable.html
