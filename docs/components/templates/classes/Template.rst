
Template
==========

A Template is the top level component in mcmData. It determines the overall 
layout of the menu. Can be created with a table or a string (name).


Fields:
-------

name (string)
    The name field is the mod name, used to register the MCM, 
    and is displayed in the mod list on the lefthand pane.

headerImagePath (string)
    Set headerImagePath to display an image at the top of your menu. 
    Path is relative to ``Data Files/``. Internally uses `:createImage()` method, so inherently the image must have power-of-2 dimensions (i.e. 16, 32, 64, 128, 256, 512, 1024, etc.).
    
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

    local template = EasyMCM.createTemplate("My Mod name")
    template:saveOnClose(configPath, config)

    
    --with image header
    local template = EasyMCM.createTemplate{
        name = "My mod name",
        headerImagePath = "Path/to/image.dds"
    }
