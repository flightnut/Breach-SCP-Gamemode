// Shared file

GM.Name 	= "Breach"
GM.Author 	= ""
GM.Email 	= ""
GM.Website 	= ""

function GM:Initialize()
	self.BaseClass.Initialize( self )
end

TEAM_SCP = 1
TEAM_GUARD = 2
TEAM_CLASSD = 3
--Link2006's Attempt to fix TeamNoCollide :)--
-------------------
--	TEAM_SPEC = 4 -
TEAM_SPEC = 5
--	TEAM_SPEC = 5 -
TEAM_SCI = 4
----------------- -
TEAM_CHAOS = 6

MINPLAYERS = 2

// Team setup
team.SetUp( TEAM_SCP, "SCPs", Color(237, 28, 63) )
team.SetUp( TEAM_GUARD, "MTF Guards", Color(0, 100, 255) )
team.SetUp( TEAM_CLASSD, "Class Ds", Color(255, 130, 0) )
team.SetUp( TEAM_SPEC, "Spectators", Color(141, 186, 160) )
team.SetUp( TEAM_SCI, "Scientists", Color(66, 188, 244) )
team.SetUp( TEAM_CHAOS, "Chaos Insurgency", Color(0, 100, 255) )

function GetLangRole(rl)
	if clang == nil then return rl end
	if rl == ROLE_SCP035 then return clang.ROLE_SCP035 end
	if rl == ROLE_SCP1048A then return clang.ROLE_SCP1048A end
	if rl == ROLE_SCP173 then return clang.ROLE_SCP173 end
	if rl == ROLE_SCP106 then return clang.ROLE_SCP106 end
	if rl == ROLE_SCP049 then return clang.ROLE_SCP049 end
	if rl == ROLE_SCP457 then return clang.ROLE_SCP457 end
	if rl == ROLE_SCP0492 then return clang.ROLE_SCP0492 end
	if rl == ROLE_SCP682 then return clang.ROLE_SCP682 end
	if rl == ROLE_SCP966 then return clang.ROLE_SCP966 end
	if rl == ROLE_SCP0762 then return clang.ROLE_SCP0762 end
	if rl == ROLE_MTFGUARD then return clang.ROLE_MTFGUARD end
	if rl == ROLE_MTFCOM then return clang.ROLE_MTFCOM end
	if rl == ROLE_MTFNTF then return clang.ROLE_MTFNTF end
	if rl == ROLE_CHAOS then return clang.ROLE_CHAOS end
	if rl == ROLE_CLASSD then return clang.ROLE_CLASSD end
	if rl == ROLE_RES then return clang.ROLE_RES end
	if rl == ROLE_SPEC then return clang.ROLE_SPEC end
	return rl
end
--Link2006 fix Start (originally was just SCP173 three times)
ROLE_SCP035 = "SCP-035"
ROLE_SCP1048A = "SCP-1048A"
ROLE_SCP682 = "SCP-682"
ROLE_SCP966 = "SCP-966"
ROLE_SCP0762 = "SCP-0762"
--link2006 fix end
ROLE_SCP173 = "SCP-173"
ROLE_SCP106 = "SCP-106"
ROLE_SCP049 = "SCP-049"
ROLE_SCP457 = "SCP-457"
ROLE_SCP0492 = "SCP-049-2"
ROLE_SCP0082 = "SCP-008-2"
ROLE_MTFGUARD = "MTF Guard"
ROLE_MTFCOM = "MTF Commander"
ROLE_MTFNTF = "MTF Nine Tailed Fox"
ROLE_CHAOS = "Chaos Insurgency"
ROLE_CHAOSCOM = "CI Commander"
ROLE_SITEDIRECTOR = "Site Director"
ROLE_CLASSD = "Class D Personell"
ROLE_RES = "Researcher"
ROLE_SPEC = "Spectator"

