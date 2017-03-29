--[[ Original script written by FPtje (for Eusion): https://facepunch.com/showthread.php?t=735138. --]]
--[[ Modified/Enhanced by StealthPaw/101kl. --]]
print("[gmpw_link2006] Loading Link2006's version of gmpermaworld...")
local DBprefix = "gmpw" -- What the server SQL database name will be prefixed with.
local LoadOnStart = true -- Change this to false if you don't want the database to be auto-loaded when you start a game/server.
local SaveIndicator = true -- Change this to true if you want entities to quickly flash green/red, indicating they have been successfully added/removed to the database.
local DeleteOnRemove = true -- Change this to true if you want entities to delete from the map after removal from database (purge included).

if CLIENT then return end
local function GetWorldDatabase()
	if not DBprefix then return {} end
	return sql.Query("SELECT * FROM "..DBprefix.."_props;") or {}
end

local function WorldHasEntity(ent)
	if not IsValid(ent) or not ent.PermaWorld or not DBprefix then return false end
	local map = string.lower(game.GetMap())
	for _,v in pairs(GetWorldDatabase()) do
		--string.find(v.map, map) == 1
		if map == v.map then
			if tostring(ent.PermaWorld) == tostring(v.unid) then return true end
		end
	end
	return false
end

local function FreezeEnt(ent)
	if not IsValid(ent) then return end
	ent:SetSolid(SOLID_VPHYSICS)
	ent:SetMoveType(MOVETYPE_NONE)
	local phys = ent:GetPhysicsObject()
	if phys and phys:IsValid() then phys:EnableMotion(false) end
	ent:SetOwner( game.GetWorld() or NULL )
end

local function PW_CleanWorld(ply)
	--If Player is in game
	if ply and ply:IsValid() and ply:IsPlayer() then --Only when the ply is valid, :^)...Makes console able to run this shit :)
		if not ply:IsSuperAdmin() then --And isnt SuperAdmin
			return --Deny.
		end
	end
	--Elseif Code was ran by CONSOLE or a SuperAdmin
	local Refreshed = false
	for _,v in pairs(ents.GetAll()) do
		if IsValid(v) and v.PermaWorld then
			v:Remove()
			Refreshed = true
		end
	end

	if not Refreshed then return false end
	return true
end
concommand.Add("PermaWorld_CleanMap", PW_CleanWorld)

