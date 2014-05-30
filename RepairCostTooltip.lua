-----------------------------------------------------------------------------------------------
-- WildStar addon "RepairCostTooltip" by Porten.
-- Made primarily for playing a bit with the (awesome!) Gemini frameworks :)
-----------------------------------------------------------------------------------------------
 
require "Window"

local RepairCostTooltip = Apollo.GetPackage("Gemini:Addon-1.0").tPackage:NewAddon("RepairCostTooltip", false, {}, "Gemini:Hook-1.0")
RepairCostTooltip.ADDON_VERSION = {1, 0, 1}

function RepairCostTooltip:OnEnable()
	-- Hook into an appropriate Vendor method 
	self:Hook(Apollo.GetAddon("Vendor"), "SetBuyButtonText", self.UpdateTooltip)
end

function RepairCostTooltip:UpdateTooltip()	
	-- Get ref to buy-button on Vendor (on self, since this is a hooked function)	
	local buyButton = self.wndVendor:FindChild("Buy")
	
	-- If we're not updating to show a "Repair All" scenario, clear tooltip and return
	if not self.wndVendor:FindChild("VendorTab3"):IsChecked()  	-- Repair tab must be checked on Vendor
			or buyButton:GetData() then 						-- There must not be item-select data associated with the buy/repair/repair-all btn
		buyButton:SetTooltip("")
		return
	end	
	
	-- Determine total repair cost
	local monAmount = 0
	for _,v in ipairs(self.tRepairableItems) do
		monAmount = monAmount + v.itemData:GetRepairCost()
	end 

	-- Produce tooltip window and set amount.
	local wndTooltip = RepairCostTooltip.ProduceTooltipWindow()
	wndTooltip:FindChild("Amount"):SetAmount(monAmount)
		
	-- Attach window as tooltip to "Repair All" button	
	buyButton:SetTooltipForm(wndTooltip)
end


function RepairCostTooltip:ProduceTooltipWindow()
	local GeminiGUI = Apollo.GetPackage("Gemini:GUI-1.0").tPackage

	-- Setup the table definition for the window
	local tWindowDefinition = {
		Name			= "RepairAllTooltip",
		Template		= "CRB_TooltipSimple",
		UseTemplateBG	= true,
		Picture			= true,
		Border			= true,
		AnchorCenter	= {210,40},
		Children = {
			{
				Name 			= "Label",
				WidgetType 		= "Window",
				AnchorFill		= true,
				Text			= Apollo.GetString("Tooltips_RepairFor"),
				TextColor		= "gray"
			},
			{
				Name 			= "Amount",
				WidgetType 		= "CashWindow",
				AnchorFill		= true,
				AllowEditing	= false,
				SkipZeroes 		= true,
				TextColor		= "gray"
			},
		}		
	}
	
	-- Create the GeminiGUI window prototype object
	local tWindow = GeminiGUI:Create(tWindowDefinition)

	-- Create the instance of the window
	return tWindow:GetInstance()	
end
