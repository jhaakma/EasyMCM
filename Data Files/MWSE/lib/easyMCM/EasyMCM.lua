local EasyMCM = {}
EasyMCM.easyMCM = true
EasyMCM.version = 1.2
function EasyMCM:new()
    local t = {}
    setmetatable(t, self)
    t.__index = EasyMCM.__index
    return t
end

function EasyMCM.register(template)
    local mcm = {}
    
    mcm.onCreate = function(container)
        template:create(container)
        mcm.onClose = template.onClose
    end
    mwse.log( "[EasyMCM v%s]: %s mod config registered", EasyMCM.version, template.name )
    mwse.registerModConfig(template.name, mcm)
end

--[[
    Check if key being accessed is in the form "create{class}" where
    {class} is a component or variable class.
    
    If only component data was sent as a parameter, create the new 
    component instance. If a parentBlock was also passed, then also
    create the element on the parent. 

    
]]--
function EasyMCM.__index(tbl, key)

    local meta = getmetatable(tbl)
    local prefixLen = string.len("create")
    if string.sub( key, 1, prefixLen ) == "create" then

        local class = string.sub(key, prefixLen + 1)
        local component

        local classPaths = require("easyMCM.classPaths").all
        for _, path in pairs(classPaths) do

            local classPath = path .. class
            local fullPath = lfs.currentdir() .. "/Data Files/MWSE/lib/" .. classPath .. ".lua"

            local fileExists = lfs.attributes(fullPath, "mode") == "file"
            if fileExists then 
                component = require(classPath)
            end      

            if component then
                return function(param1, param2)
                    local parent = nil
                    local data = nil
                    if param2 then
                        parent = param1
                        data = param2
                    else
                        data = param1
                    end
                    if type(data) == "table" then
                        data.class = class
                    end
                    
                    component = component:new(data)
                    --Add check for easyMCM field to deal with using `:` instead of `.`
                    if parent and parent.easyMCM ~= true then
                        component:create(parent)
                    end
                    return component
                end
            end
        end
    end 
    
    return meta[key]
end


return EasyMCM:new()