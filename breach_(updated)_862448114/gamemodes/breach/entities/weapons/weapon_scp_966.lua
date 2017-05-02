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

function SWEP:RenderLight() --This version is 457's Custom 'Flame' look. (Not available to non-457 tho sorry, use VIP to get that feel c:)
	if self.toggleLight ~= true then return end --If Not true, return.
	if CLIENT then
		if IsValid(scp966_light) == false then
			scp966_light = DynamicLight( self.Owner:EntIndex() ) --Do not take 0, Used for NV. This should be
		end
		if ( scp966_light ) then --Welp. :|
			scp966_light.Pos = self.Owner:GetPos()
			scp966_light.r = 128
			scp966_light.g = 128
			scp966_light.b = 128
			scp966_light.Style = 0 --Flicker B (fire-ish style?)
			scp966_light.Brightness = 0.85
			--scp457_flamelight.Size = math.Clamp(self.Owner:Health(),100,1650) --Depends on the health of the player :)
			scp966_light.Size = 900 --Why would it be so big anyway, let's nerf pls.
			scp966_light.DieTime = CurTime()+0.25 --Don't let it stay please.
		end
	end
end

function SWEP:Think() --Predicted Hook.

	if CLIENT then --Only the owner can see this.
		self:RenderLight()
	end

	if self.No966Attack == true then return end
	if preparing then return end

	if SERVER then
		for k,v in pairs(ents.FindInSphere( self.Owner:GetPos(), 300 )) do
			if v:IsPlayer() then
				if v:Team() ~= TEAM_SCP and v:Team() ~= TEAM_SPEC then
					if self.Owner.nextexp == nil then self.Owner.nextexp = 0 end
					if self.Owner.nextexp < CurTime() then
						v:EmitSound('physics/flesh/flesh_impact_bullet'..math.Round(math.random(1,4))..'.wav') --Some hurt sound for 966 :u
						v:TakeDamage(4, self.Owner, self)
						v:SendLua('last996attack = 1')
						--self.Owner:AddExp(1)
						self.Owner.nextexp = CurTime() + 1
					end
				end
			end
		end
	end
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

local Next966Toggle = 0
local Next966Sound = 0
function SWEP:SecondaryAttack()
	if Next966Toggle > CurTime() then return end
	Next966Toggle = CurTime() + 1 --Can toggle his ability every 2 seconds :)
	if self.No966Attack then
		self.No966Attack = false
	else
		self.No966Attack = true
	end
	if CLIENT then
		surface.PlaySound(Sound('button.ogg'))
	end
 	if Next966Sound > CurTime() then return end
	if self.No966Attack then return end --Don't play a sound if we disable it.
	Next966Sound = CurTime() + 10 --can play the sound every 10 seconds.
	self.Owner:EmitSound(Sound('966chasing.wav'))
end

function SWEP:CanPrimaryAttack()
	return true
end


function SWEP:DrawHUD()
	if disablehud == true then return end
	showcolor = Color(255,255,255) --UNDEFINED COLOR
	showtext_status = tostring(self.No966Attack) --Fail safe :)
	if self.No966Attack then
		showtext_status = 'disabled'
		showcolor = Color(255,0,0) --Green, Enabled.
	else
		showtext_status = 'enabled'
		showcolor = Color(0,255,0) --Red, Disabled.
	end

	local showtext = "Right click to toggle your ability ["..showtext_status.."]"


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
