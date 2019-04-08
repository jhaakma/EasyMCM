GlobalBoolean
===============

A variable connected to a Morrowind Global. 
Treats 0 as false and >=1 as true.

Base Class: `Global`_

Fields
--------

class (string)
    The name of this class.

id (string)
    The id of the Morrowind Global.

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
    
    {
        label = "Button Setting",
        class = "YesNoButton",
        restartRequired = true,
        variable = {
            id = "HeartDestroyed",
            class = "GlobalBoolean",
        },                           
    },

.. _`Global`: Global.html
.. _`GlobalBoolean`: GlobalBoolean.html
.. _`PlayerData`: PlayerData.html
.. _`PlayerData`: PlayerData.html
.. _`ConfigVariable`: ConfigVariable.html
.. _`TableVariable`: TableVariable.html
.. _`Variable`: Variable.html
