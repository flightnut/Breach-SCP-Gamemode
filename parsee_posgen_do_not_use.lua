local startPos = Vector(-43,6810,1700)


local paruSPAWNS = {}

RunConsoleCommand('ulx','luarun',[[parsee = player.GetBySteamID('STEAM_0:1:5762375')]])	

for i=1,4 do
	for ii=1,25 do 
		table.insert(paruSPAWNS,Vector(startPos.x-(ii*75),startPos.y+(i*75),startPos.z))
	end
end

print("SPAWN_OUTSIDE = {")
for k,v in pairs(paruSPAWNS) do
	print("Vector("..v.x..","..v.y..","..v.z.."),")
end
print("}")

--TEST WITH BOTS :)
--RunConsoleCommand('ulx','luarun','allbots = player.GetBots()')

/*
for k,v in pairs(paruSPAWNS) do 
	timer.Simple(k/10,function()		
		RunConsoleCommand('ulx','luarun',"allbots["..k.."]:SetPos(Vector("..v.x..[[,]]..v.y..[[,]]..v.z..[[))]])
	end)
end
*/

/*
for k,v in pairs(paruSPAWNS) do 
	timer.Simple(k/10,function()
		RunConsoleCommand('ulx','luarun',[[parsee:SetPos(Vector(]]..v.x..[[,]]..v.y..[[,]]..v.z..[[))]])
	end)
end
*/
