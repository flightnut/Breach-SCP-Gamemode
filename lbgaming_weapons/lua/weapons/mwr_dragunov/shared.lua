SWEP.BlowbackEnabled = true --Enable Blowback?
SWEP.BlowbackVector = Vector(0,-1,0) --Vector to move bone <or root> relative to bone <or view> orientation.
SWEP.BlowbackCurrentRoot = 0 --Amount of blowback currently, for root
SWEP.BlowbackCurrent = 0 --Amount of blowback currently, for bones
SWEP.BlowbackBoneMods = nil --Viewmodel bone mods via SWEP Creation Kit
SWEP.Blowback_Only_Iron = true --Only do blowback on ironsights
SWEP.Blowback_PistolMode = false --Do we recover from blowback when empty?
SWEP.Blowback_Shell_Enabled = true
SWEP.Blowback_Shell_Effect = "RifleShellEject"-- ShotgunShellEject shotgun or ShellEject for a SMG    
SWEP.UseHands				= true
SWEP.LuaShellEject			= true
SWEP.Type					= "Sniper Rifle"
SWEP.Category				= "Robotnik's CoD MWR SWEPs"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Dragunov"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 3				-- Slot in the weapon selection menu
SWEP.SlotPos				= 21			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "rpg"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.SelectiveFire		= false
SWEP.CanBeSilenced		= false
SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_mwr_dragunov.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_mwr_dragunov.mdl"	-- Weapon world model
SWEP.Base				= "tfa_3dscoped_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("mwr_dragunov.Single")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 666			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 10		-- Size of a clip
SWEP.Primary.DefaultClip		= 60		-- Bullets you start with
SWEP.Primary.KickUp				= 0.3		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.3		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.3		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "ar2"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 55		-- How much you 'zoom' in. Less is more! 	

SWEP.IronSightsSensitivity = 0.25

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 89	-- Base damage per bullet
SWEP.Primary.Spread		= .025	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .0001 -- Ironsight accuracy, should be the same for shotguns

-- Enter iron sight info and bone mod info below
SWEP.SightsPos = Vector(-3.6, 0, 2)
SWEP.SightsAng = Vector(-0.301, -0.401, 0)
SWEP.RunSightsPos = Vector (0.519, 0, -3.56)
SWEP.RunSightsAng = Vector (-6.7, 46.799, -29)
SWEP.InspectPos = Vector(7.639, 0, -0.16)
SWEP.InspectAng = Vector(18.5, 31.2, 19)


SWEP.Offset = {
        Pos = {
        Up = 01,
        Right = 0,
        Forward = 0,
        },
        Ang = {
        Up = 0,
        Right = -9,
        Forward = 180,
        },
		Scale = 1.0
}

SWEP.VElements = {
	["element_name"] = { type = "Model", model = "models/rtcircle.mdl", bone = "tag_weapon", rel = "", pos = Vector(-4.71, -0.271, 4.051), angle = Angle(0, 180, 0), size = Vector(0.308, 0.308, 0.308), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {} }
}

local ceedee = {}

SWEP.RTMaterialOverride = -1 --the number of the texture, which you subtract from GetAttachment

SWEP.RTOpaque = true

local g36
if surface then
	g36 = surface.GetTextureID("scope/gdcw_svdsight") --the texture you vant to use
end
SWEP.Secondary.ScopeZoom = 8 --IMPORTANT BIT
SWEP.RTScopeAttachment = 0
SWEP.ScopeAngleTransforms = {}
SWEP.ScopeOverlayTransformMultiplier = 1
SWEP.ScopeOverlayTransforms = {0, 0}
SWEP.ScopeReticule = ("custom/pso1")