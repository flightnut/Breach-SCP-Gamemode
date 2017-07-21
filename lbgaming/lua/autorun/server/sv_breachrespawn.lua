--Version 1.2

if CLIENT then return end --This should be in /autorun/server/, clients can't do anything

--Convars, Only here so you can know what they are

--Groups that can do !spawn
--link2006_specSpawnPerms = nil

--Changed flags:
--SpawnPerms are only on the SERVER
--RoundNoSpec are Notified to clients && Replicated && Server-only

link2006_SpawnPerms = CreateConVar("spawn_perms","Assistant,moderator",{FCVAR_SERVER_CAN_EXECUTE},"Case sensitive comma seperated list of (ulx) groups that can only !spawn players as classd")
link2006_ForceSpawn = CreateConVar("br_roundnospec","0",{FCVAR_SERVER_CAN_EXECUTE,FCVAR_REPLICATED,FCVAR_NOTIFY},"Always Respawn players during this round")
link2006_RespawnTime = CreateConVar("br_roundnospec_delay","3.0",{FCVAR_SERVER_CAN_EXECUTE,FCVAR_REPLICATED},"Delay (in seconds) between death and respawn when br_roundnospec is 1")

hook.Remove("PlayerSay","Link2006_SpecSpawn")
hook.Remove("PostCleanupMap","Link2006_AutoSpawn")
hook.Remove("PlayerDeath","br_ForceRespawn")
hook.Remove("PlayerSpawn","br_ForceRespawn_OnJoin") --Make sure this code is not running anymore BECAUSE IM AN IDIOT
hook.Remove("PlayerInitialSpawn","br_ForceRespawn_OnJoin") --Make sure this code is not running anymore BECAUSE IM AN IDIOT

function Link2006_tSayColor(pAdmin, ...) --Calling Admin (to allow us to say "You" to the admin) then Text/Color ad infinitum :)
	if pAdmin ~= nil then
		for k,ply in pairs(player.GetAll()) do
			if pAdmin == ply then
				ULib.tsayColor(ply,true,team.GetColor(pAdmin:Team()),"You ",Color(255,255,255), ...)
			else
				ULib.tsayColor(ply,true,team.GetColor(pAdmin:Team()),pAdmin:Nick().." ",Color(255,255,255), ...)
			end
		end
	else
		--How the fuck did we get here?
		--Seriously what the fuck have you done to my code.
		ULib.tsayColor(nil,true,Color(0,0,0),"(CONSOLE) ",Color(255,255,255), ...)
	end
end


