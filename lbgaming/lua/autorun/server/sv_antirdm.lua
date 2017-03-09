--Anti RDM using AWarn
--  Original by DMX
--  Modified by Link2006
--Version 1.2

print("[AntiRDM] Loading AntiRDM...")
local AntiRDMVersion = "1.2" --I should have an habit of updating this :|
local rdmTable = {}
local AntiRDM
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
                --Do not set anyone here, simply here to prevent crashes
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
        victim:SetPos(table.Random(SPAWN_OUTSIDE))
    elseif rl == ROLE_MTFNTF and vicTeam == TEAM_CHAOS then --if they are NTF Chaos (Spy)
        victim:SetChaosInsurgency(3) --Respawn as NTF Chaos
        victim:SetPos(table.Random(SPAWN_OUTSIDE))
    elseif rl == ROLE_CLASSD then
        victim:SetClassD()
        victim:SetPos(table.Random(SPAWN_CLASSD))
    elseif rl == ROLE_RES then
        victim:SetScientist()
        victim:SetPos(table.Random(SPAWN_SCIENT))
    elseif rl == ROLE_CHAOS then --TDM Chaos (Unused!)
        victim:SetChaosInsurgency() --Not the spy version.
        victim:SetPos(table.Random(SPAWN_OUTSIDE)) --Idk where to spawn normal CI
        print("WARN: THIS IS USUALLY NEVER CALLED, WHAT HAPPENED?")
    else
        print("Role was "..rl)
        print("Team was "..vicTeam)
        print("We could not respawn the RDM Victim, Role not found.")
    end

end

local function antirdm(victim, inflictor, attacker)
    if postround ~= true then
        if attacker:IsPlayer() then --If it's an entity, ignore, it's probably the tesla.
            if rdmTable[ attacker:Team() ] then --I FORGOT TO CHECK IF THE ATTACKER'S TABLE EXISTED
                if (table.HasValue( rdmTable[ attacker:Team() ], victim:Team() ) and (attacker ~= victim)) --If Attacker and Victim were allies
                or (attacker:GetNClass() == ROLE_SCP035 and victim:Team() == TEAM_CLASSD) then --OR SCP-035 killed a Class D
                    --AWARN ATTACKER
                    print("[AntiRDM] Warning \""..attacker:Nick().."\" for RDM")
                    ULib.tsayColor(nil,true,Color(255,255,255),"[AntiRDM] \"",team.GetColor(attacker:Team()),attacker:Nick(),Color(255,255,255),"\" was warned for killing \"",team.GetColor(victim:Team()),victim:Nick(),Color(255,255,255),"\"")
                    RunConsoleCommand("awarn_warn",attacker:SteamID(),"\"RDM Detected by AntiRDM\"")
                    local rl = victim:GetNClass()
                    local vicTeam = victim:Team()
                    if postround ~= true then
                        ULib.tsayColor(victim,true,Color(0,255,0),"[AntiRDM] You will be respawned in a few moments")
                    end
                    timer.Simple(7,function() --7 seconds JUST To be sure...
                        if (postround ~= true) and victim:Team() == TEAM_SPEC then --Respawn if the round didn't end yet AND the victim is _still_ dead (Fixes respawning when they're alive)
                            antirdm_respawn(victim,rl,vicTeam)
                        end
                    end)
                end
            end
        end
    end
end

hook.Remove("PlayerDeath","AntiRDM_lbgaming") --Remove the hook (I moved it to here so hooks are all grouped in 1 place.)
hook.Add("PlayerDeath","AntiRDM_lbgaming",antirdm) --Remake it

--TODO: Track people who made most damage until the victim dies.
--      Then, Sort the table to have the MOST damage be first
--      and when someone dies, if they're in the same team as attacker, warn attacker
--      AND if the most damage was ALSO in the same team, warn them as well
--      (I probably should do a check for the killer if they made less than 40% damage, not flag the RDM )


antirdm_enabled = true

concommand.Add("antirdm_disable",function(ply,cmd,args)
    if !SERVER then
        if !(ply:IsAdmin() or ply:IsSuperAdmin()) then return end
    end

    if antirdm_enabled == true then
        antirdm_enabled = false
        hook.Remove("PlayerDeath","AntiRDM_lbgaming")
        ply:PrintMessage(HUD_PRINTCONSOLE, "AntiRDM disabled")
    end
end)

concommand.Add("antirdm_enable",function(ply,cmd,args)
    if !SERVER then
        if !(ply:IsAdmin() or ply:IsSuperAdmin()) then return end
    end

    if antirdm_enabled == false then
        antirdm_enabled = true
        hook.Add("PlayerDeath","AntiRDM_lbgaming",antirdm)
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
