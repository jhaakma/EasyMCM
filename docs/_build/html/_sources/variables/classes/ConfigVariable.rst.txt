ConfigVariable
===============

A ConfigVariable fetches a json file from a given 
path and stores the variable in the ``id`` field 
in that file. If no config file of that name exists yet, 
it will create it. 

The ConfigVariable saves to the config file every time the setting 
is updated. It is generally recommended you use `TableVariable`_ and 
save the config in the onClose() function in the template instead, 
especially if you are using a setting where updates happen frequently 
such as with sliders. 

Parent Class: `Variable`_


Fields
----------

class (string)
    The name of this class.

id
    Key in the config file used to store the variable.

path
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

    variable = {
        id = "varID",                                
        path = "MyMod/config",
        class = "ConfigVariable",
    },

.. _`Global`: Global.html
.. _`GlobalBoolean`: GlobalBoolean.html
.. _`PlayerData`: PlayerData.html
.. _`PlayerData`: PlayerData.html
.. _`ConfigVariable`: ConfigVariable.html
.. _`TableVariable`: TableVariable.html
.. _`Variable`: Variable.html
