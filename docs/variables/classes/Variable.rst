Variable
==========

A Variable is an object which determines the type and location 
of the value being set by a setting. It could be a field on a 
table, or inside a config file, etc. 

The Variable base class can be used for custom variables by 
defining the `get` and `set` fields to retrieve and save the 
value to a specified location. Variable subclasses exist for 
default behaviour.

Variable Subclasses:
---------------------

* `Global`_

* `PlayerData`_

* `ConfigVariable`_

* `TableVariable`_


Fields
----------

class (string)
    The name of this class.

get (function)
    Function to retrieve the variable value.

set (function)
    Function to save the variable value.

inGameOnly (boolean)

    If true, the setting containing this variable will 
    be disabled in the main menu.

restartRequired
    If true, updating the setting containing this variable 
    will notify the player to restart the game. 

restartRequiredMessage
    The message shown if restartRequired is triggered.

Example::

    variable = {
        class = "Variable",
        get = (
            function(self)
                return tes3.getCurrentWeather().index or 0
            end
        ),
        set = (
            function(self, newVal)
                if tes3.player then
                    tes3.getWorldController().weatherController:switchImmediate(newVal)
                end
            end
        ),
    },

.. _`Global`: Global.html
.. _`GlobalBoolean`: GlobalBoolean.html
.. _`PlayerData`: PlayerData.html
.. _`PlayerData`: PlayerData.html
.. _`ConfigVariable`: ConfigVariable.html
.. _`TableVariable`: TableVariable.html
