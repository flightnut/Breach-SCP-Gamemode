AddCSLuaFile()

SWEP.PrintName = "SCP-3108"
SWEP.Author = "Tsujimoto18"
SWEP.Category = "SCP Weapons"
SWEP.Instructions = "Press LMB to shoot."
SWEP.WorldModel	= "models/weapons/w_pistol.mdl"
SWEP.ViewModel = "models/weapons/c_pistol.mdl"

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.UseHands = true
SWEP.DrawCrosshair = true

SWEP.SlotPos = 20

SWEP.Primary.Ammo = "3108"
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1

function SWEP:CanSecondaryAttack()

	return false

end

function SWEP:PrimaryAttack()

	if (!self:CanPrimaryAttack()) then return end
	if (!IsFirstTimePredicted()) then return end
	
	self.Weapon:EmitSound("weapons/crossbow/fire1.wav")
	local hit = self.Owner:GetEyeTrace()
	
	if ((IsValid(hit.Entity)) and (hit.Entity:IsPlayer()) and (hit.Entity:Alive())) then
	
		if (SERVER) then
			hit.Entity:SetModel("models/winningrook/gtav/bigfoot/bigfoot.mdl")
		end
	
	end

end
