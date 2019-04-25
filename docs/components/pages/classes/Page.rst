
Page
==========

A Page is a container that holds other components. It acts a bit like a 
page on your web browser, in that you have tabs across the top of 
your menu to selecta page to view. Pages must go in the 
pages table in your template.

The default page is a simple container, it is recommended you use 
the `SideBarPage`_ for basic settings.

Page Subclasses:
-----------------
* `SideBarPage`_
* `FilterPage`_
* `ExclusionsPage`_


Fields:
-------

label (string)
    The label field is displayed in the tab for that page at the top 
    of the menu.

    *Optional: defaults to "Page {number}"*

noScroll (boolean)
    When set to true, the page will not have a scrollbar. 
    Particularly useful if you want to use a ParagraphField, 
    which is not compatible inside of scroll panes. 

Example::

    EasyMCM.createTemplate("My mod")

    template:createPage() --sets name to "Page 1"

    template:createPage("Page two")

    template:createPage() --sets name to "Page 3"

    template:createPage{ label = "Page 4" }


.. _`SideBarPage`: SideBarPage.html
.. _`FilterPage`: FilterPage.html
.. _`ExclusionsPage`: ExclusionsPage.html
