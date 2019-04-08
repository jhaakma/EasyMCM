SideBarPage
================

A SideBarPage is a special page type that includes an 
additional container used to display mouseover 
information for components

Children in the `components` list can have a `description` 
text field, which will display in the sidebar when that component 
is moused over. When no component is moused over, the sidebar will 
either display the text in the `description` field of the page, 
unless the sidebarComponents table exists, in which case it will 
display those components instead. 

Parent Class: `Page`_

Fields:
-------

class (string)
    The name of this class.

label (string)
    The label field is displayed in the tab for that page at the top 
    of the menu.

description (string)
    Default sidebar text when no sidebarComponents is 
    defined

    *Optional.*

components (table)
    A list of components to display.

sidebarComponents (table)
    A list of components to display on the sidebar 
    when nothing is moused over. 

    *Optional: Should have either this or a description.* 


Example::

    {
        label = "SideBar Page",
        description = "Default sidebar text",
        class = "SideBarPage",
        components = {
            ...
        },
        sidebarComponents = {
            ...
        }
    }

.. _`Page`: Page.html