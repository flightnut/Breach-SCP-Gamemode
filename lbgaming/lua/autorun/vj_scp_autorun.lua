/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------ Addon Information ------------------
local PublicAddonName = "SCP SNPCs"
local AddonName = "SCP"
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_scp_autorun.lua"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')

	local vCat = "SCP"
	
	VJ.AddNPC("SCP-066","npc_scp_066",vCat)
	VJ.AddNPC("SCP-939 [Specimen 1]","npc_scp_939a",vCat)
	VJ.AddNPC("SCP-939 [Specimen 2]","npc_scp_939b",vCat)
	VJ.AddNPC("SCP-939 [Specimen 3]","npc_scp_939c",vCat)
	VJ.AddNPC("SCP-9992","npc_scp_9992",vCat)
	VJ.AddNPC("SCP-131a2","npc_scp_131a2",vCat)
	VJ.AddNPC("SCP-131b2","npc_scp_131b2",vCat)
	
	-- ConVars --
	VJ.AddConVar("vj_scp_066_h",999999)
	
	VJ.AddConVar("vj_scp_939_h1",1500)
	VJ.AddConVar("vj_scp_939_h2",2000)
	VJ.AddConVar("vj_scp_939_d",30)

-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if (CLIENT) then
		chat.AddText(Color(0,200,200),PublicAddonName,
		Color(0,255,0)," was unable to install, you are missing ",
		Color(255,100,0),"VJ Base!")
	end
	timer.Simple(1,function()
		if not VJF then
			if (CLIENT) then
				VJF = vgui.Create("DFrame")
				VJF:SetTitle("ERROR!")
				VJF:SetSize(790,560)
				VJF:SetPos((ScrW()-VJF:GetWide())/2,(ScrH()-VJF:GetTall())/2)
				VJF:MakePopup()
				VJF.Paint = function()
					draw.RoundedBox(8,0,0,VJF:GetWide(),VJF:GetTall(),Color(200,0,0,150))
				end
				
				local VJURL = vgui.Create("DHTML",VJF)
				VJURL:SetPos(VJF:GetWide()*0.005, VJF:GetTall()*0.03)
				VJURL:Dock(FILL)
				VJURL:SetAllowLua(true)
				VJURL:OpenURL("https://sites.google.com/site/vrejgaming/vjbasemissing")
			elseif (SERVER) then
				timer.Create("VJBASEMissing",5,0,function() print("VJ Base is Missing! Download it from the workshop!") end)
			end
		end
	end)
end