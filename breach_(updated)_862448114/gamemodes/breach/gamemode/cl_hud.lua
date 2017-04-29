
-- Creates a convar (console variable) to disable/enable the ui.
local d3uiHUDEnable_Sbox = CreateClientConVar( "d3HUD_Enable_Sbox", "1", true, true , "Disables the Health orb")
-- This one is for numbers on the health orbs.  (which is under the orb anyway so rip.)
local d3uiHUDHPNum_Sbox = CreateClientConVar( "d3HPNum_enable_Sbox", "1", true, true, "DEPRECATED: Shows the health number under the orbs" )
-- This is the avatar :)
local d3HUD_enable_avatar = CreateClientConVar( "d3HUD_enable_avatar", "1", true, true, "Disables avatar if 0, enables otherwise" )
--Callback to Create and Delete the avatar when toggling that variable
cvars.AddChangeCallback('d3HUD_enable_avatar',function(convar,oldvar,newvar)
	if convar == 'd3HUD_enable_avatar' then
		if newvar ~= "0" then
			CreateAvatarImage(LocalPlayer())
		else
			DeleteAvatarImage()
		end
	end
end )

local isStart = false --Default to FALSE, it shouldn't say "Starting" when a player joins mid-round :^l

net.Receive("UpdatePrepareVariable",function ()
	--local sb = net.ReadBool() or false
	isStart = net.ReadBool() or false
	--print(timeText)
	--[[
	timer.Create("suzyFast",1,0,function( )
		print("Got update bool value is now " .. tostring(sb))
	end)
	]]--
	-- isStart = sb
end)

-- Caches the textures in memory. It's bad to fetch the textures over and over again every single frame.
-- VMT files have to be used for images that have ditherd, smooth edges that fade to transparency.
-- PNGs will have some white spots instead of transparent on the edges. Don't know why but they do.
local healthOverlayTex = Material( "d3hb/d3health", "nocull smooth" ) 		-- VMT
local OverlayGoop = Material( "d3hb/d3healthgoop.png", "nocull smooth" )	-- PNG

local armorOverlayTex = Material( "d3hb/d3armor", "nocull smooth" )
local armorGoop = Material( "d3hb/d3armorgoop.png", "nocull smooth" )

local infoOverlay = Material( "d3hb/d3info", "nocull smooth" )
local infoRadar = Material( "d3hb/d3radar.png", "nocull smooth" )
local infoHunger = Material( "d3hb/d3hunger.png", "nocull smooth" )

surface.CreateFont( "MoneyFont_14", {
	font = "Exocet Light",
	size = 14,
	weight = 500,
	blursize = 0,
	scanlines = 0,
} )

surface.CreateFont( "MoneyFont_12", {
	font = "Exocet Light",
	size = 10,
	weight = 500,
	blursize = 0,
	scanlines = 0,
} )

surface.CreateFont( "WeaponFont", {
	font = "Tahoma Bold",
	size = 14,
	weight = 500,
	blursize = 0,
	scanlines = 0,
} )

surface.CreateFont( "WeaponFont_Small", {
	font = "Exocet Light",
	size = 10,
	weight = 500,
	blursize = 0,
	scanlines = 0,
} )

surface.CreateFont( "WeaponFont_Extra_Small", {
	font = "Exocet Light",
	size = 8,
	weight = 500,
	blursize = 0,
	scanlines = 0,
} )

surface.CreateFont( "AmmoFont", {
	font = "Exocet Light",
	size = 25,
	weight = 500,
	blursize = 0,
	scanlines = 0,
} )

surface.CreateFont( "JobFont_24", {
	font = "Exocet Light",
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
} )

surface.CreateFont( "JobFont_18", {
	font = "Exocet Light",
	size = 18,
	weight = 500,
	blursize = 0,
	scanlines = 0,
} )

surface.CreateFont( "JobFont_14", {
	font = "Exocet Light",
	size = 14,
	weight = 500,
	blursize = 0,
	scanlines = 0,
} )

surface.CreateFont( "JobFont_10", {
	font = "Exocet Light",
	size = 10,
	weight = 500,
	blursize = 0,
	scanlines = 0,
} )

surface.CreateFont( "JobFont_8", {
	font = "Exocet Light",
	size = 8,
	weight = 500,
	blursize = 0,
	scanlines = 0,
} )

/*-------------------------------------------------------------------
	This hook draws Health and Armor.
-------------------------------------------------------------------*/

