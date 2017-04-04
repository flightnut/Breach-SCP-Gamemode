AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_049")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= ""
SWEP.Contact		= "Look at this gamemode in workshop and search for creators"
SWEP.Purpose		= "Cure"
SWEP.Instructions	= "LMB to cure someone"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/vinrax/props/keycard.mdl"
SWEP.WorldModel		= "models/vinrax/props/keycard.mdl"
SWEP.PrintName		= "SCP-049"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.AttackDelay			= 0.25
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
SWEP.Secondary.Automatic	= false
SWEP.NextAttackW			= 0

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end
function SWEP:DrawWorldModel()
end
function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:RenderLight()
	if self.toggleLight ~= true then return end --If Not true, return.
	if CLIENT then
		if IsValid(scp_nightVision) == false then
			scp_nightVision = DynamicLight( self.Owner:EntIndex() ) --Do not take 0, Used for NV. This should be
		end
		if ( scp_nightVision ) then --Welp. :|
			scp_nightVision.Pos = self.Owner:GetPos()
			scp_nightVision.r = 128
			scp_nightVision.g = 128
			scp_nightVision.b = 128
			scp_nightVision.Brightness = 0.85
			scp_nightVision.Size = 900
			scp_nightVision.DieTime = CurTime()+0.25 --Don't let it stay please.
			scp_nightVision.Style = 0 -- https://developer.valvesoftware.com/wiki/Light_dynamic#Appearances
		end
	end
end


function SWEP:Think()
	if CLIENT then self:RenderLight() end
end

scp_toggleLight_cooldown = 0
function SWEP:Reload()
	if scp_toggleLight_cooldown >= CurTime() then return end
	if self.toggleLight then
		self.toggleLight = false
	else
		self.toggleLight = true
	end
	scp_toggleLight_cooldown = CurTime() + 2
end

function SWEP:PrimaryAttack()
	//if ( !self:CanPrimaryAttack() ) then return end
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if self.NextAttackW > CurTime() then return end
	self.NextAttackW = CurTime() + self.AttackDelay
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
				ent:SetSCP0492()
				roundstats.zombies = roundstats.zombies + 1
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 100, self.Owner, self.Owner )
				elseif ent:GetClass() == 'prop_dynamic' then
					if string.lower(ent:GetModel()) == 'models/foundation/containment/door01.mdl' then
						ent:TakeDamage( 25, self.Owner, self.Owner )
						ent:EmitSound(Sound('MetalGrate.BulletImpact'))
					end
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

function SWEP:DrawHUD()
	if disablehud == true then return end

	local showtext = "Ready to attack"
	local showcolor = Color(0,255,0)

	if self.NextAttackW > CurTime() then
		showtext = "Next attack in " .. math.Round(self.NextAttackW - CurTime())
		showcolor = Color(255,0,0)
	end

	local NvKey = input.LookupBinding('+reload') --Get key for reload
	if type(NvKey) == 'no value' then NvKey = 'NOT BOUND' end -- The key is not bound!

	draw.Text( {
		text = "Press "..NvKey.." for nightvision",
		pos = { ScrW() / 2, ScrH() - 50 },
		font = "173font",
		color = showcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})

	draw.Text( {
		text = showtext,
		pos = { ScrW() / 2, ScrH() - 30 },
		font = "173font",
		color = showcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})

	local x = ScrW() / 2.0
	local y = ScrH() / 2.0

	local scale = 0.3
	surface.SetDrawColor( 0, 255, 0, 255 )

	local gap = 5
	local length = gap + 20 * scale
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )
end