function Link2006_GetSpawns(tSpawns)
	if tSpawns == nil or type(tSpawns) ~= "table" then error("Unexpected value for Link2006_GetSpawns: "..tostring(tSpawns)) end --if this runs: wtf happened?
	local temp_Spawns = {}

	for k,SpawnPos in pairs(tSpawns) do --We use the original table, add ones without a player to a table
		--Make a box around that spawn to make sure we can spawn spectators...
		local SpawnPos_Start = SpawnPos - Vector(24,24,16)
		local SpawnPos_End = SpawnPos + Vector(24,24,64) --48x48x72 box, makes sure we're safe.
		local SpawnPos_Ents = ents.FindInBox(SpawnPos_Start,SpawnPos_End)
		local SpawnPos_Valid = true --Is there any players there?

		for k,v in pairs(SpawnPos_Ents) do
			if v:GetClass() == "player" then  -- Is there any player in that box?
				SpawnPos_Valid = false --Yes, it's not a valid option anymore.
			end
		end

		if SpawnPos_Valid then --There's no players in that box,
			table.insert(temp_Spawns,SpawnPos) --Valid spawn for spectators :)
		end
	end

	--print("[BreachRespawn] We have "..#temp_Spawns.." valid spawns")
    if #temp_Spawns <= 0 then
    --print("[BreachRespawn] WARN: No spawn available, Giving 8 new positions")
        temp_Spawns = {
            Vector(-1417,595,35),
            Vector(-1254,608,35),
            Vector(-1045,616,35),
            Vector(-783,586,35),
            Vector(-782,423,49),
            Vector(-982,422,49),
            Vector(-1263,420,49),
            Vector(-1454,418,49),
        }
    end
	return temp_Spawns
end



function Link2006_IsSpec(spec) --Made this so i can replace every checks at once instead of every single one of them, still not readable tho.
	--This might be returning if GetNClass == Spectator isntead.
	--As this seems to be MUCH MORE Reliable than TEAM_SPEC for some fucking dumb reason :(

	--Problem i have right now is spec.ActivePlayer might always be false for some reason,
	if (spec.ActivePlayer == false) and (spec:Team() ~= TEAM_SPEC and (spec:GetNClass() == "Spectator")) then
		--Uh, what?
		print("[BreachRespawn] WARN: \""..spec:Nick().."\" is not a spectator YET They aren't active? [ActivePlayer="..tostring(spec.ActivePlayer).."; Team="..tostring(spec:Team()).."; Class="..spec:GetNClass().."]")
	end

	if (spec:Team() == TEAM_SPEC or (spec:GetNClass() == "Spectator")) and (spec.ActivePlayer ~= false) then
		--SpecDM Support here
		if spec:IsGhost() then
			--They're in SpecDM, Move them away!
			spec:ManageGhost( false, true )
		end
		return true
	elseif	spec:Team() ~= TEAM_SPEC and spec:GetNClass() == "Spectator" and spec.ActivePlayer == false then
		--They have br_spectate on
		spec:SetSpectator() --They're alive but shouldn't be, go back to spectators please.
		ULib.tsayError(spec,"You have br_spectate set to spectator, you have been put back to spectators",false)
		return false
	else
		return false
	end
	--return ((spec:Team() == TEAM_SPEC) or (spec:GetNClass() == "Spectator")) and ((spec.ActivePlayer ~= false) and (spec:Team() == TEAM_SPEC))
end

--This is the old code for checking the spawns
--[[
if #tSpecSpawns > 0 then
	specNewSpawn,specKey = table.Random(tSpecSpawns)
	--table.RemoveByValue(specNewSpawn,tSpecSpawns)
	table.remove(tSpecSpawns,specKey)
	spec:SetPos(specNewSpawn)
else
	--We did run out of spawns, let's ignore this for now and spawn them normally...
	--print("[BreachRespawn] WARN: RAN OUT OF SPAWNS FOR SPECTATORS!")
end
]]--

function Link2006_RespawnSpecs(pAdmin,sClass,pCount_max)
	if pCount_max then
		pCount = 0
	end

	if sClass == nil then
		sClass = "classd" --we'll spawn them as Class D...
	end

	--Respawns spectators into Class Ds
	--GET POSSIBLE SPAWNS
	-- warning, if we exhaust our list; it's RIP and they spawn at the normal one... but it shouldnt be really a problem i guess
	if sClass == "classd" then
		--local tSpecSpawns = Link2006_GetSpawns(SPAWN_CLASSD)
		--ClassDs are actually nocollided now!
		for k,spec in pairs(player.GetAll()) do

			if Link2006_IsSpec(spec) then --Respawn Spectators (Team/GetNClass) but not br_spectate people
				spec:SetClassD() -- We set them to ClassD
				spec:SetPos(table.Random(SPAWN_CLASSD)) --Players are nocollided, dont need to care where to spawn :)
				--OldCode About Checking Spawns Here

				if pCount_max then
					pCount = pCount + 1
					--print(pCount)
					if pCount >= pCount_max then
						break  -- Stop spawning Spectators
					end
				end
			end
		end
	elseif sClass == "researcher" then
		--CODE HERE FOR RESEARCHERS
		--table is SPAWN_SCIENT
		--local tSpecSpawns = Link2006_GetSpawns(SPAWN_SCIENT)

		for k,spec in pairs(player.GetAll()) do
			if Link2006_IsSpec(spec) then --Don't spawn people that have br_spectate set
				spec:SetScientist() -- We don't care if Scientists/Researchers can't spawn in their own spawns, normal spawn is close enough anyway
				spec:SetPos(table.Random(SPAWN_SCIENT))
				if pCount_max then
					pCount = pCount + 1
					--print(pCount)
					if pCount >= pCount_max then
						break  -- Stop spawning Spectators
					end
				end
			end
		end
	elseif sClass == "mtf" then
		--CODE HERE FOR MTF
		local tSpecSpawns = Link2006_GetSpawns(SPAWN_GUARD)

		for k,spec in pairs(player.GetAll()) do
			if Link2006_IsSpec(spec) then --Don't spawn people that have br_spectate set
				if #tSpecSpawns > 0 then
					spec:SetGuard()
					specNewSpawn,specKey = table.Random(tSpecSpawns)
					--table.RemoveByValue(specNewSpawn,tSpecSpawns)
					table.remove(tSpecSpawns,specKey)
					spec:SetPos(specNewSpawn)
					if pCount_max then
						pCount = pCount + 1
						--print(pCount)
						if pCount >= pCount_max then
							break  -- Stop spawning Spectators
						end
					end
				else
					--We did run out of spawns, let's ignore this for now and spawn them normally...
					--print("[BreachRespawn] WARN: RAN OUT OF SPAWNS FOR SPECTATORS!")
				end
			end

		end

	elseif sClass == "ntf" then
		--CODE HERE FOR NTF
		local tSpecSpawns = Link2006_GetSpawns(SPAWN_OUTSIDE)

		for k,spec in pairs(player.GetAll()) do
			if Link2006_IsSpec(spec) then --Don't spawn people that have br_spectate set
				if #tSpecSpawns > 0 then
					spec:SetNTF()
					specNewSpawn,specKey = table.Random(tSpecSpawns)
					--table.RemoveByValue(specNewSpawn,tSpecSpawns)
					table.remove(tSpecSpawns,specKey)
					spec:SetPos(specNewSpawn)
					if pCount_max then
						pCount = pCount + 1
						--print(pCount)
						if pCount >= pCount_max then
							break  -- Stop spawning Spectators
						end
					end
				else
					--We did run out of spawns, let's ignore this for now and spawn them normally...
					--print("[BreachRespawn] WARN: RAN OUT OF SPAWNS FOR SPECTATORS!")
				end
			end

		end
	elseif sClass == "chaos" then
		--CODE HERE FOR CHAOS INSURGENCY (AS NTF)
		local tSpecSpawns = Link2006_GetSpawns(SPAWN_OUTSIDE)

		for k,spec in pairs(player.GetAll()) do
			if Link2006_IsSpec(spec) then --Don't spawn people that have br_spectate set
				if #tSpecSpawns > 0 then
					spec:SetChaosInsurgency(3)
					specNewSpawn,specKey = table.Random(tSpecSpawns)
					--table.RemoveByValue(specNewSpawn,tSpecSpawns)
					table.remove(tSpecSpawns,specKey)
					spec:SetPos(specNewSpawn)
					if pCount_max then
						pCount = pCount + 1
						--print(pCount)
						if pCount >= pCount_max then
							break  -- Stop spawning Spectators
						end
					end
				else
					--We did run out of spawns, let's ignore this for now and spawn them normally...
					--print("[BreachRespawn] WARN: RAN OUT OF SPAWNS FOR SPECTATORS!")
				end
			end

		end
	end

	local pCount_str = 'all'
	if pCount_max then
		if pCount then
			pCount_str = tostring(pCount)..' '
		end
	end
	if (pAdmin ~= nil) and (ulx ~= nil) then --Just making sure we do have ulx installed and the admin do exist
		--ulx.fancyLogAdmin( pAdmin, "#A respawned spectators as "..sClass) --Tell everyone which admin respawned spectators.
		if sClass == "chaos" then sClass = "ntf" end --Fixed.
		Link2006_tSayColor(pAdmin,"respawned "..pCount_str.." spectators as "..sClass)
	end

	print("[BreachRespawn] "..pCount_str.." Spectators have been respawned as "..sClass)
end

print("[BreachRespawn] Creating PlayerSay hook...")


--I'm Sorry, this looks like a fucking mess now :(
--I am very very sorry...

hook.Add( "PlayerSay", "Link2006_SpecSpawn", function( ply, text)
	--print("\""..text.."\" from "..ply:Nick()) --Debugs but cleaner lol
	--If Player is an admin OR an Assistant:
	local sPerms = string.Explode(",",link2006_SpawnPerms:GetString()) --Get table of the groups that aren't Admins
	local spec_chatArgs = string.Explode(" ",text) --idunno if i should have it check if the player is admin

	if (ply:IsAdmin() or ply:IsSuperAdmin()) then --or table.HasValue( sPerms, ply:GetUserGroup() ) then --If the speaker is admin, Check what he's saying; that way non-admins can't spam string.Explode :)
		--!specspawn/!spawnspec

		if string.lower(spec_chatArgs[1]) == "!spawnspec" or string.lower(spec_chatArgs[1]) == "!specspawn" then --i fixed it guys oops
			if (spec_chatArgs[2] ~= nil and spec_chatArgs[2] ~= "") then -- and !table.HasValue( sPerms, ply:GetUserGroup() ) then
				if string.lower(spec_chatArgs[2]) == "scientist" or string.lower(spec_chatArgs[2]) == "scientists" or string.lower(spec_chatArgs[2]) == "researcher" or string.lower(spec_chatArgs[2]) == "researchers" then
				--Researcher
					Link2006_RespawnSpecs(ply,"researcher",tonumber(spec_chatArgs[3])) --Respawn as Researcher
				elseif string.lower(spec_chatArgs[2]) == "chaos" then --those are TeamDM Chaos for now; will probably force-change to ntf chaos
					Link2006_RespawnSpecs(ply,"chaos",tonumber(spec_chatArgs[3])) --Respawn as CI
				elseif string.lower(spec_chatArgs[2]) == "ntf" or string.lower(spec_chatArgs[2]) == "ntfs" then --real ntf
					Link2006_RespawnSpecs(ply,"ntf",tonumber(spec_chatArgs[3])) --Respawn as NTF
				elseif string.lower(spec_chatArgs[2]) == "mtf" or string.lower(spec_chatArgs[2]) == "mtfs" then
					Link2006_RespawnSpecs(ply,"mtf",tonumber(spec_chatArgs[3])) --Respawn as MTF
				elseif string.lower(spec_chatArgs[2]) == "classd" then --Class D (invalid args or simply "classd")
					Link2006_RespawnSpecs(ply,"classd",tonumber(spec_chatArgs[3])) --Call RespawnSpecs and pass the admin entity through
				else
					ULib.tsayError(ply,"Invalid class specified, Valid Choices are: ",true)
					ULib.tsayError(ply,"classd,researcher,mtf,chaos,ntf",true)
				end
			else -- No arguments or player is an assistant.
				--Link2006_RespawnSpecs(ply,"classd") --Assistant only
				ULib.tsayError(ply,"No class specified, Valid Choices are: ",true)
				ULib.tsayError(ply,"classd,researcher,mtf,chaos,ntf",true)
			end
			--Silence chat
			return ""
		elseif string.lower(spec_chatArgs[1]) == "!spawn" then
			--Specific spawn
			if (spec_chatArgs[2] ~= nil and spec_chatArgs[2] ~= "") then
				--Find Player by Name  here
				local plySpawn,plyErr = ULib.getUser(spec_chatArgs[2],true,ply)
				if plySpawn then
					if (spec_chatArgs[3] ~= nil and spec_chatArgs[3] ~= "") then
						if plySpawn.ActivePlayer == false and spec_chatArgs[4] ~= "force" then
							if plySpawn == ply then
								ULib.tsayError(ply,"You have br_spectate set to true, add 'force' after role to override",true)
							else
								ULib.tsayError(ply,plySpawn:Nick().." has br_spectate set to true, add 'force' after role to override",true)
							end
						else
							--SpecDM Support here
							if plySpawn:IsGhost() then
								--They're in SpecDM, Move them away!
								plySpawn:ManageGhost( false, true )
							end
							if string.lower(spec_chatArgs[3]) == "classd" then --Class D
								plySpawn:SetClassD()
								--plySpawn:SetPos(table.Random(Link2006_GetSpawns(SPAWN_CLASSD)))
								plySpawn:SetPos(table.Random(SPAWN_CLASSD))
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as class D",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as class D")
							elseif string.lower(spec_chatArgs[3]) == "scientist" or string.lower(spec_chatArgs[3]) == "researcher" then
								--Researcher
								plySpawn:SetScientist()
								--plySpawn:SetPos(table.Random(Link2006_GetSpawns(SPAWN_SCIENT)))
								plySpawn:SetPos(table.Random(SPAWN_SCIENT))
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as a researcher",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as a researcher")
							elseif string.lower(spec_chatArgs[3]) == "commander" then
								plySpawn:SetCommander()
								plySpawn:SetPos(table.Random(Link2006_GetSpawns(SPAWN_GUARD)))
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as a MTF Commander",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as an MTF Command")
							elseif string.lower(spec_chatArgs[3]) == "mtf" then
								plySpawn:SetGuard()
								plySpawn:SetPos(table.Random(Link2006_GetSpawns(SPAWN_GUARD)))
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as a MTF Guard",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as an MTF Guard")
							elseif string.lower(spec_chatArgs[3]) == "chaos" then
								plySpawn:SetChaosInsurgency(3)
								plySpawn:SetPos(table.Random(Link2006_GetSpawns(SPAWN_OUTSIDE)))
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as a MTF Nine Tailed Fox",plySpawn) --Tell everyone an admin respawned a player as what
								--Oh yeah this part i need to make sure the chat doesn't betray my lie ;)
								Link2006_tSayColor(ply,"respawned ",team.GetColor(TEAM_GUARD),plySpawn:Nick(),Color(255,255,255)," as an MTF Nine Tailed Fox")
								print("[BreachRespawn] Admin Spawned a Chaos")
							elseif string.lower(spec_chatArgs[3]) == "sitedirector" then
								plySpawn:SetSiteDirector(true) --Uh
								plySpawn:SetPos(table.Random(Link2006_GetSpawns(SPAWN_SCIENT))) --idk where else to put him.
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as a site director",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as a site director")
							elseif string.lower(spec_chatArgs[3]) == "ntf" then
								plySpawn:SetNTF()
								plySpawn:SetPos(table.Random(Link2006_GetSpawns(SPAWN_OUTSIDE)))
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as a MTF Nine Tailed Fox",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as an MTF Nine Tailed Fox")
							elseif string.lower(spec_chatArgs[3]) == "scp-173" then
								plySpawn:SetSCP173()
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as SCP-173",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as SCP-173")
							elseif string.lower(spec_chatArgs[3]) == "scp-1048a" then
								plySpawn:SetSCP1048a()
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as SCP-1048a",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as SCP-1048A")
							elseif string.lower(spec_chatArgs[3]) == "scp-106" then
								plySpawn:SetSCP106()
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as SCP-106",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as SCP-106")
							elseif string.lower(spec_chatArgs[3]) == "scp-049" then
								plySpawn:SetSCP049()
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as SCP-049",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as SCP-049")
							elseif string.lower(spec_chatArgs[3]) == "scp-457" then
								plySpawn:SetSCP457()
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as SCP-457",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as SCP-457")
							elseif string.lower(spec_chatArgs[3]) == "scp-008-2" then
								plySpawn:SetSCP0082() --Plague Zombie (Infects players)
								plySpawn:SetPos(table.Random(Link2006_GetSpawns(SPAWN_ZOMBIES)))
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as a SCP-008-2",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as an SCP-008-2")
							elseif string.lower(spec_chatArgs[3]) == "scp-049-2" or string.lower(spec_chatArgs[3]) == "ntfs" then --real ntf
								plySpawn:SetSCP0492() --SCP049 Zombie (Kills players)
								plySpawn:SetPos(table.Random(Link2006_GetSpawns(SPAWN_ZOMBIES)))
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as a SCP-049-2",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as an SCP-049-2")
							elseif string.lower(spec_chatArgs[3]) == "scp-035" or string.lower(spec_chatArgs[3]) == "mtfs" then
								plySpawn:SetSCP035()
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as SCP-035",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as SCP-035")
							elseif string.lower(spec_chatArgs[3]) == "scp-682" then
								plySpawn:SetSCP682()
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as SCP-106",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as SCP-682")
							elseif string.lower(spec_chatArgs[3]) == "scp-966" then
								plySpawn:SetSCP966()
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as SCP-106",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as SCP-966")
							elseif string.lower(spec_chatArgs[3]) == "scp-076-2" then
								plySpawn:SetSCP0762()
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as SCP-106",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as SCP-076-2")
							elseif string.lower(spec_chatArgs[3]) == "scp-939" then
								plySpawn:SetSCP939()
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as SCP-106",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as SCP-939")
							elseif string.lower(spec_chatArgs[3]) == "scp-999" then
								plySpawn:SetSCP999()
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as SCP-106",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as SCP-999")
							elseif string.lower(spec_chatArgs[3]) == "scp-1048b" then
								plySpawn:SetSCP1048B()
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as SCP-106",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as SCP-1048B")
							else
								ULib.tsayError(ply,"Invalid class specified, Valid Choices are: ",true)
								ULib.tsayError(ply,"classd,researcher,commander,mtf,chaos,sitedirector,ntf",true)
								ULib.tsayError(ply,"scp-173,scp-1048a,scp-106,scp-049,scp-457,scp-008-2",true)
								ULib.tsayError(ply,"scp-049-2,scp-035,scp-682,scp-966,scp-076-2,scp-939",true)
								ULib.tsayError(ply,"scp-999,scp-1048b",true)
							end
						end
					else
						ULib.tsayError(ply,"No class specified, Valid Choices are: ",true)
						ULib.tsayError(ply,"classd,researcher,commander,mtf,chaos,sitedirector,ntf",true)
						ULib.tsayError(ply,"scp-173,scp-1048a,scp-106,scp-049,scp-457,scp-008-2",true)
						ULib.tsayError(ply,"scp-049-2,scp-035,scp-682,scp-966,scp-076-2,scp-939",true)
						ULib.tsayError(ply,"scp-999,scp-1048b",true)

					end
				else
					if plyErr then
						ULib.tsayError(ply,plyErr,true) -- An error occured in ULib.getUser...
					end
				end
			else
				ULib.tsayError(ply,"No target specified. Use !spawn target class [force]",true)
				ULib.tsayError(ply,"No class specified, Valid Choices are: ",true)
				ULib.tsayError(ply,"classd,researcher,commander,mtf,chaos,sitedirector,ntf",true)
				ULib.tsayError(ply,"scp-173,scp-1048a,scp-106,scp-049,scp-457,scp-008-2",true)
				ULib.tsayError(ply,"scp-049-2,scp-035,scp-682,scp-966,scp-076-2,scp-939",true)
				ULib.tsayError(ply,"scp-999,scp-1048b",true)
			end
			return ""
		end
	elseif table.HasValue( sPerms, ply:GetUserGroup() ) then
		if string.lower(spec_chatArgs[1]) == "!spawn" then
			--Specific spawn
			if (spec_chatArgs[2] ~= nil and spec_chatArgs[2] ~= "") then
				--Find Player by Name  here
				local plySpawn,plyErr = ULib.getUser(spec_chatArgs[2],true,ply)
				--TODO: Maybe check if the target is a spectator or not
				if plySpawn then
					if plySpawn.ActivePlayer ~= false then
						--SpecDM Support here
						if plySpawn:IsGhost() then
							--They're in SpecDM, Move them away!
							plySpawn:ManageGhost( false, true )
						end
						plySpawn:SetClassD()
						--plySpawn:SetPos(table.Random(Link2006_GetSpawns(SPAWN_CLASSD)))
						plySpawn:SetPos(table.Random(SPAWN_CLASSD))
						--ulx.fancyLogAdmin( pAdmin, "#A respawned #T",plySpawn) --Tell everyone an admin respawned a player as what
						Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as a class D")
					else
						if plySpawn == ply then
							ULib.tsayError(ply,"You have br_spectate set to true",true)
						else
							ULib.tsayError(ply,plySpawn:Nick().." has br_spectate set to true, sorry",true)
						end
					end
				else
					if plyErr then
						ULib.tsayError(ply,plyErr,true) -- An error occured in ULib.getUser...
					end
				end
			else
				ULib.tsayError(ply,"No target specified. Use !spawn target",true)
			end
		return ""
		elseif string.lower(spec_chatArgs[1]) == "!spawnspec" or string.lower(spec_chatArgs[1]) == "!specspawn" then
			ULib.tsayError(ply,"You do not have access to this command!",true)
			return ""
		end
	elseif string.StartWith(text,"!spawnspec") or string.StartWith(text,"!specspawn") or string.StartWith(text,"!spawn") then
		ULib.tsayError(ply,"You do not have access to this command!",true)
		return ""
	end
