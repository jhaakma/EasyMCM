--[[
    Slider:
        A Slider Setting
]]--
local Parent = require("easyMCM.components.settings.Setting")
local Slider = Parent:new()
Slider.min = 0
Slider.max = 100
Slider.step = 1
Slider.jump = 5

function Slider:updateValueLabel()
    local newValue = self.elements.slider.widget.current + self.min
    self.elements.sliderValueLabel.text = ( ": " .. newValue )
end


function Slider:update()
    local newValue = self.elements.slider.widget.current + self.min
    self.variable.value = newValue
    Parent.update(self)
end


function Slider:registerSliderElement(element)
    --click
    element:register(
        "mouseClick", 
        function(e) 
            self:update()
        end 
    )
    --drag
    element:register(
        "mouseRelease", 
        function(e) 
            self:update()
        end 
    )
end


function Slider:enable()
    Parent.enable(self)
    self.elements.sliderValueLabel.text = ( ": " .. self.variable.value )
    self.elements.slider.widget.current = self.variable.value - self.min
    
    --Register slider elements so that the value only updates when the mouse is released
    for _, sliderElement in ipairs(self.elements.slider.children) do
        self:registerSliderElement(sliderElement)
        for _, innerElement in ipairs(sliderElement.children) do
        self:registerSliderElement(innerElement)
        end
    end

    --But we want the label to update in real time so you can see where it's going to end up
    self.elements.slider:register(
        "PartScrollBar_changed", 
        function(e) 
            self:updateValueLabel() 
        end 
    )
end


function Slider:disable()
    Parent.disable(self)

    self.elements.slider.children[2].children[1].visible = false
    self.elements.sliderValueLabel.color = tes3ui.getPalette("disabled_color")

end


--UI creation functions

function Slider:createOuterContainer(parentBlock)
    Parent.createOuterContainer(self, parentBlock)
    self.elements.outerContainer.borderRight = ( self.indent * 2 )
    self.elements.outerContainer.flowDirection = "top_to_bottom"
end

function Slider:createLabel(parentBlock)
    Parent.createLabel(self, parentBlock)
    self.elements.label.autoWidth = true
    self.elements.label.widthProportional = nil
    self.elements.labelBlock.flowDirection = "left_to_right"
    
    local sliderValueLabel = self.elements.labelBlock:createLabel({text = ": --" })
    self.elements.sliderValueLabel = sliderValueLabel
    table.insert(self.mouseOvers, sliderValueLabel)
end

function Slider:createSlider(parentBlock)
    local sliderBlock 
    sliderBlock = parentBlock:createBlock()
    sliderBlock.flowDirection = "left_to_right"
    sliderBlock.autoHeight = true
    sliderBlock.widthProportional = 1.0
    range = self.max - self.min
    local slider = sliderBlock:createSlider({
        current = 0,
        max = range
    })
    slider.widthProportional = 1.0
    
    --Set custom values from setting data
    slider.widget.step = self.step 
    slider.widget.jump = self.jump

    self.elements.slider = slider
    self.elements.sliderBlock = sliderBlock
    
    --add mouseovers
    table.insert(self.mouseOvers, sliderBlock)
    table.insert(self.mouseOvers, sliderValueLabel)
    --Add every piece of the slider to the mouseOvers
    for _, sliderElement in ipairs(slider.children) do
        table.insert(self.mouseOvers, sliderElement)
        for _, innerElement in ipairs(sliderElement.children) do
            table.insert(self.mouseOvers, innerElement)
        end
    end
end

function Slider:createComponent(parentBlock)

    self:createLabel(parentBlock)

    self:createSlider(parentBlock)

end


return Slider