if !ConVarExists("br_roundrestart") then CreateConVar( "br_roundrestart", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Restart the round" ) end
if !ConVarExists("br_time_preparing") then CreateConVar( "br_time_preparing", "60", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Set preparing time" ) end
if !ConVarExists("br_time_round") then CreateConVar( "br_time_round", "780", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Set round time" ) end
if !ConVarExists("br_time_postround") then CreateConVar( "br_time_postround", "30", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Set postround time" ) end
//if !ConVarExists("br_time_gateopen") then CreateConVar( "br_time_gateopen", "180", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Set gate open time" ) end
if !ConVarExists("br_time_ntfenter") then CreateConVar( "br_time_ntfenter", "360", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Time that NTF units will enter the facility" ) end
if !ConVarExists("br_time_blink") then CreateConVar( "br_time_blink", "0.25", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Blink timer" ) end
if !ConVarExists("br_time_blinkdelay") then CreateConVar( "br_time_blinkdelay", "5", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Delay between blinks" ) end
//if !ConVarExists("br_opengatea_enabled") then CreateConVar( "br_opengatea_enabled", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Do you want to force opening gate A after x seconds?" ) end
if !ConVarExists("br_spawn_level4") then CreateConVar( "br_spawn_level4", "2", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "How many keycards level 4 you want to spawn?" ) end
if !ConVarExists("br_specialround_percentage") then CreateConVar( "br_specialround_percentage", "15", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Set percentage of special rounds" ) end
if !ConVarExists("br_specialround_forcenext") then CreateConVar( "br_specialround_forcenext", "none", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Force the next round to be a special round" ) end
if !ConVarExists("br_spawnzombies") then CreateConVar( "br_spawnzombies", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Do you want zombies?" ) end
if !ConVarExists("br_karma") then CreateConVar( "br_karma", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Do you want to enable karma system?" ) end
if !ConVarExists("br_karma_max") then CreateConVar( "br_karma_max", "1200", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Max karma" ) end
if !ConVarExists("br_karma_starting") then CreateConVar( "br_karma_starting", "1000", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Starting karma" ) end
if !ConVarExists("br_karma_save") then CreateConVar( "br_karma_save", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Do you want to save the karma?" ) end
if !ConVarExists("br_karma_round") then CreateConVar( "br_karma_round", "120", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "How much karma to add after a round" ) end
if !ConVarExists("br_karma_reduce") then CreateConVar( "br_karma_reduce", "30", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "How much karma to reduce after damaging someone" ) end
if !ConVarExists("br_scoreboardranks") then CreateConVar( "br_scoreboardranks", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "" ) end
if !ConVarExists("br_defaultlanguage") then CreateConVar( "br_defaultlanguage", "english", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "" ) end

function KarmaReduce()
	return GetConVar("br_karma_reduce"):GetInt()
end

function KarmaRound()
	return GetConVar("br_karma_round"):GetInt()
end

function SaveKarma()
	return GetConVar("br_karma_save"):GetInt()
end

function MaxKarma()
	return GetConVar("br_karma_max"):GetInt()
end

function StartingKarma()
	return GetConVar("br_karma_starting"):GetInt()
end

function KarmaEnabled()
	return GetConVar("br_karma"):GetBool()
end

function GetPrepTime()
	return GetConVar("br_time_preparing"):GetInt()
end

function GetRoundTime()
	return GetConVar("br_time_round"):GetInt()
end

function GetPostTime()
	return GetConVar("br_time_postround"):GetInt()
end

function GetGateOpenTime()
	return GetConVar("br_time_gateopen"):GetInt()
end

function GetNTFEnterTime()
	return GetConVar("br_time_ntfenter"):GetInt()
end

function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf )
	if not ply.GetNClass then
		player_manager.RunClass( ply, "SetupDataTables" )
	end
	if not ply.GetNClass then return end
	if ply:GetNClass() == ROLE_SCP173 then
		if ply.steps == nil then ply.steps = 0 end
		ply.steps = ply.steps + 1
		if ply.steps > 6 then
			ply.steps = 1
			if SERVER then
				ply:EmitSound( "173sound"..math.random(1,3)..".ogg", 300, 100, 1 )
			end
		end
		return true
	end
	return false
end


function GM:EntityTakeDamage( target, dmginfo )

	local at = dmginfo:GetAttacker()
	if at:IsNPC() then
		if at:GetClass() == "npc_fastzombie" then
			dmginfo:ScaleDamage( 4 )
		end
	elseif target:IsPlayer() then
		if target:Alive() then
			local dmgtype = dmginfo:GetDamageType()
			if dmgtype == 268435464 or dmgtype == 8 then
				if target:Team() == TEAM_SCP then
					dmginfo:SetDamage( 0 )
					return true
				elseif target.UsingArmor == "armor_fireproof" then
					dmginfo:ScaleDamage(0.75)
				end
			end
		end
	end
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	/*
	if SERVER then
		local at = dmginfo:Getat()
		if ply:Team() == at:Team() then
			at:TakeDamage( 25, at, at )
		end
	end
	*/
	print("a")
	local at = dmginfo:GetAttacker()
	local mul = 1
	local armormul = 1
	if SERVER then
		local rdm = false
		if at != ply then
			if at:IsPlayer() then
				if dmginfo:IsDamageType( DMG_BULLET ) then
					if ply.UsingArmor != nil then
						if ply.UsingArmor != "armor_fireproof" then
							armormul = 0.85
						end
					end
				end
				if postround == false then
					if at:Team() == TEAM_GUARD then
						if ply:Team() == TEAM_GUARD then
							rdm = true
						elseif ply:Team() == TEAM_SCI then
							rdm = true
						end
					elseif at:Team() == TEAM_CHAOS then
						if ply:Team() == TEAM_CHAOS then
							rdm = true
						end
					elseif at:Team() == TEAM_SCP then
						if ply:Team() == TEAM_SCP then
							rdm = true
						end
					elseif at:Team() == TEAM_CLASSD then
						if ply:Team() == TEAM_CLASSD then
							rdm = true
						end
					elseif at:Team() == TEAM_SCI then
						if ply:Team() == TEAM_GUARD or ply:Team() == TEAM_SCI then
							rdm = true
						end
					end
				end
				if postround == false then
					print(rdm)
					if rdm then
						at:ReduceKarma(KarmaReduce())
					else
						--mply:AddExp( math.Round(dmginfo:GetDamage() / 3) )
						at:AddKarma( math.Round(dmginfo:GetDamage() / 3) )
						--print("AddKarma: "..math.Round(dmginfo:GetDamage() / 3)) --I believe this is AddKarma and not AddExp? Idunno ill do some tests.
					end
				end
			end
		end
	end

	if (hitgroup == HITGROUP_HEAD) then
		mul = 1.5
	end
	if (hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM) then
		mul = 0.9
	end
	if (hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG) then
		mul = 0.9
	end
	if (hitgroup == HITGROUP_GEAR) then
		mul = 0
	end
	if (hutgroup == HITGROUP_STOMACH) then
		mul = 1
	end
	if SERVER then
		if at:IsPlayer() then
			if at.GetNKarma then
				mul = mul * (at:GetNKarma() / StartingKarma())
			end
		end
		mul = mul * armormul
		//mul = math.Round(mul)
		//print("mul: " .. mul)
		dmginfo:ScaleDamage(mul)
	end
end

--Tides' Should collide shit, Tested by Link2006
--If it crashes, rip server.
if CLIENT then
    function GM:OnEntityCreated( ent )
        if LocalPlayer() == ent then
            ent:SetCustomCollisionCheck(true)
    	end
    end
end

if(SERVER)then

	util.AddNetworkString("UpdatePrepareVariable")
	function UpdatePrepareVariable(b)

		net.Start("UpdatePrepareVariable")
		net.WriteBool(b)
		net.Broadcast()
		print("Update function has been called value set to " .. tostring(b))
	end
	timer.Simple(0.5,UpdatePrepareVariable)


end



--TEMPORARLY DISABLED TO TRY THINGS DONT MIND ME
--[[
hook.Add("PlayerInitialSpawn","CollideCheck",function(ply)
    ply:SetCustomCollisionCheck(true)
end)

--^ enabling custom collisions. ↓ should collide hook.

hook.Add( "ShouldCollide", "CollideCheck2", function(ent1,ent2)
	if ( ent1:IsPlayer() and ent2:IsPlayer()) then
		--SPECIAL ROUND RULES HERE, ASSAULT ONLY FOR NOW THOUGH PLEASE OK THX.
		if roundtype then
			if CLIENT then
				roundtype_name = roundtype
			else
				roundtype_name = roundtype.name
			end

			if roundtype_name == "Assault" then
				if ent1:Team() == ent2:Team() then
					return false
				else
					return true
				end
			end
		end
		--The rest of nocollide stuff goes here thx.
		if ((ent1:Team() == TEAM_CLASSD) and (ent2:Team() == TEAM_CLASSD)) or ((ent1:Team() == TEAM_SCI) and (ent2:Team() == TEAM_SCI)) then
			return false
		else
			return true
        end
	end
end)
]]--