end)

hook.Add("PostCleanupMap","Link2006_AutoSpawn",function() --On New Round

    if link2006_ForceSpawn:GetBool() then
        print("[BreachRespawn] Setting br_roundnospec to 0 ...")
        link2006_ForceSpawn:SetBool(false)
    end

	print("[BreachRespawn] CleanUpMap() called, Deleting Previous timers...")
    timer.Remove('BreachRespawn_Spectators') --The Spectator Respawn Timer
    timer.Remove('BreachRespawn_Spectators_Init') --The timer that checks if we can start the Spectator Respawn timer.
    timer.Create("BreachRespawn_Spectators_Init", 3, 1, function()
        if roundtype and normalround then
            --print("[BreachRespawn] DEBUG: "..roundtype.name)
            --Announce in chat a Special round started
            if (roundtype.name ~= normalround.name) then
                ULib.tsayColor(nil,true,Color(255,255,255),"Special Round! ",team.GetColor(TEAM_CLASSD),roundtype.name)
            end

            if (roundtype.name == normalround.name) or (roundtype.name == ROUNDS.multiplebreaches.name) then --HARDCODED, Checks if it's a round with Class Ds...
                print("[BreachRespawn] Round is "..roundtype.name..", Respawning specs in 12 seconds...")
				if (roundtype.name == ROUNDS.multiplebreaches.name) then
					ULib.tsayColor(nil,true,team.GetColor(TEAM_SCP),"SCP-035",Color(255,255,255)," can kill ",team.GetColor(TEAM_CLASSD),"ClassDs",Color(255,255,255)," in this round!") --We have FriendlyFire Enabled when it's TTT
				end
                timer.Create("BreachRespawn_Spectators", 12, 1, function()   Link2006_RespawnSpecs(nil,"classd",nil) end)
			elseif (roundtype.name == "ROUNDS.spies.name is DISABLED") then
                print("[BreachRespawn] Round is "..roundtype.name..", Respawning specs in 12 seconds...")
				ULib.tsayColor(nil,true,Color(255,255,255),"Friendly fire is enabled for this round!") --We have FriendlyFire Enabled when it's TTT
                timer.Create("BreachRespawn_Spectators", 12, 1, function()   Link2006_RespawnSpecs(nil,"mtf",nil) end) --let's allow them to respawn as MTF anyway...
            else --TODO: ADD SUPPORT FOR OTHER ROUNDS, NOT JUST THESE.
                print("[BreachRespawn] Round is "..roundtype.name..", Skipping Respawn")
            end
        else
            print("[BreachRespawn] roundtype/normalround is false/nil, Respawning specs in 12 seconds...")
            timer.Create("BreachRespawn_Spectators", 12, 1, function()   Link2006_RespawnSpecs(nil,"classd",nil) end)
        end
    end)
	--Remove previous SCP-294 model from map
	timer.Simple(1,function()
		print("[BreachRespawn] Removing all duplicate models ...")
		--

		print("Removing scp-294...")
		for _,prop in pairs(ents.FindByModel("models/vinrax/scp294/scp294.mdl")) do
			prop:Remove() --This worked so w/e sure.
		end
		print("Removing Fire Extinguisher")
		for _,prop in pairs(ents.FindByModel("models/props/cs_office/fire_extinguisher.mdl")) do
			prop:Remove() --This worked so w/e sure.
		end
		print("Removing prop_physics dupes...")
		for _,prop in pairs(ents.FindByClass('prop_physics')) do
			if prop:GetModel() == "models/vinrax/scp_cb/book.mdl" then
				print("Removing scp-1025..")
				prop:Remove() --Safety.
			elseif prop:GetModel() == "models/foundation/items/scp178.mdl" then
				print("Removing scp-178...")
				prop:Remove() --Safety.
			end
		end

	end)
	--Load permaprops
	timer.Simple(2,function()
		RunConsoleCommand("PermaWorld_Restore") --Map got cleaned up, respawn the props. :)
	end)
