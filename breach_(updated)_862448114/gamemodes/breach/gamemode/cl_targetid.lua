<<<<<<< HEAD

function GM:HUDDrawTargetID()
	local trace = LocalPlayer():GetEyeTrace()
	if !trace.Hit then return end
	if !trace.HitNonWorld then return end
	
	local text = "ERROR"
	local font = "TargetID"
	local ply =  trace.Entity
	
	if ply:IsPlayer() then
		if ply:Alive() == false then return end
		if ply:GTeam() == TEAM_SPEC then return end
		if ply:GetPos():Distance(LocalPlayer():GetPos()) > 700 then return end
		text = ply:Nick()
	else
		return
	end
	
	local x = ScrW() / 2
	local y = ScrH() / 2 + 30
	
	local clr = gteams.GetColor(ply:GTeam())
	local clr2 = color_white
	
	local vclass = "ERROR"
	
	if not ply.GetNClass then
		player_manager.RunClass( ply, "SetupDataTables" )
	else
		vclass = ply:GetNClass()
		text = GetLangRole(ply:GetNClass())
	end
	
	if ply:GTeam() == TEAM_CHAOS then
		if LocalPlayer():GTeam() == TEAM_CHAOS or LocalPlayer():GTeam() == TEAM_CLASSD then
			tcolor = Color(29, 81, 56)
		else
			if vclass == ROLES.ROLE_CHAOSSPY then
				text = GetLangRole(ROLES.ROLE_MTFGUARD)
			elseif vclass == ROLES.ROLE_CHAOS then
				text = GetLangRole(ROLES.ROLE_MTFNTF)
			elseif vclass == ROLES.ROLE_CHAOSCOM then
				text = GetLangRole(ROLES.ROLE_MTFNTF)
			end
		end
	end
	
	draw.Text( {
		text = ply:Nick() .. " (" .. ply:Health() .. "%)",
		pos = { x, y },
		font = "TargetID",
		color = clr2,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
	
	draw.Text( {
		text = text,
		pos = { x, y + 16 },
		font = "TargetID",
		color = clr,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
end
=======

function GM:HUDDrawTargetID()
	local trace = LocalPlayer():GetEyeTrace()
	if !trace.Hit then return end
	if !trace.HitNonWorld then return end
	
	local text = "ERROR"
	local font = "TargetID"
	local ply =  trace.Entity
	
	if ply:IsPlayer() then
		if ply:Alive() == false then return end
		if ply:GTeam() == TEAM_SPEC then return end
		if ply:GetPos():Distance(LocalPlayer():GetPos()) > 700 then return end
		text = ply:Nick()
	else
		return
	end
	
	local x = ScrW() / 2
	local y = ScrH() / 2 + 30
	
	local clr = gteams.GetColor(ply:GTeam())
	local clr2 = color_white
	
	local vclass = "ERROR"
	
	if not ply.GetNClass then
		player_manager.RunClass( ply, "SetupDataTables" )
	else
		vclass = ply:GetNClass()
		text = GetLangRole(ply:GetNClass())
	end
	
	if ply:GTeam() == TEAM_CHAOS then
		if LocalPlayer():GTeam() == TEAM_CHAOS or LocalPlayer():GTeam() == TEAM_CLASSD then
			tcolor = Color(29, 81, 56)
		else
			if vclass == ROLES.ROLE_CHAOSSPY then
				text = GetLangRole(ROLES.ROLE_MTFGUARD)
			elseif vclass == ROLES.ROLE_CHAOS then
				text = GetLangRole(ROLES.ROLE_MTFNTF)
			elseif vclass == ROLES.ROLE_CHAOSCOM then
				text = GetLangRole(ROLES.ROLE_MTFNTF)
			end
		end
	end
	
	draw.Text( {
		text = ply:Nick() .. " (" .. ply:Health() .. "%)",
		pos = { x, y },
		font = "TargetID",
		color = clr2,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
	
	draw.Text( {
		text = text,
		pos = { x, y + 16 },
		font = "TargetID",
		color = clr,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
end
>>>>>>> origin/kenade-beta
