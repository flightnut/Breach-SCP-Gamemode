if( SERVER ) then
	AddCSLuaFile( "shared.lua" )
resource.AddFile("models/weapons/w_katana.mdl");
resource.AddFile("models/weapons/v_katana.mdl");
resource.AddFile("materials/models/weapons/v_katana/katana_normal.vtf");
resource.AddFile("materials/models/weapons/v_katana/katana.vtf");
resource.AddFile("materials/models/weapons/v_katana/katana.vmt");
end

if( CLIENT ) then
	SWEP.PrintName = "SCP-076 Katana"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end

SWEP.Author			= "Vorius"
SWEP.Instructions	= "Click to slash"
SWEP.Contact		= ""
SWEP.Purpose		= "SCP-076 Katana"
SWEP.Category		= "SCP Weapons"

SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true


SWEP.ViewModel      = "models/weapons/v_katana.mdl"
SWEP.WorldModel   	= "models/weapons/w_katana.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_Knife.Slash" )
SWEP.Primary.Delay				= 1
SWEP.Primary.Recoil				= 0
SWEP.Primary.Damage				= 1000
SWEP.Primary.NumShots			= 1
SWEP.Primary.Cone				= 0
SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic   		= false
SWEP.Primary.Ammo         		= "none"

SWEP.Secondary.Delay			= 0
SWEP.Secondary.Recoil			= 0
SWEP.Secondary.Damage			= 1000
SWEP.Secondary.NumShots			= 1
SWEP.Secondary.Cone				= 0
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic  	 	= false
SWEP.Secondary.Ammo         	= "none"

SWEP.IronSightsPos = Vector (0, 0, 0)
SWEP.IronSightsAng = Vector (-66.4823, 4.1536, 0)

SWEP.droppable = false

function SWEP:Initialize()
	--if( SERVER ) then
			--self:SetWeaponHoldType("sword");
			self:SetWeaponHoldType("melee2");
	--end

	self.mode = 1
	self.changemode = 0
	self.CanPrimary = true
	self.Weapon:SetNetworkedBool( "Ironsights", false )

	self.Hit = {
	Sound( "weapons/rpg/shotdown.wav" )};
	self.FleshHit = {
  	Sound( "ambient/machines/slicer1.wav" ),
  	Sound( "ambient/machines/slicer2.wav" ),
	Sound( "ambient/machines/slicer3.wav" ),
  	Sound( "ambient/machines/slicer4.wav" ),	 } ;
end

local IRONSIGHT_TIME = 0.25

/*---------------------------------------------------------
   Name: GetViewModelPosition
   Desc: Allows you to re-position the view model
---------------------------------------------------------*/
function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )

	if ( bIron != self.bLastIron ) then

		self.bLastIron = bIron
		self.fIronTime = CurTime()

		if ( bIron ) then
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		else
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		end

	end

	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then
		return pos, ang
	end


	local Mul = 1.0

	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then

		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )

		if (!bIron) then Mul = 1 - Mul end

	end

	local Offset	= self.IronSightsPos

	if ( self.IronSightsAng ) then

		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )


	end

	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()



	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang

	end


/*---------------------------------------------------------
	SetIronsights
---------------------------------------------------------*/
function SWEP:SetIronsights( b )

	self.Weapon:SetNetworkedBool( "Ironsights", b )

end

function SWEP:Precache()
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire(CurTime() + 0.7)
	self:SetNextSecondaryFire(CurTime() + 0.7)
	self:SetWeaponHoldType("melee2"); -- I guess?
	return true;
end

function SWEP:SecondaryAttack()
	if ( !self.IronSightsPos ) then return end
	bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )
	self:SetIronsights( bIronsights )
	self.NextSecondaryAttack = CurTime() + 0.3

if self.mode == 1 and CurTime() > self.changemode then
	self.changemode = CurTime() + 0.2
	self.mode = 2
	self:SetWeaponHoldType("normal");
	self.Owner:PrintMessage( HUD_PRINTCENTER, "Weapon Lowered" )
	self.CanPrimary = false
elseif self.mode == 2 and CurTime() > self.changemode then
	self.changemode = CurTime() + 0.2
	self.mode = 1
	--self:SetWeaponHoldType("sword");
	self:SetWeaponHoldType("melee2"); --WHY IS IT NOT USING THIS INSTEAD ASJDKHAJUSFBASFGHA
	self.Owner:PrintMessage( HUD_PRINTCENTER, "Weapon Raised" )
	self.CanPrimary = true
