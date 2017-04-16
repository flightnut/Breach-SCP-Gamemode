AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_966")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= "Kanade"
SWEP.Contact		= "Look at this gamemode in workshop and search for creators"
SWEP.Purpose		= "Kill humans"
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/vinrax/props/keycard.mdl"
SWEP.WorldModel		= "models/vinrax/props/keycard.mdl"
SWEP.PrintName		= "SCP-966"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.ISSCP = true
SWEP.droppable				= false
SWEP.teams					= {1}
SWEP.Primary.Ammo			= "none"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false

SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end
function SWEP:DrawWorldModel()
end
function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:Think()
	if SERVER then
		for k,v in pairs(ents.FindInSphere( self.Owner:GetPos(), 300 )) do
			if v:IsPlayer() then
				if v:Team() ~= TEAM_SCP and v:Team() ~= TEAM_SPEC then
					if self.Owner.nextexp == nil then self.Owner.nextexp = 0 end
					if self.Owner.nextexp < CurTime() then
						v:TakeDamage(1, self.Owner, self)
						v:SendLua('last996attack = 1')
						--self.Owner:AddExp(1)
						self.Owner.nextexp = CurTime() + 1
					end
				end
			end
		end
	end
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
	//if ( !self:CanPrimaryAttack() ) then return end
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if SERVER then
		local ent = self.Owner:GetEyeTrace().Entity
		if(ent:GetPos():Distance(self.Owner:GetPos()) < 125) then
			if ent:IsPlayer() then
				if ent:Team() == TEAM_SCP then return end
				if ent:Team() == TEAM_SPEC then return end
				//ent:SetSCP0492()
				//roundstats.zombies = roundstats.zombies + 1
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 1000, self.Owner, self.Owner )
				elseif ent:GetClass() == 'prop_dynamic' then
					if string.lower(ent:GetModel()) == 'models/foundation/containment/door01.mdl' then
						ent:TakeDamage( math.Round(math.random(9,12)), self.Owner, self.Owner )
						ent:EmitSound(Sound('MetalGrate.BulletImpact'))
					end
				end
			end
		end
	end
end

local Next966Sound = 0

function SWEP:SecondaryAttack()
	if Next966Sound > CurTime() then return end
	Next966Sound = CurTime() + 10 --can play the sound every 10 seconds.
	self.Owner:EmitSound(Sound('966chasing.wav'))
end

function SWEP:CanPrimaryAttack()
	return true
end
