if SERVER then
    AddCSLuaFile("shared.lua")
end
SWEP.Author = "DjBuRnOuT"
SWEP.Purpose = "Heals infected from 049"
SWEP.Instructions = "Left Click to disinfect an infected and right click to slowly heal them."
SWEP.Category = "SCP Sweps & Models"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/c_medkit.mdl"
SWEP.WorldModel = "models/weapons/w_medkit.mdl"

SWEP.PrintName = "The Cure"
SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.UseHands = true

SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize  = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic  = true
SWEP.Primary.Delay = 0.1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Recoil = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Delay = 0.3
SWEP.Secondary.Ammo = "none"

function SWEP:disinfectPlayer(ent)
	local ply =  self.Owner
	if ent:IsPlayer() and ent != ply and ent.IsInfected then
		ent.IsInfected = false
		self:EmitSound("UI/buttonclickrelease.wav")
		if SERVER then
			local entPos = ent:GetPos()
			local entHP = ent:Health()
			ent:Spawn()
			ent:SetPos( entPos )
			ent:SetModel(ent.EntModel)
			ent:SetHealth(entHP)
			if ent:HasWeapon("weapon_sillyzombieclaw_v2") then
				ent:StripWeapon("weapon_sillyzombieclaw_v2")
			end
			net.Start("049_cancelall")
			net.Send(ent)
		end
	end
end

function SWEP:PrimaryAttack()
	local ply = self.Owner
	local tr = util.TraceHull {
	  start = ply:GetShootPos(),
	  endpos = ply:GetShootPos() + ply:GetAimVector() * 1500,
	  filter = ply,
	  mins = Vector(-10, -10, -10),
	  maxs = Vector(10, 10, 10)
	}
	if not tr.Entity then return end
	local ent = tr.Entity
	if ent:IsPlayer() and ent:Alive() then
		if ply:GetPos():Distance(ent:GetPos()) <= 100 then
			if ent.IsInfected == true then
				self:disinfectPlayer(ent)
			else
				if CLIENT then
					self:EmitSound("UI/buttonrollover.wav")
				end
			end
		end
	end
end

function SWEP:Reload()
  return
end

 //Everything below is from the DarkRP medkit, I did not make that part.
function SWEP:SecondaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    local found
    local lastDot = -1 -- the opposite of what you're looking at
    self:GetOwner():LagCompensation(true)
    local aimVec = self:GetOwner():GetAimVector()

    for k,v in pairs(player.GetAll()) do
        local maxhealth = v:GetMaxHealth() or 100
        if v == self:GetOwner() or v:GetShootPos():Distance(self:GetOwner():GetShootPos()) > 85 or v:Health() >= maxhealth or not v:Alive() then continue end

        local direction = v:GetShootPos() - self:GetOwner():GetShootPos()
        direction:Normalize()
        local dot = direction:Dot(aimVec)

        -- Looking more in the direction of this player
        if dot > lastDot then
            lastDot = dot
            found = v
        end
    end
    self:GetOwner():LagCompensation(false)

    if found then
        found:SetHealth(found:Health() + 1)
        self:EmitSound("hl1/fvox/boop.wav", 150, found:Health() / found:GetMaxHealth() * 100, 1, CHAN_AUTO)
    end
end
