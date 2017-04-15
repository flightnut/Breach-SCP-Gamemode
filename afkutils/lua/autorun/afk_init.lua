--[[=============================================================================]]--
--[[==== Away from Keyboard Utilities - Version 1.1.3                        ====]]--
--[[==== Made by Red @ https://scriptfodder.com/users/view/76561198151769476 ====]]--
--[[=============================================================================]]--

-- Table root
afkutil = {}

-- Version
afkutil.version = "1.2.2"

-- Run this stuff on the server
if SERVER then
	
	-- Notify on load
	print("Away from Keyboard Utilities loaded [SERVERSIDE]")

	-- Cached network strings
	util.AddNetworkString("GivePlayerAFKWarning")
	util.AddNetworkString("RemovePlayerAFKWarning")

	-- Broken command
	-- concommand.Add("afkutil_forcewarn", function()
	-- 	for k, v in pairs(player.GetAll()) do
	-- 		net.Start("GivePlayerAFKWarning")
	-- 		net.Send(v)
	-- 	end
	-- 	afkutil.variable.forcewarn = true
	-- 	SendChatText( ply, afkutil.config.msgcolor, "Everyone has been made afk!" ) 
	-- 	afkutil.handle.debugprint("Succesfully forced warning on every player")
	-- end)

	-- Send lua to client
	AddCSLuaFile( "afkutils_config.lua" )
	AddCSLuaFile( "sh_handler.lua" )

	-- Run lua code on server
	include( "afkutils_config.lua" )
	include( "sh_handler.lua" )

else
	-- Run this stuff on the client

	-- Notify on load
	print("Away from Keyboard Utilities loaded [CLIENTSIDE]")

	-- Clientside console commands
	concommand.Add("afkutil_getversion", function()
		afkutil.handle.debugprint("Version: "..afkutil.version)
	end)

	-- Run lua code on client
	include( "afkutils_config.lua" )
	include( "sh_handler.lua" )

end