print("[PartyReset] Loading ...")
hook.Add("PostCleanupMap","PartyReset_OnNewRound",function() --Resets respawns here
    print("[PartyReset] Cleaning Parties...")
    for k,v in pairs(player.GetAll()) do
        if v:GetParty() then --Are they in a party?
            v:LeaveParty() --Make them quit the party
            ULib.tsayColor(victim,true,Color(255,0,0),"[Party] ",Color(0,255,0),"Your party was disbanded as a new round started.") --Might not be required.
        end
    end
    print("[AntiRDM] Done.")
end)
print("[PartyReset] Ready.")
