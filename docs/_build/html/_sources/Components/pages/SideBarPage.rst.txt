SideBarPage
================

A SideBarPage is a special page type that includes an 
additional container used to display mouseover 
information for components::

        {   
            label = "Page 1",
            description = "Default sidebar text", --Optional
            class = "SideBarPage",
            components = {},
            sidebarComponents = {}, --Optional, overwrites description
        }

label
    The ``label`` field is displayed in the tab for that page at the top 
    of the menu.

class
    The name of this class.

components
    A list of components to display.

sidebarComponents
    A list of components to display on the sidebar 
    when nothing is moused over. 


The Sidebar
------------

Children in the ``components`` list can have a ``description`` 
text field, which will display in the sidebar when that component 
is moused over. When no component is moused over, the sidebar will 
either display the text in the ``description`` field of the page, 
unless the sidebarComponents table exists, in which case it will 
display those components instead. 

Example::

    {
        label = "SideBar Page",
        description = "Default sidebar text",
        class = "SideBarPage",
        components = {
            {
                label = "An On Off Button",
                description = "This will display in the sidebar when moused over"
                class = "OnOffButton",
                variable = {
                    id = "variableID",
                    class = "ConfigVariable",
                    path = "path_to_config_file",
                },
            }
        },
        sidebarComponents = {
            {
                label = "Info Label",
                class = "Info",
                text = "This will display instead of description.",
            }
        }
    }

