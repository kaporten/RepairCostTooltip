-----------------------------------------------------------------------------------------------
-- Client Lua Script for RepairAllPrice
-- Copyright (c) NCsoft. All rights reserved
-----------------------------------------------------------------------------------------------
 
require "Window"

local RepairAllPrice = Apollo.GetPackage("Gemini:Addon-1.0").tPackage:NewAddon("RepairAllPrice", false, {}, "Gemini:Hook-1.0")


function RepairAllPrice:OnEnable()
	self:Hook(Apollo.GetAddon("Vendor"), "SetBuyButtonText", self.UpdateTooltip)
	
end

function RepairAllPrice:UpdateTooltip()	
	
	-- Determine total repair cost
	local monPrice = 0
	if self.wndVendor:FindChild("VendorTab3"):IsChecked() then -- Repair tab is checked on vendor
		if not self.wndVendor:FindChild("Buy"):GetData() then -- GetData is present on single, but not all, repairs
			for _,v in pairs(self.tRepairableItems) do
				monPrice = monPrice + v.itemData:GetRepairCost()
			end 
		end
	end
	
	--
	local buyButton = self.wndVendor:FindChild("Buy")
	if monPrice == 0 then 
		buyButton:SetTooltip("")
	else
		buyButton:SetTooltipForm(RepairAllPrice:ProduceTooltipWindow(monPrice))
	end
end


function RepairAllPrice:ProduceTooltipWindow(monAmount)
	local GeminiGUI = Apollo.GetPackage("Gemini:GUI-1.0").tPackage

	-- Setup the table definition for the window
	local tWindowDefinition = {
		Name					= "MyExampleWindow",
		Template			= "CRB_TooltipSimple",
		UseTemplateBG = true,
		Picture			 = true,
		Border				= true,		
		AnchorCenter	= { 100, 40 },
		Children = {
			{
				Name = "AmountWindow",
				WidgetType = "CashWindow",
				AllowEditing = false,
				SkipZeroes = true,			
				AnchorFill = true,
			},
		}		
	}
	
	-- Create the GeminiGUI window prototype object
	local tWindow = GeminiGUI:Create(tWindowDefinition)

	-- Create the instance of the window
	local wndInstance = tWindow:GetInstance()	

	
	local wnda = wndInstance:FindChild("AmountWindow")
	--local wndb = wnda:GetChildren()[0]
	wnda:SetAmount(monAmount)
	wndInstance:ToFront()
	wndInstance:Show(true, true)
	return wndInstance
	
end

