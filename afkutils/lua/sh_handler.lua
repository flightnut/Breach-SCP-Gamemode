--[[=============================================================================]]--
--[[==== Away from Keyboard Utilities - Version 1.1.3                        ====]]--
--[[==== Made by Red @ https://scriptfodder.com/users/view/76561198151769476 ====]]--
--[[=============================================================================]]--

-- Table root
afkutil.handle = {}
afkutil.themes = {}
afkutil.variable = {}
afkutil.table = {}

-- Variables
afkutil.variable.notiftext = nil
afkutil.variable.notiftype = 0
afkutil.variable.forcewarn = false

-- Tables
afkutil.table.afkplayers = {}
afkutil.time = CurTime()

-- Check if table empty
afkutil.tableempty = function(self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end

-- Check if table has value
afkutil.tablehasvalue = function(tab, val)
    for index, value in pairs(tab) do
        if tostring(index) == val then
            return true
        end
    end
    return false
end

-- Check group
afkutil.isgroupfromtable = function(tab, ply)
	local lock = nil
	for k, v in pairs(tab) do
		if v == ply:GetUserGroup() then
			lock = true
			return true
		else
			lock = false
		end
	end
	if lock == false then
		return false
	end
end

-- Debug Function
afkutil.handle.debugprint = function(text)
	if afkutil.config.debug then
		print(afkutil.config.prefix.." "..text)
	end
end

-- Notify function
afkutil.handle.notify = function(type, text)
	afkutil.variable.notiftype = type
	afkutil.variable.notiftext = text
	net.Start( "notifyclientonpropspawn" )
	net.Broadcast()
end

-- Remove warning function
afkutil.handle.removewarning = function(ply)
	net.Start("RemovePlayerAFKWarning")
	net.Send(ply)
	ply.hasbeenwarned = false
end

-- Give warning function
afkutil.handle.givewarning = function(ply)
	net.Start("GivePlayerAFKWarning")
	net.Send(ply)
	ply.hasbeenwarned = true
end

afkutil.handle.loadthemes = function()	
	local files, dirs = file.Find("afkutils_themes/*", "LUA")
	for files, name in pairs(files) do
		if !string.EndsWith(name, ".txt") then
			if SERVER then
				afkutil.handle.debugprint("Loaded theme "..name)
				AddCSLuaFile("afkutils_themes/" .. name)
			end
			theme = {}
			
			-- Defaults
			theme.__index = theme
			theme.id = string.gsub(string.lower(name), ".lua", "") -- Remove .lua from string
			theme.name = theme.id
			theme.author = "N/A"
			theme.website = "N/A"
			theme.information = "N/A"
			theme.drawuid = "drawafkwarning_"..theme.id

			local drawwarning = false

			table.InitWarning = function()
				hook.Add("HUDPaint","drawafkWarning",function()
					if drawwarning then
						draw.RoundedBox( 2, ScrW() / 2 - 170, 20, 340, 60, Color( 0, 0, 0, 200 ) )
						surface.SetDrawColor(155, 155, 155 ,155)
						surface.DrawOutlinedRect(ScrW() / 2 - 170, 20, 340, 60)
						draw.SimpleText( afkutil.config.warnmsgtitle, "TargetID", ScrW() / 2 - 100, 40, Color( 255, 255, 255, 255 ), 0, 1 )
						if #player.GetAll() >= afkutil.config.minplayers then
							draw.SimpleText( afkutil.config.warnmsgbody_kick, "TargetIDSmall", ScrW() / 2 - 160, 60, Color( 255, 255, 255, 255 ), 0, 1 )
						else
							draw.SimpleText( afkutil.config.warnmsgbody_slay, "TargetIDSmall", ScrW() / 2 - 160, 60, Color( 255, 255, 255, 255 ), 0, 1 )
						end 
					end
				end)
			end

			theme.ToggleWarningDraw = function()
				if drawwarning == true then
					drawwarning = false
				else
					drawwarning = true
				end
			end
			
			include("afkutils_themes/" .. name)
			afkutil.themes[theme.id] = theme
			
			theme = nil
		end
	end

	if SERVER then
		afkutil.handle.debugprint("Selected theme: "..afkutil.config.themeid)
		afkutil.handle.debugprint("Stored themes")
		for k, v in pairs(afkutil.themes) do
			print(k, v)
		end
	end
end

-- Shared
afkutil.handle.loadthemes()

-- Main thread
if afkutil.config.enabled then
	if SERVER then
		-- Server code
		afkutil.config.kicktime = afkutil.config.kicktime + afkutil.config.warntime + afkutil.config.timecorrection -- Time correction
		hook.Add("PlayerAuthed", "authhook1", function(ply, sid, uid)
			ply.uid = uid
			ply.lastmoved = CurTime()
			afkutil.table.afkplayers[ply.uid] = ply
			ply.hasbeenwarned = false
			ply.dontwarn = false
		end)
		hook.Add('PlayerSpawn','AFK_SpawnFix',function(ply)
			ply.lastmoved = CurTime() --They spawned. 
			ply.hasbeenwarned = false --They shouldnt be warned anymore, they respawned. 
			ply.dontwarn = false --Dont warn! 
		end)
		hook.Add("PlayerDisconnect", "disconnecthook1", function(ply)
			if(IsValid(ply.uid)) then
				afkutil.table.afkplayers[ply.uid] = nil
			end
		end)
		hook.Add("KeyPress", "updatePlayerLastMoved", function(ply, key)
			if(IsValid(afkutil.table.afkplayers[ply.uid]))then
				ply.lastmoved = CurTime()
				if(ply.hasbeenwarned == true)then
					ply.hasbeenwarned = false
					afkutil.handle.removewarning(ply)
					afkutil.handle.debugprint("Player "..ply:Nick().." is no longer afk!")
					SendChatText( ply, afkutil.config.msgcolor, "Player "..ply:Nick().." is no longer afk!" ) 
					ply:SetRenderMode(RENDERMODE_NORMAL)
					ply:SetColor(Color(255, 255, 255, 100))
				end
			end
			if afkutil.variable.forcewarn == true then
				ply.hasbeenwarned = false
				afkutil.variable.forcewarn = false
				afkutil.handle.removewarning(ply)
				afkutil.handle.debugprint("Player "..ply:Nick().." is no longer afk!")
				SendChatText( ply, afkutil.config.msgcolor, "Player "..ply:Nick().." is no longer afk!" ) 
			end
		end)
		-- Ghost player from damage
		hook.Add("PlayerShouldTakeDamage", "donttakedmg", function(ply, ent)
			if afkutil.config.action == "ghost" then
				if ply.hasbeenwarned then
					return false
				end
			end
		end)
		function SendChatText( player, color, text )
			umsg.Start( "chatmsg", player )
				umsg.Short( color.r )
				umsg.Short( color.g )
				umsg.Short( color.b )
				umsg.String( text )
			umsg.End()
		end
		hook.Add("Think", "checkForAfkPlayers", function()		
			if afkutil.time <= CurTime() then
			--print('DEBUG: afkutil.time: '..tostring(afkutil.time))
				--print('DEBUG: table.Count(afkutil.table.afkplayers)= '..tostring(table.Count(afkutil.table.afkplayers)))
				if table.Count(afkutil.table.afkplayers) > 0 then
					--print('DEBUG: afkutil.table.afkplayers: '..tostring(afkutil.table.afkplayers))
					for k, v in pairs(afkutil.table.afkplayers) do
						if v.lastmoved != nil then
							--print('DEBUG: v.lastmoved != nil'..tostring(v.lastmoved))
							if (v.lastmoved + (afkutil.config.kicktime)) - CurTime() < 0 then
								--print('(v.lastmoved + (afkutil.config.kicktime)) - CurTime() < 0')
								local id = v.uid
								if afkutil.config.warnadmins == false then
									--print('ADMINS CAN BE AFK-KICKED')
									-- Non-Admins
									--print('v.dontwarn is '..tostring(v.dontwarn))
									if v.dontwarn == false then
									--print('v.dontwarn == false ')
										if afkutil.config.action == "kick" then
										--print('settings is kick')
											if v:IsAdmin() == false or afkutil.isgroupfromtable(afkutil.config.admingroups, v) == false then
												--print('IsNotAdmin, AFK tho')
												if #player.GetAll() >= afkutil.config.minplayers then 
													--print('KICK!')
													afkutil.table.afkplayers[id]:Kick(afkutil.config.kicktext)
													afkutil.table.afkplayers[id] = nil
													afkutil.handle.debugprint("Player "..v:Nick().." was kicked for being afk!")
													SendChatText( v, afkutil.config.msgcolor, "Player "..v:Nick().." was kicked for being afk!" )
												else
													--print('SLAY!')
													afkutil.table.afkplayers[id]:Kill()
													afkutil.handle.debugprint("Player "..v:Nick().." was slain for being afk!")
													SendChatText( v, afkutil.config.msgcolor, "Player "..v:Nick().." was slain for being afk!" )
													-- Actually Reset them, they're dead now. 
													v.lastmoved = CurTime() --They spawned. 
													v.hasbeenwarned = false --They shouldnt be warned anymore, they respawned. 
													v.dontwarn = false --Dont warn! 
													--The player MIGHT still be AFK, but they actually shouldnt have the thing if they just got slain or w/e
													afkutil.handle.removewarning(v)
													v:SetRenderMode(RENDERMODE_NORMAL)
													v:SetColor(Color(255, 255, 255, 100))
												end 
											end
										end
									end
								else
									--print('ADMINS CANNOT BE AFK-KICKED')
									-- Admins
									if v.dontwarn == false then
									--print('v.dontwarn == false ')
										if afkutil.config.action == "kick" then
										--print('settings is kick')
											if #player.GetAll() >= afkutil.config.minplayers then 
												--print('KICK!')
												afkutil.table.afkplayers[id]:Kick(afkutil.config.kicktext)
												afkutil.table.afkplayers[id] = nil
												afkutil.handle.debugprint("Player "..v:Nick().." was kicked for being afk!")
												SendChatText( v, afkutil.config.msgcolor, "Player "..v:Nick().." was kicked for being afk!" )
											else
												--print('SLAY!')
												afkutil.table.afkplayers[id]:Kill()
												afkutil.handle.debugprint("Player "..v:Nick().." was slain for being afk!")
												SendChatText( v, afkutil.config.msgcolor, "Player "..v:Nick().." was slain for being afk!" )
																									-- Actually Reset them, they're dead now. 
													v.lastmoved = CurTime() --They spawned. 
													v.hasbeenwarned = false --They shouldnt be warned anymore, they respawned. 
													v.dontwarn = false --Dont warn! 
													--The player MIGHT still be AFK, but they actually shouldnt have the thing if they just got slain or w/e
													afkutil.handle.removewarning(v)
													v:SetRenderMode(RENDERMODE_NORMAL)
													v:SetColor(Color(255, 255, 255, 100))
											end 
										end
									end
								end
							elseif (v.lastmoved + (afkutil.config.warntime)) - CurTime() < 0 then
							--print('aaaaaaaaaaaaaaaa')
								if afkutil.config.warnspectators == false then
									--print('afkutil.config.warnspectators is false')
									if afkutil.config.gamemode == "ttt" then
										if v:IsSpec() then
											v.dontwarn = true
										end
									end
									-- Super basic support for unknown gamemodes with spectators
									if afkutil.config.gamemode == "other" then
										--print('afkutil.config.gamemode == "other"')
										--if afkutil.config.spectatorteam == true then
										if afkutil.config.spectatorteam then
											--print('spectatorteam is set')
											if team.GetName(v:Team()) == afkutil.config.spectatorteam then
												v.dontwarn = true
												--print('dont warn <v>')
											end
										end
									end
								end
								if afkutil.config.warnadmins == false then
									if v:IsAdmin() == false or afkutil.isgroupfromtable(afkutil.config.admingroups, v) == false then
										if v.dontwarn == false then
											if v.hasbeenwarned == false then
												if afkutil.config.action == "ghost" then
													v:SetRenderMode(RENDERMODE_TRANSALPHA)
													v:SetColor(Color(255, 255, 255, 100))
												end
												afkutil.handle.givewarning(v)
												afkutil.handle.debugprint("Player "..v:Nick().." is now afk!")
												SendChatText( v, afkutil.config.msgcolor, "Player "..v:Nick().." is now afk!" )
											end
										end
									end
								else
									if v.dontwarn == false then
										if v.hasbeenwarned == false then
											if afkutil.config.action == "ghost" then
												v:SetRenderMode(RENDERMODE_TRANSALPHA)
												v:SetColor(Color(255, 255, 255, 100))
											end
											afkutil.handle.givewarning(v)
											afkutil.handle.debugprint("Player "..v:Nick().." is now afk!")
											SendChatText( v, afkutil.config.msgcolor, "Player "..v:Nick().." is now afk!" )
										end
									end
								end
							end
						end
					end
				end
				-- Basic grouped actions
				if afkutil.config.gakenabled then
					if afkutil.time <= CurTime() then
						if table.Count(afkutil.table.afkplayers) > 0 then
							for k, v in pairs(afkutil.table.afkplayers) do
								if v.lastmoved != nil then
									if (v.lastmoved + (afkutil.config.gakkick)) - CurTime() < 0 then
										local id = v.uid
										if afkutil.config.warnadmins == false then
											-- Non-Admins
											if v.dontwarn == false then
												if v:IsAdmin() == false or afkutil.isgroupfromtable(afkutil.config.admingroups, v) == false then
													if #player.GetAll() >= afkutil.config.minplayers then 
														--print('KICK!')
														afkutil.table.afkplayers[id]:Kick(afkutil.config.kicktext)
														afkutil.table.afkplayers[id] = nil
														afkutil.handle.debugprint("Player "..v:Nick().." was kicked for being afk!")
														SendChatText( v, afkutil.config.msgcolor, "Player "..v:Nick().." was kicked for being afk!" )
													else
														--print('SLAY!')
														afkutil.table.afkplayers[id]:Kill()
														afkutil.handle.debugprint("Player "..v:Nick().." was slain for being afk!")
														SendChatText( v, afkutil.config.msgcolor, "Player "..v:Nick().." was slain for being afk!" )
																											-- Actually Reset them, they're dead now. 
													v.lastmoved = CurTime() --They spawned. 
													v.hasbeenwarned = false --They shouldnt be warned anymore, they respawned. 
													v.dontwarn = false --Dont warn! 
													--The player MIGHT still be AFK, but they actually shouldnt have the thing if they just got slain or w/e
													afkutil.handle.removewarning(v)
													v:SetRenderMode(RENDERMODE_NORMAL)
													v:SetColor(Color(255, 255, 255, 100))
													end 
												end
											end
										else
											-- Admins
											if v.dontwarn == false then
												if #player.GetAll() >= afkutil.config.minplayers then 
													--print('KICK!')
													afkutil.table.afkplayers[id]:Kick(afkutil.config.kicktext)
													afkutil.table.afkplayers[id] = nil
													afkutil.handle.debugprint("Player "..v:Nick().." was kicked for being afk!")
													SendChatText( v, afkutil.config.msgcolor, "Player "..v:Nick().." was kicked for being afk!" )
												else
													--print('SLAY!')
													afkutil.table.afkplayers[id]:Kill()
													afkutil.handle.debugprint("Player "..v:Nick().." was slain for being afk!")
													SendChatText( v, afkutil.config.msgcolor, "Player "..v:Nick().." was slain for being afk!" )
													-- Actually Reset them, they're dead now. 
													v.lastmoved = CurTime() --They spawned. 
													v.hasbeenwarned = false --They shouldnt be warned anymore, they respawned. 
													v.dontwarn = false --Dont warn! 
													--The player MIGHT still be AFK, but they actually shouldnt have the thing if they just got slain or w/e
													afkutil.handle.removewarning(v)
													v:SetRenderMode(RENDERMODE_NORMAL)
													v:SetColor(Color(255, 255, 255, 100))
												end 
											end
										end
									elseif (v.lastmoved + (afkutil.config.gakwarn)) - CurTime() < 0 then
										if afkutil.config.warnadmins == false then
											if v:IsAdmin() == false or afkutil.isgroupfromtable(afkutil.config.admingroups, v) == false then
												if v.dontwarn == false then
													if v.hasbeenwarned == false then
														v:SetRenderMode(RENDERMODE_TRANSALPHA)
														v:SetColor(Color(255, 255, 255, 100))
														afkutil.handle.givewarning(v)
														afkutil.handle.debugprint("Player "..v:Nick().." is now afk!")
														SendChatText( v, afkutil.config.msgcolor, "Player "..v:Nick().." is now afk!" )
													end
												end
											end
										else
											if v.dontwarn == false then
												if v.hasbeenwarned == false then
													v:SetRenderMode(RENDERMODE_TRANSALPHA)
													v:SetColor(Color(255, 255, 255, 100))
													afkutil.handle.givewarning(v)
													afkutil.handle.debugprint("Player "..v:Nick().." is now afk!")
													SendChatText( v, afkutil.config.msgcolor, "Player "..v:Nick().." is now afk!" )
												end
											end
										end
									end
								end
							end
						end
					end
				end
				afkutil.time = CurTime() + 1
			end
		end)		
	else
		-- Client code
		function RecieveChatText( um )
			local r = um:ReadShort()
			local g = um:ReadShort()
			local b = um:ReadShort()
			local color = Color( r, g, b )
			local text = um:ReadString()
			
			chat.AddText( color, text )
		end
		usermessage.Hook( "chatmsg", RecieveChatText )
		local compiledid = afkutil.config.themeid
		if afkutil.tableempty(afkutil.themes) then
			afkutil.handle.debugprint("No warning theme found in directory!")
			chat.AddText( Color( 255, 12, 12 ), afkutil.config.prefix, " ERROR: ", Color( 100, 255, 100 ), "No afk warning theme found in directory!" )
		else
			if afkutil.tablehasvalue(afkutil.themes, afkutil.config.themeid) then
				local chosentheme = afkutil.themes[compiledid]
				chosentheme.InitWarning()
				net.Receive("GivePlayerAFKWarning", function()
					if afkutil.config.playsnd then
						surface.PlaySound (afkutil.config.snd)
					end
					chosentheme.ToggleWarningDraw()
				end)
				net.Receive("RemovePlayerAFKWarning", function()
					chosentheme.ToggleWarningDraw()
				end)
			else
				afkutil.handle.debugprint("No theme with the given id! Please check config!")
				chat.AddText( Color( 255, 12, 12 ), afkutil.config.prefix, " ERROR: ", Color( 100, 255, 100 ), "No afk warning theme with the given id! Please check config!" )
				afkutil.handle.debugprint("Compiled Datatype: "..type(afkutil.config.themeid))
			end
		end
	end
end