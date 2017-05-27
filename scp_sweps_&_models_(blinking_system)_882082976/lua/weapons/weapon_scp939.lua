SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay          = 2
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "None"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "None"
SWEP.Weight					= 3
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true
SWEP.IdleAnim				= true
SWEP.IconLetter			= "w"
SWEP.Primary.Sound = ("")

SWEP.UseHands = true

SWEP.Author 		= "DjBuRnOuT"
SWEP.Purpose		= "Kill people"
SWEP.Category       = "SCP Sweps & Models"
SWEP.Instructions	= "LMB to kill someone | RMB to play the attack sound"

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/vinrax/props/keycard.mdl"
SWEP.WorldModel		= "models/vinrax/props/keycard.mdl"

SWEP.PrintName		= "SCP 939"
SWEP.HoldType		= "normal"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Initialize()
	util.PrecacheSound("")
end

function SWEP:NormalSpeed() -- Resets the speed
	if self.Owner:IsValid() then
	self.Owner:SetRunSpeed(260)
	self.Owner:SetWalkSpeed(150)
	end
end

function SWEP:CustomSpeed() -- New speed
	if self.Owner:IsValid() then
	self.Owner:SetRunSpeed(260)
	self.Owner:SetWalkSpeed(150)
	end
end

function SWEP:DrawHUD() -- Show HUD
	if disablehud == true then return end

	local showtext = "Ready to attack"
	local showcolor = Color(0,255,0)
end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )

 	local trace = self.Owner:GetEyeTrace();
	if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then
			self.Owner:SetAnimation( PLAYER_ATTACK1 );
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
				bullet = {}
				bullet.Num    = 1
				bullet.Src    = self.Owner:GetShootPos()
				bullet.Dir    = self.Owner:GetAimVector()
				bullet.Spread = Vector(0, 0, 0)
				bullet.Tracer = 0
				bullet.Force  = 25
				bullet.Damage = 10000
			self.Owner:FireBullets(bullet)
	else
		self.Owner:SetAnimation( PLAYER_ATTACK1 );
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
		self.Weapon:EmitSound( ""..math.random(1,4)..".wav" )
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + 0.43 )
end

function SWEP:Deploy()
	if self.Owner:IsValid() then
	self:CustomSpeed() -- call the custom speed funciton above
	self.Owner:SetViewOffset(Vector(0,0,90))
	self.Weapon:EmitSound( ""..math.random(1,3)..".wav" )
	//self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
    //self:SetDeploySpeed( self.Weapon:SequenceDuration(0.2) )
	//self.Weapon:SendWeaponAnim( ACT_VM_IDLE )

	self:SendWeaponAnim( ACT_VM_DRAW )
	timer.Simple(0.2, function(wep) self:SendWeaponAnim(ACT_VM_IDLE) end)
	end
	return true;
end

function SWEP:SecondaryAttack()
	self.Owner:EmitSound("weapon/attack.ogg",  SNDLVL_100dB, 100, 1,  CHAN_WEAPON)
end