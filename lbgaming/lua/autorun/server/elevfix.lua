Link2006_version = "1.5"

if CLIENT then return end --This should be in /autorun/server/, clients can't do anything

--Configurable damage for elevators and doors
local elevDamage = 0 -- Default: 0 (RECOMMENDED)
local doorDamage = 0 -- Default: 0 (RECOMMENDED)

--Convars, Only here so you can know what they are

--Groups that can do !spawn
--link2006_specSpawnPerms = nil
link2006_SpawnPerms = CreateConVar("spawn_perms","Assistant",FCVAR_SERVER_CAN_EXECUTE,"Case sensitive comma seperated list of (ulx) groups that can only !spawn players as classd")


--DON'T TOUCH BELOW PLEASE, THANK YOU
-- by http://steamcommunity.com/profiles/76561197971790479/
-- || Discord: Link2006#8132

--FREEZES ALL PROPS
print("[Link2006] Script made by: http://steamcommunity.com/profiles/76561197971790479/  :)")
--Update 1.5
--	FIXED "Fake Spectators"
--	* For other stuff not in this changelog, check the bitbucket.

--Update 1.44
--	Added resource.AddFile generation at the bottom :)

--Update 1.43
--	Added announcement when a player is spawned (Chaos are announced as "MTF", Intended.)
--	Improved look of messages in chat about Spawning a player

--Update 1.42
--	Fixed !specspawn not always working (Made it a table instead of text=="!specspawn")
--	Added spawn_perms ConVar to change who has access to respawn a player.
--	Added "!spawn target"
--	Added "!spawn target class" for Admins+
--	Added Arguments for !specspawn
--	General code improvement to spawning players

--Update 1.41
--	Fixed people with br_spectate spawning anyway
--	Added ulx.fancyLogAdmin to tell if an admin spawned spectators
--	Commented debug text
--	Added !spawnspec alias

--Update 1.4 [BREAKING CHANGES]
-- Changed PostCleanupMap hook name to Link2006_NewRound
-- Added !specspawn to respawn spectators (as Class D)
-- Added automatic respawn of spectators 10 seconds after hook was called, should fix an issue where some would be stuck as spectator.
-- Removed Door damage (they will not re-open automaticly
-- Removed Elevator damage (It was abused)

--Update 1.3
-- Attempts to not freeze

--UPDATE 1.2
-- Added FreezeAllProps by Me, Prevents abuse with props.

--UPDATE 1.1
--	Fixed script not starting on any maps
--	added warning when not used on gm_site19
if string.StartWith( game.GetMap() , "gm_site19" ) == false then --if map does not start with gm_site19 \
	print("[Link2006] ========== WARNING ==========")
	print("[Link2006] This script was meant for gm_site19 (and variants)!")
	print("[Link2006] If you have issues, remove this script.")
	print("[Link2006] ========== WARNING ==========")
	--return --Commented to let the script through...
end

--Comment this if you like players get stuck (tbh, they should kill you :| )

--Removing my function before we update it, in case it's still there.
print("[Link2006] Cleaning old hook...")
hook.Remove("PostCleanupMap","Link2006_BlockDamage") -- LEGACY, I CHANGED THE HOOK NAME
hook.Remove("PostCleanupMap","Link2006_NewRound")
hook.Remove("PlayerSay","Link2006_SpecSpawn")

--Generating Functions...
print("[Link2006] Creating Functions...")



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


function Link2006_FixDoors()
	-- What.
	for k,door in pairs(ents.FindByClass("func_door")) do --For every fucking doors (aaa)
		--Disable damage... That's about it really...
		door:SetKeyValue("dmg",doorDamage) --Remove damage from the func_door
		--Fixes items making doors stuck ( ... :) )
		door:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	end
	print("[Link2006] Doors fixed")
end

function Link2006_FixElevators()
	for k,elev in pairs(ents.FindByClass("func_movelinear")) do --For every entities of func_movelinear;
		--Set Crushing damage to 1000 for ALL elevators/func_movelinear, not just a few (<,<)
		elev:SetKeyValue("BlockDamage",elevDamage)
		--And set collision_group to only playes (and props); items/weapons goes through.
		elev:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	end
	print("[Link2006] Elevators fixed")
end

