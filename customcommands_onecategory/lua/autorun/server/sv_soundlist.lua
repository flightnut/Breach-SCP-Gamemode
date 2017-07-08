--[[
CreateConVar( "soundlist_usedefaultsounds", "0", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_GAMEDLL } )

local blacklist = {
"sound/ambient/construct_tone.wav",
"sound/ambient/forest_day.wav",
"sound/ambient/forest_night.wav",
"sound/garrysmod/balloon_pop_cute.wav",
"sound/garrysmod/content_downloaded.wav",
"sound/garrysmod/save_load1.wav",
"sound/garrysmod/save_load2.wav",
"sound/garrysmod/save_load3.wav",
"sound/garrysmod/save_load4.wav",
"sound/garrysmod/ui_click.wav",
"sound/garrysmod/ui_hover.wav",
"sound/garrysmod/ui_return.wav",
"sound/phx/eggcrack.wav",
"sound/phx/epicmetal_hard.wav",
"sound/phx/epicmetal_hard1.wav",
"sound/phx/epicmetal_hard2.wav",
"sound/phx/epicmetal_hard3.wav",
"sound/phx/epicmetal_hard4.wav",
"sound/phx/epicmetal_hard5.wav",
"sound/phx/epicmetal_hard6.wav",
"sound/phx/epicmetal_hard7.wav",
"sound/phx/epicmetal_soft1.wav",
"sound/phx/epicmetal_soft2.wav",
"sound/phx/epicmetal_soft3.wav",
"sound/phx/epicmetal_soft4.wav",
"sound/phx/epicmetal_soft5.wav",
"sound/phx/epicmetal_soft6.wav",
"sound/phx/epicmetal_soft7.wav",
"sound/phx/explode00.wav",
"sound/phx/explode01.wav",
"sound/phx/explode02.wav",
"sound/phx/explode03.wav",
"sound/phx/explode04.wav",
"sound/phx/explode05.wav",
"sound/phx/explode06.wav",
"sound/phx/hmetal1.wav",
"sound/phx/hmetal2.wav",
"sound/phx/hmetal3.wav",
"sound/phx/kaboom.wav",
"sound/sfx/skidding.wav",
"sound/thrusters/hover00.wav",
"sound/thrusters/hover01.wav",
"sound/thrusters/hover02.wav",
"sound/thrusters/jet00.wav",
"sound/thrusters/jet01.wav",
"sound/thrusters/jet02.wav",
"sound/thrusters/jet03.wav",
"sound/thrusters/jet04.wav",
"sound/thrusters/mh1.wav",
"sound/thrusters/mh2.wav",
"sound/thrusters/rocket00.wav",
"sound/thrusters/rocket01.wav",
"sound/thrusters/rocket02.wav",
"sound/thrusters/rocket03.wav",
"sound/thrusters/rocket04.wav"
}

local good = {
	mp3 = 1,
	wav = 1,
	ogg = 1
}

local function FindAllIn( dir, path )

	local tab = {}

	local function ScanRecursive( dir, tab )

		local files, folder = file.Find( dir .. "/*", path )

		if folder then
			for k, v in pairs( folder ) do
				table.insert( files, v )
			end
		end

		if not files then
			files = {}
		end

		for k, x in pairs( files ) do

			local ext = string.sub( x, -3 )
			local y = dir .. "/" .. x

			if not good[ ext ] or file.IsDir( x, path ) then
				ScanRecursive( y, tab )
			elseif good[ ext ] then
				if not table.HasValue( tab, y ) then
					table.insert( tab, y )
				end
			end

		end

	end

	ScanRecursive( dir, tab )

	return tab

end

local function SoundsCommand( ply, c, a )
	if not ply:IsValid() then
		print("SoundsCommand() Failed, ply is invalid")
		return
	end

	if ply.ShouldBeBanned then
		--STOP STOP STOP STOP STOP PLEASE
		return
	end

	if ply.SoundsCommandCooldown and (ply.SoundsCommandCooldown >= CurTime()) then
		if ply.BannedCommandsCount then
			ply.BannedCommandsCount = ply.BannedCommandsCount + 1
			if ply.BannedCommandsCount >= 5 then
				ply.ShouldBeBanned = true
				ULib.kickban(ply,0,"Attempt to crash the server")
				ply.ShouldBeBanned = true
				return
			else
				ply:PrintMessage(HUD_PRINTCONSOLE,"Please, do not spam this command!")
			end
		else
			ply.BannedCommandsCount = 1
			ply:PrintMessage(HUD_PRINTCONSOLE,"Please, do not spam this command!")
			--Console Print Unknown command
		end
	else --Someone can
		local allSounds = FindAllIn( "sound", "GAME" )
		if ( ply:IsValid() ) then
			if GetConVarNumber( "soundlist_usedefaultsounds" ) == 0 then
				for k, v in pairs( allSounds ) do
					if not table.HasValue( blacklist, v ) then
						umsg.Start( "sounds_yo", ply )
						umsg.String( string.sub( v, 7 ) )
						umsg.End()
					end
				end
			else
				for k, v in pairs( allSounds ) do
					umsg.Start( "sounds_yo", ply )
					umsg.String( string.sub( v, 7 ) )
					umsg.End()
				end
			end
			ply.SoundsCommandCooldown = CurTime() + 30 -- 10~ seconds delay
		end
	end
	print(tostring(ply).." HAS ATTEMPTED TO RUN sounds_request !")
end
]]--

--concommand.Add( "sounds_request", SoundsCommand )
--lua_openscript autorun/server/sv_soundlist.lua

concommand.Add( "sounds_request", function(ply)
	if ply.ShouldBeBanned then
		if not ply.ShouldBeBanned_ButKeptGoing then
			print("[BAN WARN] RECOMMENDED: PERMA BAN "..tostring(ply).." {"..tostring(ply:SteamID()).."}")
			ply.ShouldBeBanned_ButKeptGoing = true
		end
		return
	end
	ply.ShouldBeBanned = true
	ULib.kickban(ply,120,"Attempt to lag/crash the server (banned command)")
	ply.ShouldBeBanned = true
end)

--[[
cvars.AddChangeCallback( "soundlist_usedefaultsounds", function( cvarName, oldValue, newValue )

	for k, v in pairs( player.GetAll() ) do
		umsg.Start( "resetlist", v )
		umsg.End()
	end

	Msg( "[CC] ConVar \"soundlist_usedefaultsounds\" changed to " .. newValue .. "\n" )

end )
]]--
print("[customcommands ulx] sv_soundlist.lua loaded.")
