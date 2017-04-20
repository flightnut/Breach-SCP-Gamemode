

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


--[[
-- This is all the other commands i have to do


--TODO: fgodbring <player-based> which does:
--		Bring someone, God them and Freezes them.

]]--
