AddCSLuaFile()

SWEP.PrintName			= "SCP-1048-B"			

SWEP.ViewModelFOV 		= 54
SWEP.Spawnable 			= false
SWEP.AdminOnly 			= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay        = 1
SWEP.Primary.Automatic	= false
SWEP.Primary.Ammo		= "None"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Delay			= 5
SWEP.Secondary.Ammo		= "None"

SWEP.ISSCP 				= true
SWEP.droppable				= false
SWEP.CColor					= Color(0,255,0)
SWEP.teams					= {1}

SWEP.Weight				= 3
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Slot					= 0
SWEP.SlotPos				= 4
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel 		= Model( "models/weapons/c_arms.mdl" )
SWEP.WorldModel		= ""
SWEP.IconLetter			= "w"
SWEP.HoldType 			= "fist"
SWEP.UseHands = true

SWEP.Lang = nil

function SWEP:Initialize()
	if CLIENT then
		self.Lang = GetWeaponLang().SCP_1048B
		self.Author		= self.Lang.author
		self.Contact		= self.Lang.contact
		self.Purpose		= self.Lang.purpose
		self.Instructions	= self.Lang.instructions
	end
	self:SetHoldType(self.HoldType)
	sound.Add( {
		name = "miss",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = 100,
		sound = "weapons/slam/throw.wav"
	} )
	for i=1, 6 do
			sound.Add( {
			name = "attack"..i,
			channel = CHAN_STATIC,
			volume = 1.0,
			level = 80,
			pitch = 100,
			sound = "physics/body/body_medium_impact_hard"..i..".wav"
		} )
	end
end

function SWEP:Deploy()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_draw" ) )
end

function SWEP:Holster()
	return true
end

SWEP.Freeze = false
SWEP.NextIdle = 0

SWEP.DrawRed = 0

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
	if CLIENT then --Only the owner can see this. PREDICTED HOOKS AHOY .-.
		self:RenderLight()
	end
	if self.NextIdle < CurTime() then
		local vm = self.Owner:GetViewModel()
		self.NextIdle = CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate()
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_idle_0" .. math.random( 1, 2 ) ) )
	end
	if !SERVER then return end
	if preparing and (self.Freeze == false) then
		self.Freeze = true
		self.Owner:SetJumpPower(1)
		self.Owner:SetCrouchedWalkSpeed(2)
		self.Owner:SetWalkSpeed(1)
		self.Owner:SetRunSpeed(1)
	end
	if preparing or postround then return end
	if self.Freeze == true then
		self.Freeze = false
		self.Owner:SetCrouchedWalkSpeed(0.6)
		self.Owner:SetJumpPower(200)
		self.Owner:SetWalkSpeed(180)
		self.Owner:SetRunSpeed(180)
	end
end

SWEP.NextPrimary = 0

function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if self.NextPrimary > CurTime() then return end
	self.NextPrimary = CurTime() + 1
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( table.Random( { "fists_left", "fists_right" } ) ) )
	self.NextIdle = CurTime() + 0.3
	local trace = util.TraceHull( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 50,
		filter = self.Owner,
		mask = MASK_SHOT,
		maxs = Vector( 10, 10, 8 ),
		mins = Vector( -10, -10, -8 ),
	} )
	local ent = trace.Entity
	if trace.Hit then
		self:EmitSound( "attack"..math.random( 1, 6 ) )
	else
		self:EmitSound( "miss" )
	end
	if SERVER then
		if IsValid( ent ) then
			if ent:IsPlayer() then
				if ent:Team() == TEAM_SPEC then return end
				if ent:Team() == TEAM_SCP then return end
				ent:TakeDamage( math.random( 20, 40 ), self.Owner, self )
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 100, self.Owner, self.Owner )
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

function SWEP:SecondaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	self:PrimaryAttack()
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

function SWEP:DrawHUD()
	if disablehud == true then return end
	local showtext = ""
	local lookcolor = Color(0,255,0)
	local showcolor = Color(17, 145, 66)

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
	surface.SetDrawColor( self.CColor.r, self.CColor.g, self.CColor.b, 255 )

	local gap = 5
	local length = gap + 20 * scale
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )
end