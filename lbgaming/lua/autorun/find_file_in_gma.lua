if CLIENT or game.IsDedicated() then
	local searchThread
	local helpString = "\n"..[[
	Syntax:
	- Find files:  find_file_in_gma <filenameSubstring> [extension=""] [folderPrefix=""] [maxHeaderSize=65536]
	- Stop search: find_file_in_gma stop
	
	Arguments:
	- filenameSubstring: Substring to find, or "" to match any file
	- extension: the file extension (such as "bsp") or "" to match any extension (optional)
	- folderPrefix: the path prefix (such as "maps/") or "" to match any path (optional)
	- maxHeaderSize: the read length (in bytes) at the beginning of .gma files (optional)
	
	Examples:
	- Find roleplay maps:      find_file_in_gma "/rp_" "bsp" "maps/"
	- Find "prison" maps:      find_file_in_gma "prison" "bsp" "maps/"
	- Find "helicopter" files: find_file_in_gma "helicopter"
	- Find "zombie" models:    find_file_in_gma "zombie" "mdl" "models/"
	- Find all text files:     find_file_in_gma "" "txt"
	]]
	local function stopSearch()
		hook.Remove( "Think", "find_file_in_gma" )
		hook.Remove( "PreRender", "find_file_in_gma" )
		hook.Remove( "DrawOverlay", "find_file_in_gma" )
	end
	concommand.Add( "find_file_in_gma", function( ply, _, args )
		if SERVER and IsValid( ply ) and not ply:IsListenServerHost() then return end
		if not args[1] then
			print( helpString )
		elseif args[1]=="stop" and not args[2] then
			stopSearch()
		else
			local filenameSubstring = args[1] and string.len( args[1] )~=0 and string.lower( args[1] ) or nil
			local extension = args[2] and string.len( args[2] )~=0 and string.lower( args[2] ) or nil
			if extension and string.sub( extension, 1, 1 )~="." then
				extension = "."..extension
			end
			local extensionLen = extension and string.len( extension ) or nil
			local folderPrefix = args[3] and string.len( args[3] )~=0 and string.lower( args[3] ) or nil
			local folderPrefixLen = folderPrefix and string.len( folderPrefix ) or nil
			local maxHeaderSize = args[4] and tonumber( args[4] ) or 65536
			local gmasCount
			local gmasProgress = 0
			-- Search
			searchThread = coroutine.create( function()
				-- Fast functions
				local max = math.max
				local TickInterval = engine.TickInterval
				local SysTime = SysTime
				local yield = coroutine.yield
				local ipairs = ipairs
				local file_Find = file.Find
				local insert = table.insert
				local file_Open = file.Open
				local gmatch = string.gmatch
				local len = string.len
				local sub = string.sub
				local lower = string.lower
				local find = string.find
				local print = print
				local ErrorNoHalt = ErrorNoHalt
				-- Yield function
				local yieldIfNeeded
				do
					local maxDuration = max( 1/20, TickInterval() )  -- max = min( 20 fps, tickrate )
					local entered = SysTime()
					local now
					function yieldIfNeeded()
						now = SysTime()
						if now>entered+maxDuration then
							yield()
							entered = now
						end
					end
				end
				-- Search
				local countResults = 0
				local countAddons = 0
				local gmas = {}
				for _,folder in ipairs( {"addons/", "downloads/server/", "cache/srcds/"} ) do
					for _,gmaName in ipairs( file_Find( folder.."*.gma", "MOD" ) ) do
						insert( gmas, folder..gmaName )
					end
				end
				gmasCount = #gmas
				print( "Searching in", gmasCount, "addons..." )
				for i,gmaName in ipairs( gmas ) do
					yieldIfNeeded()
					local gma = file_Open( gmaName, "rb", "MOD" )
					if gma then
						local headers = gma:Read( maxHeaderSize )
						countAddons = countAddons+1
						gma:Close()
						local displayedGmaName = false
						for filename in gmatch( headers, "[%a]+[%/][\x20-\xFF]+[%.][%a]+[%z]" ) do -- slow!
							yieldIfNeeded()
							if len( filename )~=0 then
								filename = sub( filename, 1, -2 ) -- remove the NUL ending character
								local filenameLower = lower( filename ) -- lowercase
								local candidate = true
								if extension and sub( filenameLower, -extensionLen )~=extension then
									candidate = false -- extension does not match
								elseif folderPrefix and sub( filenameLower, 1, folderPrefixLen )~=folderPrefix then
									candidate = false -- path prefix does not match
								elseif filenameSubstring and not( find( filenameLower, filenameSubstring, 1, true ) ) then
									candidate = false -- does not match with searched substring
								end
								if candidate then
									if not displayedGmaName then
										displayedGmaName = true
										print( "In "..gmaName )
									end
									countResults = countResults+1
									print( "", filename )
								end
							end
						end
					else
						ErrorNoHalt( 'Could not open "'..gmaName..'"\n' )
					end
					gmasProgress = i
				end
				print( "Found", countResults, "results while browsing", countAddons, "addons." )
				return true
			end )
			hook.Add( SERVER and "Think" or "PreRender", "find_file_in_gma", function()
				local alive,msgOrFinished = coroutine.resume( searchThread )
				if alive and msgOrFinished==true then
					stopSearch()
				elseif not alive then
					stopSearch()
					if isstring( msg ) then
						ErrorNoHalt( "[ERROR] "..msg.."\n" )
					end
				end
			end )
			-- Gauge
			if CLIENT then
				local magnify = Material( "icon32/zoom_extend.png" )
				hook.Add( "DrawOverlay", "find_file_in_gma", function()
					surface.SetDrawColor( 255,255,255,192 )
					surface.DrawRect( 0,0, 48,48 )
					if gmasCount then
						local progress = 48*gmasProgress/gmasCount
						surface.SetDrawColor( 0,255,0,192 )
						surface.DrawRect( 0,1, progress,46 )
					end
					surface.SetDrawColor( 255,255,255,255-( ( RealTime()%0.5 )*384 ) )
					surface.SetMaterial( magnify )
					surface.DrawTexturedRect( 8,8, 32,32 )
				end )
			end
		end
	end, nil, helpString )
end
