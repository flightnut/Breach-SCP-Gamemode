AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "SCP-1025"
ENT.Author = "Tsujimoto18"
ENT.Information = "A Encyclopedia of Common Diseases"
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

function ENT:Use(activator, ply)
	if ply:Team() == TEAM_SCP or ply:Team() == TEAM_SPEC or preparing or postround then
		return
	end

	if (SERVER) then
		if (ply:GetNWInt("canBeInfected", 0) == 2) then
			ply:PrintMessage(HUD_PRINTCENTER,"You cannot get any other diseases") --lol
			return
		end

		local number
		if ((ply:GetNWInt("canBeInfected", 0) == 0) or (ply:GetNWInt("canBeInfectedb", 0) == 0)) then
			 ply:SetNWInt("canBeInfected", 1)
			 ply:SetNWInt("canBeInfectedb", 1)
		end
		local Diseases = {}

		Diseases[1] = "Appendicitus"
		Diseases[2] = "Asthma"
		Diseases[3] = "Black Blood Syndrome"
		Diseases[4] = "Cardiac Arrest"
		Diseases[5] = "Chicken Pox"
		Diseases[6] = "The Common Cold"
		Diseases[7] = "Muscular Mutation Trait"
		Diseases[8] = "Regenerative Trait"
		Diseases[9] = "Finger Calluses"
		Diseases[10] = "Lung Cancer"
		Diseases[11] = "Super Calluses"

		math.randomseed(os.time())
		number = math.random(1, 11)

		ply:PrintMessage(HUD_PRINTCENTER, "You read about " .. Diseases[number])

		if ((number == 1) and (ply:GetNWInt("canBeInfectedb", 0) == 1)) then

			if ply:Alive() then
				local newRunSpeed = ply:GetWalkSpeed()
				timer.Simple(2, function() ply:PrintMessage(4, "The pain in your stomach has become unbearable") end)
				ply:SetRunSpeed(newRunSpeed)
			end

		end

		if ((number == 2) and (ply:GetNWInt("canBeInfectedb", 0) == 1)) then

			local asthmaCounter = 0
			local asthmaCounterb = 0
			local oldRunSpeedA = ply:GetRunSpeed()
			local oldWalkSpeedA = ply:GetWalkSpeed()
			timer.Create(ply:SteamID64().."Asthma", 1, 0, function()

				--if (not ply:Alive()) or (ply:Team() == TEAM_SPEC) or (ply:Team() == TEAM_SCP) or preparing or postround then
				if ply:Alive() and (ply:Team() ~= TEAM_SPEC) and (ply:Team() ~= TEAM_SCP) and not preparing and not postround then

					math.randomseed(os.time())
					cough = math.random(1, 100)
					if (ply:KeyDown(IN_SPEED)) then

						asthmaCounter = asthmaCounter + 1
						if asthmaCounter <= 10 then

							if cough <= 20 then

								math.randomseed(os.time())
								soundNum = math.random(1, 4)
								ply:EmitSound(Sound("ambient/voices/cough"..soundNum..".wav"))

							end

						elseif ((asthmaCounter > 10) and (asthmaCounter <=20)) then

							if cough <= 80 then

								math.randomseed(os.time())
								soundNum = math.random(1, 4)
								ply:EmitSound(Sound("ambient/voices/cough"..soundNum..".wav"))

							end

						elseif ((asthmaCounter > 20) and (asthmaCounter < 30)) then

							if cough < 100 then

								math.randomseed(os.time())
								soundNum = math.random(1, 4)
								ply:EmitSound(Sound("ambient/voices/cough"..soundNum..".wav"))

							end

						else

							ply:PrintMessage(4, "You need to catch your breath")
							ply:SetRunSpeed(0)
							ply:SetWalkSpeed(0)
							timer.Create(ply:SteamID64().."AsthmaB", 1, 0, function()

								if (not ply:Alive()) or (ply:Team() == TEAM_SPEC) or (ply:Team() == TEAM_SCP) or preparing or postround then
									timer.Remove(ply:SteamID64().."AsthmaB")
								end

								if asthmaCounterb < 15 then

									asthmaCounterb = asthmaCounterb + 1
									math.randomseed(os.time())
									soundNum = math.random(1, 4)
									ply:EmitSound(Sound("ambient/voices/cough"..soundNum..".wav"))

								else

									ply:SetRunSpeed(oldRunSpeedA)
									ply:SetWalkSpeed(oldWalkSpeedA)
									timer.Remove(ply:SteamID64().."AsthmaB")

								end

							end)

						end

					else

						asthmaCounter = 0

					end

				else

					timer.Remove(ply:SteamID64().."Asthma")

				end

			end)

		end

		if ((number == 3) and (ply:GetNWInt("canBeInfectedb", 0) == 1)) then

			timer.Create("blackblood", 1, 0, function()
				if (not ply:Alive()) or (ply:Team() == TEAM_SPEC) or (ply:Team() == TEAM_SCP) or preparing or postround then
					ply:SetNWInt("canBeInfected", 0)
					ply:SetNWInt("canBeInfectedb", 0)
					timer.Remove("blackblood")
				else
					timer.Simple(1,function()
							ply:PrintMessage(HUD_PRINTCENTER,"You cannot get any other diseases") --lol
					end)
					ply:SetNWInt("canBeInfected", 2)
					ply:SetNWInt("canBeInfectedb", 2)

				end
			end)

		end

		if ((number == 4) and (ply:GetNWInt("canBeInfectedb", 0) == 1)) then

			timer.Simple(5, function() ply:PrintMessage(4, "Your heart starts beating faster") end)
			timer.Simple(15, function()
				if (not ply:Alive()) or (ply:Team() == TEAM_SPEC) or (ply:Team() == TEAM_SCP) or preparing or postround then
					return
				end
				if ply:Alive() then
					ply:Kill()
				end
			end)

		end

		if ((number == 5) and (ply:GetNWInt("canBeInfectedb", 0) == 1)) then

			timer.Simple(4, function() ply:PrintMessage(4, "Your skin feels itchy") end)

		end

		if ((number == 6) and (ply:GetNWInt("canBeInfectedb", 0) == 1)) then

			timer.Create(ply:SteamID64().."Cold", 3, 0, function()

				if (not ply:Alive()) or (ply:Team() == TEAM_SPEC) or (ply:Team() == TEAM_SCP) or preparing or postround then
					timer.Remove(ply:SteamID64().."Cold")
				end

				math.randomseed(os.time())
				soundNum = math.random(1, 4)
				ply:EmitSound(Sound("ambient/voices/cough"..soundNum..".wav"))
			end)

		end

		if ((number == 7) and (ply:GetNWInt("canBeInfected", 0) == 1)) then

			local newRunSpeed = ply:GetRunSpeed()
			ply:SetRunSpeed(newRunSpeed +25)

		end

		if ((number == 8) and (ply:GetNWInt("canBeInfected", 0) == 1)) then

			timer.Create(ply:SteamID64().."regen", 10, 0, function()

				if (not ply:Alive()) or (ply:Team() == TEAM_SPEC) or (ply:Team() == TEAM_SCP) or preparing or postround then

					timer.Remove(ply:SteamID64().."regen")

				end

				ply:SetHealth(ply:GetMaxHealth())

			end)

		end

		if ((number == 9) and (ply:GetNWInt("canBeInfected", 0) == 1)) then

			timer.Simple(4, function() ply:PrintMessage(4, "Your fingers form a fleshy shell") end)

		end

		if ((number == 10) and (ply:GetNWInt("canBeInfectedb", 0) == 1)) then

			local cancercounter = 0
			timer.Create(ply:SteamID64().."Cancer", 3, 0, function()

				if (not ply:Alive()) or (ply:Team() == TEAM_SPEC) or (ply:Team() == TEAM_SCP) or preparing or postround then
					timer.Remove(ply:SteamID64().."Cancer")
				end

				if (cancercounter == 5) then

					ply:SetRunSpeed(ply:GetWalkSpeed())

				else

					cancercounter = cancercounter + 1

				end
				math.randomseed(os.time())
				soundNum = math.random(1, 4)
				ply:EmitSound(Sound("ambient/voices/cough"..soundNum..".wav"))
			end)

		end

		if ((number == 12) and (ply:GetNWInt("canBeInfected", 0) == 1)) then

			timer.Create("SickleCell", 1, 0, function()

				if (not ply:Alive()) or (ply:Team() == TEAM_SPEC) or (ply:Team() == TEAM_SCP) or preparing or postround then
					ply:SetNWInt("canBeInfectedb", 0)
					timer.Remove("SickleCell")
				else
					ply:SetNWInt("canBeInfectedb", 2)
				end

			end)

		end

		if ((number == 11) and (ply:GetNWInt("canBeInfected", 0) == 1)) then

			ply:SetMaxHealth(300)
			ply:SetHealth(300)

		end

	end

end