-- These have to be set outside the hook so they don't override everytime.
local hpsmoothing = 0
local arsmoothing = 0

hook.Add( "HUDPaint", "HUDDiabloHealth", function()

	if GetConVar( "d3HUD_Enable_Sbox" ):GetBool() == false then return end


	local ply = LocalPlayer()
	local hp = ply:Health()
	local maxhp = ply:GetMaxHealth()
	-- Disable Armor Till We Fix
	local ar = 0
	--local ar = ply:Armor()

	if ply:Team() == TEAM_SPEC then
		local ent = ply:GetObserverTarget()
		if IsValid(ent) then
			if ent:IsPlayer() then
				hp = ent:Health()
				maxhp = ent:GetMaxHealth()
				ar = 0
			end
		end
	end


	-- This is where the smoothing magic happens.
	hpsmoothing = math.Approach( hpsmoothing, hp, 70 * FrameTime())
	arsmoothing = math.Approach( arsmoothing, ar, 70 * FrameTime())

	-- The size of the goop that will be scissor rect'd.
	local w = 256
	local h = 256

	-- used for pos of goop and overlay.
	local y = ScrH() - h
	local z = ScrW() - w

	-- Sets the number to somethine like 0.0433 usually
	--local HPmath = 1 - math.Clamp( hpsmoothing / 100, 0, 1)
	local HPmath = 1 - math.Clamp( hpsmoothing / maxhp, 0, 1)

	local goopW,goopH = 152.5,148
	local goopX,goopY = 92, y + 93.5

	-- Then the scissor rect moves to the outside of the goop, or cutting the top off.
	render.SetScissorRect( goopX, goopY + ( goopW * HPmath ), goopX + goopW, goopY + goopW, true ) // Sets a scissor rect; anything outside of it is cut off
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( OverlayGoop )
		surface.DrawTexturedRect( goopX, goopY, goopW, goopH )
	render.SetScissorRect( 0, 0, 0, 0, false ) -- Has to be reset after.

	-- The overlay overtop of the goop.
	surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( healthOverlayTex )
	surface.DrawTexturedRect( 0, y, w, h )


	-- Hides the armor meter if you have no Armor
	if ar < 1 then return end

	-- This is all the same as the health above but moved to the other side of the screen.
	local ARmath = 1 - math.Clamp( arsmoothing / 100, 0, 1)

	local goopW,goopH = 155, 155
	local goopX,goopY = z + 10, y + 89

	render.SetScissorRect( goopX, goopY + ( goopW * ARmath ), goopX + goopW, goopY + goopW, true ) // Sets a scissor rect; anything outside of it is cut off
		surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( armorGoop )
		surface.DrawTexturedRect( goopX, goopY, goopW, goopH )
	render.SetScissorRect( 0, 0, 0, 0, false )

	surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( armorOverlayTex )
	surface.DrawTexturedRect( z, y, w, h )


end )

hook.Add( "HUDPaint", "!HUDDiablo", function()

	if GetConVar( "d3HUD_Enable_Sbox" ):GetBool() == false then return end

	local ply = LocalPlayer()

	local w = 512
	local h = 256

	local g = ScrW() / 2

	local y = ScrH() - h + 100
	local z = ScrW() - 620 - g


	-- gets and draws the players job
	darkrpJob = ply:GetUserGroup()
	JobFont = "JobFont_24"

	if string.len( darkrpJob ) > 18 then JobFont = "JobFont_8" elseif  string.len( darkrpJob ) > 15 then JobFont = "JobFont_10" elseif string.len( darkrpJob ) > 10 then JobFont = "JobFont_14" elseif string.len( darkrpJob ) > 8 then JobFont = "JobFont_18" end

	-- Number of props spawned and the max.
	-- the # takes the returned table and makes it a number
	-- GetConVar( "sbox_maxprops" ):GetInt()
	-- ply:GetCount( "props" )

end )


// I added _Conf to the end of these just incase some other addon messes just happens
// to have the same variable.

// Enable this if you use a special hunger mod that has it's own special meter
// or you want have the default DarkRP hunger mod on but don't want your players
// to see the UI for it for whaterver reason.
SpecialHungerMod_Conf = false

// Set this to 1 (the default) for the players model, 2 for player's steam avatar,
// 3 for a custom png, 0 for nothing (ugly, but supported).
ShowHUDModel_Conf = 2

