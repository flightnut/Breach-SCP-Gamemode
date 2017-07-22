AddCSLuaFile()

SWEP.PrintName				= "SCP999"			

SWEP.ViewModelFOV 		= 56
SWEP.Spawnable 			= false
SWEP.AdminOnly 			= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay        = 2
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
SWEP.ViewModel			= ""
SWEP.WorldModel			= ""
SWEP.IconLetter			= "w"
SWEP.HoldType 			= "normal"

SWEP.Lang = nil

function SWEP:Initialize()
	if CLIENT then
		self.Lang = GetWeaponLang().SCP_999
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
	end
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

function SWEP:Holster()
	return true;
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

SWEP.NextPrimary = 0
function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if CurTime() < self.NextPrimary then return end
	self.NextPrimary = CurTime() + self.Primary.Delay
	if SERVER then
		local tr = util.TraceHull({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 150,
			maxs = Vector(10, 10, 10),
			mins = Vector(-10, -10, -10),
			filter = self.Owner,
			mask = MASK_SHOT
		})
		local ent = tr.Entity
		if !IsValid(ent) then return end
		if ent:IsPlayer() then
			if ent:Team() != TEAM_SPEC then
				if ent:Health() >= ent:GetMaxHealth() then return end
				local scp999hpGain = math.random(5, 10)
				local hp = ent:Health() + scp999hpGain
				if hp > ent:GetMaxHealth() then hp = ent:GetMaxHealth() end
				--self.Owner:AddExp(20, false)
				if SERVER then 
					self.Owner:PS2_AddStandardPoints(scp999hpGain,"Healing another player (SCP-999)",true)
				end
				ent:SetHealth(hp)
			end
		else
			if ent:GetClass() == "func_breakable" then
				ent:TakeDamage( 100, self.Owner, self.Owner )
			elseif ent:GetClass() == 'prop_dynamic' then
				if string.lower(ent:GetModel()) == 'models/foundation/containment/door01.mdl' then
					ent:TakeDamage( math.Round(math.random(12,20)), self.Owner, self.Owner )
					ent:EmitSound(Sound('MetalGrate.BulletImpact'))
				end
			end
		end
	end
end

SWEP.NextSecondary = 0
function SWEP:SecondaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if CurTime() < self.NextSecondary then return end
	self.NextSecondary = CurTime() + self.Secondary.Delay
	if SERVER then
		local fent = ents.FindInSphere(self.Owner:GetPos(), 300)
		local hp = 0
		local totalheal = 0
		for k, v in pairs(fent) do
			if v:IsPlayer() then
				if v:Team() != TEAM_SPEC and v != self.Owner then
					hp = v:Health() + math.random(5, 15)
					if hp > v:GetMaxHealth() then hp = v:GetMaxHealth() end
					totalheal = totalheal + (hp - v:Health())
					v:SetHealth(hp)
					hp = 0
				end
			end
		end
		if totalheal > 0 then 
			if SERVER then 
				self.Owner:PS2_AddStandardPoints(totalheal,"Healing another player (SCP-999)",true)
			end
			--self.Owner:AddExp(totalheal, false) 
		end
	end
end

function SWEP:DrawHUD()
	if disablehud == true then return end
	
	local showtext = self.Lang.HUD.ghealReady
	local showtext2 = self.Lang.HUD.healReady
	local showcolor = Color(0,255,0)
	local showcolor2 = Color(0,255,0)
	
	if self.NextSecondary > CurTime() then
		showtext = self.Lang.HUD.ghealCD.." ".. math.Round(self.NextSecondary - CurTime()).."s"
		showcolor = Color(255,0,0)
	end
	
	if self.NextPrimary > CurTime() then
		showtext2 = self.Lang.HUD.healCD.." "..math.Round(self.NextPrimary - CurTime()).."s"
		showcolor2 = Color(255,0,0)
	end
	
	draw.Text( {
		text = showtext,
		pos = { ScrW() / 2, ScrH() - 30 },
		font = "173font",
		color = showcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
	
	draw.Text( {
		text = showtext2,
		pos = { ScrW() / 2, ScrH() - 50 },
		font = "173font",
		color = showcolor2,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
	
	local NvKey = input.LookupBinding('+reload') --Get key for reload
	if type(NvKey) == 'no value' then NvKey = 'NOT BOUND' end -- The key is not bound!

	draw.Text( {
		text = "Press "..NvKey.." for nightvision",
		pos = { ScrW() / 2, ScrH() - 70 },
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