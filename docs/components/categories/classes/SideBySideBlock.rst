
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

Example::

    local category = page:createSideBySideBlock("List of buttons")
    category:createButton{ buttonText = "Button A" }
    category:createButton{ buttonText = "Button B" }


.. _`SideBarPage`: ../../pages/classes/SideBarPage.html
