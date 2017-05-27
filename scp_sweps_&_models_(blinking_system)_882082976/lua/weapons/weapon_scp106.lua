if SERVER then
	concommand.Add("scp106_set",function(ply)
		local tppoints = file.Read("scp_106.txt","DATA")
		if not tppoints or string.len(tppoints) <= 0 then tppoints = "" end
		local tpTable = util.JSONToTable(tppoints)
		if not tpTable then tpTable = {} end

		tpTable[game.GetMap()] = ply:GetPos()
		file.Write("scp_106.txt",util.TableToJSON(tpTable))
	end)

	function SCP106GetTPPos()
		local fl = file.Read("scp_106.txt","DATA")
		if not fl or string.len(fl) <= 0 then return end
		local tpTable = util.JSONToTable(fl)
		if not tpTable then return end
		if not tpTable[game.GetMap()] then return end

		return tpTable[game.GetMap()]
	end
end

AddCSLuaFile()

SWEP.Author 		= "DjBuRnOuT"
SWEP.Purpose		= "Kill people"
SWEP.Category       = "SCP Sweps & Models"
SWEP.Instructions	= "LMB to teleport someone"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
--SWEP.ViewModel		= "models/vinrax/props/keycard.mdl"
--SWEP.WorldModel		= "models/vinrax/props/keycard.mdl"

SWEP.PrintName		= "SCP 106"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.HoldType		= "normal"
SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true

SWEP.AttackDelay	= 0.25
SWEP.ISSCP 			= true
SWEP.droppable		= false
SWEP.NextAttackW	= 0

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end
function SWEP:DrawWorldModel()
end
function SWEP:Initialize()
	self:SetHoldType("normal")
end
function SWEP:Holster()
	return true
end
function SWEP:CanPrimaryAttack()
	return true
end
function SWEP:HUDShouldDraw( element )
	local hide = {
		CHudAmmo = true,
		CHudSecondaryAmmo = true,
	}
	if hide[element] then return false end
	return true
end
function SWEP:SecondaryAttack()
	return false
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	if self.NextAttackW > CurTime() then return end
	self.NextAttackW = CurTime() + self.AttackDelay
	if SERVER then
		local ent = self.Owner:GetEyeTrace().Entity
		if not (ent:GetPos():Distance(self.Owner:GetPos()) < 150) then return end
		if not ent:IsPlayer() then return end
		local weapon = ent:GetActiveWeapon()
		if weapon and weapon.ISSCP then return end

		local tppos = SCP106GetTPPos()
		if not tppos then return end
		ent:SetPos(tppos)
	end
end