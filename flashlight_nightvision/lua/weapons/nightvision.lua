AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.PrintName = "Night vision SWEP"
SWEP.Instructions = "'Reload' key to enable / disable night vision"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Category = "Rasko"

SWEP.HoldType = "normal"
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.DrawCrosshair = false

SWEP.HitDistance = 50

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay = 1

SWEP.Secondary.ClipSize		= 5
SWEP.Secondary.DefaultClip	= 5
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay = 5

SWEP.Nightvision = false
SWEP.NextReload = CurTime()

SWEP.Slot				= 0
SWEP.SlotPos			= 0
--Link2006's Temporary fix for Nightvision;
SWEP.droppable = false

if ( SERVER ) then
	util.AddNetworkString( "RASKO_NightvisionOn" )
	util.AddNetworkString( "RASKO_NightvisionOff" )
end

function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )

end


function SWEP:PrimaryAttack()

	if ( SERVER ) then
	end
end


function SWEP:SecondaryAttack()

	if ( SERVER ) then
	end
end


function SWEP:Reload()

	if ( SERVER ) then
		if self.NextReload > CurTime() then return end

		self.NextReload = CurTime() + 2
		local ply = self:GetOwner()
		if self.Nightvision == false then
			self.Nightvision = true
			net.Start( "RASKO_NightvisionOn" )
			net.WriteEntity( ply )
			net.Send( ply )
		elseif self.Nightvision == true then
			self.Nightvision = false
			net.Start( "RASKO_NightvisionOff" )
			net.WriteEntity( ply )
			net.Send( ply )
		end
	end

end

function SWEP:Deploy()
	if ( SERVER ) then
		self.NvOwner = self:GetOwner()
	end
end

function SWEP:OnRemove()
end

--[[
function SWEP:Holster()

	if ( SERVER ) then
		local ply = self:GetOwner()
		self.Nightvision = false
		net.Start( "RASKO_NightvisionOff" )
		net.WriteEntity( ply )
		net.Send( ply )
		return true
	end

end
]]--

--Link2006's Fix for NV Not turning off when dropped
function SWEP:OnDrop()
	if SERVER then
		self.Nightvision = false
		net.Start( "RASKO_NightvisionOff" )
		net.WriteEntity( self.NvOwner )
		net.Send( self.NvOwner )
		return true
	end
end

--Same here when they die, delete themselves.
function SWEP:OnRemove()
	if SERVER then
		self.Nightvision = false
		net.Start( "RASKO_NightvisionOff" )
		net.WriteEntity( self.NvOwner )
		net.Send( self.NvOwner )
		return true
	end
end

if( CLIENT ) then

	net.Receive( "RASKO_NightvisionOn", function ( len, ply )
		local ply = net.ReadEntity()
		am_nightvision = DynamicLight( 0 )
		if ( am_nightvision ) then
			am_nightvision.Pos = ply:GetPos()
			am_nightvision.r = 11
			am_nightvision.g = 50
			am_nightvision.b = 4
			am_nightvision.Brightness = 1
			am_nightvision.Size = 2000
			am_nightvision.DieTime = CurTime()+100000
			am_nightvision.Style = 1
		end
		timer.Create( "RASKO_LightTimer", 0.05, 0, function()
			am_nightvision.Pos = ply:GetPos()
		end)
	end)

	net.Receive( "RASKO_NightvisionOff", function ( len, ply )
		local ply = net.ReadEntity()
		timer.Destroy( "RASKO_LightTimer" )
		if am_nightvision then
			am_nightvision.DieTime = CurTime()+0.1
		end
	end)

end