end
end

SWEP.NextSwing = 0

function SWEP:PrimaryAttack()
	if self.mode == 1 then
		self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self.Weapon:EmitSound( self.Primary.Sound )
		self:Slash()
		self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end
	if self.mode == 2 then
		self.Owner:PrintMessage( HUD_PRINTCENTER, "Cannot attack!" )
	end
end

function SWEP:Slash()
 	local trace = self.Owner:GetEyeTrace();
	if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 70 then

		bullet = {}
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 14
		bullet.Damage = 1000
		if( trace.Entity:IsPlayer() or trace.Entity:IsNPC() or trace.Entity:GetClass()=="prop_ragdoll" ) then
			self.Owner:EmitSound( self.FleshHit[math.random(1,#self.FleshHit)] );
			if trace.Entity:IsPlayer() then
				if trace.Entity:Team() == TEAM_SCP then
					--Don't Shoot them!
					return -- We cannot slash them, they're our friend
				else
					bullet.Damage = math.random(35,50)
				end
			end
		else
			bullet.Damage = math.random(5,14)
			self.Owner:EmitSound( self.Hit[math.random(1,#self.Hit)] );
		end
			self.Owner:FireBullets(bullet)
	end
end


--[[
	local ActIndex = {}
	ActIndex["pistol"] 		= ACT_HL2MP_IDLE_PISTOL
	ActIndex["smg"] 			= ACT_HL2MP_IDLE_SMG1
	ActIndex["grenade"] 		= ACT_HL2MP_IDLE_GRENADE
	ActIndex["ar2"] 			= ACT_HL2MP_IDLE_AR2
	ActIndex["shotgun"] 		= ACT_HL2MP_IDLE_SHOTGUN
	ActIndex["rpg"]	 		= ACT_HL2MP_IDLE_RPG
	ActIndex["physgun"] 		= ACT_HL2MP_IDLE_PHYSGUN
	ActIndex["crossbow"] 		= ACT_HL2MP_IDLE_CROSSBOW
	ActIndex["melee"] 		= ACT_HL2MP_IDLE_MELEE
	ActIndex["slam"] 			= ACT_HL2MP_IDLE_SLAM
	ActIndex["normal"]		= ACT_HL2MP_IDLE
	ActIndex["knife"]			= ACT_HL2MP_IDLE_KNIFE
	ActIndex["sword"]			= ACT_HL2MP_IDLE_MELEE2
	ActIndex["passive"]		= ACT_HL2MP_IDLE_PASSIVE
	ActIndex["fist"]			= ACT_HL2MP_IDLE_FIST

function SWEP:SetWeaponHoldType(t)
	local index = ActIndex[t]
	if (index == nil) then
		Msg("SWEP:SetWeaponHoldType - ActIndex[ \""..t.."\" ] isn't set!\n")
		return
	end
	self.ActivityTranslate = {}
	self.ActivityTranslate [ACT_HL2MP_IDLE] 					= index
	self.ActivityTranslate [ACT_HL2MP_WALK] 					= index + 1
	self.ActivityTranslate [ACT_HL2MP_RUN] 					= index + 2
	self.ActivityTranslate [ACT_HL2MP_IDLE_CROUCH] 				= index + 3
	self.ActivityTranslate [ACT_HL2MP_WALK_CROUCH] 				= index + 4
	self.ActivityTranslate [ACT_HL2MP_GESTURE_RANGE_ATTACK] 		= index + 5
	self.ActivityTranslate [ACT_HL2MP_GESTURE_RELOAD] 			= index + 6
	self.ActivityTranslate [ACT_HL2MP_JUMP] 					= index + 7
	self.ActivityTranslate [ACT_RANGE_ATTACK1] 				= index + 8
end

function SWEP:TranslateActivity(act)
	if (self.Owner:IsNPC()) then
		if (self.ActivityTranslateAI[act]) then
			return self.ActivityTranslateAI[act]
		end
		return -1
	end
	if (self.ActivityTranslate[act] != nil) then
		return self.ActivityTranslate[act]
	end
	return -1
end
]]--

function SWEP:DoImpactEffect( tr, nDamageType )
	util.Decal("ManhackCut", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	return true;

end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
end
end
