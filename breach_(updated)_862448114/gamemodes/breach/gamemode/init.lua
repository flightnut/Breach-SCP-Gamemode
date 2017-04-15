// Initialization file

//AddCSLuaFile( "class_default.lua" )
AddCSLuaFile( "fonts.lua" )
AddCSLuaFile( "class_default.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "cl_mtfmenu.lua" )
AddCSLuaFile( "sh_player.lua" )
mapfile = "mapconfigs/" .. game.GetMap() .. ".lua"
AddCSLuaFile(mapfile)
ALLLANGUAGES = {}
clang = nil
local files, dirs = file.Find(GM.FolderName .. "/gamemode/languages/*.lua", "LUA" )
for k,v in pairs(files) do
	local path = "languages/"..v
	if string.Right(v, 3) == "lua" then
		AddCSLuaFile( path )
		include( path )
		print("Language found: " .. path)
	end
end
AddCSLuaFile( "rounds.lua" )
AddCSLuaFile( "cl_sounds.lua" )
AddCSLuaFile( "cl_targetid.lua" )
AddCSLuaFile( "cl_init.lua" )
include( "server.lua" )
include( "rounds.lua" )
include( "class_default.lua" )
include( "shared.lua" )
include( mapfile )
include( "sh_player.lua" )
include( "sv_player.lua" )
include( "player.lua" )
include( "sv_round.lua" )
/*
PrintTable(ALLLANGUAGES)
local trytofind = ALLLANGUAGES[GetConVar("br_svlanguage"):GetString()]
if trytofind != nil then
	if istable(trytofind) then
		clang = trytofind
	end
end
if clang == nil then
	clang = ALLLANGUAGES.english
end
*/
resource.AddFile( "sound/radio/chatter1.ogg" )
resource.AddFile( "sound/radio/chatter2.ogg" )
resource.AddFile( "sound/radio/chatter3.ogg" )
resource.AddFile( "sound/radio/chatter4.ogg" )
resource.AddFile( "sound/radio/franklin1.ogg" )
resource.AddFile( "sound/radio/franklin2.ogg" )
resource.AddFile( "sound/radio/franklin3.ogg" )
resource.AddFile( "sound/radio/franklin4.ogg" )
resource.AddFile( "sound/radio/radioalarm.ogg" )
resource.AddFile( "sound/radio/radioalarm2.ogg" )
resource.AddFile( "sound/radio/scpradio0.ogg" )
resource.AddFile( "sound/radio/scpradio1.ogg" )
resource.AddFile( "sound/radio/scpradio2.ogg" )
resource.AddFile( "sound/radio/scpradio3.ogg" )
resource.AddFile( "sound/radio/scpradio4.ogg" )
resource.AddFile( "sound/radio/scpradio5.ogg" )
resource.AddFile( "sound/radio/scpradio6.ogg" )
resource.AddFile( "sound/radio/scpradio7.ogg" )
resource.AddFile( "sound/radio/scpradio8.ogg" )
resource.AddFile( "sound/radio/ohgod.ogg" )

SPCS = {
	{name = "SCP 173",
	func = function(pl)
		pl:SetSCP173()
	end},
	{name = "SCP 049",
	func = function(pl)
		pl:SetSCP049()
	end},
	{name = "SCP 106",
	func = function(pl)
		pl:SetSCP106()
	end},
	{name = "SCP 035",
	func = function(pl)
		pl:SetSCP035()
	end},
	{name = "SCP 1048A",
	func = function(pl)
		pl:SetSCP1048a()
	end},
	{name = "SCP 457",
	func = function(pl)
		pl:SetSCP457()
	end},
	{name = "SCP 682",
	func = function(pl)
		pl:SetSCP682()
	end},

}

/*
Names = {
	researchers = {
		"Dr. Django Bridge",
		"Dr. Jack Bright",
		"Dr. Jeremiah Cimmerian",
		"Dr. Alto Clef",
		"Researcher Jacob Conwell",
		"Dr. Kain Crow",
		"Dr. Chelsea Elliott",
		"Dr. Charles Gears",
		"Dr. Simon Glass",
		"Dr. Frederick Heiden",
		"Dr. Everett King",
		"Dr. Zyn Kiryu",
		"Dr. Mark Kiryu",
		"Dr. Adam Leeward",
		"Dr. Everett Mann",
		"Dr. Riven Mercer",
		"Dr. Johannes Sorts",
		"Dr. Thaddeus Xyank"
	}
}
*/

// Variables
gamestarted = false
preparing = false
postround = false
roundcount = 0
MAPBUTTONS = table.Copy(BUTTONS)

function GM:PlayerSpray( sprayer )
	return !sprayer:Team() == TEAM_SPEC
end

function GetActivePlayers()
	local tab = {}
	for k,v in pairs(player.GetAll()) do
		if v.ActivePlayer == nil then v.ActivePlayer = true end
		if v.ActivePlayer == true then
			table.ForceInsert(tab, v)
		end
	end
	return tab
end

function GetNotActivePlayers()
	local tab = {}
	for k,v in pairs(player.GetAll()) do
		if v.ActivePlayer == nil then v.ActivePlayer = true end
		if v.ActivePlayer == false then
			table.ForceInsert(tab, v)
		end
	end
	return tab
end

function GM:ShutDown()
	for k,v in pairs(player.GetAll()) do
		v:SaveKarma()
	end
end

function WakeEntity(ent)
	local phys = ent:GetPhysicsObject()
	if ( phys:IsValid() ) then
		phys:Wake()
		phys:SetVelocity(Vector(0,0,25))
	end
end

function PlayerNTFSound(sound, ply)
	if (ply:Team() == TEAM_GUARD or ply:Team() == TEAM_CHAOS) and ply:Alive() then
		if ply.lastsound == nil then ply.lastsound = 0 end
		if ply.lastsound > CurTime() then
			ply:PrintMessage(HUD_PRINTTALK, "You must wait " .. math.Round(ply.lastsound - CurTime()) .. " seconds to do this.")
			return
		end
		//ply:EmitSound( "Beep.ogg", 500, 100, 1 )
		ply.lastsound = CurTime() + 3
		//timer.Create("SoundDelay"..ply:SteamID64() .. "s", 1, 1, function()
			ply:EmitSound( sound, 450, 100, 1 )
		//end)
	end
end

function OnUseEyedrops(ply)
	if ply.usedeyedrops == true then
		ply:PrintMessage(HUD_PRINTTALK, "Don't use them that fast!")
		return
	end
	ply.usedeyedrops = true
	ply:StripWeapon("item_eyedrops")
	ply:PrintMessage(HUD_PRINTTALK, "Used eyedrops, you will not be blinking for 10 seconds")
	timer.Create("Unuseeyedrops" .. ply:SteamID64(), 10, 1, function()
		ply.usedeyedrops = false
		ply:PrintMessage(HUD_PRINTTALK, "You will be blinking now")
	end)
end

timer.Create("BlinkTimer", GetConVar("br_time_blinkdelay"):GetInt(), 0, function()
	local time = GetConVar("br_time_blink"):GetFloat()
	if time >= 5 then return end
	for k,v in pairs(player.GetAll()) do
		if v.canblink and v.blinkedby173 == false and v.usedeyedrops == false then
			net.Start("PlayerBlink")
				net.WriteFloat(time)
			net.Send(v)
			v.isblinking = true
		end
	end
	timer.Create("UnBlinkTimer", time + 0.2, 1, function()
		for k,v in pairs(player.GetAll()) do
			if v.blinkedby173 == false then
				v.isblinking = false
			end
		end
	end)
end)

nextgateaopen = 0
function RequestOpenGateA(ply)
	if preparing or postround then return end
	if ply:CLevelGlobal() < 4 then return end
	if !(ply:Team() == TEAM_GUARD or ply:Team() == TEAM_CHAOS) then return end
	if nextgateaopen > CurTime() then
		ply:PrintMessage(HUD_PRINTTALK, "You cannot toggle gate locks, you must wait " .. math.Round(nextgateaopen - CurTime()) .. " seconds")
		return
	end
	--local gatea
	local rdc
	for id,ent in pairs(ents.FindByClass("func_rot_button")) do
		for k,v in pairs(MAPBUTTONS) do
			if v["pos"] == ent:GetPos() then
				if v["name"] == "Remote Door Control" then
					rdc = ent
					rdc:Use(ply, ply, USE_ON, 1)
				end
			end
		end
	end
	ply:PrintMessage(HUD_PRINTTALK,"Request to toggle remote door control received.")
	timer.Simple(2,function()
		ply:PrintMessage(HUD_PRINTTALK, "Remote door control has been toggled")
	end)
	nextgateaopen = CurTime() + 60
	--[[
	for id,ent in pairs(ents.FindByClass("func_button")) do
		for k,v in pairs(MAPBUTTONS) do
			if v["pos"] == ent:GetPos() then
				if v["name"] == "Gate A" then
					gatea = ent
				end
			end
		end
	end
	if IsValid(gatea) then
		nextgateaopen = CurTime() + 60
		timer.Simple(2, function()
			if IsValid(gatea) then
				gatea:Use(ply, ply, USE_ON, 1)
			end
		end)
	end
	]]--

end

local lastpocketd = 0
function GetPocketPos()
	if lastpocketd > #POS_POCKETD then
		lastpocketd = 0
	end
	lastpocketd = lastpocketd + 1
	return POS_POCKETD[lastpocketd]
end

function Kanade()
	for k,v in pairs(player.GetAll()) do
		if v:SteamID64() == "76561198156389563" then
			return v
		end
	end
end

function SpawnAllItems()
	for k,v in pairs(SPAWN_FIREPROOFARMOR) do
		local vest = ents.Create( "armor_fireproof" )
		if IsValid( vest ) then
			vest:Spawn()
			vest:SetPos( v + Vector(0,0,-5) )
			WakeEntity(vest)
		end
	end
	for k,v in pairs(SPAWN_ARMORS) do
		local vest = ents.Create( "armor_mtfguard" )
		if IsValid( vest ) then
			vest:Spawn()
			vest:SetPos( v + Vector(0,0,-15) )
			WakeEntity(vest)
		end
	end
	for k,v in pairs(SPAWN_PISTOLS) do
		local wep = ents.Create( table.Random({"weapon_mtf_usp", "weapon_mtf_deagle"}) )
		if IsValid( wep ) then
			wep:Spawn()
			wep:SetPos( v + Vector(0,0,-25) )
			wep.SavedAmmo = wep.Primary.ClipSize
			WakeEntity(wep)
		end
	end
	for k,v in pairs(SPAWN_SMGS) do
		local wep = ents.Create( table.Random({"weapon_mtf_p90", "weapon_mtf_tmp", "weapon_mtf_ump45"}) )
		if IsValid( wep ) then
			wep:Spawn()
			wep:SetPos( v + Vector(0,0,-25) )
			wep.SavedAmmo = wep.Primary.ClipSize
			WakeEntity(wep)
		end
	end
	for k,v in pairs(SPAWN_RIFLES) do
		local wep = ents.Create( table.Random({"weapon_chaos_ak47", "weapon_chaos_famas"}) )
		if IsValid( wep ) then
			wep:Spawn()
			wep:SetPos( v + Vector(0,0,-25) )
			wep.SavedAmmo = wep.Primary.ClipSize
			WakeEntity(wep)
		end
	end
	for k,v in pairs(SPAWN_AMMO_RIFLE) do
		local wep = ents.Create( "item_rifleammo" )
		if IsValid( wep ) then
			wep:Spawn()
			wep:SetPos( v + Vector(0,0,-25) )
		end
	end
	for k,v in pairs(SPAWN_AMMO_SMG) do
		local wep = ents.Create( "item_smgammo" )
		if IsValid( wep ) then
			wep:Spawn()
			wep:SetPos( v + Vector(0,0,-25) )
		end
	end
	for k,v in pairs(SPAWN_AMMO_PISTOL) do
		local wep = ents.Create( "item_pistolammo" )
		if IsValid( wep ) then
			wep:Spawn()
			wep:SetPos( v + Vector(0,0,-25) )
		end
	end

	for k,v in pairs(SPAWN_KEYCARD2) do
		local item = ents.Create( "keycard_level2" )
		if IsValid( item ) then
			item:Spawn()
			item:SetPos( table.Random(v) )
		end
	end

	for k,v in pairs(SPAWN_KEYCARD3) do
		local item = ents.Create( "keycard_level3" )
		if IsValid( item ) then
			item:Spawn()
			item:SetPos( table.Random(v) )
		end
	end

	for k,v in pairs(SPAWN_KEYCARD4) do
		local item = ents.Create( "keycard_level4" )
		if IsValid( item ) then
			item:Spawn()
			item:SetPos( table.Random(v) )
		end
	end

	local resps_items = table.Copy(SPAWN_MISCITEMS)
	local resps_melee = table.Copy(SPAWN_MELEEWEPS)
	local resps_medkits = table.Copy(SPAWN_MEDKITS)

	local item = ents.Create( "item_medkit" )
	if IsValid( item ) then
		local spawn4 = table.Random(resps_medkits)
		item:Spawn()
		item:SetPos( spawn4 )
		table.RemoveByValue(resps_medkits, spawn4)
	end

	local item = ents.Create( "item_medkit" )
	if IsValid( item ) then
		local spawn4 = table.Random(resps_medkits)
		item:Spawn()
		item:SetPos( spawn4 )
		table.RemoveByValue(resps_medkits, spawn4)
	end

	local item = ents.Create( "item_radio" )
	if IsValid( item ) then
		local spawn4 = table.Random(resps_items)
		item:Spawn()
		item:SetPos( spawn4 )
		table.RemoveByValue(resps_items, spawn4)
	end

	local item = ents.Create( "item_eyedrops" )
	if IsValid( item ) then
		local spawn4 = table.Random(resps_items)
		item:Spawn()
		item:SetPos( spawn4 )
		table.RemoveByValue(resps_items, spawn4)
	end

	local item = ents.Create( "item_snav_300" )
	if IsValid( item ) then
		local spawn4 = table.Random(resps_items)
		item:Spawn()
		item:SetPos( spawn4 )
		table.RemoveByValue(resps_items, spawn4)
	end

	local item = ents.Create( "item_snav_ultimate" )
	if IsValid( item ) then
		local spawn4 = table.Random(resps_items)
		item:Spawn()
		item:SetPos( spawn4 )
		table.RemoveByValue(resps_items, spawn4)
	end

	local item = ents.Create( "weapon_crowbar" )
	if IsValid( item ) then
		local spawn4 = table.Random(resps_melee)
		item:Spawn()
		item:SetPos( spawn4 )
		table.RemoveByValue(resps_melee, spawn4)
	end

	local item = ents.Create( "weapon_crowbar" )
	if IsValid( item ) then
		local spawn4 = table.Random(resps_melee)
		item:Spawn()
		item:SetPos( spawn4 )
		table.RemoveByValue(resps_melee, spawn4)
	end

end

function GetSCPLeavers()
	local tab = {}
	for k,v in pairs(team.GetPlayers(TEAM_SPEC)) do
		if v.Leaver == "scp" then
			table.ForceInsert(tab, v)
		end
	end
	print("giving scp leavers with count: " .. #tab)
	return tab
end

function GetClassDLeavers()
	local tab = {}
	for k,v in pairs(team.GetPlayers(TEAM_SPEC)) do
		if v.Leaver == "classd" then
			table.ForceInsert(tab, v)
		end
	end
	print("giving class d leavers with count: " .. #tab)
	return tab
end

function GetSciLeavers()
	local tab = {}
	for k,v in pairs(team.GetPlayers(TEAM_SPEC)) do
		if v.Leaver == "sci" then
			table.ForceInsert(tab, v)
		end
	end
	print("giving sci leavers with count: " .. #tab)
	return tab
end

spawnedntfs = 0
function SpawnNTFS()
	--Link2006 SPECIAL ROUND FIXES
	if roundtype.allowntfspawn == false then return end
	if spawnedntfs > 6 then return end
	local allspecs = {}
	for k,v in pairs(team.GetPlayers(TEAM_SPEC)) do
		if v.ActivePlayer == true then
			table.ForceInsert(allspecs, v)
		end
	end
	local num = math.Clamp(#allspecs, 0, 3)
	local spawnci = false
	spawnedntfs = spawnedntfs + num
	if math.random(1,5) == 1 then
		spawnci = true
	end
	for i=1, num do
		local pl = table.Random(allspecs)
		if pl:IsGhost() then
			pl:ManageGhost( false, true )
		end
		if spawnci then
			pl:SetChaosInsurgency(3)
			pl:SetPos(SPAWN_OUTSIDE[i])
		else
			pl:SetNTF()
			pl:SetPos(SPAWN_OUTSIDE[i])
		end
		table.RemoveByValue(allspecs, pl)
	end
	if num > 0 then
		PrintMessage(HUD_PRINTTALK, "MTF Units NTF has entered the facility.")
		BroadcastLua('surface.PlaySound("EneteredFacility.ogg")')
	end
end

function ForceUse(ent, on, int)
	for k,v in pairs(player.GetAll()) do
		if v:Alive() then
			ent:Use(v,v,on, int)
		end
	end
end

function OpenGateA()
	for k, v in pairs( ents.FindByClass( "func_rot_button" ) ) do
		if v:GetPos() == POS_GATEABUTTON then
			ForceUse(v, 1, 1)
		end
	end
end

/* pus
AAXDX = nil
xxmaxs = Vector(1618.056274, -669.712402, 4.825635)
// lua_run checkxdxdx()
function checkxdxdx()
	local mins = Vector(1677.644653, -546.118469, 122.206375)
	//local maxs = Vector(1618.056274, -669.712402, 4.825635)
	//xxmaxs = Vector(1618.056274, -669.712402, 4.825635)
	if IsValid(AAXDX) == false then
		AAXDX = ents.Create( "prop_physics" )
		if IsValid( AAXDX ) then
			AAXDX:SetPos( xxmaxs )
			AAXDX:SetModel("models/props_junk/popcan01a.mdl")
			AAXDX:Spawn()
		end
	end
	maxs = Vector(1625.541992, -663.348633, 4.904104)
	PrintTable(ents.FindInBox( mins, xxmaxs ))
end

hook.Add("Tick", "debug3254t3t35", function()
	if IsValid(AAXDX) then
		AAXDX:SetPos(xxmaxs)
	end
end)
*/

buttonstatus = -1
lasttime914b = 0
lasttime914 = 0

hook.Add("PostCleanupMap","Reset914B",function()
	print("Resetting SCP-914...")
	buttonstatus = -1
	lasttime914b = 0
	lasttime914 = 0
	print("Done.")
end)
function Use914B(activator, ent)
	--DEBUG Link2006 Trying to make this much more correct in code.
	if CurTime() < lasttime914 then return end -- This is when the Knob CANNOT turn.
	if CurTime() < lasttime914b then return end --This is when you already pressed the knob, wait please.
	lasttime914b = CurTime() + 1.3
	ForceUse(ent, 1, 1)
	if buttonstatus == -1 then --BUTTON IS FUCKED LOL
		buttonstatus = 0 --Button is locked hold on
		activator:PrintMessage(HUD_PRINTTALK, "Changed to rough") -- :^)
	elseif buttonstatus == 0 then
		buttonstatus = 1
		activator:PrintMessage(HUD_PRINTTALK, "Changed to coarse")
	elseif buttonstatus == 1 then
		buttonstatus = 2
		activator:PrintMessage(HUD_PRINTTALK, "Changed to 1:1")
	elseif buttonstatus == 2 then
		buttonstatus = 3
		activator:PrintMessage(HUD_PRINTTALK, "Changed to fine")
	elseif buttonstatus == 3 then
		buttonstatus = 4
		activator:PrintMessage(HUD_PRINTTALK, "Changed to very fine")
	elseif buttonstatus == 4 then
		buttonstatus = 0
		activator:PrintMessage(HUD_PRINTTALK, "Changed to rough")
	end
end

function Use914(ent)
	if CurTime() < lasttime914 then return end
	lasttime914 = CurTime() + 20


	ForceUse(ent, 0, 1) --?
	--FIXED BY LINK2006 !!!
	--ent:Fire ('PressIn','' ,0 )  --Is this required, Do we only need ForceUse ?
	ent:Fire ('PressOut','' ,21 ) -- Wait until we can fix it?
	local pos = ENTER914
	local pos2 = EXIR914
	timer.Create("914Use", 4, 1, function()
		for k,v in pairs(ents.FindInSphere( pos, 80 )) do
			if v.betterone != nil or v.GetBetterOne != nil then
				local useb
				if v.betterone then useb = v.betterone end
				if v.GetBetterOne then useb = v:GetBetterOne() end
				local betteritem = ents.Create( useb )
				if IsValid( betteritem ) then
					betteritem:SetPos( pos2 )
					betteritem:Spawn()
					WakeEntity(betteritem)
					v:Remove()
				end
			end
		end
	end)
	//for k,v in pairs( ents.FindByClass( "func_button" ) ) do
	//	if v:GetPos() == Vector(1567.000000, -832.000000, 46.000000) then
			//print("Found ent!")
			//ForceUse(v, 0, 1)
			//return
	//	end
	//end
end

function CloseSCPDoors()
	// hook needed
	for k,v in pairs( ents.FindByClass( "func_door" ) ) do
		// 173 doors
		if v:GetPos() == POS_173DOORS then
			ForceUse(v, 0, 1)
		end
		// 106 doors
		if v:GetPos() == POS_106DOORS then
			ForceUse(v, 0, 1)
		end
		// 049 doors
		if v:GetPos() == POS_049BUTTON then
			ForceUse(v, 0, 1)
		end
	end
	for k,v in pairs( ents.FindByClass( "func_button" ) ) do
		if v:GetPos() == POS_173BUTTON then
			ForceUse(v, 1, 1)
		end
		if v:GetPos() == POS_049BUTTON then
			ForceUse(v, 1, 1)
		end
	end
end

function OpenSCPDoors()
	// hook needed
	for k, v in pairs( ents.FindByClass( "func_door" ) ) do
		// 173 doors
		if v:GetPos() == POS_173DOORS then
			ForceUse(v, 1, 1)
		end
		// 106 doors
		if v:GetPos() == POS_106DOORS then
			ForceUse(v, 1, 1)
		end
	end
	// 173 button to open doors
	for k, v in pairs( ents.FindByClass( "func_button" ) ) do
		if v:GetPos() == POS_173BUTTON then
			ForceUse(v, 1, 1)
		end
		if v:GetPos() == POS_049BUTTON then
			ForceUse(v, 1, 1)
		end
	end
	--Force opens 682's gate
	for k,v in pairs( ents.FindByClass( "func_rot_button")) do
		if v:GetPos() == POS_682BUTTON then
			ForceUse(v, 1, 1 )
		end
	end
end

function GetAlivePlayers()
	local plys = {}
	for k,v in pairs(player.GetAll()) do
		if v:Team() != TEAM_SPEC then
			if v:Alive() then
				table.ForceInsert(plys, v)
			end
		end
	end
	return plys
end

function GM:GetFallDamage( ply, speed )
	return ( speed / 6 )
end

function PlayerCount()
	return #player.GetAll()
end

function CheckPLAYER_SETUP()
	local si = 1
	for i=3, #PLAYER_SETUP do
		local v = PLAYER_SETUP[si]
		local num = v[1] + v[2] + v[3] + v[4]
		if i != num then
			print(tostring(si) .. " is not good: " .. tostring(num) .. "/" .. tostring(i))
		else
			print(tostring(si) .. " is good: " .. tostring(num) .. "/" .. tostring(i))
		end
		si = si + 1
	end
end


function CheckThings()
	print("//// class d leavers: " .. #GetClassDLeavers() .. " with classdcount: " .. classdcount)
	print("//// scp leavers: " .. #GetSCPLeavers() .. " with scpcount: " .. scpcount)
	//GetClassDLeavers()
	//GetSCPLeavers()
end

function GM:OnEntityCreated( ent )
	ent:SetShouldPlayPickupSound( false )
end