end)

print("[BreachRespawn] Installing br_roundnospec hook...")
--TODO: Make it so new players that join also get respawned :)


hook.Add("PlayerInitialSpawn","br_ForceRespawn_OnJoin",function(ply)
	timer.Simple(link2006_RespawnTime:GetFloat(),function()
		if link2006_ForceSpawn:GetBool() then --If PlayerRespawn is Enabled
			if postround then
				return --Stop.
			end
			if (roundtype.name == "ROUNDS.spies.name is DISABLED") then --If it's the TTT Gamemode, spawn them as a Guard :^) lmao
				ply:SetGuard()
				ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_GUARD)))
			elseif (roundtype.name == normalround.name) or (roundtype.name == ROUNDS.multiplebreaches.name) then
				if ply:IsUserGroup("VIP") then --This feels like Pay2Win but w/e
					local plySpawnRNG = math.Round ( math.random ( 1,5 ) )  --1,2 = Researcher, 3,4=MTF, 5=Chaos
					if plySpawnRNG == 1 or plySpawnRNG == 2 then
				        ply:SetScientist()
				        ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_SCIENT)))
					elseif plySpawnRNG == 3 or plySpawnRNG == 4 then
				        ply:SetGuard()
				        ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_GUARD)))
					elseif plySpawnRNG == 5 then
						ply:SetChaosInsurgency(1) -- The MTF Spy :)
						ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_GUARD)))
					else
				        ply:SetScientist()
				        ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_SCIENT)))
					end
				else
					ply:SetClassD()
					ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_CLASSD)))
				end
			elseif roundtype.name == ROUNDS.zombieplague.name then --Hm
				ply:SetSCP0082()
				ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_CLASSD)))
			elseif roundtype.name == ROUNDS.assault.name then
				local plySpawnRNG = math.Round ( math.random ( 1,2 ) )
				if plySpawnRNG == 2 then
					ply:SetGuard()
					ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_GUARD)))
				else
					ply:SetChaosInsurgency(4) -- Why is this 4?
					ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_CLASSD)))
				end
			else
				print("Unknown Gametype, Unable to spawn new player")
			end
		end
	end)
