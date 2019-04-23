FilterPage
==========

A FilterPage is a `SideBarPage`_ with additional functionality: 
The components container is a vertical scroll pane with a searchbar. 
This is expecially useful if you have a large or unknown number 
of settings. 

Parent Class: `Page`_

Fields:
-------

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

    local sidebar = {
        EasyMCM.createButton({ buttonText = "press button" })
    }

    template:createFilterPage{
        label = "Filter Page",
        description = "Default sidebar text",
        sidebarComponents = sidebar
    }



.. _`SideBarPage`: SideBarPage.html
.. _`Page`: Page.html