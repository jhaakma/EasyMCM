
Page
==========

A Page is a container that holds other components. It acts a bit like a 
page on your web browser, in that you have tabs across the top of 
your menu to selecta page to view. Pages must go in the 
``pages`` table in your template.

The default page is a simple container, it is recommended you use 
the `SideBarPage`_ for basic settings.


label (string)
    The ``label`` field is displayed in the tab for that page at the top 
    of the menu.

class (string)
    Defaults to "Page" for all entries in the ``pages`` 
    table in the template.

components (table)
    A list of components to display.

Example::

    {
        label = "Page 1",
        class = "Page",
        components = {
            ...
        }
    }

.. _`SideBarPage`: SideBarPage.html
