AddCSLuaFile()

SWEP.PrintName			= "SCP-343"
SWEP.Author				= "azuspl" 
SWEP.Instructions		= "Lewym atakujesz"--Left click to bite, Right click to bark, Reload to Growl."
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Category	= "Other"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"
SWEP.Primary.Distance		= 100
SWEP.Primary.Delay			= 1

SWEP.HoldType			= "normal"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"
SWEP.Secondary.Delay	= 1

SWEP.ISSCP = true
SWEP.droppable				= false
SWEP.teams					= {1}
SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Slot			= 1
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/c_arms.mdl"
SWEP.WorldModel	= ""
SWEP.Nightvision = false
SWEP.NextReload = CurTime()
SWEP.NextAttackH = 2
SWEP.NextAttackW = 40
SWEP.NextAttackWW = 5
SWEP.NextLunge = 30
SWEP.AttackDelay1 = 7
SWEP.AttackDelay2 = 5
SWEP.IsFaster = false
SWEP.BoostEnd = 0
SWEP.OrigWalk = 200
SWEP.OrigRun = 300
SWEP.OrigMax = 400
SWEP.OrigJump = 200


local bellen = "weapons/massif/bellenneu.mp3"
local bite = "weapons/massif/bite.wav"
local knurren = "weapons/massif/knurrenneu.mp3"

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end

	local tr = self.Owner:GetEyeTrace().Entity
		if not tr:IsValid() then return end
		if tr:GetPos():Distance( self.Owner:GetPos() ) > self.Primary.Distance then return end
		--if not tr:IsPlayer() then return end
		if SERVER then
			if tr:GetClass() == "func_breakable" then
				tr:TakeDamage( 100, self.Owner, self.Owner )
			end
	
	if self.NextAttackWW > CurTime() then
		if SERVER then
			self.Owner:PrintMessage(2, "Umiejętność ładuje się. Za chwile znów użyjesz miotacza!")
			return
		end
	end
	self.NextAttackWW = CurTime() + self.AttackDelay2
			if tr:IsPlayer() then
				if tr:Team() == TEAM_SCP then return end
				if tr:Team() == TEAM_SPEC then return end
				self:Shooting()
		local function RemoveBuff2()
		end
		timer.Create("SCP_PLAYER_WILL_LOSE_BUFF2", 7, 1, RemoveBuff2)
	end
end
end

if ( SERVER ) then
	util.AddNetworkString( "RASKO_NightvisionOn" )
	util.AddNetworkString( "RASKO_NightvisionOff" )
end

function SWEP:Reload()

	if ( SERVER ) then
		if self.NextReload > CurTime() then return end
	
		self.NextReload = CurTime() + 2
		local ply = self:GetOwner()
		if self.Nightvision == false then
			self.Nightvision = true
			net.Start( "RASKO_NightvisionOn" )
			net.WriteEntity( ply )
			net.Send( ply )
		elseif self.Nightvision == true then
			self.Nightvision = false
			net.Start( "RASKO_NightvisionOff" )
			net.WriteEntity( ply )
			net.Send( ply )
		end
	end
	
end

function SWEP:Holster()

	if ( SERVER ) then
		local ply = self:GetOwner()
		self.Nightvision = false
		net.Start( "RASKO_NightvisionOff" )
		net.WriteEntity( ply )
		net.Send( ply )
		return true
	end
	
end

if( CLIENT ) then

	net.Receive( "RASKO_NightvisionOn", function ( len, ply )
		local ply = net.ReadEntity()
		am_nightvision = DynamicLight( 0 )
		if ( am_nightvision ) then
			am_nightvision.Pos = ply:GetPos()
			am_nightvision.r = 11
			am_nightvision.g = 50
			am_nightvision.b = 4
			am_nightvision.Brightness = 1
			am_nightvision.Size = 2000
			am_nightvision.DieTime = CurTime()+100000
			am_nightvision.Style = 1
		end
		timer.Create( "RASKO_LightTimer", 0.05, 0, function()
			am_nightvision.Pos = ply:GetPos()
		end)
	end)
	
	net.Receive( "RASKO_NightvisionOff", function ( len, ply )
		local ply = net.ReadEntity()
		timer.Destroy( "RASKO_LightTimer" )
		if am_nightvision then
			am_nightvision.DieTime = CurTime()+0.1
		end
	end)

end

function SWEP:Shooting()

	self:Anim()

	if ( CLIENT ) then return end
	
	local ent = ents.Create("energyconc_ent")
	if (  !IsValid( ent ) ) then return end
	ent:SetPos(self.Owner:GetShootPos() + self.Owner:EyeAngles():Right() * 10 + self.Owner:GetAimVector() * 20 - self.Owner:EyeAngles():Up() * 4)
	ent:SetAngles( self.Owner:EyeAngles() )
	ent:SetOwner(self.Owner)
	ent:SetModel("models/hunter/plates/plate.mdl")
	ent:Spawn()
	
	local phys = ent:GetPhysicsObject()
	if (  !IsValid( phys ) ) then ent:Remove() return end
	
	phys:SetMass(1)
	phys:EnableGravity(false)
	phys:ApplyForceCenter(self.Owner:GetAimVector() * 5000)
end

function SWEP:Anim()
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:ViewPunch(Angle(math.Rand(-0.25, -0.15), math.Rand(-0.23, 0.23), 0.1 ))
end

function SWEP:SecondaryAttack()
end