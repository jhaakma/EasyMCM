
SideBySideBlock
==================

A SideBySideBlock is a category that arranges its settings 
horizontally instead of vertically. Particularly useful 
in conjunction with buttons that have no labels. 


label (string)
    The label field is displayed in the tab for that Category at the top 
    of the menu.

description (string)
    If in a `SideBarPage`_, description will be shown on mouseover.

    *Optional.*

class (string)
    The name of this class.

components (table)
    A list of components to display.

Example::

    {
        label = "Buttons",
        class = "SideBySideBlock",
        description = "A horizontal list of buttons."
        components = {
            {
                buttonText = "Button A",
                description = "A button.",
                class = "Button",
                callback = ( function(self) ... end ),

            },
            {
                buttonText = "Button B",
                description = "Another button.",
                class = "Button",
                callback = ( function(self) ... end ),
            },
        }
    }


.. _`SideBarPage`: ../../pages/classes/SideBarPage.html
