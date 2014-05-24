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
	local tooltip = ""
	if self.wndVendor:FindChild("VendorTab3"):IsChecked() then -- Repair tab is checked on vendor
		if not self.wndVendor:FindChild("Buy"):GetData() then -- GetData is present on single, but not all, repairs
			local total = 0
			for _,v in pairs(self.tRepairableItems) do
				total = total + v.itemData:GetRepairCost()
			end 
			tooltip = total
		end
	end
		
	self.wndVendor:FindChild("Buy"):SetTooltip(tooltip)
end

