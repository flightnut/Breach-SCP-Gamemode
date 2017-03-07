sm = nil
Color1 = Color(39,39,39)
Color2 = Color(199,0,0)

if not sm then
	sm = nil
end


function sm_close()
	if ispanel(sm) then
		if sm.Close then
			sm:Close()
		end
		if sm.Remove then
			sm:Remove()
		end
	end
end

function sm_open()
	if IsValid(sm) then return end
	--sm doesn't seem to exist
	if !IsValid(sm) then
		sm = vgui.Create("DFrame")
		sm:SetSize(350, 400)
		sm:SetPos((ScrW()/2-sm:GetWide()/2), (ScrH()/2-sm:GetTall()))
		sm:SetTitle("")
		sm:ShowCloseButton(false)
		sm.Paint = function()
			draw.RoundedBox(0,0,0,sm:GetWide(),sm:GetTall(),Color(59,59,59,245))
			draw.RoundedBox(0,0,0,sm:GetWide(),25,Color1)
			draw.SimpleText(">Sound Menu<","DermaDefault",sm:GetWide()/2,5,Color2,TEXT_ALIGN_CENTER)
		end

		sm:Show()
		sm:MakePopup()
		sm:SetKeyboardInputEnabled(false)
		sm:SetDraggable(false)
		sm:Center()
		sm:SetBackgroundBlur(true)

		--Sound files here are NOT USED, Change them in the SERVER SIDED Table!
		local says = {
			['a'] = {"049_3.wav","Oh my..."},
			['b'] = {"049_4.wav","You are not a doctor."},
			['c'] = {"049_5.wav","I sense the disease in you."},
			['d'] = {"049_6.wav","I am the cure."},
			['e'] = {"049_7.wav","Do not be afraid..."},
			['f'] = {"049_8.wav","Stop resisting..."},
			['g'] = {"049_alert_1.wav","Hello."},
			['h'] = {"049_alert_2.wav","Greetings."},
			['i'] = {"049_9.wav","*Singing*"},
			['j'] = {"049_10.wav","Oh my...(2)"},
		}

		local temp = 30

		for k,v in pairs(says) do
			local b1 = vgui.Create("DButton", sm)
			b1:SetSize(sm:GetWide()-10, 30)
			b1:SetPos(5, temp)
			b1:SetText(v[2])
			b1.Paint = function()
				draw.RoundedBox(0,0,0,b1:GetWide(),b1:GetTall(),Color1)
			end
			b1.DoClick = function()
				net.Start("sm_emitsound")
					--net.WriteString(v[1])
					net.WriteString(k) --send the ID and not the actual sound!
				net.SendToServer()
			end
			b1.OnCursorEntered = function()
				b1.Paint = function()
					draw.RoundedBox(0,0,0,b1:GetWide(),b1:GetTall(),Color2)
				end
			end
			b1.OnCursorExited = function()
				b1.Paint = function()
					draw.RoundedBox(0,0,0,b1:GetWide(),b1:GetTall(),Color1)
				end
			end
			b1.OnMousePressed = function()
				b1.Paint = function()
					draw.RoundedBox(0,0,0,b1:GetWide(),b1:GetTall(),Color1)
				end
			end
			b1.OnMouseReleased = function()
				b1.Paint = function()
					draw.RoundedBox(0,0,0,b1:GetWide(),b1:GetTall(),Color2)
				end
				b1:DoClick()
			end
			temp = temp + 31
		end

		--Close button
		local bClose = vgui.Create("DButton", sm)
		bClose:SetSize(sm:GetWide()-10, 30)
		bClose:SetPos(5, temp) --at the bottom
		bClose:SetText("Close")
		bClose.Paint = function()
			draw.RoundedBox(0,0,0,bClose:GetWide(),bClose:GetTall(),Color1)
		end
		bClose.DoClick = function()
			--sm:Remove()
			sm_close()
		end
		bClose.OnCursorEntered = function()
			bClose.Paint = function()
				draw.RoundedBox(0,0,0,bClose:GetWide(),bClose:GetTall(),Color2)
			end
		end
		bClose.OnCursorExited = function()
			bClose.Paint = function()
				draw.RoundedBox(0,0,0,bClose:GetWide(),bClose:GetTall(),Color1)
			end
		end
		bClose.OnMousePressed = function()
			bClose.Paint = function()
				draw.RoundedBox(0,0,0,bClose:GetWide(),bClose:GetTall(),Color1)
			end
		end
		bClose.OnMouseReleased = function()
			bClose.Paint = function()
				draw.RoundedBox(0,0,0,bClose:GetWide(),bClose:GetTall(),Color2)
			end
			bClose:DoClick()
		end

	else
		sm_close()
	end
end

hook.Add( "KeyPress", "SM_ACTION_PRESS", function( ply, key )
	if ply:Team() != TEAM_SCP then return end
	if ply:GetNClass() != ROLE_SCP049 then return end
	if ( key == IN_ZOOM ) then
		sm_open()
	end
end )
hook.Add( "KeyRelease", "SM_ACTION_RELEASE", function( ply, key )
	if ply:Team() != TEAM_SCP then return end
	if ply:GetNClass() != ROLE_SCP049 then return end
	if ( key == IN_ZOOM ) then
		sm_close()
	end
end )

--This method spams errors because it runs every tick :|
--[[
hook.Add( "Tick", "SM_ACTION", function()
	if LocalPlayer():GetNClass() != ROLE_SCP049 then return end
	if LocalPlayer():KeyPressed( IN_ZOOM ) then sm_toggle() end
	if LocalPlayer():KeyReleased( IN_ZOOM ) then sm_toggle() end
end )
]]--
