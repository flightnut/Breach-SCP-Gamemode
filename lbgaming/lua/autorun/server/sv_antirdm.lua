--Anti RDM using AWarn
--  Original by DMX
--  Modified by Link2006
--Version 1.0

print("[AntiRDM] Loading AntiRDM...")
local AntiRDMVersion = "1.0" --:)
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
                --They can kill Anyone, No Check here.
                --Adds support for Preventing SCP vs SCP tho :)
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
hook.Remove("PlayerDeath","AntiRDM_lbgaming")

local function antirdm(victim, inflictor, attacker)
    if postround ~= true then
        if attacker:IsPlayer() then --If it's an entity, ignore, it's probably the tesla.
            if rdmTable[ attacker:Team() ] then --I FORGOT TO CHECK IF THE ATTACKER'S TABLE EXISTED
                if table.HasValue( rdmTable[ attacker:Team() ], victim:Team() ) and (attacker ~= victim) then --attacker is not nil
                    --AWARN ATTACKER
                    print("[AntiRDM] Warning \""..attacker:Nick().."\" for RDM")
                    RunConsoleCommand("awarn_warn",attacker:SteamID(),"\"RDM Detected by AntiRDM\"")
                end
            end
        end
    end
end

hook.Add("PlayerDeath","AntiRDM_lbgaming",antirdm)

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
    ply:PrintMessage(HUD_PRINTCONSOLE, "AntiRDM enabled : "..antirdm_enabled)
end)

print("[AntiRDM] AntiRDM "..AntiRDMVersion.." by Link2006 & DMX, Ready.")
