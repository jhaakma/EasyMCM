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
-------.

label (string)
    The label field is displayed in the tab for that page at the top 
    of the menu.

description (string)
    Default sidebar text when no sidebarComponents is 
    defined

    *Optional.*

sidebarComponents (table)
    A list of components to display on the sidebar 
    when nothing is moused over. 

    *Optional: Should have either this or a description.* 


Example::

    EasyMCM.createTemplate("My Mod")

    local sidebar = { EasyMCM.createButton{ buttonText = "press button" } }
    local page = template:createSideBarPage{ sidebarComponents = sidebar }
    page:createButton{
        buttonText = "Button",
        description = "When hovering over the button, this text will be shown in the sidebar"
    }

    template:createSideBarPage{
        label = "Sidebar Page",
        description = "Default sidebar text"
    }


.. _`Page`: Page.html
