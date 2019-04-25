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

sidebar (MouseOverPage)
    The object that holds components in the sidebar.
    Add to it like any other component


Example::

    local filterPage = template:createFilterPage("Filter Page")
    filterPage.sidebar:createCategory("Heading")
    filterpage.sideBar:createInfo{ text = "Description of my mod." }



.. _`SideBarPage`: SideBarPage.html
.. _`Page`: Page.html