AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_173")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= ""
SWEP.Contact		= "Look at this gamemode in workshop and search for creators"
SWEP.Purpose		= "Kill people"
SWEP.Instructions	= "LMB to attack someone, RMB to screech"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/vinrax/props/keycard.mdl"
SWEP.WorldModel		= "models/vinrax/props/keycard.mdl"
SWEP.PrintName		= "SCP-1048a"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.AttackDelay			= 0.50
SWEP.ISSCP = true
SWEP.droppable				= false
SWEP.CColor					= Color(0,255,0)
SWEP.YellSound		    	= Sound( "1048attack.ogg" ) -- ent:EmitSound( self.YellSound, 500, 100 )
SWEP.teams					= {1}
SWEP.Primary.Ammo			= "none"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false

SWEP.SpecialDelay			= 30
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
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

--[[--
function SWEP:Reload()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
end
--]]--

function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if self.NextAttackW > CurTime() then return end
	self.NextAttackW = CurTime() + self.AttackDelay
	if SERVER then
		local ent = self.Owner:GetEyeTrace().Entity
		if (ent:GetPos():Distance(self.Owner:GetPos()) < 150) then
			if ent:IsPlayer() then
				if ent:Team() == TEAM_SCP then return end
				if ent:Team() == TEAM_SPEC then return end
				ent:TakeDamage( 15, self.Owner, self.Owner )
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

function SWEP:Holster()
end

SWEP.NextSpecial = 0
function SWEP:SecondaryAttack()
	local time = 5
	if self.NextSpecial > CurTime() then return end
	self.NextSpecial = CurTime() + self.SpecialDelay
	if CLIENT then
		surface.PlaySound("1048attack.ogg")
	end
	local findents = ents.FindInSphere( self.Owner:GetPos(), 500 )
	local foundplayers = {}
	for k,v in pairs(findents) do
		if v:IsPlayer() then
			if !(v:Team() == TEAM_SCP or v:Team() == TEAM_SPEC) then
				table.ForceInsert(foundplayers, v)
			end
		elseif v:GetClass() == "func_breakable" then
			if v.TakeDamage then
				v:TakeDamage( 100, self.Owner, self.Owner )
			end
		end
	end
	if #foundplayers > 0 then
		local fixednicks = "Hurt: "
		if CLIENT then return end
		local numi = 0
		for k,v in pairs(foundplayers) do
			numi = numi + 1

			if numi == 1 then
				fixednicks = fixednicks .. v:Nick()
			elseif numi == #foundplayers then
				fixednicks = fixednicks .. " and " .. v:Nick()
			else
				fixednicks = fixednicks .. ", " .. v:Nick()
			end
			v:SendLua( 'surface.PlaySound("1048attack.ogg")' )

			v:TakeDamage( ((v:Health() / 100) * 75), self.Owner, self.Owner )

		end
		self.Owner:PrintMessage(HUD_PRINTTALK, fixednicks)
	end
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:DrawHUD()
	if disablehud == true then return end
	local specialstatus = ""
	local showtext = ""
	local lookcolor = Color(0,255,0)
	local showcolor = Color(17, 145, 66)
	if self.NextSpecial > CurTime() then
		specialstatus = "ready to use in " .. math.Round(self.NextSpecial - CurTime())
		showcolor = Color(145, 17, 62)
	else
		specialstatus = "ready to use"
	end
	showtext = "Special " .. specialstatus
	if self.DrawRed < CurTime() then
		self.CColor = Color(255,0,0)
		lookcolor = Color(145, 17, 62)
	else
		self.CColor = Color(0,255,0)
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
	surface.SetDrawColor( self.CColor.r, self.CColor.g, self.CColor.b, 255 )

	local gap = 5
	local length = gap + 20 * scale
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )
end
