--Anti RDM using AWarn
--  Original by DMX
--  Modified by Link2006
-- 2.0 just means fuck this versioning lol ;)

print("[AntiRDM] Loading AntiRDM...")
local AntiRDMVersion = "2.0" --I should have an habit of updating this :|
antirdm_enabled = true --Global so we can have it everywhere, also put it here so it's easy to find
br_friendlyfire = CreateConVar("br_friendlyfire","0",{FCVAR_SERVER_CAN_EXECUTE,FCVAR_NOTIFY},"0 = Disable FriendlyFire, 1 = Enable FriendlyFire") --Self Explained :)
local rdmTable = {} -- Normal Table
local rdmTable_ff = {} --FriendlyFire Table
local AntiRDM
local AntiRDM_Respawns = 2 --How many respawns do players get?

function rdmTableInit()
    if TEAM_CLASSD == nil then
        timer.Simple(1,rdmTableInit)
    else
        rdmTable = {
            [TEAM_CLASSD]={
                TEAM_CLASSD,
                TEAM_CHAOS
            },
            [TEAM_CHAOS]={
                TEAM_CHAOS,
                TEAM_CLASSD
            },
            [ TEAM_SCI ] =  {
                TEAM_SCI,
                TEAM_GUARD
            },
            [ TEAM_GUARD ] =  {
                TEAM_SCI,
                TEAM_GUARD
            },
            [ TEAM_SCP ] = {
                TEAM_SCP --Because of course SCP-035 gets point for killing other SCPs ... Why ?
            },
        }
        --FriendlyFire Version of the table
        rdmTable_ff = {
                [TEAM_CLASSD]={
                    TEAM_CLASSD,
                    TEAM_CHAOS
                },
                [TEAM_CHAOS]={
                    TEAM_CLASSD
                },
                [ TEAM_SCI ] =  {
                    TEAM_SCI,
                    TEAM_GUARD
                },
                [ TEAM_GUARD ] =  {
                    TEAM_SCI
                },
                [ TEAM_SCP ] = {
                    TEAM_SCP --Because of course SCP-035 gets point for killing other SCPs ... Why ?
                },
            }
    end
end

timer.Simple(1,rdmTableInit)