local function PW_Add(ply)
	local ent = ply:GetEyeTrace().Entity
	if not IsValid(ent) or not ply:IsSuperAdmin() or ent:IsWorld() or not DBprefix then return end
	if WorldHasEntity(ent) then ply:ChatPrint("[PermaWorld] Already In Database.") return end
	local pos = ent:GetPos()
	pos = Vector(math.Round(pos.x), math.Round(pos.y), math.Round(pos.z))
	local col = ent:GetColor() or Color(255,255,255,255)
	ent:SetPos(pos)
	local ang = ent:EyeAngles()
	ang = Angle(math.Round(ang.p), math.Round(ang.y), math.Round(ang.r))
	ent:SetAngles(ang)
	local map = string.lower(game.GetMap())
	local class = ent:GetClass() or "prop_physics"
	local model = ent:GetModel()
	local mat = ent:GetMaterial() or "false"
	if not model then return end
	FreezeEnt(ent)
	local data = GetWorldDatabase()
	--local identifier = math.Rand( 1, 500 ) --We dont need this anymore, it should AUTOINCREMENT :)
	--string.find(v.map, map) == 1
	for _,v in pairs(data) do if map == v.map then if identifier == tonumber(v.unid) then identifier = math.Rand( 1, 500 ) end end end -- Just in case...
	ent.PermaWorld = identifier
	--sql.Query("INSERT INTO "..DBprefix.."_props VALUES("..sql.SQLStr(map..tostring(table.Count(data) + 1))..", "..sql.SQLStr(identifier)..", "..sql.SQLStr(class)..", "..sql.SQLStr(model)..", "..sql.SQLStr(mat)..", "..sql.SQLStr(pos.x)..", "..sql.SQLStr(pos.y)..", "..sql.SQLStr(pos.z)..", "..sql.SQLStr(col.r)..", "..sql.SQLStr(col.g)..", "..sql.SQLStr(col.b)..", "..sql.SQLStr(col.a)..", "..sql.SQLStr(ang.p)..", "..sql.SQLStr(ang.y)..", "..sql.SQLStr(ang.r)..");")
	sql.Query("INSERT INTO "..DBprefix.."_props VALUES("..
		--sql.SQLStr(map..tostring(table.Count(data) + 1))..", "
		sql.SQLStr(map)..","
		--..sql.SQLStr(identifier)..", "
		.."NULL, " --Identifier is not there anymore,should AUTOINCREMENT... :)
		..sql.SQLStr(class)..", "
		..sql.SQLStr(model)..", "
		..sql.SQLStr(mat)..", "
		..sql.SQLStr(pos.x)..", "
		..sql.SQLStr(pos.y)..", "
		..sql.SQLStr(pos.z)..", "
		..sql.SQLStr(col.r)..", "
		..sql.SQLStr(col.g)..", "
		..sql.SQLStr(col.b)..", "
		..sql.SQLStr(col.a)..", "
		..sql.SQLStr(ang.p)..", "
		..sql.SQLStr(ang.y)..", "
		..sql.SQLStr(ang.r)..");")
	if SaveIndicator then
		local RenderMode = ent:GetRenderMode() or 1
		local RenderColor = ent:GetColor()
		if RenderMode ~= 1 then ent:SetRenderMode( 1 ) end
		ent:SetColor(Color(0,255,0,255))
		timer.Simple(0.5, function() if ent and IsValid(ent) then ent:SetColor(RenderColor or Color(255,255,255,255)) ent:SetRenderMode( RenderMode ) end end)
	end
	ply:ChatPrint("[PermaWorld] Added To Permanent World.")
end
concommand.Add("PermaWorld_Add", PW_Add)

local function PW_Remove(ply)
	local ent = ply:GetEyeTrace().Entity
	if not IsValid(ent) or not ply:IsSuperAdmin() or ent:IsWorld() or not ent.PermaWorld or not DBprefix then return end
	if not WorldHasEntity(ent) then ply:ChatPrint("[PermaWorld] Not In Database.") return end
	sql.Query("DELETE FROM "..DBprefix.."_props WHERE unid = "..sql.SQLStr(ent.PermaWorld)..";")
	ent.PermaWorld = false
	if SaveIndicator then
		local RenderMode = ent:GetRenderMode() or 1
		local RenderColor = ent:GetColor()
		if RenderMode ~= 1 then ent:SetRenderMode( 1 ) end
		ent:SetColor(Color(255,0,0,255))
		timer.Simple(0.5, function() if ent and IsValid(ent) then if DeleteOnRemove then ent:Remove() else ent:SetColor(RenderColor or Color(255,255,255,255)) ent:SetRenderMode( RenderMode ) end end end)
	end
	ply:ChatPrint("[PermaWorld] Removed From Permanent World.")
end
concommand.Add("PermaWorld_Remove", PW_Remove)

