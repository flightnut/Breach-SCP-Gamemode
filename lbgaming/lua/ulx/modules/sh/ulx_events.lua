
Rewards_SCI = (30*1000) --30 K Regular points
Rewards_SCP = (15*1000) --15 K Regular points
HNS_MaxSCP = 5 --5 Seekers

------------------------------------
---	Stuff For Events by Link2006 ---
------------------------------------

function ulx.sayhealth( calling_ply, target_ply )

	ulx.fancyLogAdmin( calling_ply, "Health of #T: "..tostring(target_ply:Health()), target_ply )

end
local sayhealth = ulx.command( "Link2006", "ulx sayhealth", ulx.sayhealth, "!sayhealth" )
sayhealth:addParam{ type=ULib.cmds.PlayerArg, target="*" }  --Can target anyone.
sayhealth:defaultAccess( ULib.ACCESS_ADMIN )
sayhealth:help( "Tells the health of the player to everyone" )

br_namedTeam = {}
--because apparently TEAM_SCP and such are not set, rip :(
br_namedTeam['TEAM_SCP'] = TEAM_SCP or 1
br_namedTeam['TEAM_GUARD'] = TEAM_GUARD or 2
br_namedTeam['TEAM_CLASSD'] = TEAM_CLASSD or 3
br_namedTeam['TEAM_SCI'] = TEAM_SCI or 4
br_namedTeam['TEAM_SPEC'] = TEAM_SPEC or 5
br_namedTeam['TEAM_CHAOS'] = TEAM_CHAOS or 6

br_TeamList = {'TEAM_SCP','TEAM_GUARD','TEAM_CLASSD','TEAM_SCI','TEAM_SPEC','TEAM_CHAOS'}

function ulx.freezeteam (calling_ply, target_team)
	--Breach support only.
	if br_namedTeam[target_team] then
		for k,v in pairs(team.GetPlayers(br_namedTeam[target_team])) do
			--v:Freeze(true) --
			v:Lock()
			v.frozen = true
		end
		ulx.fancyLogAdmin( calling_ply, "#A froze the team "..tostring(target_team))
	else
		ULib.tsayError(calling_ply,'Valid teams: TEAM_SCP,TEAM_GUARD,TEAM_CLASSD,TEAM_CHAOS,TEAM_SPEC,TEAM_SCI')
	end
	--Default rank Admins
end

local freezeteam = ulx.command( "Link2006", "ulx freezeteam", ulx.freezeteam, "!freezeteam" )
freezeteam:addParam{ type=ULib.cmds.StringArg, hint="Select a team", completes=br_TeamList }
freezeteam:defaultAccess( ULib.ACCESS_ADMIN )
freezeteam:help( "Freezes a team" )

function ulx.unfreezeteam (calling_ply, target_team)
	--Breach support only.
	if br_namedTeam[target_team] then
		for k,v in pairs(team.GetPlayers(br_namedTeam[target_team])) do
			--v:Freeze(false)
			v:UnLock()
			v.frozen = true
		end
		ulx.fancyLogAdmin( calling_ply, "#A unfroze the team "..tostring(target_team))
	else
		ULib.tsayError(calling_ply,'Valid teams: TEAM_SCP,TEAM_GUARD,TEAM_CLASSD,TEAM_CHAOS,TEAM_SPEC,TEAM_SCI')
	end
	--Default rank Admins
end
local unfreezeteam = ulx.command( "Link2006", "ulx unfreezeteam", ulx.unfreezeteam, "!unfreezeteam" )
unfreezeteam:addParam{ type=ULib.cmds.StringArg, hint="Select a team", completes=br_TeamList }
unfreezeteam:defaultAccess( ULib.ACCESS_ADMIN )
unfreezeteam:help( "Unfreezes a team" )



function ulx.pgagteam (calling_ply, target_team)
	--!pgagteam spectators/!pgagteam spec
	if br_namedTeam[target_team] then
		ulx.pgag( calling_ply, team.GetPlayers(br_namedTeam[target_team]), false )
	else
		ULib.tsayError(calling_ply,'Valid teams: TEAM_SCP,TEAM_GUARD,TEAM_CLASSD,TEAM_CHAOS,TEAM_SPEC,TEAM_SCI')
	end
	--Default rank Admins
end

local pgagteam = ulx.command( "Link2006", "ulx pgagteam", ulx.pgagteam, "!pgagteam" )
pgagteam:addParam{ type=ULib.cmds.StringArg, hint="Select a team", completes=br_TeamList }
pgagteam:defaultAccess( ULib.ACCESS_ADMIN )
pgagteam:help( "pgags a team" )

function ulx.unpgagteam (calling_ply, target_team)
	--!pgagteam spectators/!pgagteam spec
	if br_namedTeam[target_team] then
		ulx.pgag( calling_ply, team.GetPlayers(br_namedTeam[target_team]), true )
	else
		ULib.tsayError(calling_ply,'Valid teams: TEAM_SCP,TEAM_GUARD,TEAM_CLASSD,TEAM_CHAOS,TEAM_SPEC,TEAM_SCI')
	end
	--Default rank Admins
end

local unpgagteam = ulx.command( "Link2006", "ulx unpgagteam", ulx.unpgagteam, "!unpgagteam" )
unpgagteam:addParam{ type=ULib.cmds.StringArg, hint="Select a team", completes=br_TeamList }
unpgagteam:defaultAccess( ULib.ACCESS_ADMIN )
unpgagteam:help( "unpgags a team" )

function ulx.slayteam ( calling_ply, target_team)
	if br_namedTeam[target_team] then
		for k,v in pairs(team.GetPlayers(br_namedTeam[target_team])) do
			v:Kill()
		end
		ulx.fancyLogAdmin( calling_ply, "#A slayed the team "..tostring(target_team))
	else
		ULib.tsayError(calling_ply,'Valid teams: TEAM_SCP,TEAM_GUARD,TEAM_CLASSD,TEAM_CHAOS,TEAM_SPEC,TEAM_SCI')
	end
	--Default rank Admins
end
local unpgagteam = ulx.command( "Link2006", "ulx slayteam", ulx.slayteam, "!slayteam" )
unpgagteam:addParam{ type=ULib.cmds.StringArg, hint="Select a team", completes=br_TeamList }
unpgagteam:defaultAccess( ULib.ACCESS_ADMIN )
unpgagteam:help( "TEMP" )

function ulx.nuke (calling_ply)
	--[LB] Breach support only
	umsg.Start( "ulib_sound" )
		umsg.String( Sound( 'nukes/siren.ogg' ) ) --
	umsg.End()

	timer.Simple(14,function()
		umsg.Start( "ulib_sound" )
			umsg.String( Sound( 'nukes/nuke1.ogg' ) ) --BOOM SOUND
		umsg.End()
	end)
	timer.Simple(14.5,function()
		net.Start('SCP1123flash_lvl1') --White flash
		net.Broadcast() -- Send to everyone :)
	end)
	timer.Simple(15,function()
		umsg.Start( "ulib_sound" )
			umsg.String( Sound( 'nukes/nuke2.ogg' ) ) --BOOM SOUND
		umsg.End()
		for k,v in pairs(player.GetAll()) do
			if v:Team() ~= TEAM_SPEC then
				v:Kill() --Dead!
			end
		end
	end)
	-- Default Rank: Superadmins
	ulx.fancyLogAdmin( calling_ply, "#A started a nuke!" )
