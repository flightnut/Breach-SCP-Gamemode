include("shared.lua")
include("fonts.lua")
include("class_default.lua")
include("sh_player.lua")
include("cl_mtfmenu.lua")
include("cl_scoreboard.lua")
include( "cl_sounds.lua" )
include( "cl_targetid.lua" )

								  
surface.CreateFont( "173font", {
	font = "TargetID",
	extended = false,
	size = 22,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

clang = nil
ALLLANGUAGES = {}

local files, dirs = file.Find(GM.FolderName .. "/gamemode/languages/*.lua", "LUA" )
for k,v in pairs(files) do
	local path = "languages/"..v
	if string.Right(v, 3) == "lua" then
		include( path )
		print("Loading language: " .. path)
	end
end

langtouse = CreateClientConVar( "br_language", "english", true, false ):GetString()
//defaultlang = GetConVar("br_defaultlanguage"):GetString()

//if ALLLANGUAGES[defaultlang] then
//	langtouse =  defaultlang
//end

cvars.AddChangeCallback( "br_language", function( convar_name, value_old, value_new )
	langtouse = value_new
	if ALLLANGUAGES[langtouse] then
		clang = ALLLANGUAGES[langtouse]
	end
end )

print("langtouse:")
print(langtouse)

//print("Alllangs:")
//PrintTable(ALLLANGUAGES)

if ALLLANGUAGES[langtouse] then
	clang = ALLLANGUAGES[langtouse]
else
	clang = ALLLANGUAGES.english
end

mapfile = "mapconfigs/" .. game.GetMap() .. ".lua"
include(mapfile)

include("cl_hud.lua")

RADIO4SOUNDSHC = {
	{"chatter1", 39},
	{"chatter2", 72},
	{"chatter4", 12},
	{"franklin1", 8},
	{"franklin2", 13},
	{"franklin3", 12},
	{"franklin4", 19},
	{"ohgod", 25}
}

RADIO4SOUNDS = table.Copy(RADIO4SOUNDSHC)

disablehud = false
livecolors = false

function DropCurrentVest()
	if LocalPlayer():Alive() and LocalPlayer():Team() != TEAM_SPEC then
		net.Start("DropCurrentVest")
		net.SendToServer()
	end
end

concommand.Add( "br_spectate", function( ply, cmd, args )
	net.Start("SpectateMode")
	net.SendToServer()
end )

concommand.Add( "br_roundrestart_cl", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("RoundRestart")
		net.SendToServer()
	end
end )

concommand.Add( "br_dropvest", function( ply, cmd, args )
	DropCurrentVest()
end )

concommand.Add( "br_disableallhud", function( ply, cmd, args )
	disablehud = !disablehud
end )

concommand.Add( "br_livecolors", function( ply, cmd, args )
	if livecolors then
		livecolors = false
		chat.AddText("livecolors disabled")
	else
		livecolors = true
		chat.AddText("livecolors enabled")
	end
end )

gamestarted = false
cltime = 0
drawinfodelete = 0
shoulddrawinfo = false
drawendmsg = nil
timefromround = 0

timer.Create("HeartbeatSound", 2, 0, function()
	if not LocalPlayer().Alive then return end
	if LocalPlayer():Alive() and LocalPlayer():Team() != TEAM_SPEC then
		if LocalPlayer():Health() < 30 then
			LocalPlayer():EmitSound("heartbeat.ogg")
		end
	end
end)

/*
viewpositions = {
	{Vector(-402.106079, 4011.909424, 70.592346),
	Vector(-585.309265, 4389.821289, 80.523294)}
}

usingview = 0
viewstatus = 0
function CalcViewTest( ply, pos, angles, fov )
	local view = {}
	if #player.GetAll() > 2 then
		view.origin = pos
		view.angles = angles
		view.fov = fov
		view.drawviewer = false
		return view
	end
	
	view.origin = pos
	view.angles = angles
	if usingview == 0 then
		if #viewpositions > 0 then
			usingview = 1
		end
	end
	if usingview > 0 then
		if viewstatus == 0 then
			view.origin = viewpositions[usingview][1]
			viewstatus = 1
		elseif viewstatus == 1 then
			//view.origin = viewpositions[usingview][1]
			view.angles = (viewpositions[usingview][2] - EyePos()):Angle()
			//view.origin = viewpositions[usingview][2] - viewpositions[usingview][1]
			local tr = util.TraceLine( {
				start = viewpositions[usingview][1],
				endpos = EyePos() + EyeAngles():Forward()
			} )
			view.origin = tr.HitPos
			view.origin = viewpositions[usingview][2] - viewpositions[usingview][1]
			//print( tr.HitPos, tr.Entity )
		end
	end
	view.fov = fov
	view.drawviewer = false
	return view
end
hook.Add( "CalcView", "CalcViewTest", CalcViewTest )
*/

function OnUseEyedrops(ply) end

function StartTime()
	timer.Destroy("UpdateTime")
	timer.Create("UpdateTime", 1, 0, function()
		if cltime > 0 then
			cltime = cltime - 1
		end
	end)
end

endinformation = {}

net.Receive( "UpdateTime", function( len )
	cltime = tonumber(net.ReadString())
	StartTime()
end)

net.Receive( "OnEscaped", function( len )
	local nri = net.ReadInt(4)
	shoulddrawescape = nri
	esctime = CurTime() - timefromround
	lastescapegot = CurTime() + 20
	StartEndSound()
	SlowFadeBlink(5)
end)

net.Receive( "ForcePlaySound", function( len )
	local sound = net.ReadString()
	surface.PlaySound(sound)
end)

net.Receive( "UpdateRoundType", function( len )
	roundtype = net.ReadString()
	print("Current roundtype: " .. roundtype)
end)

net.Receive( "SendRoundInfo", function( len )
	local infos = net.ReadTable()
	endinformation = {
		string.Replace( clang.lang_pldied, "{num}", infos.deaths ),
		string.Replace( clang.lang_descaped, "{num}", infos.descaped ),
		string.Replace( clang.lang_sescaped, "{num}", infos.sescaped ),
		string.Replace( clang.lang_rescaped, "{num}", infos.rescaped ),
		string.Replace( clang.lang_dcaptured, "{num}", infos.dcaptured ),
		string.Replace( clang.lang_rescorted, "{num}", infos.rescorted ),
		string.Replace( clang.lang_teleported, "{num}", infos.teleported ),
		string.Replace( clang.lang_snapped, "{num}", infos.snapped ),
		string.Replace( clang.lang_zombies, "{num}", infos.zombies )
	}
	if infos.secretf == true then
		table.ForceInsert(endinformation, clang.lang_secret_found)
	else
		table.ForceInsert(endinformation, clang.lang_secret_nfound)
	end
end)

net.Receive( "RolesSelected", function( len )
	drawinfodelete = CurTime() + 25
	shoulddrawinfo = true
end)

net.Receive( "PrepStart", function( len )
	cltime = net.ReadInt(8)
	chat.AddText(string.Replace( clang.preparing,  "{num}", cltime ))
	StartTime()
	drawendmsg = nil
	hook457delete = CurTime() + 0.5
	hook.Add("Tick", "Stop457Sounds", function()
		if hook457delete != nil then
			if hook457delete < CurTime() then
				hook457delete = nil
				hook.Remove("Tick", "Stop457Sounds")
			end
			if LocalPlayer():GetNClass() == ROLE_SCP457 then
				RunConsoleCommand("stopsound")
			end
		end
	end)
	timer.Destroy("SoundsOnRoundStart")
	timer.Create("SoundsOnRoundStart", 1, 1, SoundsOnRoundStart)
	timefromround = CurTime() + 10
	RADIO4SOUNDS = table.Copy(RADIO4SOUNDSHC)
end)

net.Receive( "RoundStart", function( len )
	cltime = net.ReadInt(12)
	chat.AddText(clang.round)
	StartTime()
	drawendmsg = nil
end)

net.Receive( "PostStart", function( len )
	cltime = net.ReadInt(6)
	win = net.ReadInt(4)
	drawendmsg = win
	StartTime()
end)

hook.Add( "OnPlayerChat", "CheckChatFunctions", function( ply, strText, bTeam, bDead )
	strText = string.lower( strText )

	if ( strText == "dropvest" ) then
		if ply == LocalPlayer() then
			DropCurrentVest()
		end
		return true
	end
end)

// Blinking system

local brightness = 0
local f_fadein = 0.25
local f_fadeout = 0.000075


local f_end = 0
local f_started = false
function tick_flash()
	if LocalPlayer().Team == nil then return end
	if LocalPlayer():Team() != TEAM_SPEC then
		for k,v in pairs(ents.FindInSphere(OUTSIDESOUNDS, 300)) do
			if v == LocalPlayer() then
				StartOutisdeSounds()
			end
		end
	end
	if shoulddrawinfo then
		if CurTime() > drawinfodelete then
			shoulddrawinfo = false
			drawinfodelete = 0
		end
	end
	if f_started then
		if CurTime() > f_end then
			brightness = brightness + f_fadeout
			if brightness < 0 then
				f_end = 0
				brightness = 0
				f_started = false
				//print("blink end")
			end
		else
			if brightness < 1 then
				brightness = brightness - f_fadein
			end
		end
	end
end
hook.Add( "Tick", "htickflash", tick_flash )

net.Receive("PlayerBlink", function(len)
	local time = net.ReadFloat()
	Blink(time)
end)

net.Receive("SlowPlayerBlink", function(len)
	local time = net.ReadFloat()
	Blink(time)
end)

function SlowFadeBlink(time)
	f_fadein = 0.0075
	f_fadeout = 0.0075
	f_started = true
	f_end = CurTime() + time
end

function Blink(time)
	f_fadein = 0.25
	f_fadeout = 0.000075
	f_started = true
	f_end = CurTime() + time
	//print("blink start")
end

local mat_color = Material( "pp/colour" ) -- used outside of the hook for performance
hook.Add( "RenderScreenspaceEffects", "blinkeffects", function()
	//if f_started == false then return end
	
	local contrast = 1
	local colour = 1
	
	if livecolors then
		contrast = 1.1
		colour = 1.5
	end
	if LocalPlayer():Health() < 30 and LocalPlayer():Alive() then
		colour = math.Clamp((LocalPlayer():Health() / LocalPlayer():GetMaxHealth()) * 5, 0, 2)
	end
	render.UpdateScreenEffectTexture()

	
	mat_color:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )
	
	mat_color:SetFloat( "$pp_colour_brightness", brightness )
	mat_color:SetFloat( "$pp_colour_contrast", contrast)
	mat_color:SetFloat( "$pp_colour_colour", colour )

	render.SetMaterial( mat_color )
	render.DrawScreenQuad()
end )

local dropnext = 0
function GM:PlayerBindPress( ply, bind, pressed )
	if bind == "+menu" then
		if dropnext > CurTime() then return true end
		dropnext = CurTime() + 0.5
		net.Start("DropWeapon")
		net.SendToServer()
		if LocalPlayer().channel != nil then
			LocalPlayer().channel:EnableLooping( false )
			LocalPlayer().channel:Stop()
			LocalPlayer().channel = nil
		end
		return true
	elseif bind == "+menu_context" then
		thirdpersonenabled = !thirdpersonenabled
	end
end

concommand.Add("br_requestescort", function()
	if !((LocalPlayer():Team() == TEAM_GUARD or LocalPlayer():Team() == TEAM_CHAOS) or LocalPlayer():Team() == TEAM_CHAOS) then return end
	net.Start("RequestEscorting")
	net.SendToServer()
end)

concommand.Add("br_requestgatea", function()
	if !((LocalPlayer():Team() == TEAM_GUARD or LocalPlayer():Team() == TEAM_CHAOS) or LocalPlayer():Team() == TEAM_CHAOS) then return end
	if LocalPlayer():CLevelGlobal() < 4 then return end
	net.Start("RequestGateA")
	net.SendToServer()
end)

concommand.Add("br_sound_random", function()
	if (LocalPlayer():Team() == TEAM_GUARD or LocalPlayer():Team() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Random")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_searching", function()
	if (LocalPlayer():Team() == TEAM_GUARD or LocalPlayer():Team() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Searching")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_classd", function()
	if (LocalPlayer():Team() == TEAM_GUARD or LocalPlayer():Team() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Classd")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_stop", function()
	if (LocalPlayer():Team() == TEAM_GUARD or LocalPlayer():Team() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Stop")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_lost", function()
	if (LocalPlayer():Team() == TEAM_GUARD or LocalPlayer():Team() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_Lost")
		net.SendToServer()
	end
end)
/*
function CalcView3DPerson( ply, pos, angles, fov )
	local view = {}
	view.origin = pos
	view.angles = angles
	view.fov = fov
	view.drawviewer = false
	if thirdpersonenabled then
		local eyepos = ply:EyePos()
		local eyeangles = ply:EyeAngles()
		local point = ply:GetEyeTrace().HitPos
		local goup = 2
		if ply:Crouching() then
			goup = 20
		end
		view.drawviewer = true
		view.origin = eyepos + Vector(0,0,goup) - (eyeangles:Forward() * 30) + (eyeangles:Right() * 20)
		view.angles = (point - view.origin):Angle()
		local endps = eyepos + Vector(0,0,goup) - (eyeangles:Forward() * 30) + (eyeangles:Right() * 15)
		local tr = util.TraceLine( { start = eyepos, endpos = endps} )
		if tr.Hit then
			view.origin = tr.HitPos
		end
	end
	return view
end
hook.Add( "CalcView", "CalcView3DPerson", CalcView3DPerson )
*/
print("cl_init loads")

