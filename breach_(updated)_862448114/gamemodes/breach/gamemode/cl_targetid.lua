
function GM:HUDDrawTargetID()
	local trace = LocalPlayer():GetEyeTrace()
	if !trace.Hit then return end
	if !trace.HitNonWorld then return end

	--local text = "ERROR"
	local font = "TargetID"
	local ply =  trace.Entity
	local targetIDtxt = "" --Just, don't render it ok thx.

	local clr = Color(255,255,255) --Default value
	local clr2 = Color(255,255,255) --default value
	--Player code here

	if ply:IsPlayer() then --Player
		if ply:Alive() == false then return end
		if ply.IsGhost then
			if ply:Team() == TEAM_SPEC and !ply:IsGhost() then 
				return
			end --Target is NOT a ghost (in SpecDM) But is a spectator, Return.
			if (LocalPlayer():Team() == TEAM_SPEC and !LocalPlayer():IsGhost()) and (ply:Team() == TEAM_SPEC and ply:IsGhost()) then
				return --LocalPlayer is NOT a ghost (not in SpecDM) but Target was, Return
			end
		else
			if ply:Team() == TEAM_SPEC then return end -- i was scared ok?
		end
		if ply:GetPos():Distance(LocalPlayer():GetPos()) > 700 then return end
		targetIDtxt = ply:Nick()
		--text = ply:Nick()
	elseif ply:GetClass() == 'prop_dynamic' then --Gate A/B
		if ply:GetPos():Distance(LocalPlayer():GetPos()) > 1400 then return end --Don't show Gate Health after 1400 units
		if string.lower(ply:GetModel()) == 'models/foundation/containment/door01.mdl' then
			if ply:Health() >= 1 then
				targetIDtxt = "Gate door health: "..ply:Health()
			end
		else
			return --Don't render anything
		end
	else
		return
	end

	local x = ScrW() / 2
	local y = ScrH() / 2 + 30

	if ply:IsPlayer() then
		clr = self:GetTeamColor( ply )
		clr2 = team.GetColor(ply:Team())

		if not ply.GetNClass then
			player_manager.RunClass( ply, "SetupDataTables" )
		--else
			--text = ply:GetNClass()
		end
		if LocalPlayer():Team() == TEAM_CHAOS or LocalPlayer():Team() == TEAM_CLASSD then
			if ply:Team() == TEAM_CHAOS then
				--text = "Chaos Insurgency"
				clr2 = Color(29, 81, 56)
			end
		end

	end

	draw.Text( {
		text = targetIDtxt, --.. " (" .. ply:Health() .. "%)",
		pos = { x, y },
		font = "TargetID",
		color = clr2,
		--color = team.GetColor(ply:Team())
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	} )
--[[--
	draw.Text( {
		text = text,
		pos = { x, y + 16 },
		font = "TargetID",
		color = clr,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
--]]--
end
