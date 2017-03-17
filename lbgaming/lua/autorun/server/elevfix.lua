Link2006_version = "1.7"

if CLIENT then return end --This should be in /autorun/server/, clients can't do anything

--Configurable damage for elevators and doors
local elevDamage = 0 -- Default: 0 (RECOMMENDED)
local doorDamage = 0 -- Default: 0 (RECOMMENDED)


--DON'T TOUCH BELOW PLEASE, THANK YOU
-- by http://steamcommunity.com/profiles/76561197971790479/
-- || Discord: Link2006#8132

--FREEZES ALL PROPS
print("[Link2006] Script made by: http://steamcommunity.com/profiles/76561197971790479/  :)")
--Update 1.6
--	* Moved everything related  to respawning into sv_breachrespawn
--	* This file now only has Mapfixes and nothing else.


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

--Generating Functions...
print("[Link2006] Creating Functions...")



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

print("[Link2006] Creating PostCleanupMap hook...")

hook.Add("PostCleanupMap","Link2006_NewRound",function() --On New Round
	print("[Link2006] CleanUpMap() called, Waiting a bit...")
	timer.Simple(1.0,function()
		print("[Link2006] Running Fixes...")
		Link2006_FixElevators()
		Link2006_FreezeAllProps()
		Link2006_FixDoors()
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

--lbgaming's sounds
Link2006_AddFiles("addons/lbgaming/sound",string.len("addons/lbgaming/")) -- string Folder, string (length) to remove
--SCP294's stuff
Link2006_AddFiles("addons/scp-294_entity_774064122/materials",string.len("addons/scp-294_entity_774064122/"))
Link2006_AddFiles("addons/scp-294_entity_774064122/models",string.len("addons/scp-294_entity_774064122/"))
Link2006_AddFiles("addons/scp-294_entity_774064122/sound",string.len("addons/scp-294_entity_774064122/"))
Link2006_AddFiles("addons/scp-294_entity_774064122/sound/scp294",string.len("addons/scp-294_entity_774064122/")) --:^l
--SCP513's stuff
Link2006_AddFiles("addons/scp-513_entity_[working]_770291148/materials",string.len("addons/scp-513_entity_[working]_770291148/"))
Link2006_AddFiles("addons/scp-513_entity_[working]_770291148/models",string.len("addons/scp-513_entity_[working]_770291148/"))
Link2006_AddFiles("addons/scp-513_entity_[working]_770291148/sound",string.len("addons/scp-513_entity_[working]_770291148/"))
Link2006_AddFiles("addons/scp-513_entity_[working]_770291148/sound/scp_pack",string.len("addons/scp-513_entity_[working]_770291148/")) --:^l oops

print("[Link2006] Ready. Version "..Link2006_version)

--Link2006 was here