--THATS NOT HOW YOU DO THIS HOLY SHIT
--if (sql.Query ( "SELECT * FROM gmpw_props;" )  == false ) then
if (sql.TableExists (DBprefix..'_props') == false) then --The table does NOT exist!
	print("[gmpw_link2006] "..DBprefix.."_props TABLE DOES NOT EXIST, CREATING ... ")
	--print("Select Result: "..sql.LastError())
	--sql.Query("CREATE TABLE IF NOT EXISTS "..DBprefix.."_props('map' TEXT NOT NULL, 'unid' INTEGER NOT NULL, 'class' TEXT NOT NULL, 'model' TEXT NOT NULL, 'material' TEXT NOT NULL, 'x' INTEGER NOT NULL, 'y' INTEGER NOT NULL, 'z' INTEGER NOT NULL, 'red' INTEGER NOT NULL, 'green' INTEGER NOT NULL, 'blue' INTEGER NOT NULL, 'alpha' INTEGER NOT NULL, 'pitch' INTEGER NOT NULL, 'yaw' INTEGER NOT NULL, 'roll' INTEGER NOT NULL, PRIMARY KEY('map'));")
	sql.Query("CREATE TABLE IF NOT EXISTS "..DBprefix.."_props"..
		"('map' TEXT NOT NULL,"..
		" 'unid' INTEGER PRIMARY KEY AUTOINCREMENT ,"..
		" 'class' TEXT NOT NULL,"..
		" 'model' TEXT NOT NULL,"..
		"'material' TEXT NOT NULL,"..
		" 'x' INTEGER NOT NULL,"..
		" 'y' INTEGER NOT NULL,"..
		" 'z' INTEGER NOT NULL,"..
		" 'red' INTEGER NOT NULL,"..
		" 'green' INTEGER NOT NULL,"..
		" 'blue' INTEGER NOT NULL,"..
		" 'alpha' INTEGER NOT NULL,"..
		" 'pitch' INTEGER NOT NULL,"..
		" 'yaw' INTEGER NOT NULL,"..
		" 'roll' INTEGER NOT NULL);")
	print("[gmpw_link2006] CREATE TABLE Result:"..sql.LastError())
	--print("TABLE DIDN'T EXIST? IMPORTING FROM OTHER DB...")
	if sql.TableExists(DBprefix.."_worldspawns") then
		local oldMap = ""
		local oldDb = sql.Query("SELECT * FROM "..DBprefix.."_worldspawns;")
		print("[gmpw_link2006] Importing from "..DBprefix.."_worldspawns ...")
			for k,v in pairs(oldDb) do
				if oldMap == "" then
					oldMap = v.map
					--print("set map to "..oldMap) --Is this the propermap?
					print("[gmpw_link2006] WARNING: default map set to "..oldMap)
				end
				sql.Query("INSERT INTO "..DBprefix.."_props VALUES("..
					--sql.SQLStr(map..tostring(table.Count(data) + 1))..", "
					sql.SQLStr(oldMap)..","
					--..sql.SQLStr(identifier)..", "
					.."NULL, " --Identifier is not there anymore,should AUTOINCREMENT... :)
					..sql.SQLStr(v.class)..", "
					..sql.SQLStr(v.model)..", "
					..sql.SQLStr(v.material)..", "
					..sql.SQLStr(v.x)..", "
					..sql.SQLStr(v.y)..", "
					..sql.SQLStr(v.z)..", "
					..sql.SQLStr(v.red)..", "
					..sql.SQLStr(v.green)..", "
					..sql.SQLStr(v.blue)..", "
					..sql.SQLStr(v.alpha)..", "
					..sql.SQLStr(v.pitch)..", "
					..sql.SQLStr(v.yaw)..", "
					..sql.SQLStr(v.roll)..");")
				print("[gmpw_link2006] INSERT RESULT: "..sql.LastError())
				print("[gmpw_link2006] Done;")
			end
			print("[gmpw_link2006] Setting oldDb to nil...")
			oldDb = nil --Should make it so GC grabs it.
			print("[gmpw_link2006] Done.")
		end
	print("[gmpw_link2006] End of Database creation for GMPW.")
	print("[gmpw_link2006] WARNING: THE TABLE MIGHT NOT BE USABLE IF YOU USED MORE THAN 1 MAP OR IF YOU HAD MULTIPLE MAP WITH THE SAME PROPS")
	print("[gmpw_link2006] You will need to manually clean/purge the database if such a database is unusable.")
	print("[gmpw_link2006] You can also use permaworld_import <from_map> to get your items into an updated map")
end