function Link2006_FreezeAllProps()
	local Props = ents.FindByClass("prop_physics")
	for k,v in pairs(Props) do
		--freeze the props.
		local v_phys = v:GetPhysicsObject()
		if v_phys and v_phys:IsValid() then
			--If it's the melon or the boxes outside, don't freeze them, we can break them.
			if string.lower(v:GetModel()) == "models/props_junk/watermelon01.mdl" or string.lower(v:GetModel()) == "models/props_junk/wood_crate001a.mdl" then
				v_phys:EnableMotion(true) --Unfreeze them
				v_phys:Wake() --meme: WAKE ME UP
			else
				v_phys:Sleep() --Sleep, stops them
				v_phys:EnableMotion(false) --Freeze them
			end
		end
	end
	print("[Link2006] Props frozen")
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

	print("[Link2006] We have "..#temp_Spawns.." valid spawns")
	return temp_Spawns
end

function Link2006_IsSpec(spec) --Made this so i can replace every checks at once instead of every single one of them, still not readable tho.
	--This might be returning if GetNClass == Spectator isntead.
	--As this seems to be MUCH MORE Reliable than TEAM_SPEC for some fucking dumb reason :(

	--Problem i have right now is spec.ActivePlayer might always be false for some reason,
	if (spec.ActivePlayer == false) and (spec:Team() ~= TEAM_SPEC and (spec:GetNClass() == "Spectator")) then
		--Uh, what?
		print("[Link2006] WARN: \""..spec:Nick().."\" is not a spectator YET They aren't active? [ActivePlayer="..tostring(spec.ActivePlayer).."; Team="..tostring(spec:Team()).."; Class="..spec:GetNClass().."]")
	end

	if (spec:Team() == TEAM_SPEC or (spec:GetNClass() == "Spectator")) and (spec.ActivePlayer ~= false) then
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


function Link2006_RespawnSpecs(pAdmin,sClass)
	if sClass == nil then
		sClass = "classd" --we'll spawn them as Class D...
	end

	--Respawns spectators into Class Ds
	--GET POSSIBLE SPAWNS
	-- warning, if we exhaust our list; it's RIP and they spawn at the normal one... but it shouldnt be really a problem i guess
	if sClass == "classd" then
		local tSpecSpawns = Link2006_GetSpawns(SPAWN_CLASSD)

		for k,spec in pairs(player.GetAll()) do
			if Link2006_IsSpec(spec) then --Respawn Spectators (Team/GetNClass) but not br_spectate people
				spec:SetClassD() -- We don't care if ClassDs can't spawn in their own spawns
				if #tSpecSpawns > 0 then
					specNewSpawn,specKey = table.Random(tSpecSpawns)
					--table.RemoveByValue(specNewSpawn,tSpecSpawns)
					table.remove(tSpecSpawns,specKey)
					spec:SetPos(specNewSpawn)
				else
					--We did run out of spawns, let's ignore this for now and spawn them normally...
					--print("[Link2006] WARN: RAN OUT OF SPAWNS FOR SPECTATORS!")
				end
			end
		end
	elseif sClass == "researcher" then
		--CODE HERE FOR RESEARCHERS
		--table is SPAWN_SCIENT
		local tSpecSpawns = Link2006_GetSpawns(SPAWN_SCIENT)

		for k,spec in pairs(player.GetAll()) do
			if Link2006_IsSpec(spec) then --Don't spawn people that have br_spectate set
				spec:SetScientist() -- We don't care if Scientists/Researchers can't spawn in their own spawns, normal spawn is close enough anyway
				if #tSpecSpawns > 0 then
					specNewSpawn,specKey = table.Random(tSpecSpawns)
					--table.RemoveByValue(specNewSpawn,tSpecSpawns)
					table.remove(tSpecSpawns,specKey)
					spec:SetPos(specNewSpawn)
				else
					--We did run out of spawns, let's ignore this for now and spawn them normally...
					--print("[Link2006] WARN: RAN OUT OF SPAWNS FOR SPECTATORS!")
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
				else
					--We did run out of spawns, let's ignore this for now and spawn them normally...
					--print("[Link2006] WARN: RAN OUT OF SPAWNS FOR SPECTATORS!")
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
				else
					--We did run out of spawns, let's ignore this for now and spawn them normally...
					--print("[Link2006] WARN: RAN OUT OF SPAWNS FOR SPECTATORS!")
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
				else
					--We did run out of spawns, let's ignore this for now and spawn them normally...
					--print("[Link2006] WARN: RAN OUT OF SPAWNS FOR SPECTATORS!")
				end
			end
		end
	end
	if (pAdmin ~= nil) and (ulx ~= nil) then --Just making sure we do have ulx installed and the admin do exist
		--ulx.fancyLogAdmin( pAdmin, "#A respawned spectators as "..sClass) --Tell everyone which admin respawned spectators.
		Link2006_tSayColor(pAdmin,"respawned spectators as "..sClass)
	end
	print("[Link2006] Spectators have been respawned as "..sClass)
end

print("[Link2006] Creating PlayerSay hook...")


--I'm Sorry, this looks like a fucking mess now :(
--I am very very sorry...

hook.Add( "PlayerSay", "Link2006_SpecSpawn", function( ply, text)
	--If Player is an admin OR an Assistant:
	local sPerms = string.Explode(",",link2006_SpawnPerms:GetString()) --Get table of the groups that aren't Admins
	local spec_chatArgs = string.Explode(" ",text) --idunno if i should have it check if the player is admin

	if (ply:IsAdmin() or ply:IsSuperAdmin()) then --or table.HasValue( sPerms, ply:GetUserGroup() ) then --If the speaker is admin, Check what he's saying; that way non-admins can't spam string.Explode :)
		--!specspawn/!spawnspec

		if string.lower(spec_chatArgs[1]) == "!spawnspec" or string.lower(spec_chatArgs[1]) == "!specspawn" then --i fixed it guys oops
			if (spec_chatArgs[2] ~= nil and spec_chatArgs[2] ~= "") then -- and !table.HasValue( sPerms, ply:GetUserGroup() ) then
				if string.lower(spec_chatArgs[2]) == "scientist" or string.lower(spec_chatArgs[2]) == "scientists" or string.lower(spec_chatArgs[2]) == "researcher" or string.lower(spec_chatArgs[2]) == "researchers" then
				--Researcher
					Link2006_RespawnSpecs(ply,"researcher") --Respawn as Researcher
				elseif string.lower(spec_chatArgs[2]) == "chaos" then --those are TeamDM Chaos for now; will probably force-change to ntf chaos
					Link2006_RespawnSpecs(ply,"chaos") --Respawn as CI
				elseif string.lower(spec_chatArgs[2]) == "ntf" or string.lower(spec_chatArgs[2]) == "ntfs" then --real ntf
					Link2006_RespawnSpecs(ply,"ntf") --Respawn as NTF
				elseif string.lower(spec_chatArgs[2]) == "mtf" or string.lower(spec_chatArgs[2]) == "mtfs" then
					Link2006_RespawnSpecs(ply,"mtf") --Respawn as MTF
				elseif string.lower(spec_chatArgs[2]) == "classd" then --Class D (invalid args or simply "classd")
					Link2006_RespawnSpecs(ply,"classd") --Call RespawnSpecs and pass the admin entity through
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
							if string.lower(spec_chatArgs[3]) == "classd" then --Class D
								plySpawn:SetClassD()
								plySpawn:SetPos(table.Random(SPAWN_CLASSD))
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as class D",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as class D")
							elseif string.lower(spec_chatArgs[3]) == "scientist" or string.lower(spec_chatArgs[3]) == "researcher" then
								--Researcher
								plySpawn:SetScientist()
								plySpawn:SetPos(table.Random(SPAWN_SCIENT))
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as a researcher",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as a researcher")
							elseif string.lower(spec_chatArgs[3]) == "commander" then
								plySpawn:SetCommander()
								plySpawn:SetPos(table.Random(SPAWN_GUARD))
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as a MTF Commander",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as an MTF Command")
							elseif string.lower(spec_chatArgs[3]) == "mtf" then
								plySpawn:SetGuard()
								plySpawn:SetPos(table.Random(SPAWN_GUARD))
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as a MTF Guard",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as an MTF Guard")
							elseif string.lower(spec_chatArgs[3]) == "chaos" then
								plySpawn:SetChaosInsurgency(3)
								plySpawn:SetPos(table.Random(SPAWN_OUTSIDE))
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as a MTF Nine Tailed Fox",plySpawn) --Tell everyone an admin respawned a player as what
								--Oh yeah this part i need to make sure the chat doesn't betray my lie ;)
								Link2006_tSayColor(ply,"respawned ",team.GetColor(TEAM_GUARD),plySpawn:Nick(),Color(255,255,255)," as an MTF Nine Tailed Fox")
								print("[Link2006] Admin Spawned a Chaos")
							elseif string.lower(spec_chatArgs[3]) == "sitedirector" then
								plySpawn:SetSiteDirector(true) --Uh
								plySpawn:SetPos(table.Random(SPAWN_SCIENT)) --idk where else to put him.
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as a site director",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as a site director")
							elseif string.lower(spec_chatArgs[3]) == "ntf" then
								plySpawn:SetNTF()
								plySpawn:SetPos(table.Random(SPAWN_OUTSIDE))
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
								plySpawn:SetPos(table.Random(SPAWN_ZOMBIES))
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as a SCP-008-2",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as an SCP-008-2")
							elseif string.lower(spec_chatArgs[3]) == "scp-049-2" or string.lower(spec_chatArgs[3]) == "ntfs" then --real ntf
								plySpawn:SetSCP0492() --SCP049 Zombie (Kills players)
								plySpawn:SetPos(table.Random(SPAWN_ZOMBIES))
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as a SCP-049-2",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as an SCP-049-2")
							elseif string.lower(spec_chatArgs[3]) == "scp-035" or string.lower(spec_chatArgs[3]) == "mtfs" then
								plySpawn:SetSCP035()
								--ulx.fancyLogAdmin( pAdmin, "#A respawned #T as SCP-035",plySpawn) --Tell everyone an admin respawned a player as what
								Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as SCP-035")
							else
								ULib.tsayError(ply,"Invalid class specified, Valid Choices are: ",true)
								ULib.tsayError(ply,"classd,researcher,commander,mtf,chaos,sitedirector,ntf",true)
								ULib.tsayError(ply,"scp-173,scp-1048a,scp-106,scp-049,scp-457,scp-008-2,scp-049-2,scp-035",true)
							end
						end
					else
						ULib.tsayError(ply,"No class specified, Valid Choices are: ",true)
						ULib.tsayError(ply,"classd,researcher,commander,mtf,chaos,sitedirector,ntf",true)
						ULib.tsayError(ply,"scp-173,scp-1048a,scp-106,scp-049,scp-457,scp-008-2,scp-049-2,scp-035",true)
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
				ULib.tsayError(ply,"scp-173,scp-1048a,scp-106,scp-049,scp-457,scp-008-2,scp-049-2,scp-035",true)
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
					plySpawn:SetClassD()
					plySpawn:SetPos(table.Random(SPAWN_CLASSD))
					--ulx.fancyLogAdmin( pAdmin, "#A respawned #T",plySpawn) --Tell everyone an admin respawned a player as what
					Link2006_tSayColor(ply,"respawned ",team.GetColor(plySpawn:Team()),plySpawn:Nick(),Color(255,255,255)," as a class D")
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