end
local nuke = ulx.command( "Link2006", "ulx nuke", ulx.nuke, "!nuke" )
nuke:defaultAccess( ULib.ACCESS_SUPERADMIN )
nuke:help( "Nukes!" )

function ulx.fakenuke (calling_ply)

	umsg.Start( "ulib_sound" )
		umsg.String( Sound( 'nukes/siren.ogg' ) ) --
	umsg.End()

	timer.Simple(15,function()
		umsg.Start( "ulib_sound" )
			umsg.String( Sound( 'nukes/alpha_warheads_fail.ogg' ) ) --BOOM SOUND
		umsg.End()
	end)
	--Default Rank:  Superadmins
	ulx.fancyLogAdmin( calling_ply, "#A started a nuke!" )
end
local fakenuke = ulx.command( "Link2006", "ulx fakenuke", ulx.fakenuke, "!fakenuke" )
fakenuke:defaultAccess( ULib.ACCESS_SUPERADMIN )
fakenuke:help( "(fake) NUKES!" )

function ulx.eventstart (calling_ply)
	--default rank: Super admin !
	timer.Destroy("PreparingTime")
	timer.Destroy("RoundTime")
	preparing = false
	postround = false
	ulx.fancyLogAdmin( calling_ply, "#A stopped the round" )
