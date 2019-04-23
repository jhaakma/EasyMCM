ConfigVariable
===============

A ConfigVariable fetches a json file from a given 
path and stores the variable in the ``id`` field 
in that file. If no config file of that name exists yet, 
it will create it. 

The ConfigVariable saves to the config file every time the setting 
is updated. It is generally recommended you use `TableVariable`_ and 
save the config using template.saveOnClose() instead, 
especially if you are using a setting where updates happen frequently 
such as with sliders. 

Parent Class: `Variable`_


Fields
----------

id (string)
    Key in the config file used to store the variable.

path (string)
    Location of the config file relative to ``MWSE/config/``.

defaultSetting(any)
    If ``id`` does not exist in the config file, it will 
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

    EasyMCM.createVariable{
        id = "varID",                                
        path = "MyMod/config",
    },

.. _`Global`: Global.html
.. _`GlobalBoolean`: GlobalBoolean.html
.. _`PlayerData`: PlayerData.html
.. _`PlayerData`: PlayerData.html
.. _`ConfigVariable`: ConfigVariable.html
.. _`TableVariable`: TableVariable.html
.. _`Variable`: Variable.html