--KEEP THIS CLOSE, MIGHT BE NEEDED LATER
--  if (victim:Team() == TEAM_CLASSD and attacker:GetNClass() == ROLE_SCP035 or (attacker:Team() == TEAM_CLASSD and victim:GetNClass() == ROLE_SCP035) then
--      --AWARN
--  end
--Just to make sure we dont have dupes while testing.

local function antirdm_respawn(victim,rl,vicTeam)
    -- I copy-pasted from how it checks languages
    if rl == ROLE_SCP035 then
        victim:SetSCP035()
    elseif rl == ROLE_SCP1048A then
        victim:SetSCP1048a()
    elseif rl == ROLE_SCP173 then
        victim:SetSCP173()
    elseif rl == ROLE_SCP106 then
        victim:SetSCP106()
    elseif rl == ROLE_SCP049 then
        victim:SetSCP049()
    elseif rl == ROLE_SCP457 then
        victim:SetSCP457()
    elseif rl == ROLE_SCP0492 then
        victim:SetSCP0492()
    elseif rl == ROLE_MTFGUARD and vicTeam == TEAM_GUARD then --If they are MTF
        victim:SetGuard()
        victim:SetPos(table.Random(SPAWN_GUARD))
    elseif rl == ROLE_MTFGUARD and vicTeam == TEAM_CHAOS then --If they are MTF CI
        victim:SetChaosInsurgency(1) --Normal CI
        victim:SetPos(table.Random(SPAWN_GUARD))
    elseif rl == ROLE_MTFCOM then
        victim:SetCommander()
        victim:SetPos(table.Random(SPAWN_GUARD))
    elseif rl == ROLE_MTFNTF and vicTeam == TEAM_GUARD then -- If they are NTF...
        victim:SetNTF() --Respawn as NTF, they were NTF
        if roundtype then
            if (roundtype.name == ROUNDS.assault.name) then --If it's the Assault gamemode
                victim:SetPos(table.Random(SPAWN_GUARD))
            else
                victim:SetPos(table.Random(SPAWN_OUTSIDE))
            end
        else
            victim:SetPos(table.Random(SPAWN_OUTSIDE))
        end
    elseif rl == ROLE_MTFNTF and vicTeam == TEAM_CHAOS then --if they are NTF Chaos (Spy)
        victim:SetChaosInsurgency(3) --Respawn as NTF Chaos
        if roundtype then
            if (roundtype.name == ROUNDS.spies.name) then --If it's the TTT Gamemode, respawn them lmao
                victim:SetPos(table.Random(SPAWN_GUARD))
            else
                victim:SetPos(table.Random(SPAWN_OUTSIDE))
            end
        else
            victim:SetPos(table.Random(SPAWN_OUTSIDE))
        end
    elseif rl == ROLE_CLASSD then
        victim:SetClassD()
        victim:SetPos(table.Random(SPAWN_CLASSD))
    elseif rl == ROLE_RES then
        victim:SetScientist()
        victim:SetPos(table.Random(SPAWN_SCIENT))
    elseif rl == ROLE_CHAOS then --TDM Chaos (Unused!)
        victim:SetChaosInsurgency() --Not the spy version.
        if roundtype then
            if (roundtype.name == ROUNDS.assault.name) then --If it's the Assault gamemode
                victim:SetChaosInsurgency(4) --Reset their class to the assault one, needs to be 4 apparently.
                victim:SetPos(table.Random(SPAWN_CLASSD))
            else
                victim:SetPos(table.Random(SPAWN_OUTSIDE)) --Idk where to spawn normal CI
            end
        else
            victim:SetPos(table.Random(SPAWN_OUTSIDE)) --Idk where to spawn normal CI
        end
        --print("WARN: THIS IS USUALLY NEVER CALLED, WHAT HAPPENED?")
    else
        print('[AntiRDM] RESPAWN FAILED: ')
        print("[AntiRDM] Role was "..rl)
        vicTeam_name= {
            TEAM_SCP = "Team SCP (1)",
            TEAM_GUARD = "Team Guard(2)",
            TEAM_CLASSD = "Team ClassD(3)",
            TEAM_SPEC = "Team Spec(4)",
            TEAM_SCI = "Team_SCI(5)",
            TEAM_CHAOS = "Team_Chaos(6)",
        }
        print("[AntiRDM] Team was "..vicTeam_name[TEAM_SCP])
        print("[AntiRDM] We could not respawn the RDM Victim, Role not found.")
    end

end

if br_roundnospec == nil then
    br_roundnospec = GetConVar("br_roundnospec")
end

local function antirdm(victim, inflictor, attacker)
    if br_roundnospec == nil then
        br_roundnospec = GetConVar("br_roundnospec")
    end
    if postround ~= true then
        if attacker:IsPlayer() then --If it's an entity, ignore, it's probably the tesla.
            if rdmTable[ attacker:Team() ] then --I FORGOT TO CHECK IF THE ATTACKER'S TABLE EXISTED
                if (table.HasValue( rdmTable[ attacker:Team() ], victim:Team() ) and (attacker ~= victim)) --If Attacker and Victim were allies
                or (attacker:GetNClass() == ROLE_SCP035 and victim:Team() == TEAM_CLASSD) --OR SCP-035 killed a Class D
                or (victim:GetNClass() == ROLE_SCP035 and attacker:Team() == TEAM_CLASSD) then --OR Class D killed SCP-035
                    --AWARN ATTACKER
                    --MULTIPLE BREACH SPECIAL CASE WHERE WE NEED 035 ABLE TO KILL CLASSDS
                    if (attacker:GetNClass() == ROLE_SCP035 and victim:Team() == TEAM_CLASSD) or (victim:GetNClass() == ROLE_SCP035 and attacker:Team() == TEAM_CLASSD) then
                        if roundtype.name == ROUNDS.multiplebreaches.name then
                            return
                        end
                    end
                    print("[AntiRDM] Warning \""..attacker:Nick().."\" for RDM")
                    if antirdm_enabled and (tostring(roundtype.name) ~= ROUNDS.spies.name) then --As long it's not TTT lol ...
                        ULib.tsayColor(nil,true,Color(255,0,0),"[AntiRDM]",Color(255,255,255)," \"",team.GetColor(attacker:Team()),attacker:Nick(),Color(255,255,255),"\" was warned for killing \"",team.GetColor(victim:Team()),victim:Nick(),Color(255,255,255),"\"")
                        RunConsoleCommand("awarn_warn",attacker:SteamID(),"\"RDM Detected by AntiRDM\"")
                    else
                        ULib.tsayColor(attacker,true,Color(255,0,0),"[AntiRDM]",Color(255,255,255)," Be careful, You killed \"",team.GetColor(victim:Team()),victim:Nick(),Color(255,255,255),"\"")
                    end
                    local rl = victim:GetNClass()
                    local vicTeam = victim:Team()
                    if br_roundnospec:GetBool() ~= true then
                        if victim.Respawns == nil then --if not set, set them.
                            victim.Respawns = AntiRDM_Respawns
                        end
                        if postround ~= true then
                            victim.Respawns = victim.Respawns - 1
                            if victim.Respawns > 0 then
                                ULib.tsayColor(victim,true,Color(0,255,0),"[AntiRDM]",Color(255,255,255)," You will be respawned, Respawns Left: "..tostring(victim.Respawns))
                                timer.Simple(7,function() --7 seconds JUST To be sure...
                                    if victim.Respawns then
                                        if (postround ~= true) and (victim:Team() == TEAM_SPEC) and victim.Respawns > 0 then --Respawn if the round didn't end yet AND the victim is _still_ dead (Fixes respawning when they're alive)
                                            antirdm_respawn(victim,rl,vicTeam)
                                            ULib.tsayColor(victim,true,Color(0,255,0),"[AntiRDM]",Color(255,255,255)," Respawns left: "..victim.Respawns)
                                        end
                                    end
                                end)
                            else
                                ULib.tsayColor(victim,true,Color(255,0,0),"[AntiRDM]",Color(255,255,255)," You will not be respawned as you have died too many times.")
                            end
                        end

                    end
                end
            end
        end
    end
