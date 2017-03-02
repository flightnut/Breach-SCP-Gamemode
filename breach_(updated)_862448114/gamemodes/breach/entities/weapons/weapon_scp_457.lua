AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_457")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= ""
SWEP.Contact		= "Look at this gamemode in workshop and search for creators"
SWEP.Purpose		= "Burn"
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/vinrax/props/keycard.mdl"
SWEP.WorldModel		= "models/vinrax/props/keycard.mdl"
SWEP.PrintName		= "SCP-457"
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

--------------------------------------------------------------------------
--	Configure Health and Wait time between heals here					--
-- Do note that the heal amount is per player burning					--
-- Example:  Amount is set to 1, cooldown to 0.3; There's 5 players		--
--				It will heal 457 by 5 hp every 0.3 seconds on average	--
--------------------------------------------------------------------------
Link2006_457BurnHealAmount = 1 
Link2006_457BurnHealCooldown = 0.2 
--Heal system by Link2006, Please optimize it 


function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end
function SWEP:DrawWorldModel()
end
function SWEP:Initialize() --Init the weapon
	self:SetHoldType("normal")
	--Link2006's Heal System 
	if self.Cooldown == nil then --Is there a table inside the weapon? 
		self.Cooldown = {} --Init a table please, we need it later.
	end 
end

function SWEP:Think()
	if SERVER then
		self.Owner:Ignite(0.1,100)
		for k,v in pairs(ents.FindInSphere( self.Owner:GetPos(), 125 )) do
			if v:IsPlayer() then
				if v:Team() != TEAM_SCP and v:Team() != TEAM_SPEC then
					v:Ignite(0.3,100)
					--Heal buff by Link2006, Please optimize it. I put it here just in case it's needed
					if self.Cooldown == nil then --this is nil.
						print("[SCP-457] CoolDown table for 457 is nil while we're in Think()? FIX ME")
						self.Cooldown = {} --Init a table please
					end 
					
					if self.Cooldown[v:UserID()] == nil and v:IsOnFire() then --If there is no value in that table for this UserID and that IS on fire.
						--print("Burning "..v:UserID()) -- Debug 
						self.Cooldown[v:UserID()] = true  --Set it to true 
						self.Owner:SetHealth(self.Owner:Health()+Link2006_457BurnHealAmount) --Heal the owner 
						timer.Simple(Link2006_457BurnHealCooldown, function() --wait 0.3 seconds
							self.Cooldown[v:UserID()] = nil --make it nil 
							--Then remove it maybe? 
						end)
					end
					--END--
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
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:CanPrimaryAttack()
	return true
end