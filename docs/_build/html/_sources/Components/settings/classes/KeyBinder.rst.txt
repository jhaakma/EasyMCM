KeyBinder
===========

This button allows the player to bind a key combination 
for use with hotkeys. 

The player presses the hotkey button, a prompt asks them to 
press a key (or key combination using Shift, Ctrl or Alt), and 
the current key combo is displayed in the popup until they press 
"Okay" to confirm.

Key combos are stored in the following format::

    {
        keyCode = tes3.scanCode.{key},
        isShiftDown = true,
        isAltDown = true,
        isControlDown = true,
    },

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

allowCombinations (Boolean)
    If true, keybinds can allow combos of Shift+x, Alt+x or Ctrl+x

    *Optional.*

variable (`Variable`_)
    The Boolean variable being toggled.

inGameOnly (Boolean)
    If true, this setting is disabled in main menu.

    *Optional.*

restartRequired (Boolean)
    If true, a message will display prompting the user 
    to restart their game when the setting changes. 

    *Optional.*

callback (function)
    Function that is called when the button is pressed.

*Optional.*


Example::

    {
        class = "KeyBinder", 
        label = "Key Combo Binding",
        description = "Keybinds can allow combos of Shift+x, Alt+x or Ctrl+x.",
        allowCombinations = true,
        variable = {
            id = "keybind1", 
            class = "TableVariable", 
            table = localConfig,
            defaultSetting = {
                keyCode = tes3.scanCode.k,
                --These default to false
                isShiftDown = true,
                isAltDown = false,
                isControlDown = false,
            },
        },--/rebind

.. _`Button`: Button.html
.. _`Setting`: ../settings.html
.. _`SideBarPage`: ../../pages/SideBarPage.html
.. _`Variable`: ../../../variables/Variable.html
