YesNoButton
===========

Toggles a `Variable`_ between true and false, with the buttonText 
switching between the strings "Yes" and "No". 

Parent Class: `Button`_

Fields:
-------

class (string)
    The name of this class

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

inGameOnly (Boolean)
    If true, this setting is disabled in main menu.

    *Optional.*

restartRequired (Boolean)
    If true, a message will display prompting the user 
    to restart their game when the setting changes. 

    *Optional.*


*Optional.*


Example::

    {
        label = "Button Setting",
        class = "YesNoButton",
        restartRequired = true,
        variable = {
            id = "enabled",
            class = "TableVariable",
            table = localConfig,
            defaultSetting = true,
        },                            

    },

.. _`Button`: Button.html
.. _`Setting`: ../settings.html
.. _`SideBarPage`: ../../pages/SideBarPage.html
.. _`Variable`: ../../../variables/classes/Variable.html
