local this = {}

this.version = 1.2
function this.registerModData(mcmData)
    --object returned to be used in modConfigMenu
    local modConfig = {}

    --function for formatting logs and asserts
    local logLevels = {
        error = "ERROR",
        info = "INFO",
        none = ""
    }
    local function getLogMessage(message, logLevel)
        logLevel = logLevel or logLevels.info
        formattedMessage = string.format("[%s MCM %s] %s", mcmData.name, logLevel, message)
        return formattedMessage
    end

    --Check mod data has necessary values
    assert(mcmData, getLogMessage("No mcmData!", logLevels.none) )
    assert(mcmData.name, getLogMessage("No name given!", logLevels.none))
    assert(mcmData.pages, getLogMessage("Mod Data has no pages!", logLevels.none))

    ---CREATE MCM---
    function modConfig.onCreate(container)
        local templateClass = mcmData.template or "Template"
        local templatePath = ( "easyMCM.components.templates." .. templateClass)
        local template = require(templatePath):new(mcmData)
        template:create(container)
        modConfig.onClose = template.onClose
    end

   mwse.log( "[EasyMCM v%s]: %s mod config registered", this.version, mcmData.name )

    return modConfig
end

function this.registerMCM(mcmData)
    local mcm = this.registerModData( mcmData ) 
    mwse.registerModConfig(mcmData.name, mcm)
end



return this