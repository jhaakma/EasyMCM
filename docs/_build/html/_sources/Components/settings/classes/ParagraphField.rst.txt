ParagraphField
=================

A ParagraphField allows you to enter a multi-line of text. 
Press Enter to submit or Shift+Enter to enter a new line. 

Parent Class: `TextField`_


Fields:
-------

label (string)
    Text shown above text field. 

    *Optional.*


variable (`Variable`_)
    The variable which stores the setting value.

description (string)
    If in a `SideBarPage`_, description will be shown on mouseover.

    *Optional.*

height (number)
    Fixes the height of the paragraph field to a custom value.

    *Optional.*

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
    page:createParagraphField{
        label = "Paragraph input",
        variable = EasyMCM.createTableVariable{ id = "text", table = config },
        height = 150
    }


    --Adding to a non-easyMCM element
    block = e:createBlock()
    EasyMCM.createParagraphField(
        block,
        {
            label = "Paragraph input",
            variable = EasyMCM.createTableVariable{ id = "text", table = config },
            height = 150
        }
    }


.. _`TextField`: TextField.html
.. _`ParagraphField`: ParagraphField.html
.. _`Setting`: ../settings.html
.. _`SideBarPage`: ../../pages/SideBarPage.html
.. _`Variable`: ../../../variables/Variable.html
