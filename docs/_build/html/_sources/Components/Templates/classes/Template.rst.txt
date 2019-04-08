
Template
==========

A Template is the top level component in mcmData. It determines the overall 
layout of the menu.


Fields:
-------

class (string)
    Can be set to custom template types. 

    *Optional: Defaults to "Template" for the 
    top level table in mcmData.*

name (string)
    The name field is the mod name, used to register the MCM, 
    and is displayed in the mod list on the lefthand pane.

headerImagePath (string)
    Set headerImagePath to display an image at the top of your menu. 
    Path is relative to ``Data Files/``
    
    *Optional.*

onClose (function)
    Set this to a function which will be called when the menu is closed. 
    Useful for saving variables, such as ``TableVariable``. For example::

        onClose = (
            function()
                mwse.log("saving config to json")
                mwse.saveConfig(configPath, localConfig)
            end
        ),

    *Optional.*

Example::

    {
        name = "Mod Name", --Displayed in mod list on lefthand side of MCM
        class = "Template", --Optional, defaults to "Template" class
        headerImagePath = "Path/to/image", --Optional, shows image at top of menu
        onClose = function() ... end, --Optional, called when menu is closed
        pages = {}, --List of pages that contain your components
    }
