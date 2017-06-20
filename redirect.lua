--Put this file in /garrysmod/lua/autorun and change the IP to forcefully redirect players
--This has many hooks to make sure they are redirected.
newServerIp = "167.114.95.131:27028"

if SERVER then
    AddCSLuaFile()
    hook.Add('PlayerInitialSpawn','AutoRedirect2',function(ply)
        ply:ChatPrint('We Moved to '..newServerIp..' !')
        ply:SendLua([[LocalPlayer():ConCommand('connect ]]..newServerIp..[[')]])
    end)
    hook.Add('PlayerSpawn','AutoRedirect3',function(ply)
        ply:ChatPrint('We Moved to '..newServerIp..' !')
        ply:SendLua([[LocalPlayer():ConCommand('connect ]]..newServerIp..[[')]])
    end)
    hook.Add()
elseif CLIENT then
    hook.Add( "InitPostEntity", "AutoRedirect", function() LocalPlayer():ConCommand( "connect "..newServerIp ) end )
end
