AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_zombie")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= ""
SWEP.Contact		= "Look at this gamemode in workshop and search for creators"
SWEP.Purpose		= "Kill humens"
SWEP.Instructions	= "Click left to attack"
SWEP.Base			= "weapon_breach_basemelee"

SWEP.ViewModelFOV	= 75
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "knife"
SWEP.ViewModel		= "models/weapons/v_zombiearms.mdl"
SWEP.WorldModel		= ""
SWEP.PrintName		= "Zombie"
SWEP.DrawCrosshair	= false
SWEP.Slot			= 0

SWEP.Spawnable			= false
SWEP.AdminOnly			= false

SWEP.droppable				= false
SWEP.Primary.Automatic		= false
SWEP.Primary.NextAttack		= 0.25
SWEP.Primary.AttackDelay	= 0.4
SWEP.Primary.Damage			= 26
SWEP.Primary.Force			= 3250
SWEP.Primary.AnimSpeed		= 2.8

SWEP.Secondary.Automatic	= true
SWEP.Secondary.NextAttack	= 0.7
SWEP.Secondary.AttackDelay	= 1.6
SWEP.Secondary.Damage		= 125
SWEP.Secondary.Force		= 6000
SWEP.Secondary.AnimSpeed	= 2.4

SWEP.Range					= 100

SWEP.UseHands				= false
SWEP.DrawCustomCrosshair	= true
SWEP.DeploySpeed			= 1
SWEP.AttackTeams			= {2,3,4,6} // Attack only humans
SWEP.AttackNPCs				= false

SWEP.ZombieWeapon			= true

SWEP.SoundMiss 			= "npc/zombie/claw_miss1.wav"
SWEP.SoundWallHit		= "npc/zombie/claw_strike1.wav"
SWEP.SoundFleshSmall	= "npc/zombie/claw_strike2.wav"
SWEP.SoundFleshLarge	= "npc/zombie/claw_strike3.wav"

function SWEP:RenderLight()
	if self.toggleLight ~= true then return end --If Not true, return.
	if CLIENT then
		if IsValid(scp_nightVision) == false then
			scp_nightVision = DynamicLight( self.Owner:EntIndex() ) --Do not take 0, Used for NV. This should be
		end
		if ( scp_nightVision ) then --Welp. :|
			scp_nightVision.Pos = self.Owner:GetPos()
			scp_nightVision.r = 128
			scp_nightVision.g = 0
			scp_nightVision.b = 0
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

function SWEP:SecondaryAttack()
	--[[
	self:SetHoldType("knife")
	//if ( !self:CanSecondaryAttack() ) then return end
	//if not IsFirstTimePredicted() then return end
	if self:GetNextSecondaryFire() > CurTime() then return end
	self.Owner:GetViewModel():SetPlaybackRate( self.Secondary.AnimSpeed )
	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_RANGE_ZOMBIE)
	timer.Create("AttackDelay" .. self.Owner:SteamID(), self.Secondary.NextAttack, 1, function()
		if IsValid(self) == false then return end
		self.AttackType = 2
		self:Stab(2, self.Range)
	end)
	self:SetNextPrimaryFire( CurTime() + self.Secondary.AttackDelay)
	self:SetNextSecondaryFire( CurTime() + self.Secondary.AttackDelay)
	--]]
end


function SWEP:DrawHUD()
	if disablehud == true then return end

	local showcolor = Color(0,255,0)

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

end
