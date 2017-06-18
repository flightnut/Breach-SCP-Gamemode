concommand.Add('br_teleportme',function(ply,cmd,args)
	if ply:IsAdmin() then 
		if ply.TeleportNumber == nil then 
			ply.TeleportNumber = 1
		end 
		if ply.TeleString == nil then 
			ply.TeleString = "__INVALID__"
		end 
		
		if ply.TeleString ~= tostring(args[1])..'.'..tostring(args[2]) and ply.TeleString ~= tostring(args[1]) then 
			if args[2] then 
				ply.TeleString = tostring(args[1])..'.'..tostring(args[2])
				ply.TeleTable = _G[args[1]][args[2]]
			else
				ply.TeleString = tostring(args[1])
				ply.TeleTable = _G[args[1]]
			end 
			ply.TeleportNumber = 1
		end 
		if ply.TeleTable then 
			--print(ply:GetName().." ran br_teleportme")
			--print(":TeleString:"..tostring(ply.TeleString))
			--print(":TeleIndex:"..tostring(ply.TeleportNumber ))
			--print(ply.TeleTable[ply.TeleportNumber ])
			ply:ChatPrint("[br_teleportme] "..tostring(ply.TeleString)..'['..tostring(ply.TeleportNumber)..']'..' = '..tostring(ply.TeleTable[ply.TeleportNumber]))
			--ply:ChatPrint("[DEBUG] "..tostring(ply.TeleString))
			--ply:ChatPrint("[DEBUG] "..tostring(ply.TeleTable))
			--ply:ChatPrint("[DEBUG] "..tostring(ply.TeleportNumber))
			--ply:ChatPrint("[DEBUG] "..tostring(ply.TeleTable[ply.TeleportNumber]))
			ply:SetPos(ply.TeleTable[ply.TeleportNumber])
			ply.TeleportNumber  = ply.TeleportNumber  + 1 
		else
			ply:ChatPrint("[br_teleportme] ERROR: "..tostring(args[1]).."; "..tostring(args[2]))
			--ply:SendLua('error("br_teleportme received an invalid command")')
			--error("Invalid Table from br_teleportme by "..tostring(ply).." ("..tostring(args[1])..")")
			ply.TeleportNumber = 1
		end 
	end 
end)

concommand.Add('br_teleportme_resetme',function(ply)
	if ply:IsAdmin() then 
		ply.TeleportNumber = 1
		ply.TeleString = nil
		ply.TeleTable = nil 
		ply:ChatPrint("Deleted your TeleportMe data...")
	end 
end)