// Either overwrite the .png in the material/custom folder or change this to
// your new one. The new one should be 56x56 pixels.
ShowHUDModelCustomPNG_Conf = "custom/customimage.png" -- default image

// Incase you think the defaul font (Exocet Light) is unreadable here is a way to
// change it.
// Default is "JobFont_14"
// Options you can choose from by default are here: https://wiki.garrysmod.com/page/Default_Fonts

AgendaFont_Conf = "JobFont_14"


local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
	//CHudWeaponSelection = true,
	CHudDeathNotice = true
	//CHudWeapon = true
}

surface.CreateFont("ImpactBig", {font = "Impact",
                                  size = 45,
                                  weight = 700})
surface.CreateFont("ImpactSmall", {font = "Impact",
                                  size = 30,
                                  weight = 700})

surface.CreateFont( "RadioFont", {
	font = "Impact",
	extended = false,
	size = 26,
	weight = 7000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function GM:DrawDeathNotice( x,  y )
end

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	--Draw the Deathnotice for spectators (DOES NOT WORK?)
	if name == "CHudDeathNotice"  then --Is it a HudDeathNotice?
		if IsValid(LocalPlayer()) then --Are we a player.
			if LocalPlayer().Team then --Check By Team
				if LocalPlayer():Team() == TEAM_SPEC then --Are we spectator?
					return true --Show the death
				end
			elseif LocalPlayer().IsGhost then --TEAMCHECK FAILED, SpecDm check
				if LocalPlayer():IsGhost() then --We're in SpecDM
					return true --Show the death
				end
			end
		end
	end

	if ( hide[ name ] ) then return false end
end )

function Getrl()
	local rl = LocalPlayer():GetNClass()
	if LocalPlayer():Team() == TEAM_CHAOS then
		if roundtype == "Trouble in SCP Town" then
			return 12
		elseif roundtype == "Assault" then
			return 13
		else
			return 11
		end
	end
	if rl == ROLE_SCP173 then return 1 end
	if rl == ROLE_SCP106 then return 2 end
	if rl == ROLE_SCP049 then return 3 end
	if rl == ROLE_SCP457 then return 15 end
	if rl == ROLE_SCP035 then return 18 end
	if rl == ROLE_SCP1048A then return 19 end
	if rl == ROLE_SCP682 then return 20 end
	if rl == ROLE_SCP966 then return 21 end
	if rl == ROLE_MTFGUARD then
		if roundtype == "Trouble in SCP Town" then
			return 5
		elseif roundtype == "Zombie Plague" then
			return 16
		else
			return 4
		end
	end
	if rl == ROLE_MTFCOM then return 6 end
	if rl == ROLE_MTFNTF then return 7 end
	if rl == ROLE_CLASSD then return 8 end
	if rl == ROLE_RES then return 9 end
	if rl == ROLE_SCP0492 then return 10 end
	if rl == ROLE_SPEC then return 14 end
	if rl == ROLE_SCP0082 then return 17 end
	return 14
end

endmessages = {
	{
		main = clang.lang_end1,
		txt = clang.lang_end2,
		clr = team.GetColor(TEAM_SCP)
	},
	{
		main = clang.lang_end1,
		txt = clang.lang_end3,
		clr = team.GetColor(TEAM_SCP)
	}
}

function DrawInfo(pos, txt, clr)
	pos = pos:ToScreen()
	draw.TextShadow( {
		text = txt,
		pos = { pos.x, pos.y },
		font = "HealthAmmo",
		color = clr,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}, 2, 255 )
end

hook.Add( "Tick", "966check", function()
	local hide = true
	if LocalPlayer().Team == nil then return end
	if LocalPlayer():Team() == TEAM_SCP or LocalPlayer():Team() == TEAM_SPEC then
		hide = false
	end

	--TODO: REPLACE WITH CUSTOM NV CODE

	if LocalPlayer().CanSee966 then
		hide = false
	end
	--[[
	if IsValid(LocalPlayer():GetActiveWeapon()) then
		if LocalPlayer():GetActiveWeapon():GetClass() == "item_nvg" then
			hide = false
		end
	end
	]]--
	for k,v in pairs(player.GetAll()) do
		if not v.GetNClass then
			player_manager.RunClass( v, "SetupDataTables" )
		end
		if v.GetNClass == nil then return end
		if v:GetNClass() == ROLE_SCP966 then
			v:SetNoDraw(hide)
		end
	end
end )

local info1 = Material( "breach/info_mtf.png")
hook.Add( "HUDPaint", "Breach_DrawHUD", function()
	if disablehud == true then return end
	/*
	if BUTTONS != nil then
		for k,v in pairs(BUTTONS) do
			//DrawInfo(v.pos, v.name, Color(0,255,50))
		end
		for k,v in pairs(SPAWN_KEYCARD2) do
			//DrawInfo(v, "Keycard2", Color(255,255,0))
		end
		for k,v in pairs(SPAWN_KEYCARD3) do
			//DrawInfo(v, "Keycard3", Color(255,120,0))
		end
		for k,v in pairs(SPAWN_KEYCARD4) do
			//DrawInfo(v, "Keycard4", Color(255,0,0))
		end
		for k,v in pairs(SPAWN_ITEMS) do
			DrawInfo(v, "Item", Color(255,255,255))
		end
		for k,v in pairs(SPAWN_SMGS) do
			//DrawInfo(v, "SMG", Color(255,255,255))
		end
	end
	*/
	/*
	if player.GetCount() < MINPLAYERS then
		draw.TextShadow( {
			text = "Not enough players to start the round",
			pos = { ScrW() / 2, ScrH() / 15 },
			font = "ImpactBig",
			color = Color(255,255,255),
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}, 2, 255 )
		draw.TextShadow( {
			text = "Waiting for more players to join the server",
			pos = { ScrW() / 2, ScrH() / 15 + 45 },
			font = "ImpactSmall",
			color = Color(255,255,255),
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}, 2, 255 )
		return

	elseif gamestarted == false then
		draw.TextShadow( {
			text = "Game is starting",
			pos = { ScrW() / 2, ScrH() / 15 },
			font = "ImpactBig",
			color = Color(255,128,70),
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}, 2, 255 )
		draw.TextShadow( {
			text = "Wait for the round to start",
			pos = { ScrW() / 2, ScrH() / 15 + 45 },
			font = "ImpactSmall",
			color = Color(255,255,255),
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}, 2, 255 )
		return
	end
	*/

	if shoulddrawinfo == true then
		local getrl = Getrl()
		local align = 32
		local tcolor = team.GetColor(LocalPlayer():Team())
		if LocalPlayer():Team() == TEAM_CHAOS then
			tcolor = Color(29, 81, 56)
		end
		draw.TextShadow( {
			text = clang.starttexts[getrl][1],
			pos = { ScrW() / 2, ScrH() / 15 },
			font = "ImpactBig",
			color = tcolor,
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
		}, 2, 255 )
		for i,txt in ipairs(clang.starttexts[getrl][2]) do
			draw.TextShadow( {
				text = txt,
				pos = { ScrW() / 2, ScrH() / 15 + 10 + (align * i) },
				font = "ImpactSmall",
				color = Color(255,255,255),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}, 2, 255 )
		end
		if roundtype != nil then
			draw.TextShadow( {
				text = string.Replace( clang.roundtype,  "{type}", roundtype ),
				pos = { ScrW() / 2, ScrH() - 25 },
				font = "ImpactSmall",
				color = Color(255, 130, 0),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}, 2, 255 )
		end
	end

	--[[local panel = vgui.Create("DPanel")
	panel:ParentToHUD()
	panel:SetSize( 64, 64 )
	panel:SetPos(300 - 46,ScrH() - 130 - 15)
	panel:SetColor(0,0,0,0)]]


	if isnumber(drawendmsg) then
		local ndtext = clang.lang_end2
		if drawendmsg == 2 then
			ndtext = clang.lang_end3
		end
		//if clang.endmessages[drawendmsg] then
			shoulddrawinfo = false
			draw.TextShadow( {
				text = clang.lang_end1,
				pos = { ScrW() / 2, ScrH() / 15 },
				font = "ImpactBig",
				color = Color(0,255,0),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}, 2, 255 )
			draw.TextShadow( {
				text = ndtext,
				pos = { ScrW() / 2, ScrH() / 15 + 45 },
				font = "ImpactSmall",
				color = Color(255,255,255),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}, 2, 255 )
			for i,txt in ipairs(endinformation) do
				draw.TextShadow( {
					text = txt,
					pos = { ScrW() / 2, ScrH() / 8 + (35 * i)},
					font = "ImpactSmall",
					color = color_white,
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255 )
			end
		//else
		//	drawendmsg = nil
		//end
	else
		if isnumber(shoulddrawescape) then
			if CurTime() > lastescapegot then
				shoulddrawescape = nil
			end
			if clang.escapemessages[shoulddrawescape] then
				local tab = clang.escapemessages[shoulddrawescape]
				draw.TextShadow( {
					text = tab.main,
					pos = { ScrW() / 2, ScrH() / 15 },
					font = "ImpactBig",
					color = tab.clr,
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255 )
				draw.TextShadow( {
					text = string.Replace( tab.txt, "{t}", string.ToMinutesSecondsMilliseconds(esctime) ),
					pos = { ScrW() / 2, ScrH() / 15 + 45 },
					font = "ImpactSmall",
					color = Color(255,255,255),
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255 )
				draw.TextShadow( {
					text = tab.txt2,
					pos = { ScrW() / 2, ScrH() / 15 + 75 },
					font = "ImpactSmall",
					color = Color(255,255,255),
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255 )
			end
		end
	end
	local ply = LocalPlayer()
	if ply:Alive() == false then
		DeleteAvatarImage()
		return
	end


	if ply:Team() == TEAM_SPEC then
		local ent = ply:GetObserverTarget()
		if IsValid(ent) then
			if ent:IsPlayer() then
				local sw = 350
				local sh = 35
				local sx =  ScrW() / 2 - (sw / 2)
				local sy = 0
				draw.RoundedBox(0, sx, sy, sw, sh, Color(50,50,50,255))
				draw.TextShadow( {
					text = string.sub(ent:Nick(), 1, 17),
					pos = { sx + sw / 2, 15 },
					font = "HealthAmmo",
					color = Color(255,255,255),
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255 )

				CreateAvatarImage(ent)
			else
				CreateAvatarImage(ply)
			end
		else
			CreateAvatarImage(ply)
		end
		//return
	else
		CreateAvatarImage(ply)
	end
	local wep = nil
	local ammo = -1
	local ammo2 = -1

	local width = 400
	local height = 130
	local role_width = width - 25

	local x,y
	x = 245
	y = ScrH() - height - 15

	local hl = math.Clamp(LocalPlayer():Health(), 1, LocalPlayer():GetMaxHealth()) / LocalPlayer():GetMaxHealth()
	if hl < 0.06 then hl = 0.06 end

	local name = "None"
	if not ply.GetNClass then
		player_manager.RunClass( ply, "SetupDataTables" )
	elseif LocalPlayer():Team() != TEAM_SPEC then
		name = GetLangRole(ply:GetNClass())
		if ply:Team() == TEAM_CHAOS then
			name = GetLangRole(ROLE_CHAOS)
			//if ply:GetNClass() == ROLE_MTFNTF then
			//	name = "MTF NTF (SPY)"
			//end
		end
	else
		local obs = ply:GetObserverTarget()
		if IsValid(obs) then
			if obs.GetNClass != nil then
				name = GetLangRole(obs:GetNClass())
				ply = obs
			else
				name = GetLangRole(ply:GetNClass())
			end
		else
			name = GetLangRole(ply:GetNClass())
		end
	end
	local color = team.GetColor( ply:Team() )
	if ply:Team() == TEAM_CHAOS then
		color = Color(29, 81, 56)
	end
	draw.RoundedBox(0, x, y, width, height, Color(0,0,10,200))
	draw.RoundedBox(0, x, y, role_width - 70, 30, color )

	draw.TextShadow( {
		text = name,
		pos = { role_width * 2 / 1.9, y + 12.5 },
		font = "ClassName",
		color = Color(255,255,255),
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}, 2, 255 )

	local tclr = Color(255,255,255)
	local timeText = "Time Left: ERROR"


	if isStart then
		timeText = "Starting:  ".. tostring(string.ToMinutesSeconds( cltime ))
	else
		timeText = "Time Left:  ".. tostring(string.ToMinutesSeconds( cltime ))
	end

	draw.TextShadow( {
		text = timeText,
		pos = { width + 50, y + 104 },
		font = "TimeLeft",
		color = tclr,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_TOP,
	}, 2, 255 )

	//Health
	local hpText = "HP: "..tostring(ply:Health())
	if ply:Team() == TEAM_SPEC then
		local ent = ply:GetObserverTarget()
		if IsValid(ent) then
			if ent:IsPlayer() then
				hpText = ent:Health()
			end
		end
	end
	draw.TextShadow({
		text = hpText,
		--pos = {width - 200,y+100},
		pos = { width + 100, y + 35 },
		font = "WeaponFont",
			color = Color(255,255,255),
			xalign = TEXT_ALIGN_RIGHT, --TEXT_ALIGN_RIGHT
			yalign = TEXT_ALIGN_RIGHT,
	},2,255)

	// ping
	draw.TextShadow( {
		text = "Ping:   " .. ply:Ping() , Color( 255, 255, 255, 255 ),
		pos = { width - 50, y + 35 },
		font = "WeaponFont",
		color = Color(255,255,255),
		xalign = TEXT_ALIGN_RIGHT,
		yalign = TEXT_ALIGN_RIGHT,
	}, 2, 255 )

	// fps
	draw.TextShadow( {
		text = "FPS:   " .. ( math.floor(1/FrameTime()) ) , WeaponFont, Color( 255, 255, 255, 255 ),
		pos = { width - 50, y + 54 },
		font = "WeaponFont",
		color = Color(255,255,255),
		xalign = TEXT_ALIGN_RIGHT,
		yalign = TEXT_ALIGN_RIGHT,
	}, 2, 255 )

	local w = 512
	local h = 256

	// range
	draw.TextShadow( {
		text = "Rank: " .. tostring(darkrpJob), JobFont, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER,
		pos = { width + 100, y + 54 },
		font = "WeaponFont",
		color = Color(255,255,255),
		xalign = TEXT_ALIGN_RIGHT,
		yalign = TEXT_ALIGN_RIGHT,
	}, 2, 255 )

	local ammotext = nil
	local wep = nil

	if ply:GetActiveWeapon() != nil and #ply:GetWeapons() > 0 then
		wep = ply:GetActiveWeapon()
		if wep then
			if wep.Clip1 == nil then return end
			if wep:Clip1() > -1 then
				ammo1 = wep:Clip1()
				ammo2 = ply:GetAmmoCount( wep:GetPrimaryAmmoType() )
				ammotext = ammo1 .. " + ".. ammo2
			end
		end
	end


	if not ammotext then return end
	local am = math.Clamp(wep:Clip1(), 0, wep:GetMaxClip1()) / wep:GetMaxClip1()

	// Ammo
	draw.RoundedBox(0, 258, y + 75, (width - 30) * am, 27, Color(205, 155, 0, 255))
	draw.TextShadow( {
		text = ammotext,
		pos = { width - 46, y + 75 },
		font = "HealthAmmo",
		color = Color(255,255,255),
		xalign = TEXT_ALIGN_RIGHT,
		yalign = TEXT_ALIGN_RIGHT,
	}, 2, 255 )


end )

hook.Add( "InitPostEntity", "some_unique_name", function()
	CreateAvatarImage(LocalPlayer())
end )

function DeleteAvatarImage() --Might not be useful tbh :x
	if AvatarImage then
		if AvatarImage:IsValid() then
			AvatarImage:Clear()
			AvatarImage:Remove()
		end
	end
end
function CreateAvatarImage(ply)
	if AvatarImage then
		if AvatarImage:IsValid() then
			AvatarImage:Clear()
			AvatarImage:Remove()
		end
	end
	if d3HUD_enable_avatar:GetBool() then --Do we create one?
		AvatarImage = vgui.Create( "AvatarImage" )
    	--local avImg = ScreenScale()
		local sw,sh = ScrW(), ScrH()
		AvatarImage:SetSize( 64, 64 )

		local x,y = RegulateToScreen( )
		AvatarImage:SetPos ( sw / 2 - x,ScrH() - y)
		AvatarImage:SetPlayer( ply, 64 )
	end
end



function RegulateToScreen( )
    local sw,sh = ScrW(), ScrH()
    local x,y = 0, 0
    if(sw == 1920 && sh == 1080)then
    	x = 397
    	y = 140

    	elseif(sw == 1768 && sh == 992)then
    		x = 320
    		y = 140

    	elseif(sw == 1600 && sh == 900)then
    		x = 235
    		y = 140

    	elseif(sw == 1366 && sh ==760)then
    		x = 120
    		y = 140

    	elseif(sw == 1360 && sh == 768)then
    		x = 115
    		y = 140

    	elseif(sw == 1280 && sh == 720)then
    		x = 77
    		y = 140

    	elseif(sw == 1176 && sh == 664)then
    		x = 25
    		y = 140

	end
	return x, y

end
