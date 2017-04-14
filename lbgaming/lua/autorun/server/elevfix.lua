Link2006_version = "1.8"

if CLIENT then return end --This should be in /autorun/server/, clients can't do anything

--Configurable damage for elevators and doors
local elevDamage = 0 -- Default: 0 (RECOMMENDED)
local doorDamage = 0 -- Default: 0 (RECOMMENDED)
local fixElevators = false -- Default: false (RECOMMENDED FOR NOW)
--This boolean will disable the elevator fix and allow me to re-enable it whenever.

--DON'T TOUCH BELOW PLEASE, THANK YOU
-- by http://steamcommunity.com/profiles/76561197971790479/
-- || Discord: Link2006#8132

--FREEZES ALL PROPS
print("[Link2006] Script made by: http://steamcommunity.com/profiles/76561197971790479/  :)")

--------------------------------
--Update 1.7+ 				  --
--	* Deleted Changelog 	  --
--------------------------------

if string.StartWith( game.GetMap() , "gm_site19" ) == false then --if map does not start with gm_site19
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
		--Set Crushing damage to elevDamage for ALL elevators/func_movelinear, not just a few (<,<)
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
		if fixElevators then
			Link2006_FixElevators()
		end
		Link2006_FreezeAllProps()
		Link2006_FixDoors()
	end)
end)

--Moves entities too, not just props / players
--	WARNING: I have no idea what the fuck i'm doing.

--GateA_BotTele; GateA_TopTele; GateB_BotTele; GateB_TopTele;
local ElevTeles ={
	'GateA_BotTele', --Bottom
	'GateA_TopTele', --Top
	'GateB_TopTele', --Bottom (They are INVERTED!!)
	'GateB_BotTele', -- Top (Props fucked up c:)
}
local TeleBlacklist = {
	'trigger_teleport', --Lol?
	'player', --Players are already teleported, we dont need to :)
	'predicted_viewmodel', --???
	'func_door', --Doors
	'prop_dynamic', --Doors
	'entityflame',--SCP457's Flame
	'func_button',-- We dont want to break the buttons do we ;)
	'ambient_generic', --sounds
	'env_sprite', --Sprites
	'info_player_start', --WHAT ARE YOU DOING HERE WHAT?
}
--When those trigger, we also check anything inside their box and tp them up/down C:
--Blacklist system up there because some entities SHOULD NOT MOVE.

hook.Add("AcceptInput","Link2006_TeleFix",function(ent,trigger)
	if table.HasValue(ElevTeles,ent:GetName()) and ent:GetClass() ~= "player" then --NO PLAYER PLEASE. 
		if trigger == "Enable" then --Teleport them.
			local MinVec,MaxVec = ent:GetCollisionBounds()
			MinVec = ent:GetPos() + MinVec
			MaxVec = ent:GetPos() + MaxVec
			local TeleEnts = ents.FindInBox(MinVec,MaxVec)
			if ent:GetName() == 'GateA_BotTele' then
				--Teleport the entities to the top
				for k,v in pairs(TeleEnts) do
					if table.HasValue(TeleBlacklist,v:GetClass()) == false then
						print("A <BotTele> TELEPORTING ["..v:GetClass().."] named: "..v:GetName())
						v:SetPos(Vector(v:GetPos().x,v:GetPos().y,v:GetPos().z+1024))
					end
				end
			elseif ent:GetName() == 'GateA_TopTele'	then
				--Teleport the entities to the bottom
				for k,v in pairs(TeleEnts) do
					if table.HasValue(TeleBlacklist,v:GetClass()) == false then
						print("A <TopTele>TELEPORTING ["..v:GetClass().."] named: "..v:GetName())
						v:SetPos(Vector(v:GetPos().x,v:GetPos().y,v:GetPos().z-1024))
					end
				end
			elseif ent:GetName() == 'GateB_TopTele'	then
				--Teleport the entities to the top
				for k,v in pairs(TeleEnts) do

					if table.HasValue(TeleBlacklist,v:GetClass()) == false then
						--Pos is: -3888.000000 1788.000000 64.000000
						-- ulx luarun par:SetPos(Vector(par:GetPos().x+3248,par:GetPos().y+2942,par:GetPos().z+1024))
						print("B <TopTele> TELEPORTING ["..v:GetClass().."] named: "..v:GetName())
						v:SetPos(Vector(v:GetPos().x+3248,v:GetPos().y+2942,v:GetPos().z+1024))
					end
				end
			elseif ent:GetName() == 'GateB_BotTele'	then
				--Teleport the entities to the bottom
				for k,v in pairs(TeleEnts) do
					if table.HasValue(TeleBlacklist,v:GetClass()) == false then
						--Pos is: -640.000000 4730.009766 1088.000000
						-- ulx luarun par:SetPos(Vector(par:GetPos().x-3248,par:GetPos().y-2942,par:GetPos().z-1024))
						print("B <BotTele> TELEPORTING ["..v:GetClass().."] named: "..v:GetName())
						--v:SetPos(Vector(v:GetPos().x,v:GetPos().y,v:GetPos().z-1024))
						v:SetPos(Vector(v:GetPos().x-3248,v:GetPos().y-2942,v:GetPos().z-1024))
					end
				end
			end

		end
	end
end)

print("[Link2006] Forcing changes to the map immediately...")
if fixElevators then
	Link2006_FixElevators()
end
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

--lbgaming's SCP-682
Link2006_AddFiles("addons/lbgaming/models",string.len("addons/lbgaming/")) -- string Folder, string (length) to remove
Link2006_AddFiles("addons/lbgaming/materials",string.len("addons/lbgaming/")) -- string Folder, string (length) to remove
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