print("[Link2006] Creating PostCleanupMap hook...")

hook.Add("PostCleanupMap","Link2006_NewRound",function() --On New Round
	print("[Link2006] CleanUpMap() called, Waiting a bit...")
	timer.Simple(1.0,function()
		print("[Link2006] Running Fixes...")
		Link2006_FixElevators()
		Link2006_FreezeAllProps()
		Link2006_FixDoors()
	end)
	timer.Simple(10, function()
		Link2006_RespawnSpecs(nil,"classd") --:)
	end)
end)

print("[Link2006] Forcing changes to the map immediately...")
Link2006_FixElevators()
Link2006_FreezeAllProps()
Link2006_FixDoors()
print("[Link2006] Generating list of files needed by clients...")


--Taken from https://facepunch.com/showthread.php?t=1469993, heavily modified to be used as resource.AddFile instead

function Link2006_AddFiles(name,remLength)
	local files, directories = file.Find(name .. "/*", "GAME");
	-- Delete files
	for _, f in pairs(files) do
		--the +1 there is only so we start at "s" from "sound" instead of "/" ...
		resource.AddFile(string.sub(name.."/"..f,remLength+1))
	end
	-- Recurse directories
	for _, d in pairs(directories) do
		Link2006_AddFiles(name .. "/" .. d,remLength);
	end
end

Link2006_AddFiles("addons/lbgaming/sound",string.len("addons/lbgaming/")) -- string Folder, string (length) to remove


print("[Link2006] Ready. Version "..Link2006_version)

--Link2006 was here
