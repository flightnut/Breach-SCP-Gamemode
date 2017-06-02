AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "SCP-012"
ENT.Author = "Tsujimoto18"
ENT.Information = "A Bad Composition"
ENT.Category = "SCP"

ENT.Editable = false
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:Initialize()

	if (CLIENT) then return end

	self:SetModel("models/vinrax/scp_cb/book.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then

		phys:Wake()

	end

end

function ENT:Draw()

	if (SERVER) then return end

	self:DrawModel()

end

function ENT:Think()

	if (CLIENT) then return end
	self:NextThink( CurTime() + 1 )
	for k, ply in pairs(ents.FindInSphere(self:GetPos(), 125)) do

		if (ply:IsPlayer()) then

			if ply:Alive() and (ply:Team() ~= TEAM_SPEC) and (ply:Team() ~= TEAM_SCP) and not preparing and not postround then
			ply:PrintMessage(HUD_PRINTCENTER, "You try using your blood to finish the composition.")
			ply:SetHealth(ply:Health()-5)
			if (ply:Health() <= 0) then

				ply:Kill()

			end
			math.randomseed(os.time())
			local num = math.random(1,4)
			if (num == 3) then

				ply:EmitSound("ambient/creatures/town_scared_breathing1.wav", 100, 100, 1, CHAN_VOICE)

			end

			if (num == 4) then

				ply:EmitSound("ambient/creatures/town_scared_breathing2.wav", 100, 100, 1, CHAN_VOICE)

			end
			end

		end

	end
	return true --Oops apparently you gotta do this. 
end
