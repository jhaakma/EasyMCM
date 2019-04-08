
Category
==========

A Category has a header and a list of 
components. Components within a category are indented. Categories can 
be nested indefinitely. A category is a good way to organise settings 
within a page. 


label (string)
    The ``label`` field is displayed in the tab for that Category at the top 
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
        label = "General Settings",
        class = "Category",
        description = "A list of general settings for this mod."
        components = {
            ...
        }
    }


.. _`SideBarPage`: ../../pages/classes/SideBarPage.html