end
local eventstart = ulx.command( "Link2006", "ulx eventstart", ulx.eventstart, "!eventstart" )
eventstart:defaultAccess( ULib.ACCESS_SUPERADMIN )
eventstart:help( "Destroys the timers to let a customround take place (Requires br_roundrestart_cl access)" )

function ulx.hidenseek(calling_ply)
	if SERVER then
		local AllPlayers = {}
		for k,v in pairs(player.GetAll()) do
			if v.ActivePlayer then
				table.insert(AllPlayers,v)
			end
		end
		if #AllPlayers < 16 then
			ULib.tsayError(calling_ply,"ERROR: There is not enough active players to start Hide & Seek (16+ required)")
			AllPlayers = nil
			return
		end
		for i=1,HNS_MaxSCP do
			timer.Remove("HideNSeek_SetWep_"..i)
		end
		for k,v in pairs(player.GetAll()) do
			v:Freeze(false)
			v:GodDisable()
		end

		for i=1,HNS_MaxSCP do
			MsgC(Color(137,207,240),"Setting seeker: "..tostring(i)..'\n')
			local seekSCP = table.Random(AllPlayers)
			seekSCP:SetSCP035()
			seekSCP:GodEnable()
			seekSCP:SetNoCollideWithTeammates(true)
			seekSCP:Freeze(true)
			timer.Simple(0.25,function()
				ULib.tsayColor(seekSCP,true,team.GetColor(TEAM_SCP),"[Hide & Seek] You're a seeker, you'll be unfrozen in 45 seconds...")
			end)
			--timer.Simple(10,function() --10 seconds after they're spawned.
			timer.Create("HideNSeek_SetWep_"..i,10,1,function()
				seekSCP:StripWeapons()
				seekSCP:Give('weapon_mtf_p90')
				seekSCP:GiveAmmo(100000,'SMG1') --fuck this,100k :P
				seekSCP:Give('keycard_level5')
			end)
			MsgC(Color(137,207,240),"New Seeker: "..tostring(seekSCP:Nick())..'\n')
			table.RemoveByValue(AllPlayers,seekSCP)
		end

		--Teleport them somewhere outside the play area
		--	OR just freeze them in spawn?
		timer.Remove('HideNSeek_Unfreeze')
	    timer.Remove('BreachRespawn_Spectators') --The Spectator Respawn Timer
	    timer.Remove('BreachRespawn_Spectators_Init') --The timer that checks if we can start the Spectator Respawn timer.
		timer.Remove('HideNSeek_RestartRound')

		timer.Create("HideNSeek_Unfreeze",45,1,function()
			for k,v in pairs(team.GetPlayers(TEAM_SCP)) do
				v:Freeze(false)
			end
			ULib.tsayColor(nil,true,Color(0,255,0),"[Hide & Seek] Seekers are now free!")
		end)

		for k,v in pairs(AllPlayers) do
			v:SetScientist()
			v:SetPos(table.Random(SPAWN_CLASSD))
			timer.Simple(0.25,function()
				ULib.tsayColor(v,true,team.GetColor(TEAM_SCI),"[Hide & Seek] Seekers will be unfrozen in 45 seconds, hide!")
				ULib.tsayColor(v,true,Color(255,0,0),"[Hide & Seek] Please note, you cannot hide in the pocket dimension!")
			end)
		end

		function HideNSeek_Event(ply)
			if team.NumPlayers(TEAM_SCI) <= 10 then

				for i=1,HNS_MaxSCP do
					timer.Remove("HideNSeek_SetWep_"..i)
				end
				hook.Remove('PlayerDeath','HideNSeek_Counter1')
				hook.Remove('PlayerDisconnected','HideNSeek_Counter2')
				hook.Remove('PlayerSpawn','HideNSeek_Counter3')
				timer.Remove('HideNSeek_Unfreeze')
				timer.Remove('HideNSeek_RestartRound')

				ULib.tsayColor(nil,true,Color(255,0,0),"The event is over!",Color(0,255,0)," Winners received "..Rewards_SCI.." points and Seekers got "..Rewards_SCP.."!")
				ULib.tsayColor(nil,true,Color(0,255,0),"Congratulations!")

				MsgC(Color(137,207,240),"========================================\n")
				MsgC(Color(137,207,240),"==  WINNERS OF THE HIDE & SEEK EVENT  ==\n")
				for k,v in pairs(team.GetPlayers(TEAM_SCI)) do
					MsgC(Color(137,207,240),v:Nick()..'\n')
					v:PS2_AddStandardPoints(Rewards_SCI,"Winning Hide & Seek event",true)
				end
				for k,v in pairs(team.GetPlayers(TEAM_SCP)) do
					v:PS2_AddStandardPoints(Rewards_SCP,"Being an SCP in Hide & Seek event",true)
				end

				MsgC(Color(137,207,240),'== Sending the list to online admins! ==\n')
				for _,pAdmin in pairs(player.GetAll()) do
					if pAdmin:IsAdmin() then
						pAdmin:ChatPrint("(To Admins) Here's the list of players who won the event:")
						for k,v in pairs(team.GetPlayers(TEAM_SCI)) do
							pAdmin:ChatPrint(v:Nick())
						end
					end
				end
				MsgC(Color(137,207,240),"========================================\n")
				HideNSeek_Event = nil --Delete our function, we dont need it anymore. :)
				RunConsoleCommand("ulx","nuke")
			end
		end
		hook.Add('PlayerDeath','HideNSeek_Counter1',HideNSeek_Event)
		hook.Add('PlayerDisconnected','HideNSeek_Counter2',HideNSeek_Event)
		hook.Add('PlayerSpawn','HideNSeek_Counter3',HideNSeek_Event)
		hook.Add('PreCleanupMap','ResetHideNSeek',function()
			print("<!> MAP HAS BEEN RESET, ABORTING HIDE & SEEK EVENT <!> ")
			for k,v in pairs(player.GetAll()) do
				v:GodDisable()
				--Other stuff that breaks when map resets goes here
			end
			hook.Remove('PlayerDeath','HideNSeek_Counter1')
			hook.Remove('PlayerDisconnected','HideNSeek_Counter2')
			hook.Remove('PlayerSpawn','HideNSeek_Counter3')
			timer.Remove('HideNSeek_Unfreeze')
		    timer.Remove('BreachRespawn_Spectators') --The Spectator Respawn Timer
		    timer.Remove('BreachRespawn_Spectators_Init') --The timer that checks if we can start the Spectator Respawn timer.
			timer.Remove('HideNSeek_RestartRound')
			for i=1,HNS_MaxSCP do
				timer.Remove("HideNSeek_SetWep_"..i)
			end
		end )
		--HideNSeek_Event(nil) --No player entity are needed but w/e, this call only makes sure you can even start that event ;)
	else
		print("ULX Command for HideNSeek event sent...") --?
	end

	ulx.fancyLogAdmin( calling_ply, "#A started an event: Hide & Seek" )
end
local hidenseek = ulx.command("Link2006","ulx hidenseek",ulx.hidenseek,"!hidenseek")
hidenseek:defaultAccess(ULib.ACCESS_SUPERADMIN)
hidenseek:help("Spawns everyone into an Hide & Seek event (except spectators)")

--[[
-- This is all the other commands i have to do


--TODO: fgodbring <player-based> which does:
--		Bring someone, God them and Freezes them.

]]--
