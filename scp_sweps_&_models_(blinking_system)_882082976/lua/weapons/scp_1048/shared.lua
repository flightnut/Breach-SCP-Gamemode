AddCSLuaFile()
SWEP.Author = "DjBuRnOuT"
SWEP.Contact = "http://steamcommunity.com/id/djburnouttt"
SWEP.Purpose = "Acts as a weapon for SCP 1048."
SWEP.Instructions = "Transform a player in 1048 A."
SWEP.Category = "SCP Sweps & Models"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_stunbaton.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"

SWEP.PrintName = "SCP 1048"
SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.SwingSound = "Weapon_Crowbar.Single"
SWEP.HitSound = "weapons/stunstick/stunstick_fleshhit1.wav"

SWEP.HoldType = "normal"

SWEP.AllowDrop = true
SWEP.Kind = WEAPON_MELEE

SWEP.Delay = 1
SWEP.Range = 100
SWEP.Damage = 0
SWEP.RemoveCan = true
SWEP.DocAndResearch = {
	TEAM_BRIGHT, 
	TEAM_RIGHTS, 
	TEAM_CLEF, 
	TEAM_KONDRAKI, 
	TEAM_GEARS,
	TEAM_RESEARCHER
}
SWEP.MTF = {
	TEAM_MTF, 
	TEAM_MTFSNIPER, 
	TEAM_MTFBREACHER, 
	TEAM_MTFHEAVY, 
	EAM_MTFLEADER, 
	TEAM_MTFMEDIC, 
	TEAM_SECURITY, 
	TEAM_NINE
}

if SERVER then
	util.AddNetworkString("SCP_Taken_Over")
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
    
    local ent = tr.Entity
    if not IsValid(ply) then return end
    	ply:SetAnimation(PLAYER_ATTACK1)
    if tr.StartPos:Distance(tr.HitPos) < 150 then
        self:EmitSound(self.HitSound)
    else
        self:EmitSound(self.SwingSound)
    end

    local vm = self:GetOwner():GetViewModel()
    if not IsValid(vm) then return end
    vm:SendViewModelMatchingSequence(vm:LookupSequence("attackch"))
    vm:SetPlaybackRate(1 + 1/3)
    local duration = vm:SequenceDuration() / vm:GetPlaybackRate()
    local time = CurTime() + duration
    self:SetNextPrimaryFire(time)

    if ent:IsPlayer() and ent != ply and !ent.IsZombie then
    	if table.HasValue(self.DocAndResearch, ent:Team()) then
    		ply:EmitSound("049/notdoctor.mp3")
		else
			self.EntModel = ent:GetModel()
			ent.IsZombie = true
			if SERVER then
				if table.HasValue(self.MTF, ent:Team()) then
					ent:SetModel("models/player/mrsilver/scp-1048-a.mdl")
				else
					ent:SetModel("models/player/mrsilver/scp-1048-a.mdl")
				end
				net.Start("SCP_Taken_Over")
					net.WriteEntity(ply)
				net.Send(ent)
				hook.Add("PlayerDeath", "Revert_To_Model"..ply:EntIndex(), function(pl)
					if pl == ent and ent.IsZombie then
						ent.IsZombie = false
						if SERVER then
							ent:SetModel(self.EntModel)
						end
					end
				end)
				ent:StripWeapons()
				ent:Give("scp_1048a")
			end
		end
    end
end

function SWEP:Think()
    return false
end

if CLIENT then
	net.Receive("SCP_Taken_Over", function()
		local ply = net.ReadEntity()
		RunConsoleCommand("say", "/advert J'ai été infecté par: "..ply:Nick())
	end)
end