.. EasyMCM documentation master file, created by
   sphinx-quickstart on Sat Apr  6 20:43:42 2019.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

===================================
EasyMCM
===================================

.. toctree::
   :maxdepth: 1
   :glob:

   components/*
   variables/*
   tutorial

EasyMCM is a UI Library for Morrowind, 
allowing modders to quickly generate Mod Config 
Menus and preconfigured UI elements without touching UI code.

Example::

    local function registerModConfig()
        EasyMCM = require("easyMCM.EasyMCM")
        local template = EasyMCM.createTemplate("Basic MCM")
        local page = template:createPage()
        local category = page:createCategory("Settings")
        category:createButton{ buttonText = "Press" }
        EasyMCM.register(template)
    end
    event.register("modConfigReady", registerModConfig)

See the `Tutorial`_ for a more detailed walkthrough.

.. _`Tutorial`: tutorial.html