print("Loading sv_breachhooks for PointShop2...")
local S = function( id )
	return Pointshop2.GetSetting( "Breach Integration", id )
end

hook.Add("BreachPlayerEscape", "PS2_BreachEscape",function(ply,escort) -- player entity, escort boolean
	if S('Escapes.EnableEscapeRewards') ~= true then return end

	if escort == nil then escort = false end
	if ply:Team() == TEAM_SCP then
		ply:PS2_AddStandardPoints( S('Escapes.SCPEscapes'), "Breach escape rewards", true )
	else
		if escort then
			ply:PS2_AddStandardPoints( S('Escapes.PlayerGetsEscorted'), "Breach escape rewards", true )
		else
			ply:PS2_AddStandardPoints( S('Escapes.PlayerEscapesAlone'), "Breach escape rewards", true )
		end
	end
end)

hook.Add( "PlayerDeath", "PS2_BreachPlayerDeath", function( victim, inflictor, attacker )


	print("DEBUG PS2_BreachPlayerDeath: ")
	if victim == attacker then
		print("Victim is attacker")
		return
	end

	--SpecDM
	if (attacker.IsGhost and attacker:IsGhost()) then
		return --Not here
	end

	print("Whatever else here.")
	if S('Kills.EnableKillRewards') ~= true then return end

	if not victim.GetNClass then
		return
	end

	local victimRole = victim:GetNClass( )

	if not attacker.GetNClass then
		return
	end
	local attackerRole = attacker:GetNClass( )

	--TODO: Reimplement this system WAY better than it currently is :\
	if attacker != victim and postround == false and attacker:IsPlayer() then
		if attacker:IsPlayer() then
			if attacker:Team() == TEAM_GUARD then
				--victim:PrintMessage(HUD_PRINTTALK, "You were killed by an MTF Guard: " .. attacker:Nick())
				if victim:Team() == TEAM_SCP then
					--attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 10 points for killng an SCP!")
					--attacker:PS2_AddStandardPoints( S('Kills.PlayerKilledSCP'), "Breach kill rewards", true )
					attacker:PS2_AddStandardPoints( S('Kills.PlayerKilledSCP'), "Breach kill rewards", true )

				elseif victim:Team() == TEAM_CHAOS then
					--attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 5 points for killng a Chaos Insurgency member!")
					attacker:PS2_AddStandardPoints( S('Kills.PlayerKilledChaos'), "Breach kill rewards", true )
				elseif victim:Team() == TEAM_CLASSD then
					--attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng a Class D Personell!")
					attacker:PS2_AddStandardPoints( S('Kills.PlayerKilledOther'), "Breach kill rewards", true )
				end
			elseif attacker:Team() == TEAM_CHAOS then
				--victim:PrintMessage(HUD_PRINTTALK, "You were killed by a Chaos Insurgency Soldier: " .. attacker:Nick())
				if victim:Team() == TEAM_GUARD then
					--attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng an MTF Guard!")
					attacker:PS2_AddStandardPoints( S('Kills.PlayerKilledOther'), "Breach kill rewards", true )
				elseif victim:Team() == TEAM_SCI then
					--attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng a Researcher!")
					attacker:PS2_AddStandardPoints( S('Kills.PlayerKilledOther'), "Breach kill rewards", true )
				elseif victim:Team() == TEAM_SCP then
					--attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 10 points for killng an SCP!")
					attacker:PS2_AddStandardPoints( S('Kills.PlayerKilledSCP'), "Breach kill rewards", true )
				elseif victim:Team() == TEAM_CLASSD then
					--attacker:PrintMessage(HUD_PRINTTALK, "Don't kill Class D Personell, you can capture them to get bonus points!")
					--attacker:AddFrags(1)
				end
			elseif attacker:Team() == TEAM_SCP then
				--victim:PrintMessage(HUD_PRINTTALK, "You were killed by an SCP: " .. attacker:Nick())
				--attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng " .. victim:Nick())
				attacker:PS2_AddStandardPoints( S('Kills.PlayerKilledOther'), "Breach kill rewards", true )
			elseif attacker:Team() == TEAM_CLASSD then
				--victim:PrintMessage(HUD_PRINTTALK, "You were killed by a Class D: " .. attacker:Nick())
				if victim:Team() == TEAM_GUARD then
					--attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 4 points for killng an MTF Guard!")
					attacker:PS2_AddStandardPoints( S('Kills.ClassDKilledMTF'), "Breach kill rewards", true )
				elseif victim:Team() == TEAM_SCI then
					--attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng a Researcher!")
					attacker:PS2_AddStandardPoints( S('Kills.PlayerKilledOther'), "Breach kill rewards", true )
				elseif victim:Team() == TEAM_SCP then
					--attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 10 points for killng an SCP!")
					attacker:PS2_AddStandardPoints( S('Kills.PlayerKilledSCP'), "Breach kill rewards", true )
				elseif victim:Team() == TEAM_CHAOS then
					--attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killng a Chaos Insurgency member!")
					attacker:PS2_AddStandardPoints( S('Kills.PlayerKilledOther'), "Breach kill rewards", true )
				end
			elseif attacker:Team() == TEAM_SCI then
				--victim:PrintMessage(HUD_PRINTTALK, "You were killed by a Researcher: " .. attacker:Nick())
				if victim:Team() == TEAM_SCP then
					--attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 10 points for killng an SCP!")
					attacker:PS2_AddStandardPoints( S('Kills.PlayerKilledSCP'), "Breach kill rewards", true )
				elseif victim:Team() == TEAM_CHAOS then
					--attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 5 points for killng a Chaos Insurgency member!")
					attacker:PS2_AddStandardPoints( S('Kills.PlayerKilledChaos'), "Breach kill rewards", true )
				elseif victim:Team() == TEAM_CLASSD then
					--attacker:PrintMessage(HUD_PRINTTALK, "You've been awarded with 2 points for killing a Class D Personell!")
					attacker:PS2_AddStandardPoints( S('Kills.PlayerKilledOther'), "Breach kill rewards", true )
				end
			end
		end
	end
end )

hook.Add("SpecDMKill","PS2_SpecDMKill",function(victim,attacker)
	if (victim.IsGhost and victim:IsGhost()) then
		if (attacker.IsGhost and attacker:IsGhost()) then
			print("attacker is ghost ")
			if S('SpecDM.SpecDMEnable') then
				print('SpecDM is enabled ')
				--SpecDM is enabled !
				print("adding points ")
				attacker:PS2_AddStandardPoints( S('SpecDM.SpecDMPoints'), "SpecDM Kill", true )
				return
			else
				print("specdm is off")
				return
			end
		end
	end
end)
print("Ready")
