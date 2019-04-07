
Page
==========

A ``Page`` a container that holds other components. It acts a bit like a 
page on your web browser, in that you have tabs across the top of 
your menu to selecta page to view. Pages must go in the 
``pages`` table in your template.::

    --Page fields
    {
            label = "SideBar Page",
            class = "Page",
            components = {},
        }

label
#####

The ``label`` field is displayed in the tab for that page at the top 
of the menu.

class (Optional)
################

Can be set to custom page types. Defaults to "Page" for all entries in 
the ``pages`` table in the template.

components
#############

A list of components to display
