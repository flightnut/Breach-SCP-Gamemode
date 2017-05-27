if SERVER then
	util.AddNetworkString("blinking_send")

	local plymeta = FindMetaTable( "Player" )
	CreateConVar("blinking_time",10,FCVAR_ARCHIVE,"Time between blinks")
	CreateConVar("blinking_duration",0.5,FCVAR_ARCHIVE,"Duration time for blinking")

	function plymeta:IsBlinking()
		--print("[DEBUG-IsBlinking] IsBlinking for: "..tostring(self))
		if not self.blinkTime then return false end
		if self:Team() == TEAM_SPEC or self:Team() == TEAM_SCP then	return false end
		if self:GetActiveWeapon() and self:GetActiveWeapon().ISSCP then	return false end
		--if (self.blinkTime - GetConVar("blinking_duration"):GetFloat()) < CurTime() then return false end
		if self.usedeyedrops then return false end
		if self.blinkTime >= CurTime() then
			return false
		else
			return true
		end
		--print("[DEBUG-IsBlinking] Returning True ======")
		return true
	end

	function plymeta:playerBlink(blinkDur)
		--print(self)
		--print(blinkDur)
		if self.usedeyedrops then return false end --We do not need to blink yet! :)

		if blinkDur == nil then
			blinkDur = GetConVar("blinking_duration"):GetFloat()
		end
		--print(blinkDur)
		--ply.blinkTime = CurTime() + GetConVar("blinking_time"):GetInt() --It used to be os.time() instead of CurTime()
		self.blinkTime = CurTime() + blinkDur
		net.Start("blinking_send")
			net.WriteFloat(blinkDur)
		net.Send(self)
	end

	hook.Add("PlayerInitialSpawn","Blinking initial spawn",function(ply)
		if not timer.Exists( ply:SteamID64() .. " blinktime" ) then
			timer.Create(ply:SteamID64() .. " blinktime", GetConVar("blinking_time"):GetInt(), 0, function()
				ply:playerBlink(nil)
			end)
		end
	end)
	hook.Add("PlayerDisconnected","Blinking remove timer",function(ply)
		if timer.Exists( ply:SteamID64() .. " blinktime" ) then
			timer.Remove(ply:SteamID64() .. " blinktime")
		end
	end)
	concommand.Add("br_blink",function(ply)
		if timer.Exists( ply:SteamID64() .. " blinktime" ) then
			timer.Remove( ply:SteamID64() .. " blinktime" )
		end
		ply:playerBlink(nil)
		timer.Create(ply:SteamID64() .. " blinktime", GetConVar("blinking_time"):GetInt(), 0, function()
			ply:playerBlink(nil)
		end)
	end)
end
if CLIENT then
	--local scpblinker
	local function createscpblinker(duration)
		if LocalPlayer():GetActiveWeapon().ISSCP then return end
		if LocalPlayer():Team() == TEAM_SCP or LocalPlayer():Team() == TEAM_SPEC then return end
		if scpblinker then
			scpblinker:Remove()
			scpblinker = nil
		end
		scpblinker = vgui.Create("DPanel")
		scpblinker:SetPos(0,0)
		scpblinker:SetSize(ScrW(),ScrH())
		scpblinker.Paint = function(bt)
			draw.RoundedBox(0,0,0,bt:GetWide(),bt:GetTall(),Color(0,0,0))
		end

		timer.Simple(duration,function()
			if scpblinker then scpblinker:Remove() end
			scpblinker = nil
		end)
	end
	net.Receive("blinking_send",function()
		local newBlinkTime = net.ReadFloat()
		createscpblinker(newBlinkTime)
	end)
	-- Blinking
	local bclicked = false
	hook.Add("Think","Blinking key",function()
		if input.IsKeyDown(KEY_T) then --When we press T...
			if type(input.LookupBinding("br_blink")) == "no value" then  --If the player has not bound br_blink..
				if not bclicked then
					RunConsoleCommand("br_blink") --Blink.
					bclicked = true
				end
			end
		else
			if bclicked then
				bclicked = false
			end
		end
	end)
end