local function PW_Restore(ply)
	--if (ply and !ply:IsSuperAdmin()) or !DBprefix then return end
	if ply and ply:IsValid() and ply:IsPlayer() then --If called ingame
		print("[gmpw_link2006] Reloading permaworld props... Caller: ")
		print("[gmpw_link2006] "..tostring(ply))
		if not ply:IsSuperAdmin() then --And caller isnt superadmin
			return --Deny
		end
	end
	if not DBprefix then
		return
	end --If no database prefix is set, deny

	--Run code.
	if PW_CleanWorld(ply) then
		print("[gmpw_link2006] Refreshing Permanent World.") --Print it in console
		if ply and ply:IsValid() and ply:IsPlayer() then
			ply:ChatPrint("[PermaWorld] Refreshing Permanent World.")
		end
	end
	timer.Simple(1, function()
		local data = GetWorldDatabase()
		if not data then return end
		local map = string.lower(game.GetMap())
		for _,v in pairs(GetWorldDatabase()) do
			--string.find(v.map, map) == 1
			if map == v.map then
				local ent = ents.Create(v.class or "prop_physics")
				ent:SetPos(Vector(tonumber(v.x), tonumber(v.y), tonumber(v.z)))
				ent:SetAngles(Angle(tonumber(v.pitch), tonumber(v.yaw), tonumber(v.roll)))
				if v.material and v.material ~= "false" then ent:SetMaterial( v.material, false ) end
				if tonumber(v.alpha) < 255 then ent:SetRenderMode( 1 ) end
				ent:SetColor(Color(tonumber(v.red), tonumber(v.green), tonumber(v.blue), tonumber(v.alpha)))
				ent:SetModel(v.model)
				ent.PermaWorld = tonumber(v.unid)
				ent:Spawn()
				ent:Activate()
				FreezeEnt(ent)
			end
		end
	end)
end

if LoadOnStart then hook.Add( "InitPostEntity", "MapRestore", PW_Restore) end
concommand.Add("PermaWorld_Restore", PW_Restore)

local function PW_Purge(ply)
	if not ply:IsSuperAdmin() or not DBprefix then return end
	if DeleteOnRemove then PW_CleanWorld(ply) end
	local map = string.lower(game.GetMap())
	for _,v in pairs(GetWorldDatabase()) do
		--string.find(v.map, map) == 1
		if map == v.map then
			sql.Query("DELETE FROM "..DBprefix.."_props WHERE map = "..sql.SQLStr(v.map)..";")
		end
	end
	ply:ChatPrint("[PermaWorld] Permanent World Database Purged.")
end
concommand.Add("PermaWorld_Purge", PW_Purge)

local function PW_Import(ply,sCmd,args) --Planned: Import from an old map to the new one
	if IsValid(ply) then --Player's console
		if not ply:IsSuperAdmin() or not DBprefix then return end
		if args[1] then
			local from_map = string.lower(args[1])
			local to_map = string.lower(game.GetMap())
			ply:ChatPrint("[PermaWorld] Importing from "..from_map.." to "..to_map)
			--Insert code here that does: UPDATE DBPrefix SET map=to_map WHERE map=from_map;
			sql.Query("UPDATE "..DBprefix.."_props SET map="..sql.SQLStr(to_map).." WHERE map="..sql.SQLStr(from_map)..";")
			ply:ChatPrint("[gmpw_link2006] Completed.")
			ply:ChatPrint("[PermaWorld] Reloading current props...")
			PW_Restore(nil) --Claim we're console.
			ply:ChatPrint("[gmpw_link2006] Done. If you now see your props, it worked.")
		else
			ply:ChatPrint("[PermaWorld] Usage: PermaWorld_Import <from_map>")
		end
	else --Console
		if args[1] then
			local from_map = string.lower(args[1])
			local to_map = string.lower(game.GetMap())
			print("[PermaWorld] Importing from "..from_map.." to "..to_map)
			--Insert code here that does: UPDATE DBPrefix SET map=to_map WHERE map=from_map;
			sql.Query("UPDATE "..DBprefix.."_props SET map="..sql.SQLStr(to_map).." WHERE map="..sql.SQLStr(from_map)..";")
			--print("[gmpw_link2006] PW_Import's Update Result: "..sql.LastError())
			print("[gmpw_link2006] Completed.")
			print("[gmpw_link2006] Reloading current props...")
			PW_Restore(nil) --Claim we're console.
			print("[gmpw_link2006] Done. If you now see your props, it worked.")
		else
			print("[gmpw_link2006] Usage: PermaWorld_Import <from_map>")
		end
	end
end
concommand.Add("PermaWorld_Import", PW_Import)

print("[gmpw_link2006] Ready.")
