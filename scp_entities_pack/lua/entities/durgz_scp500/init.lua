AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = "models/props_lab/jar01b.mdl"

ENT.HASHIGH = false

ENT.LASTINGEFFECT = 0;

--called when you use it (after it sets the high visual values and removes itself already)
function ENT:ReplacePlayer(ply,ply_oldAng,ply_oldPos)
	--Kind of cleaner code because why not?
	ply:SetPos(ply_oldPos) --Seriously, what?
	ply:SetAngles(ply_oldAng)
	ply:SetEyeAngles(ply_oldAng) --idk what the fuck i'm doing :(
end

function ENT:High(ply,caller)
	self:Soberize(ply) --Stop SCP-420-J
	if ply:Team() ~= TEAM_SCP then return end

	--Wait, we're an SCP? Let's do MORE stuff : )
	if ply:GetNClass() == ROLE_SCP0492 or ply:GetNClass() == ROLE_SCP0082 then
		if ply.TurnMeBack then
			local ply_oldAng = ply:GetAngles()
			local ply_oldPos = ply:GetPos()
			ply.TurnMeBack()
			ply:StripWeapons() -- No abuse please.
			self:ReplacePlayer(ply,ply_oldAng,ply_oldPos) --Player, Player's Old angles, Player's old Positions
			if ply:Team() == TEAM_GUARD or ply:Team() == TEAM_CHAOS then
				--Give ammo...?
				ply:GiveAmmo(150, "SMG1", false)
				ply:GiveAmmo(150, "AR2", false)
				ply:GiveAmmo(75, "Pistol", false)
			end
			ply:ChatPrint('You feel healthy again.')
			print("[SCP-500] We cured '"..ply:Nick().."'")
		else
			ply:ChatPrint('The pill did nothing to you.')
			print("[SCP-500] WE CANNOT TURN BACK '"..ply:Nick().."'")
		end
		--No matter what, do this check, 1 second after they're cleaned.
		timer.Simple(1,function()
			if WinCheck then
				WinCheck() --Do a check to see if we just turned back the last zombie.
			end
		end)
	end

end
