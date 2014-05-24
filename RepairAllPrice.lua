-----------------------------------------------------------------------------------------------
-- Client Lua Script for RepairAllPrice
-- Copyright (c) NCsoft. All rights reserved
-----------------------------------------------------------------------------------------------
 
require "Window"

local RepairAllPrice = Apollo.GetPackage("Gemini:Addon-1.0").tPackage:NewAddon("RepairAllPrice", false, {}, "Gemini:Hook-1.0")

function RepairAllPrice:OnEnable()
	-- Hook into an appropriate Vendor method 
	self:Hook(Apollo.GetAddon("Vendor"), "SetBuyButtonText", self.UpdateTooltip)
end

function RepairAllPrice:UpdateTooltip()	
	-- Get ref to buy-button on Vendor (on self, since this is a hooked function)	
	local buyButton = self.wndVendor:FindChild("Buy")
	
	-- If we're not updating to show a "Repair All" scenario, clear tooltip and return
	if not self.wndVendor:FindChild("VendorTab3"):IsChecked()  	-- Repair tab must be checked on Vendor
			or buyButton:GetData() then 						-- There must be item-select data associated with the buy/repair/repair-all btn
		buyButton:SetTooltip("")
		return
	end	
	
	-- Determine total repair cost
	local monAmount = 0
	for _,v in ipairs(self.tRepairableItems) do
		monAmount = monAmount + v.itemData:GetRepairCost()
	end 

	-- Produce tooltip window and set amount
	local wndTooltip = RepairAllPrice.ProduceTooltipWindow()
	wndTooltip:FindChild("Amount"):SetAmount(monAmount)
		
	-- Attach window as tooltip to "Repair All" button	
	buyButton:SetTooltipForm(wndTooltip)	
end


function RepairAllPrice:ProduceTooltipWindow()
	local GeminiGUI = Apollo.GetPackage("Gemini:GUI-1.0").tPackage

	-- Setup the table definition for the window
	local tWindowDefinition = {
		Name			= "RepairAllTooltip",
		Template		= "CRB_TooltipSimple",
		UseTemplateBG	= true,
		Picture			= true,
		Border			= true,		
		AnchorCenter	= {100, 40},
		Children = {
			{
				Name 			= "Amount",
				WidgetType 		= "CashWindow",
				AllowEditing	= false,
				SkipZeroes 		= true,			
				AnchorFill 		= true,
			},
		}		
	}
	
	-- Create the GeminiGUI window prototype object
	local tWindow = GeminiGUI:Create(tWindowDefinition)

	-- Create the instance of the window
	return tWindow:GetInstance()	
end

