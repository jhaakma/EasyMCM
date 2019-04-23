TableVariable
===============

A TableVariable takes a lua table and stores the variable in the ``id`` field 
in that table. 

The TableVariable can be used to save multiple changes to a config file only 
when the menu is closed. Load the config file with mwse.loadConfig(), pass it
to any TableVariables in your MCM, then save it using the 
template:onSaveClose() function.

Parent Class: `Variable`_


Fields
----------

class (string)
    The name of this class.

id (string)
    Key in the config file used to store the variable.

table (table)
    The table to save the data to.

defaultSetting(any)
    If ``id`` does not exist in the table, it will 
    be initialised to this value.

    *Optional.*

inGameOnly (boolean)
    If true, the setting containing this variable will 
    be disabled in the main menu.

    *Optional.*

restartRequired (boolean)
    If true, updating the setting containing this variable 
    will notify the player to restart the game. 

    *Optional.*

restartRequiredMessage (string)
    The message shown if restartRequired is triggered.

    *Optional.*

Example::

    local configPath = "myMod.config"
    local config = mwse.loadConfig(configPath)
    if not config then
        config = {}
    end
    local template = EasyMCM.createTemplate("My Mod")
    template:saveOnClose(configPath, config)

    EasyMCM.createTableVariable{
        id = "varID",                                
        table = config,
    },

.. _`Global`: Global.html
.. _`GlobalBoolean`: GlobalBoolean.html
.. _`PlayerData`: PlayerData.html
.. _`PlayerData`: PlayerData.html
.. _`ConfigVariable`: ConfigVariable.html
.. _`TableVariable`: TableVariable.html
.. _`Variable`: Variable.html
