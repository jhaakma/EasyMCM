PlayerData
===========

Stores the variable on the Player reference. This results 
in the value of the variable being local to the loaded save file. 
If users may want different values set for different games, this 
is a good Variable to use.

Settings using PlayerData are in-game only by default, as the 
Player reference can only be accessed while a game is loaded. 

Parent Class: `Variable`_


Fields
----------

id (string)
    Key of entry used on the Player data table. 

path (string)
    Path to ``id`` relative to ``tes3.player.data``. 
    It's best to at least store all your PlayerData fields in 
    a table named after your mod to avoid conflicts. 

defaultSetting (any)
    If ``id`` does not exist in on the playerData field, it will 
    be initialised to this value. best to initialise this yourself 
    though, as this will not create the value until you've entered 
    the MCM.

    *Optional.*

restartRequired (boolean)
    If true, updating the setting containing this variable 
    will notify the player to restart the game. 

    *Optional.*

restartRequiredMessage (string)
    The message shown if restartRequired is triggered.

    *Optional.*

Example::

    EasyMCM.createPlayerData{
        id = "varID",
        path = "myModName.mcmSettings",
        defaultSetting = true
    }


.. _`Global`: Global.html
.. _`GlobalBoolean`: GlobalBoolean.html
.. _`PlayerData`: PlayerData.html
.. _`PlayerData`: PlayerData.html
.. _`ConfigVariable`: ConfigVariable.html
.. _`TableVariable`: TableVariable.html
.. _`Variable`: Variable.html