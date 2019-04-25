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

sidebar (MouseOverPage)
    The object that holds components in the sidebar.
    Add to it like any

noScroll (boolean)
    When set to true, the page will not have a scrollbar. 
    Particularly useful if you want to use a ParagraphField, 
    which is not compatible inside of scroll panes. 


Example::

    --With sidebar
    local template = EasyMCM.createTemplate("My Mod")
    local page = template:createSideBarPage()
    page:createButton{
        buttonText = "Button",
        description = "When hovering over the button, this text will be shown in the sidebar"
    }
    page.sidebar:createButton{ buttonText = "press button" } }

    --With basic description
    template:createSideBarPage{
        label = "Sidebar Page",
        description = "Default sidebar text"
    }


.. _`Page`: Page.html
