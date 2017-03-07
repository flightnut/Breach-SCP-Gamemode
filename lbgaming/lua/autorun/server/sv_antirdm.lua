--Anti RDM using AWarn
--  Original by DMX
--  Modified by Link2006
--Version 1.0
print("[AntiRDM] Loading AntiRDM...")
local AntiRDMVersion = "1.0" --:)

local rdmTable = {
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
}

--KEEP THIS CLOSE, MIGHT BE NEEDED LATER
--  if (victim:Team() == TEAM_CLASSD and attacker:GetNClass() == ROLE_SCP035 or (attacker:Team() == TEAM_CLASSD and victim:GetNClass() == ROLE_SCP035) then
--      --AWARN
--  end
--Just to make sure we dont have dupes while testing.
hook.Remove("PlayerDeath","AntiRDM")

hook.Add("PlayerDeath","AntiRDM_lbgaming",function(victim, inflictor, attacker)
    if postround ~= true then
        if attacker:IsPlayer() then --If it's an entity, ignore, it's probably the tesla.
            if table.HasValue( rdmTable[ attacker:Team() ], victim:Team() ) and (attacker ~= victim) then --attacker is not nil
                --AWARN ATTACKER
                print("[AntiRDM] Warning \""..attacker:Nick().."\" for RDM")
                RunConsoleCommand("awarn_warn",attacker:SteamID(),"\"RDM Detected by AntiRDM\"")
            end
        end
    end
end)

print("[AntiRDM] AntiRDM "..AntiRDMVersion.." by Link2006 & DMX, Ready.")
