AddCSLuaFile()

SWEP.PrintName = "SCP-939"

SWEP.ViewModelFOV 		= 56
SWEP.Spawnable 			= false
SWEP.AdminOnly 			= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay        = 1
SWEP.Primary.Automatic	= false
SWEP.Primary.Ammo		= "None"
SWEP.PrimarySoundTable	= {"vj_scp_939/specimen1/attack1.wav","vj_scp_939/specimen1/attack2.wav","vj_scp_939/specimen1/attack3.wav"}


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
SWEP.ViewModel			= ""
SWEP.WorldModel			= ""
SWEP.IconLetter			= "w"
SWEP.HoldType 			= "melee"

SWEP.Lang = nil

function SWEP:Initialize()
	if CLIENT then
		self.Lang = GetWeaponLang().SCP_939
		self.Author		= self.Lang.author
		self.Contact		= self.Lang.contact
		self.Purpose		= self.Lang.purpose
		self.Instructions	= self.Lang.instructions
	end
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
	if self.Owner:IsValid() then
		self.Owner:DrawWorldModel( false )
		self.Owner:DrawViewModel( false )
		--self.Owner:SetModelScale( 0.75 )
	end
end

function SWEP:Holster()
	return true;
end

SWEP.Freeze = false

function SWEP:Think()
	if !SERVER then return end
	if preparing and (self.Freeze == false) then
		self.Freeze = true
		self.Owner:SetJumpPower(1)
		self.Owner:SetCrouchedWalkSpeed(1)
		self.Owner:SetWalkSpeed(1)
		self.Owner:SetRunSpeed(1)
	end
--	if preparing and self.Owner:GetPos():Distance(SPAWN_939) > 150 then
--		self.Owner:SetPos(SPAWN_939)
--	end
	if preparing or postround then return end
	if self.Freeze == true then
		self.Freeze = false
		self.Owner:SetCrouchedWalkSpeed(0.6)
		self.Owner:SetJumpPower(200)
		self.Owner:SetWalkSpeed(225)
		self.Owner:SetRunSpeed(225)
	end
end

SWEP.NextPrimary = 0

function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if self.NextPrimary > CurTime() then return end
	self.NextPrimary = CurTime() + self.Primary.Delay
	if !SERVER then return end
	local tr = util.TraceHull( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 100,
		maxs = Vector( 10, 10, 10 ),
		mins = Vector( -10, -10, -10 ),
		filter = self.Owner,
		mask = MASK_SHOT
	} )
	local ent = tr.Entity
	if IsValid( ent ) then
		if ent:IsPlayer() then
			if ent:Team() == TEAM_SPEC then return end
			if ent:Team() == TEAM_SCP then return end
			local attSound = table.Random(self.PrimarySoundTable)
			self.Owner:EmitSound(attSound)
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			ent:TakeDamage( math.random( 20, 50 ), self.Owner, self.Owner )
		else
			if ent:GetClass() == "func_breakable" then
				ent:TakeDamage( 100, self.Owner, self.Owner )
			end
		end
	end
end

SWEP.Channel = 0
SWEP.DBG = 0
function SWEP:SecondaryAttack()
	if preparing or postround then return end
	if self.DBG > CurTime() then return end
	self.DBG = CurTime() + 0.3
	--self.Channel = self:nextChannel()
	self.Channel = self.Channel + 1
	if self.Channel > 10 then
		self.Channel = 0
	end
end

--[[
function SWEP:nextChannel()
	for k, v in pairs(self.AvChannels) do
		if v == self.Channel then
			if k == 6 then
				return self.AvChannels[1]
			end
			return self.AvChannels[k + 1]
		end
	end
end
]]--

function SWEP:DrawHUD()
	if disablehud == true then return end

	local showtext = self.Lang.HUD.attackReady
	local showcolor = Color(0,255,0)

	if self.NextPrimary > CurTime() then
		showtext = self.Lang.HUD.attackCD.." "..math.Round(self.NextPrimary - CurTime())
		showcolor = Color(255,0,0)
	end

	draw.Text( {
		text = showtext,
		pos = { ScrW() / 2, ScrH() - 30 },
		font = "173font",
		color = showcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
		if self.Channel == 0 then
			curVcChannel = "none"
		else
			curVcChannel = self.Channel
		end 
		draw.Text( {
		text = self.Lang.HUD.channel.." "..curVcChannel,
		pos = { ScrW() / 2, ScrH() - 60 },
		font = "173font",
		color = Color(0,255,0),
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
end
