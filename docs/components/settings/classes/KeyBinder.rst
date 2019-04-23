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

label (string)
    Text shown next to the button.

    *Optional.*

description
    If in a `SideBarPage`_, description will be shown on mouseover.

    *Optional.*

allowCombinations (boolean)
    If true, keybinds can allow combos of Shift+x, Alt+x or Ctrl+x

    *Optional.*

variable (`Variable`_)
    The Boolean variable being toggled.

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

callback (function)
    Function that is called when the button is pressed.

    *Optional.*


Example::

    --EasyMCM:
    local template = EasyMCM.createTemplate("My mod")
    local page = template:createPage()
    page:createKeyBinder{
        label = "Assign Keybind",
        allowCombinations = true,
        variable = EasyMCM.createTableVariable{
            id = "keybind_1",
            table = config,
            defaultSetting = {
                keyCode = tes3.scanCode.k,
                --These default to false
                isShiftDown = true,
                isAltDown = false,
                isControlDown = false,
            }
        }
    }

    --Adding to a non-easyMCM element
    block = e:createBlock()
    EasyMCM.createKeyBinder{
        block,
        {
            label = "Assign Keybind",
            allowCombinations = true,
            variable = EasyMCM.createTableVariable{
                id = "keybind_1",
                table = config,
                defaultSetting = {
                    keyCode = tes3.scanCode.k,
                    --These default to false
                    isShiftDown = true,
                    isAltDown = false,
                    isControlDown = false,
                }
            }
        }
    }

.. _`Button`: Button.html
.. _`Setting`: ../settings.html
.. _`SideBarPage`: ../../pages/SideBarPage.html
.. _`Variable`: ../../../variables/Variable.html
