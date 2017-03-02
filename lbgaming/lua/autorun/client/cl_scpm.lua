concommand.Add("roletestmenu",function( ply, cmd, args, argstr )
	if !ply:IsAdmin() then --Admin only, clientside but whatever.
		ply:ChatPrint("You do not have access to this command.")
		return 
	end
	
	local scpm = nil
	local hasChanged = false
	local currentNum = 1
	local trg = LocalPlayer() 

	if !IsValid( scpm ) then --This is useless omg
		scpm = vgui.Create("DFrame")
		scpm:SetSize(600,500)
		scpm:SetPos((ScrW() / 2) - 300, (ScrH() / 2) - 250)
		scpm:SetTitle("[Role-Test-Menu]")
		scpm:SetDraggable(true)
		scpm:ShowCloseButton(true)
		scpm.Paint = function ()
			draw.RoundedBoxEx(7, 0, 0, scpm:GetWide(), scpm:GetTall(), Color(50,50,50), false, true, false, false)
			draw.RoundedBoxEx(7, 0, 0, scpm:GetWide(), 25, Color(30,30,30), false, true, false, false)
			draw.RoundedBox(4, 503.46, 2.3, 93, 20, Color(50,50,50))
		end

		scpm:Show()
		scpm:MakePopup()
		scpm:SetKeyBoardInputEnabled(false)

		local cbbp = vgui.Create( "DComboBox", scpm )
		cbbp:SetPos( 180, 200 ) 
		cbbp:SetSize( 250, 20 )
		cbbp:SetValue( "LocalPlayer" )
		cbbp.Paint = function ()
		draw.RoundedBoxEx(7, 0, 0, cbbp:GetWide(), cbbp:GetTall(), Color(30,30,30), true, true, true, true)
		end

		function refreshPL()
			for k,v in pairs(player.GetAll()) do
			--if v == LocalPlayer() then cbbp:AddChoice("LocalPlayer", LocalPlayer()) 
			--else
				cbbp:AddChoice(v:Nick(), v)
			--end
			end
		end

		refreshPL()

		cbbp.OnSelect = function( panel, index, value )
			--local val = cbbp:GetOptionData( index )
			--HACK: Possible fix for the target always being LocalPlayer() instead of actual target
			trg = cbbp:GetOptionData( index ) -- Set the new player 
			if trg == LocalPlayer() then --if it's local player then stop
				if timer.Exists("rtmRef") then
					timer.Remove("rtmRef")
				end
				return
			end
			if timer.Exists("rtmRef") then timer.Remove("rtmRef") end --remove the timer right now 
			timer.Create( "rtmRef", 1, 0, function() --check if it's a valid player still
				if !trg:IsPlayer() then --if target is not player, 
					trg = LocalPlayer() --set back to local player 
					--cbbp:SetValue("LocalPlayer")
					cbbp:SetValue(trg:Nick()) --set back to LocalPlayer's name
					refreshPL() --Refresh list 
					cbbp.OnSelect() --??? Unknown, possibly tells the server a new selection?
				end
			end )
		end

		local cbb = vgui.Create( "DComboBox", scpm )
		cbb:SetPos( 180, 230 ) 
		cbb:SetSize( 250, 20 )
		cbb:SetValue( "Role" )
		cbb.Paint = function ()
		draw.RoundedBoxEx(7, 0, 0, cbb:GetWide(), cbb:GetTall(), Color(30,30,30), true, true, true, true)
		end
		cbb:AddChoice( "Class D", 2 )
		cbb:AddChoice( "Scientist", 3 )
		cbb:AddChoice( "MTF Commander", 4 )
		cbb:AddChoice( "MTF", 5 )
		cbb:AddChoice( "Chaos Insurgency", 6 )
		cbb:AddChoice( "Site Director", 7 )
		cbb:AddChoice( "Nine Tail Fox", 8 )
		cbb:AddChoice( "SCP-173", 9 )
		cbb:AddChoice( "SCP-1048A", 10 )
		cbb:AddChoice( "SCP-106", 11 )
		cbb:AddChoice( "SCP-049", 12 )
		cbb:AddChoice( "SCP-457", 13 )
		cbb:AddChoice( "SCP-0082", 14 )
		cbb:AddChoice( "SCP-0492", 15 )
		cbb:AddChoice( "SCP-035", 16 )
		cbb:AddChoice( "Spectator", 1 )
		cbb.OnSelect = function( panel, index, value )
			local func = cbb:GetOptionData( index )
			currentNum = func

			cbb.Paint = function ()
			draw.RoundedBoxEx(7, 0, 0, cbb:GetWide(), cbb:GetTall(), Color(30,30,30), false, false, false, false)
			end

			cbbp.Paint = function ()
			draw.RoundedBoxEx(7, 0, 0, cbbp:GetWide(), cbbp:GetTall(), Color(30,30,30), true, true, false, false)
			end

			if !hasChanged then
				hasChanged = true

				cbb:SetPos( 180, 220 )

				local cb = vgui.Create( "DButton", scpm )
				cb:SetText( "Spawn" )	
				cb:SetPos( 180, 240 )	
				cb:SetSize( 250, 20 )	
				cb.DoClick = function()	
				if hasChanged then
					--Do another check that the player is STILL valid please, before sending the new
					--	spawn command, makes sure to not break shit
					if !trg:IsPlayer() then --if target is not player, 
						trg = LocalPlayer() --set back to local player 
						--cbbp:SetValue("LocalPlayer")
						cbbp:SetValue(trg:Nick()) --set back to LocalPlayer's name
						refreshPL() --Refresh list 
						cbbp.OnSelect() --??? Unknown, possibly tells the server a new selection?
					end
				
					if trg == LocalPlayer() then
					net.Start( "spawnas" )
						net.WriteInt( currentNum, 32 )
					net.SendToServer()
					else
					net.Start( "spawnthemas" )
						net.WriteInt( currentNum, 32 )
						net.WriteEntity( trg )
					net.SendToServer()
					end
				end
				end
			end
		end

	else
		scpm:Remove()
	end
end)