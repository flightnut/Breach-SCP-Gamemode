--[[=======================================================================================]]--
--[[==== Away from Keyboard Utilities - Version 1.1.3                                  ====]]--
--[[==== Made by Red @ https://scriptfodder.com/users/view/76561198151769476           ====]]--
--[[=======================================================================================]]--
--[[==== Plugin Description:                                                           ====]]--
--[[==== A bunch helpful utilities for player afk management. The basic detector works ====]]--
--[[==== based on if a player stops moving for a certain preiod of time (configurable) ====]]--
--[[=======================================================================================]]--

-- Table roots
afkutil.config = {}

--[[==== Note about specator stuff ====]]--
-- I have added some support to check if a player is in specator mode, and to prevent them from being warned.
-- It does not work super well because all gamemodes use different systems for making the player a specator, and checking if they are a specator.
-- I make no promises that this basic support will work that well, but I will keep trying to make it better.
-- Thanks everyone!
-- Red


--[[==== Easy Config ====]]--

-- Note that all delays and timing configurations are using seconds

-- Enable or disable afkutil
-- Enables or disables afkutil completely
afkutil.config.enabled = true

--Link2006 Edit: 
--minimum players before enabling Anti-AFK kick 
--set to 0 to always trigger :)
afkutil.config.minplayers = 64
 
-- Gamemode
-- The gamemode that you are using for your server
-- "ttt" for Trouble in Terrorist Town
-- "darkrp" for DarkRP
-- "other" for any other gamemode (certain features not supported)
afkutil.config.gamemode = "other"

-- Spectator team (Not tested)
-- The team that the player are when they are spectators
-- Only enable if you are using a gamemode not listed above!
-- Set to false to disable
afkutil.config.spectatorteam = "Spectators"

-- Warn spectators
-- Enabled/disables the warning of players in spectator moderator
-- This only works for certain gamemodes
afkutil.config.warnspectators = false

-- AFK warning theme
-- The gui theme you see when you are afk
-- Use the theme id found in the theme's file
-- All themes are located in the "themes" folder
afkutil.config.themeid = "minimal2"

-- Debug printing
-- Print out error messages and debug info in console
-- No sensistive information is sent to players
-- I recommend keeping this on
afkutil.config.debug = true

-- Text prefix
-- The prefix shown with any afkutil related error/message
afkutil.config.prefix = "[AFKUTIL]"

-- Afk actions
-- The action taken when afk
-- "kick" = Kick player on afk after warning shown
--		Link2006's note: I made this NOT kick if the 
-- "ghost" = Ghost player on afk after warning shown to protect the player from all damage
afkutil.config.action = "kick"

-- AFK warn time
-- The seconds until the afk warning comes up
afkutil.config.warntime = 120

-- Kick time
-- The seconds until the player is kicked after the warning message is shown
-- Only works if kick is enabled
afkutil.config.kicktime = 240

-- Time correction
-- Sometimes the timing isn't always perfect
-- You can add a couple of seconds to help correct timing
afkutil.config.timecorrection = 5

-- Play AFK sound
-- Makes a bell sound when a player goes AFK
afkutil.config.playsnd = true

-- AFK sound
-- The sound played if the above is enabled
afkutil.config.snd = "HL1/fvox/bell.wav"

-- AFK chat message color
-- The color of the message that apears in chat when a player is made afk
-- The color is rbg format
afkutil.config.msgcolor = Color( 255, 12, 12 )

-- Warning title
-- The title of the afk warning
afkutil.config.warnmsgtitle = "WARNING!"

-- Warning body/text
-- The body text of the afk warning
afkutil.config.warnmsgbody = "You are going to be kicked/slain for being AFK!\nPress any key to abort kick/slay!"
afkutil.config.warnmsgbody_slay = "You are going to be slain for being AFK!\nPress any key to abort slay!"
afkutil.config.warnmsgbody_kick = "You are going to be kicked for being AFK!\nPress any key to abort kick!"

-- Kick text
-- The text displayed when a player is kicked for being afk
-- Only works if kick is enabled
afkutil.config.kicktext = "You were auto kicked for being away from keyboard"

-- Warn admins
-- Enables or disables the warning of admins when they go afk
afkutil.config.warnadmins = false

-- Admin groups
-- If warnadmins is not working correctly, add all the admin groups here
-- Only tested on ULX Admin Menu
afkutil.config.admingroups = {"Assistant", "AssistantV", "moderatorV", "adminV", "moderator", "admin", "superadmin", "headadmin", "Owner"}


--[[==== Advanced Config ====]]--
-- The following is advanced, only edit if you are good with debugging.

-- Ghost and kick
-- Ghosts player then kicks them after a certain time period
afkutil.config.gakenabled = false

-- Ghost and kick warn delay
-- Player will be ghosted after not moving for this delay
afkutil.config.gakwarn = 30

-- Ghost and kick kick delay
-- Player will be kicked after being a ghost for this delay
afkutil.config.gakkick = 60

-- Font generator
-- Automatically generates fonts
-- You don't need to edit this
if SERVER then return end
for i=4, 150 do
	surface.CreateFont( "afkutil.font."..i, {
		font = "Roboto",
		size = i,
		weight = 0,
		antialias = true,
	} )
	surface.CreateFont( "afkutil.font."..i..".bold", {
		font = "Roboto Bold",
		size = i,
		weight = 1000,
		antialias = true,
	} )
end