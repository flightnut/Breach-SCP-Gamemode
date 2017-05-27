AddCSLuaFile()

SWEP.Author			= "DjBuRnOuT"
SWEP.Contact		= "http://steamcommunity.com/id/djburnouttt"
SWEP.Purpose		= "Scream"
SWEP.Instructions	= "LMB to say eric, RMB to play the Beethoven sound"
SWEP.Category       = "SCP Sweps & Models"
SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
--SWEP.ViewModel		= "models/vinrax/props/keycard.mdl"
--SWEP.WorldModel		= ""
SWEP.PrintName		= "SCP 066"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= true
SWEP.AdminSpawnable	= false

SWEP.AttackDelay			= 0.25
SWEP.droppable				= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false

SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Automatic	= false
SWEP.Secondary.NextAttack = 0
SWEP.Secondary.Delay = 1
SWEP.NextAttackW = 0
SWEP.Primary.Delay = 5
SWEP.Primary.Damage = 20
SWEP.oldv = 60
SWEP.AttackIsActive = false

function SWEP:Initialize()
	util.PrecacheSound("weapon/eric1.ogg")
	util.PrecacheSound("weapon/beethoven.ogg")
	self:SetHoldType("normal")
end
function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
	self.Owner:DrawWorldModel(false)
	self.Owner:SetViewOffset(Vector(0,0,30))
end
function SWEP:Holster()
	self.Owner:SetViewOffset(Vector(0,0,60))
	return true
end
function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if CurTime() < self.NextAttackW then return end
	self.AttackIsActive = true
	self.Owner:EmitSound("weapon/eric1.ogg",  SNDLVL_100dB, 100, 1,  CHAN_WEAPON)
end
function SWEP:SecondaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if CurTime() < self.NextAttackW then return end
	self.AttackIsActive = true
	self.Owner:EmitSound("weapon/beethoven.ogg",  SNDLVL_100dB, 100, 1,  CHAN_WEAPON)
end
