--CURRENT VERSION:  1.41

if CLIENT then return end --This should be in /autorun/server/, clients can't do anything 

--Configurable damage for elevators and doors 
local elevDamage = 0 -- Default: 0 (RECOMMENDED)
local doorDamage = 0 -- Default: 0 (RECOMMENDED)


--DON'T TOUCH BELOW PLEASE, THANK YOU 
-- by http://steamcommunity.com/profiles/76561197971790479/
-- || Discord: Link2006#8132

--FREEZES ALL PROPS
print("[Link2006] Script made by: http://steamcommunity.com/profiles/76561197971790479/  :)")
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
if !string.StartWith( game.GetMap() , "gm_site19" ) then --if map does not start with gm_site19 \
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

function Link2006_FixElevators()
	for k,elev in pairs(ents.FindByClass("func_movelinear")) do --For every entities of func_movelinear; 
		--Set Crushing damage to 1000 for ALL elevators/func_movelinear, not just a few (<,<)
		elev:SetKeyValue("BlockDamage",elevDamage)
		--And set collision_group to only playes (and props); items/weapons goes through.
		elev:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	end 
	print("[Link2006] Elevators fixed")
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

function Link2006_RespawnSpecs(pAdmin) 
	--Respawns spectators into Class Ds
	--GET POSSIBLE SPAWNS
	local tSpecSpawns = {}  --table SpecSpawns, This is a table we'll use to store all possible spawns for the Spectators
	-- warning, if we exhaust our list; it's RIP and they spawn at the normal one... but it shouldnt be really a problem i guess
	
	for k,SpawnPos in pairs(SPAWN_CLASSD) do --We use the original table, add ones without a player to a table
		--Make a box around that spawn to make sure we can spawn spectators...
		local SpawnPos_Start = SpawnPos - Vector(24,24,16)
		local SpawnPos_End = SpawnPos + Vector(24,24,64) --48x48x72 box, makes sure we're safe. 
		local SpawnPos_Ents = ents.FindInBox(SpawnPos_Start,SpawnPos_End)
		
		if #SpawnPos_Ents == 0 then 
			table.insert(tSpecSpawns,SpawnPos) --Valid spawn for spectators :)
		end 
	end 
	print("[Link2006] We have "..#tSpecSpawns.." valid spawns for spectators...")
	
	for k,spec in pairs(player.GetAll()) do
		if (spec:Team() == TEAM_SPEC) and (spec.ActivePlayer ~= false) then --Don't spawn people that have br_spectate set 
			spec:SetClassD()
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
	
	if (pAdmin ~= nil) and (ulx ~= nil) then --Just making sure we do have ulx installed and the admin do exist
		ulx.fancyLogAdmin( pAdmin, "#A respawned spectators") --Tell everyone which admin respawned spectators.
	end 
	print("[Link2006] Spectators have been respawned as Class Ds")
end 

print("[Link2006] Creating PlayerSay hook...")

hook.Add( "PlayerSay", "Link2006_SpecSpawn", function( ply, text)
	if text == "!specspawn" or text == "!spawnspec" then 
		--print("DEBUG: someone said  !specspawn")
		if ply:IsAdmin() or ply:IsSuperAdmin() then
			--print("DEBUG: And is an admin!")
			Link2006_RespawnSpecs(ply) --Call RespawnSpecs and pass the admin entity through
			return ""
		end 
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
		Link2006_RespawnSpecs(nil) --:)
	end)
end)

print("[Link2006] Forcing changes to the map immediately...")
Link2006_FixElevators()
Link2006_FreezeAllProps()
Link2006_FixDoors()
print("[Link2006] Ready.")


--Link2006 was here