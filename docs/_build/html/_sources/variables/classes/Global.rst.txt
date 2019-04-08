Global
==========

A variable connected to a Morrowind Global.

Base Class: `Variable`_

Global Subclasses:
------------------

* `GlobalBoolean`_


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

restartRequired
    If true, updating the setting containing this variable 
    will notify the player to restart the game. 

    *Optional.*

restartRequiredMessage
    The message shown if restartRequired is triggered.

    *Optional.*

Example::

    variable = {
        id = "timeScale",
        class = "Global",
    },

.. _`Global`: Global.html
.. _`GlobalBoolean`: GlobalBoolean.html
.. _`PlayerData`: PlayerData.html
.. _`PlayerData`: PlayerData.html
.. _`ConfigVariable`: ConfigVariable.html
.. _`TableVariable`: TableVariable.html
.. _`Variable`: Variable.html
