-----------------------------------------------------------------------------------------------
-- Client Lua Script for RepairAllPrice
-- Copyright (c) NCsoft. All rights reserved
-----------------------------------------------------------------------------------------------
 
require "Window"
 
-----------------------------------------------------------------------------------------------
-- RepairAllPrice Module Definition
-----------------------------------------------------------------------------------------------
local RepairAllPrice = {} 
 

function RepairAllPrice:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 
    return o
end

function RepairAllPrice:Init()
	local bHasConfigureFunction = false
	local strConfigureButtonText = ""
	local tDependencies = {
		"Vendor",
	}
    Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)
end
 

-----------------------------------------------------------------------------------------------
-- RepairAllPrice OnLoad
-----------------------------------------------------------------------------------------------
function RepairAllPrice:OnLoad()
    -- load our form file
	self.xmlDoc = XmlDoc.CreateFromFile("RepairAllPrice.xml")
	self.xmlDoc:RegisterCallback("OnDocLoaded", self)
end

-----------------------------------------------------------------------------------------------
-- RepairAllPrice OnDocLoaded
-----------------------------------------------------------------------------------------------
function RepairAllPrice:OnDocLoaded()

	if self.xmlDoc ~= nil and self.xmlDoc:IsLoaded() then
	    self.wndMain = Apollo.LoadForm(self.xmlDoc, "RepairAllPriceForm", nil, self)
		if self.wndMain == nil then
			Apollo.AddAddonErrorText(self, "Could not load the main window for some reason.")
			return
		end
		
	    self.wndMain:Show(false, true)

		-- if the xmlDoc is no longer needed, you should set it to nil
		-- self.xmlDoc = nil
		
		-- Register handlers for events, slash commands and timer, etc.
		-- e.g. Apollo.RegisterEventHandler("KeyDown", "OnKeyDown", self)


		-- Do additional Addon initialization here
	end
end

-----------------------------------------------------------------------------------------------
-- RepairAllPrice Functions
-----------------------------------------------------------------------------------------------
-- Define general functions here


-----------------------------------------------------------------------------------------------
-- RepairAllPriceForm Functions
-----------------------------------------------------------------------------------------------
-- when the OK button is clicked
function RepairAllPrice:OnOK()
	self.wndMain:Close() -- hide the window
end

-- when the Cancel button is clicked
function RepairAllPrice:OnCancel()
	self.wndMain:Close() -- hide the window
end


-----------------------------------------------------------------------------------------------
-- RepairAllPrice Instance
-----------------------------------------------------------------------------------------------
local RepairAllPriceInst = RepairAllPrice:new()
RepairAllPriceInst:Init()
