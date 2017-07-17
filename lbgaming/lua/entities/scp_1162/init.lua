AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
	
function ENT:Initialize()

	self:SetModel("models/hunter/blocks/cube1x1x025.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NOCLIP)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
		phys:EnableMotion(false)
	end

	local defaultpos = Vector(1777.695068, 881.130493, 43.745945)
	local defaultang = Angle(-90, 0, 180)
	phys:SetAngles(defaultang)
	self:SetAngles(defaultang)
	phys:SetPos(defaultpos)
	self:SetPos(defaultpos)
	
	self:SetUseType(SIMPLE_USE)

	self:SetNoDraw(true)
end

// Add anything else in the Use function
function ENT:Use(c, a)
	if IsValid( c ) and c:IsPlayer() and c:Alive() and c:Team() != TEAM_SPEC and c:Team() ~= TEAM_SCP then --Ripper's check to skip if they are a spectator or SCP
		local chance = math.random(1,100)
		local choose = math.random(1,4)
		local weapon = "none"
		if tostring(c:GetActiveWeapon()) != "[NULL Entity]"  then
			weapon = c:GetActiveWeapon():GetClass()
		end
		//c:PrintMessage(HUD_PRINTTALK, weapon)
		// Incorrect: tostring(c:GetActiveWeapon())
		if weapon == "keycard_level2" then
			if chance < 30 then
				c:StripWeapon("keycard_level2")
				c:Give("keycard_level3")
			elseif chance < 60 then
				c:StripWeapon("keycard_level2")
				c:Give("item_snav_300")
			else
				c:StripWeapon("keycard_level2")
				c:Give("item_eyedrops")
			end
		elseif weapon == "keycard_level3" then
			if chance < 10 then
				c:StripWeapon("keycard_level3")
				c:Give("keycard_level4")
			elseif chance < 60  then
				c:StripWeapon("keycard_level3")
				c:Give("keycard_level2")
			else
				c:StripWeapon("keycard_level3")
				if choose == 1 then c:Give("item_snav_ultimate")
				elseif choose == 2 then c:Give("item_radio")
				else c:Give("item_medkit")
				end
			end
		elseif weapon == "keycard_level4" then
			if chance < 10 then
				c:StripWeapon("keycard_level4")
				c:Give("keycard_level5")
			elseif chance < 40 then
				c:StripWeapon("keycard_level4")
				c:Give("keycard_level3")
			else
				c:StripWeapon("keycard_level4")
				if choose == 1 then c:Give("item_medkit")
				elseif choose == 2 then c:Give("item_nvg")
				else c:Give("item_snav_ultimate")
				end
			end
		elseif weapon == "keycard_level5" then
			if chance < 30 then
				c:StripWeapon("keycard_level5")
				c:Give("keycard_omni")
			elseif chance < 50 then
				c:StripWeapon("keycard_level5")
				c:Give("keycard_level4")
			else
				c:StripWeapon("keycard_level5")
				if choose == 1 then c:Give("item_medkit")
				elseif choose == 2 then c:Give("item_nvg")
				else c:Give("item_snav_ultimate")
				end
			end
		elseif weapon == "keycard_omni" then
			if chance < 30 then
				c:StripWeapon("keycard_omni")
				c:Give("keycard_level5")
			elseif chance < 50 then
				c:StripWeapon("keycard_omni")
				c:Give("keycard_level4")
			else
				c:StripWeapon("keycard_omni")
				if choose == 1 then c:Give("item_medkit")
				elseif choose == 2 then c:Give("item_nvg")
				else c:Give("item_snav_ultimate")
				end
			end
		//elseif tostring(c:GetActiveWeapon()) == "[NULL Entity]" then
		elseif weapon == "none" then
			c:TakeDamage(30)
			c:PrintMessage(HUD_PRINTTALK, "You reach into the hole with nothing in your hand. You feel extremely sick...")
			if chance < 30 then
				c:Give("keycard_level2")
			elseif chance < 45 then
				c:Give("keycard_level3")
			else
				if choose == 1 then c:Give("item_snav_300")
				elseif choose == 2 then c:Give("item_eyedrops")
				else c:Give("item_radio")
				end
			end
		elseif weapon == "item_radio" then
			if chance < 50 then
				c:StripWeapon("item_radio")
				c:Give("item_snav_300")
			else
				c:StripWeapon("item_radio")
				c:Give("item_nvg")
			end
		elseif weapon == "item_snav_300" then
			if chance < 50 then
				c:StripWeapon("item_snav_300")
				c:Give("item_nvg")
			else
				c:StripWeapon("item_snav_300")
				c:Give("keycard_level2")
			end
		elseif weapon == "item_snav_ultimate" then
			if chance < 50 then
				c:StripWeapon("item_snav_ultimate")
				c:Give("keycard_level3")
			else
				c:StripWeapon("item_snav_ultimate")
				c:Give("item_medkit")
			end	
		elseif weapon == "item_eyedrops" then
			if chance < 50 then
				c:StripWeapon("item_eyedrops")
				c:Give("item_radio")
			else
				c:StripWeapon("item_eyedrops")
				c:Give("item_nvg")
			end
		elseif weapon == "item_nvg" then
			if chance < 50 then
				c:StripWeapon("item_nvg")
				c:Give("item_snav_300")
			else
				c:StripWeapon("item_nvg")
				c:Give("item_radio")
			end
		elseif weapon == "item_radio" then
			if chance < 50 then
				c:StripWeapon("item_radio")
				c:Give("item_snav_300")
			else
				c:StripWeapon("item_radio")
				c:Give("item_nvg")
			end
		elseif weapon == "item_medkit" then
			if chance < 50 then
				c:StripWeapon("item_medkit")
				c:Give("keycard_level3")
			else
				c:StripWeapon("item_medkit")
				c:Give("weapon_crowbar")
			end
		elseif weapon == "item_radio" then
			if chance < 50 then
				c:StripWeapon("item_radio")
				c:Give("item_snav_300")
			else
				c:StripWeapon("item_radio")
				c:Give("item_nvg")
			end
		elseif weapon == "weapon_crowbar" then
			if chance < 50 then
				c:StripWeapon("weapon_crowbar")
				c:Give("keycard_level3")
			else
				c:StripWeapon("weapon_crowbar")
				c:Give("item_medkit")
			end
		elseif weapon == "weapon_stunstick" then
			if chance < 20 then
				c:StripWeapon("weapon_stunstick")
				c:Give("keycard_level4")
			else
				c:StripWeapon("weapon_stunstick")
				c:Give("keycard_level3")
			end
		else
			c:PrintMessage(HUD_PRINTTALK,"Invalid input for SCP-1162")
			c:PrintMessage(tostring(weapon))
		end
	end
end