end

hook.Remove("PlayerDeath","AntiRDM_lbgaming") --Remove the hook (I moved it to here so hooks are all grouped in 1 place.)
hook.Remove("PostCleanupMap","AntiRDM_CleanRespawns") --This makes sure we dont have dupes
hook.Add("PlayerDeath","AntiRDM_lbgaming",antirdm)  --AntiRDM Function here, manages kills/RDMs
hook.Add("PostCleanupMap","AntiRDM_CleanRespawns",function() --Resets respawns here
    print("[AntiRDM] Cleaning Respawns for every players...")
    for k,v in pairs(player.GetAll()) do
        v.Respawns = nil --Make it invalid.
    end
    print("[AntiRDM] Forcing noChaosHurt to nil")
    noChaosHurt = nil
    print("[AntiRDM] Destroying remaining timers...")
    timer.Remove("noChaosHurt")
    timer.Remove("noChaosHurt_notify")
    if roundtype then
        if roundtype.name == normalround.name then --Only the normal round we can protect the Chaos/MTF
            print("[AntiRDM] Disabling MTF<->Chaos damage for 90 seconds...")
            noChaosHurt = true
            timer.Create("noChaosHurt_notify",60,1,function()
                for k,v in pairs(player.GetAll()) do
                    if v:Team() == TEAM_CHAOS then
                        v:ChatPrint("Spawn protection enabled")
                    end
                end
            end)
            timer.Create("noChaosHurt",90,1,function()
                print("[AntiRDM] Enabling MTF<->Chaos damage...")
                noChaosHurt = nil
                for k,v in pairs(player.GetAll()) do
                    if v:Team() == TEAM_CHAOS then
                        v:ChatPrint("Spawn protection disabled")
                    end
                end
            end)
        end
    end
    print("[AntiRDM] Done.")
end)
-- br_friendlyfire:GetBool() ~= true
hook.Add("PlayerShouldTakeDamage","AntiRDM_NoDamage",function(victim,attacker)
    --Force Friendly Fire OFF when round hasn't started
    if roundtype then
        if roundtype.name == ROUNDS.zombieplague.name then
            if IsValid(victim) and IsValid(attacker) then
                if victim:IsPlayer() and attacker:IsPlayer() then
                    if rdmTable[ attacker:Team() ] then --I FORGOT TO CHECK IF THE ATTACKER'S TABLE EXISTED
                        if (table.HasValue( rdmTable[ attacker:Team() ], victim:Team() ) and (attacker ~= victim)) then--If Attacker and Victim were allies
                            return false --Do not allow damage
                        else
                            return true --Allow damage
                        end
                    end
                end
            end
        elseif roundtype.name == ROUNDS.multiplebreaches.name then
            if IsValid(victim) and IsValid(attacker) then
                if victim:IsPlayer() and attacker:IsPlayer() then
                    if rdmTable[ attacker:Team() ] then --I FORGOT TO CHECK IF THE ATTACKER'S TABLE EXISTED
                        if (table.HasValue( rdmTable[ attacker:Team() ], victim:Team() ) and (attacker ~= victim)) then--If Attacker and Victim were allies
                            return false --Do not allow damage
                        else
                            return true --Allow damage
                        end
                    end
                end
            end
        end
    end

    if preparing then
        return false --Stops the players from doing ANY damage during preparing round
    end
    if noChaosHurt then
        --Prevent Finding chaos between 13:00 and 12:30 ... oops
        if IsValid(victim) and IsValid(attacker) then
			if victim:IsPlayer() and attacker:IsPlayer() then
				if (victim:Team() == TEAM_GUARD and attacker:Team() == TEAM_GUARD) or (victim:Team() == TEAM_GUARD and attacker:Team() == TEAM_CHAOS) or (attacker:Team() == TEAM_GUARD and victim:Team() == TEAM_CHAOS) then
					return false
				end
			end
        end
    end
    --Force Friendly Fire ON when Round is "spies"
    if roundtype and (roundtype.name == ROUNDS.spies.name) then --If it's the TTT Gamemode, respawn them lmao
        return true
    end
    --Force Friendly Fire ON when round is over, but if it isn't then we do our checks. :)
    if postround ~= true then
        if victim:IsPlayer() then
            if attacker:IsPlayer() then
                if br_friendlyfire:GetBool() then
                    if rdmTable_ff[ attacker:Team() ] then --I FORGOT TO CHECK IF THE ATTACKER'S TABLE EXISTED
                        if (table.HasValue( rdmTable_ff[ attacker:Team() ], victim:Team() ) and (attacker ~= victim)) --If Attacker and Victim were allies
                        or (attacker:GetNClass() == ROLE_SCP035 and victim:Team() == TEAM_CLASSD) --OR SCP-035 attacked a Class D
                        or (victim:GetNClass() == ROLE_SCP035 and attacker:Team() == TEAM_CLASSD) --OR Class D attacked SCP-035
                        or (attacker:Team() == TEAM_SPEC) then --Uh
                            return false
                        end
                    end
                else
                    if rdmTable[ attacker:Team() ] then --I FORGOT TO CHECK IF THE ATTACKER'S TABLE EXISTED
                        if (table.HasValue( rdmTable[ attacker:Team() ], victim:Team() ) and (attacker ~= victim)) --If Attacker and Victim were allies
                        or (attacker:GetNClass() == ROLE_SCP035 and victim:Team() == TEAM_CLASSD) --OR SCP-035 attacked a Class D
                        or (victim:GetNClass() == ROLE_SCP035 and attacker:Team() == TEAM_CLASSD) --OR Class D attacked SCP-035
                        or (attacker:Team() == TEAM_SPEC) then --Or attacker's a spectator
                            return false
                        end
                    end
                end
            end
        end
    end

    return true
end)

