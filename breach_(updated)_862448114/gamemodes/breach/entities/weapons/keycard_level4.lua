
if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_keycard4")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= ""
SWEP.Contact		= "Look at this gamemode in workshop and search for creators"
SWEP.Purpose		= "Open certain doors"
SWEP.Instructions	= "If you hold it, you can open doors with level 4"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/c_keycard4scpn.mdl"
SWEP.WorldModel		= "models/weapons/w_keycard4scpn.mdl"
SWEP.PrintName		= "Keycard Level 4"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false
SWEP.UseHands		= true


function SWEP:GetBetterOne()
	local r = math.random(1,100)
	if buttonstatus == 3 then
		if r < 50 then
			return "keycard_level5"
		else
			return "keycard_level4"
		end
	elseif buttonstatus == 4 then
		if r < 16 then
			return "keycard_omni"
		elseif r < 40 then
			return "keycard_level5"
		else
			return "keycard_level4"
		end
	end
	return "keycard_level4"
end
SWEP.droppable				= true
SWEP.clevel					= 4
SWEP.teams					= {2,3,4,6}

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false

function SWEP:Deploy()
	self.Owner:DrawViewModel( true )
end
function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end
function SWEP:Initialize()
	self:SetHoldType("normal")
	self:SetSkin(9)
end
function SWEP:Think()
	--When IN_USE then
	if self.Owner:KeyPressed(IN_USE) then
		self.Owner:SetAnimation(ACT_VM_PRIMARYATTACK)
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
end
function SWEP:Reload()
end
function SWEP:PrimaryAttack()
end
function SWEP:SecondaryAttack()
end
function SWEP:CanPrimaryAttack()
end