TextField
===========

A TextField allows you to enter a single line of text 
and submit with a button. You can also force it to 
only accept numbers with the numbersOnly field. 

Parent Class: `Setting`_

TextField Subclasses:
-----------------------
* `ParagraphField`_


Fields:
-------

label (string)
    Text shown above text field. 

    *Optional.*


description (string)
    If in a `SideBarPage`_, description will be shown on mouseover.

    *Optional.*

numbersOnly (boolean)
    If true, the input will only accept numbers

    *Optional: default false*

press (function)
    A function that happens before the update()
    function. Can be overriden to add a confirmation message 
    before updating.

sNumbersOnly (string)
    The text shown in a messageBox when the user entered 
    an invalid input when numbersOnly is true.

    *Optional: default "Value must be a number."*

sNewValue (string)
    Text shown when the setting is updated. This can be 
    formatted with a '%s' which will be replaced with 
    the new value.

    *Optional: default "New value: '%s'"*

callback (function)
    Function that is called when setting is updated.

inGameOnly (boolean)
    If true, this setting is disabled in main menu.

    *Optional.*

restartRequired (boolean)
    If true, a message will display prompting the user 
    to restart their game when the setting changes. 

    *Optional.*

restartRequiredMessage (boolean)
    The message shown if restartRequired is triggered.

    *Optional.*

Example::

    --EasyMCM:
    local template = EasyMCM.createTemplate("My mod")
    local page = template:createPage()
    page:createTextField{
        label = "Text input",
        variable = EasyMCM.createTableVariable{ id = "text", table = config },
    }


    --Adding to a non-easyMCM element
    block = e:createBlock()
    EasyMCM.createTextField(
        block,
        {
            label = "Text input",
            variable = EasyMCM.createTableVariable{ id = "text", table = config },
        }
    }


.. _`ParagraphField`: ParagraphField.html
.. _`Setting`: ../settings.html
.. _`SideBarPage`: ../../pages/SideBarPage.html

