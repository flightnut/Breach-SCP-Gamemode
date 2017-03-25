util.AddNetworkString("openScpInventory")
util.AddNetworkString("SCP1123flash")
util.AddNetworkString("SCP1123flash_lvl1")
util.AddNetworkString("SCP35manipulation")
util.AddNetworkString("SCP35manipulation_lvl1")
util.AddNetworkString("dropItemSCP")
util.AddNetworkString("useItemSCP")

--[[--

local pl = FindMetaTable("Player")

function pl:SCP_GiveHealth( heal )
self:SetHealth(self:Health() + heal )
if self:Health() > 100 then
self:SetHealth(100)
end
self:EmitSound("scp/pickitem.mp3")
end

function pl:SCP_GiveArmor( armor )
self:SetArmor(self:Armor() + armor )
if self:Armor() > 100 then
self:SetArmor(100)
end
self:EmitSound("scp/pickitem.mp3")
end

function pl:SCP_EquipHazmat()
if self:GetModel() != "models/materials/humans/group03m/male_09.mdl" then
self.SCP_OldModel = self:GetModel()
end
self.HasHazmat = true
self:SetModel("models/materials/humans/group03m/male_09.mdl")
self:EmitSound("scp/PickItem0.mp3")
end

net.Receive("dropItemSCP", function(len, ply)
local slot = net.ReadInt( 32 )

local ent = ents.Create( ply.SCPinv[slot].ent )
ent:SetPos( ply:GetShootPos() + (ply:GetAimVector() * 50) ) 
ent:SetAngles( ply:GetAngles() ) 
ent:Spawn()

ply.SCPinv[slot].ID = ""
ply.SCPinv[slot].img = ""
ply.SCPinv[slot].ent = ""

table.remove( ply.SCPinv, slot)
end)

net.Receive("useItemSCP", function(len, ply)
local slot = net.ReadInt( 32 )

if ply.SCPinv[slot].ent == "ent_fak" && ply:Health() < 100 then
ply:SCP_GiveHealth( 28 )
table.remove( ply.SCPinv, slot)
elseif ply.SCPinv[slot].ent == "ent_bfak" && ply:Health() < 100 then
ply:SCP_GiveHealth( 50 )
table.remove( ply.SCPinv, slot)
elseif ply.SCPinv[slot].ent == "ent_hazmat_suit" && !ply.HasHazmat then
ply:SCP_EquipHazmat()
table.remove( ply.SCPinv, slot)
elseif ply.SCPinv[slot].ent == "ent_inv_vest" && ply:Armor() < 100 then
ply:SCP_GiveArmor(100)
table.remove( ply.SCPinv, slot)
else

end


end)


hook.Add( "PlayerSay", "SCP_Say", function( ply, text, team )
	if string.lower(text) == "/scpinv" then 
		if ply.SCPinv == nil then
			ply.SCPinv  = {}
		end
		
		net.Start("openScpInventory")
		net.WriteTable(ply.SCPinv)
		net.Send(ply)
		return ""
		
	end
	
	if text == "/drophazmat" && ply.HasHazmat == true then 
		ply:SetModel(ply.SCP_OldModel)
		ply.HasHazmat  = false
		ply.SCP_OldModel = nil 
		local ent = ents.Create("ent_hazmat_suit")
		ent:SetPos( ply:GetShootPos() + (ply:GetAimVector() * 50) ) 
		ent:SetAngles( ply:GetAngles() ) 
		ent:Spawn()
		return ""
	end
	
end )
--]]--

hook.Add("PlayerSpawn","SCP_SpawnPlayer", function(ply)
	ply.HasTouched1123 = false
	ply.HasSCP1123_lvl = 0
	ply.MaskControl = false
	ply.SCP35mindControl = 0 
end)
	
	
hook.Add( "PlayerDeath", "SCP_Death", function(  victim, inflictor, attacker )
	if victim.SCPinv then
		victim.SCPinv = {}
	end
end )