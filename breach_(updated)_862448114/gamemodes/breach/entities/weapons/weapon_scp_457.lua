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
	self.scp457_Burn = true

end

function SWEP:DrawWorldModel()
end

function SWEP:Initialize() --Init the weapon
	self:SetHoldType("normal")
	--Link2006's Heal System
	if self.Cooldown == nil then --Is there a table inside the weapon?
		self.Cooldown = {} --Init a table please, we need it later.
	end
	self.scp457_Burn = true

end

function SWEP:RenderLight() --This version is 457's Custom 'Flame' look. (Not available to non-457 tho sorry, use VIP to get that feel c:)
	if self.toggleLight ~= true then return end --If Not true, return.
	if CLIENT then
		if IsValid(scp457_flamelight) == false then
			scp457_flamelight = DynamicLight( self.Owner:EntIndex() ) --Do not take 0, Used for NV. This should be
		end
		if ( scp457_flamelight ) then --Welp. :|
			scp457_flamelight.Pos = self.Owner:GetPos()
			if self.scp457_Burn then --Orange
				scp457_flamelight.r = 226
				scp457_flamelight.g = 88
				scp457_flamelight.b = 34
				scp457_flamelight.Style = 6 --Flicker B (fire-ish style?)
			else --white :)
				scp457_flamelight.r = 128
				scp457_flamelight.g = 128
				scp457_flamelight.b = 128
				scp457_flamelight.Style = 0 --Flicker B (fire-ish style?)
			end
			scp457_flamelight.Brightness = 0.85
			--scp457_flamelight.Size = math.Clamp(self.Owner:Health(),100,1650) --Depends on the health of the player :)
			scp457_flamelight.Size = 900 --Why would it be so big anyway, let's nerf pls.
			scp457_flamelight.DieTime = CurTime()+0.25 --Don't let it stay please.
		end
	end
end

function SWEP:Think() --Predicted Hook.

	if CLIENT then --Only the owner can see this. PREDICTED HOOKS AHOY .-.
		self:RenderLight()
	end

	if SERVER and self.scp457_Burn then
		self.Owner:Ignite(0.1,100)
		--									Source				Range (default 125)
		for k,v in pairs(ents.FindInSphere( self.Owner:GetPos(), 150 )) do
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


scp457_cooldown = 0

function SWEP:SecondaryAttack()
	if scp457_cooldown >= CurTime() then return end  --Don't toggle yet.

	if self.scp457_Burn then
		self.scp457_Burn = false
	else
		self.scp457_Burn = true
	end
	scp457_cooldown = CurTime() + 1

	if CLIENT then
		surface.PlaySound(Sound('button.ogg'))
	end
end

function SWEP:CanPrimaryAttack()
	return true
end


function SWEP:DrawHUD()
	if disablehud == true then return end
	showcolor = Color(255,255,255) --UNDEFINED COLOR
	showtext_status = tostring(self.scp457_Burn) --Fail safe :)
	if self.scp457_Burn then
		showtext_status = 'enabled'
		showcolor = Color(0,255,0) --Green, Enabled.
	else
		showtext_status = 'disabled'
		showcolor = Color(255,0,0) --Red, Disabled.
	end

	local showtext = "Right click to toggle your fire ["..showtext_status.."]"


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