--TODO: Track people who made most damage until the victim dies.
--      Then, Sort the table to have the MOST damage be first
--      and when someone dies, if they're in the same team as attacker, warn attacker
--      AND if the most damage was ALSO in the same team, warn them as well
--      (I probably should do a check for the killer if they made less than 40% damage, not flag the RDM )



concommand.Add("antirdm_disable",function(ply,cmd,args)
    if !SERVER then
        if !(ply:IsAdmin() or ply:IsSuperAdmin()) then return end
    end

    if antirdm_enabled == true then
        antirdm_enabled = false
        --hook.Remove("PlayerDeath","AntiRDM_lbgaming")
        ply:PrintMessage(HUD_PRINTCONSOLE, "AntiRDM disabled")
    end
end)

concommand.Add("antirdm_enable",function(ply,cmd,args)
    if !SERVER then
        if !(ply:IsAdmin() or ply:IsSuperAdmin()) then return end
    end

    if antirdm_enabled == false then
        antirdm_enabled = true
        --hook.Add("PlayerDeath","AntiRDM_lbgaming",antirdm)
        ply:PrintMessage(HUD_PRINTCONSOLE, "AntiRDM enabled")
    end
end)

concommand.Add("antirdm_status",function(ply,cmd,args)
    if !SERVER then
        if !(ply:IsAdmin() or ply:IsSuperAdmin()) then return end
    end
    ply:PrintMessage(HUD_PRINTCONSOLE, "AntiRDM enabled : "..tostring(antirdm_enabled))
end)

print("[AntiRDM] AntiRDM "..AntiRDMVersion.." by Link2006 & DMX, Ready.")
