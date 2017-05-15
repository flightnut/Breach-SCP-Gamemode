
AddCSLuaFile()

SWEP.PrintName				= "Veryhard"
SWEP.Category				= "CLAWS"

SWEP.Slot					= 1
SWEP.SlotPos 				= 2

SWEP.Spawnable				= true

SWEP.ViewModel				= ""
SWEP.WorldModel 			= ""
SWEP.DrawWorldModel			= false
SWEP.ViewModelFOV			= 60
SWEP.ISSCP 					= true
SWEP.AdminOnly				= false
SWEP.UseHands				= false
SWEP.Dropable				= false

SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 5
--SWEP.teams					= {1}
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Anim 					= 0

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"
SWEP.droppable 				= false
SWEP.Damage 				= 25
SWEP.AttackTeams	= {2,3,4,6}
SWEP.AttackNPCs				= false
SWEP.DamageType				= DMG_SLASH
SWEP.NextAttackH			= 2
SWEP.NextAttackW			= 30
SWEP.NextLunge				= 30
SWEP.AttackDelay1			= 3
SWEP.AttackDelay2			= 60
SWEP.HitDistance			= 75
SWEP.HitRate				= 0.2
SWEP.AutoSwitchTo 			= true
SWEP.AutoSwitchFrom 		= false

SWEP.HitSound				= Sound("CLAW_HIT")
SWEP.SwingSound				= Sound("CLAW_SWING")

if CLIENT then
	SWEP.DrawWeaponInfoBox	= false
	SWEP.BounceWeaponIcon 	= false
end

function SWEP:Initialize()
	self:SetHoldType( "knife") 
end

function SWEP:PrimaryAttack()
	if self.NextAttackH > CurTime() then return end
	self.NextAttackH = CurTime() + self.AttackDelay1
	if SERVER then
		local ent = nil
		local tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 100 ),
			filter = self.Owner,
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			mask = MASK_SHOT_HULL
		} )
		ent = tr.Entity
		if IsValid(ent) then
			if ent:IsPlayer() then
				if ent:Team() == TEAM_SCP then return end
				if ent:Team() == TEAM_SPEC then return end
				ent:Kill()
				ent:EmitSound("sfx/player/death4.ogg", 500, 200)
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 100, self.Owner, self.Owner )
				elseif ent:IsNPC() then
					ent:TakeDamage( 20000, self.Owner, self.Owner )
			    elseif ent:GetClass() == 'prop_dynamic' then
					if string.lower(ent:GetModel()) == 'models/foundation/containment/door01.mdl' then
						ent:TakeDamage( math.Round(math.random(10,52)), self.Owner, self.Owner )
						ent:EmitSound(Sound('MetalGrate.BulletImpact'))
					end
				end
				
			end
		end
	end
	self.Weapon:SetNextPrimaryFire( CurTime() + self.HitRate )
    self.Weapon:SetNextSecondaryFire( CurTime() + self.HitRate )
    self.Owner:EmitSound(self.SwingSound, 75, 100)
    timer.Create("hitdelay", 0.1, 1, function() self.HitWait(self) end)
    timer.Start( "hitdelay" )
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end

function SWEP:OnDrop()	
end

function SWEP.HitWait(self)

	local tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -5, -5, -5 ),
			maxs = Vector( 5, 5, 5 ),
			mask = MASK_SHOT_HULL  
		} )
 
	if ( tr.Hit ) then

		if ( SERVER and string.find(tr.Entity:GetClass(),"player")) then
			tr.Entity:EmitSound(self.HitSound, 150, 100)
			if tr.Entity:Health() > self.Damage then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self.Owner) 
			dmginfo:SetInflictor(self) 
			dmginfo:SetDamage(self.Damage) 
			dmginfo:SetDamageType(self.DamageType) 
			tr.Entity:TakeDamageInfo(dmginfo)
		else
			local nade = ents.Create("prop_ragdoll")
			nade:SetModel( tr.Entity:GetModel())		
			nade:SetPos(tr.Entity:GetPos())
			nade:SetAngles(tr.Entity:EyeAngles())
			tr.Entity:KillSilent() 
			nade:Spawn()
		end
	else 
		if ( SERVER and string.find(tr.Entity:GetClass(),"npc")) then
		
			tr.Entity:EmitSound(self.HitSound, 75, 100)
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self.Owner)
			dmginfo:SetInflictor(self) 
			dmginfo:SetDamage(self.Damage) 
			dmginfo:SetDamageForce(self.Owner:GetAimVector() * self.Damage )
			dmginfo:SetDamageType(self.DamageType) 
			tr.Entity:TakeDamageInfo(dmginfo)	
		else 
		if ( SERVER and string.find(tr.Entity:GetClass(),"prop_ragdoll")) then
			
			if tr.Entity:GetMaterialType() == MAT_FLESH then
				tr.Entity:EmitSound(self.HitSound, 100, 100)
				
			if tr.Entity:GetMaterial() ~=  "models/zombie_fast/fast_zombie_sheet" then

				tr.Entity:SetMaterial("models/zombie_fast/fast_zombie_sheet",true)
			else
				self.Owner:SetHealth( self.Owner:Health() + tr.Entity:GetPhysicsObject():GetMass() )
				self:SetClip1(self:Clip1() + 1)
				tr.Entity:Remove()
			end
			end
			
			if tr.Entity:GetMaterialType() == MAT_ALIENFLESH or tr.Entity:GetMaterialType() == MAT_ANTLION then
				tr.Entity:EmitSound(self.HitSound, 75, 100)
				
			if tr.Entity:GetMaterial() ~=  "models/antlion/antlion_innards" then
				tr.Entity:SetMaterial("models/antlion/antlion_innards",true) 
			else
				self.Owner:SetHealth( self.Owner:Health() + tr.Entity:GetPhysicsObject():GetMass() )
				self:SetClip1(self:Clip1() + 1)
				tr.Entity:Remove()
				end	
			end
			end
		end
end
end
end

function SWEP:Deploy()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "idle" ) ) 
end

function SWEP:Reload()
end

function SWEP:Holster()
	return true
end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {} 
 
	self.AmmoDisplay.Draw = true //draw the display?
 
	self.AmmoDisplay.PrimaryClip = self:Clip1() //amount in clip
 
	return self.AmmoDisplay //return the table
end

function SWEP:OnRemove()
	timer.Remove("hitdelay")
	return true
end