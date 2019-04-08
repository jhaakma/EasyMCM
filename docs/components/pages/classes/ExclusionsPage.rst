ExclusionsPage
=================

An ExclusionsPage is a highly specialised page used for making 
whitelists/blacklists. It is made up of two lists: The righthand 
list displays objects that are filtered using custom settings. It 
could be a list of NPCs, or weapons, or plugins etc. Clicking on
an item in the righthand list will transfer it to the lefthand list, 
and is also added to a config table. Both lists can be searched using 
searchbars, and buttons can be added for different filters to appear 
in the lefthand list

Parent Class: `Page`

Fields:
-------

class (string)
    Defaults to "Page" for all entries in the pages 
    table in the template.

label (string)
    The label field is displayed in the tab for that page at the top 
    of the menu.

description (string)
    Displayed at the top of the page above the lists.

    *Optional.*

toggleText (string)
    Overwrite the text for the button that toggles filtered 
    items from one list to another.

    *Optional: defaults to "Toggle Filtered".*

leftListLabel (string)
    Overwrite the label for the lefthand list. 

    *Optional: defaults to "Blocked".*

rightListLabel (string)
    Overwrite the label for the righthand list

    *Optional: defaults to "Allowed".*

variable (`Variable`_)
    The `Variable`_ used to store blocked list entries. 

filters (table)
    A list of filters, which appears as buttons between the 
    two lists. At least one filter is required. See the 
    below example to see the different filter types. 


Example::

    {
        label = "Exclusions Page",
        class = "ExclusionsPage",         
        description = "Description",
        toggleText = "Toggle", --Optional: default "Toggle Filtered"
        leftListLabel = "Blacklist", --Optional: default "Blocked"
        rightListLabel = "Whitelist", --Optional: default = "Allowed"

        variable = {
            id = "blocked",
            class = "TableVariable", 
            table = config,
        },  
        
        filters = {

            --Filter by plugins to exclude entire mods
            {
                label = "Plugins",
                type = "Plugin",
            },

            --Filter by object type
            {
                label = "Ingredients",
                type = "Object",
                objectType = tes3.objectType.ingredient,
            },

            --Define object filters for more specific filters
            {
                label = "Helmets",
                type = "Object",
                objectType = tes3.objectType.armor,
                objectFilters = {
                    slot = tes3.armorSlot.helmet
                }
            },
            {
                label = "Blunt Weapons",
                type = "Object",
                objectType = tes3.objectType.weapon,
                objectFilters = {
                    type = tes3.weaponType.bluntOneHand
                }
            },
            {
                label = "Essential NPCs",
                type = "Object",
                objectType = tes3.objectType.npc,
                objectFilters = {
                    isEssential = true
                }
            },
        
            --define your own callback for a custom filter
            {
                label = "GMSTs",
                callback = (
                    function(self)
                        local gmstNames = {}
                        for gmst, _ in pairs(tes3.gmst) do
                            table.insert(gmstNames, gmst)
                        end
                        return gmstNames
                    end
                )
            },

        }--/filters
    }

.. _`Variable`: /variables/classes/Variable.html
.. _`Page`: Page.html