end)

hook.Add("PlayerDeath","br_ForceRespawn", function(ply)
    if link2006_ForceSpawn:GetBool() then --If PlayerRespawn is Enabled
        if postround then
            return --Stop if round is over .
        end
		local plyTeam = ply:Team()
        local rl = ply:GetNClass()
        timer.Simple(link2006_RespawnTime:GetFloat(),function()
            if Link2006_IsSpec(ply) ~= true then return end --Ignore Spectator with br_spectate (and fix broken players while at it)

            if rl == ROLE_SCP035 then
                ply:SetSCP035()
            elseif rl == ROLE_SCP1048A then
                ply:SetSCP1048a()
            elseif rl == ROLE_SCP173 then
                ply:SetSCP173()
            elseif rl == ROLE_SCP106 then
                ply:SetSCP106()
            elseif rl == ROLE_SCP049 then
                ply:SetSCP049()
            elseif rl == ROLE_SCP457 then
                ply:SetSCP457()
            elseif rl == ROLE_SCP0492 then
                ply:SetSCP0492()
			elseif rl == ROLE_MTFGUARD and plyTeam == TEAM_GUARD then --If they are MTF
		        ply:SetGuard()
		        ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_GUARD)))
		    elseif rl == ROLE_MTFGUARD and plyTeam == TEAM_CHAOS then --If they are MTF CI
		        ply:SetChaosInsurgency(1) --Normal CI
		        ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_GUARD)))
		    elseif rl == ROLE_MTFCOM then
		        ply:SetCommander()
		        ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_GUARD)))
		    elseif rl == ROLE_MTFNTF and plyTeam == TEAM_GUARD then -- If they are NTF...
		        ply:SetNTF() --Respawn as NTF, they were NTF
		        if roundtype then
		            if (roundtype.name == ROUNDS.assault.name) then --If it's the Assault gamemode
		                ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_GUARD)))
		            else
		                ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_OUTSIDE)))
		            end
		        else
		            ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_OUTSIDE)))
		        end
		    elseif rl == ROLE_MTFNTF and plyTeam == TEAM_CHAOS then --if they are NTF Chaos (Spy)
		        ply:SetChaosInsurgency(3) --Respawn as NTF Chaos
		        if roundtype then
		            if (roundtype.name == "ROUNDS.spies.name is DISABLED") then --If it's the TTT Gamemode, respawn them lmao
		                ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_GUARD)))
		            else
		                ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_OUTSIDE)))
		            end
		        else
		            ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_OUTSIDE)))
		        end
		    elseif rl == ROLE_CLASSD then
		        ply:SetClassD()
		        --ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_CLASSD)))
				ply:SetPos(table.Random(SPAWN_CLASSD))
		    elseif rl == ROLE_RES then
		        ply:SetScientist()
		        --ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_SCIENT)))
				ply:SetPos(table.Random(SPAWN_SCIENT))
		    elseif rl == ROLE_CHAOS then --TDM Chaos (Unused!)
		        ply:SetChaosInsurgency() --Not the spy version.
		        if roundtype then
		            if (roundtype.name == ROUNDS.assault.name) then --If it's the Assault gamemode
		                ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_CLASSD)))
		            else
		                ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_OUTSIDE))) --Idk where to spawn normal CI
		            end
		        else
		            ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_OUTSIDE))) --Idk where to spawn normal CI
		        end
		        --print("WARN: THIS IS USUALLY NEVER CALLED, WHAT HAPPENED?")
			elseif rl == ROLE_MTFNTF and plyTeam == TEAM_SPEC then
				--WHY IS ASSAULT SETTING MTFS IN TEAM_SPEC WTF ... Let's respawn them as they should anyway ?
				ply:SetNTF() --Respawn as NTF, they were NTF
				if roundtype then
					if (roundtype.name == ROUNDS.assault.name) then --If it's the Assault gamemode
						ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_GUARD)))
					else
						ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_OUTSIDE)))
					end
				else
					ply:SetPos(table.Random(Link2006_GetSpawns(SPAWN_OUTSIDE)))
				end
            else
				--Mostly here for debugging im sorry.
		        print('[AntiRDM] RESPAWN FAILED: ')
		        print("[AntiRDM] Role was "..rl)
		        local team_names= {}
		        team_names[TEAM_SCP] = "TEAM_SCP"
		        team_names[TEAM_GUARD] = "TEAM_GUARD"
		        team_names[TEAM_CLASSD] = "TEAM_CLASSD"
		        team_names[TEAM_SPEC] = "TEAM_SPEC"
		        team_names[TEAM_SCI] = "TEAM_SCI"
		        team_names[TEAM_CHAOS] = "TEAM_CHAOS"

		        print("[AntiRDM] Team was "..team_names[plyTeam])
		        print("[AntiRDM] We could not respawn the player, role not supported.")
            end
        end)
    end
end)


local parseeEntities = {
	scp_012 = Vector(-320,-222.50,-110),
	npc_scp_939a = Vector(1139.425049,22.350645,-739.968750),
	npc_scp_939b = Vector(2025.817383,-787.103455,-739.968750),
	npc_scp_939c = Vector(1793.306763,-1728.281250,-739.968750),
	scp_1162 = Vector(1777.695068, 881.130493, 43.745945),
	--Name = Position
}


print("[BreachRespawn] Creating hook to respawn entity ...")
hook.Add('PostCleanupMap','ParseeEntSpawner',function()
	timer.Remove("ParseeEntSpawnTimer")
	timer.Create("ParseeEntSpawnTimer",4,1,function()
		--Create entities here.
		for kClass,vPos in pairs(parseeEntities) do
		print("[BreachRespawn] Spawning "..kClass.. " @ "..tostring(vPos).."...")
			local vEnt = ents.Create(kClass)
			if not IsValid(vEnt) then
				print("[BreachRespawn] Failed to spawn "..kClass)
			else
				if kClass == "scp_012" then
					vEnt:SetAngles(Angle(0,-90,0))
				end
				vEnt:SetPos(vPos)
				vEnt:Spawn()
			end
		end
	end)

end)
print("[BreachRespawn] Ready.")
