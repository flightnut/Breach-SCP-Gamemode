
local mply = FindMetaTable( "Player" )

// just for finding a bad spawns :p
function mply:FindClosest(tab, num)
	local allradiuses = {}
	for k,v in pairs(tab) do
		table.ForceInsert(allradiuses, {v:Distance(self:GetPos()), v})
	end
	table.sort( allradiuses, function( a, b ) return a[1] < b[1] end )
	local rtab = {}
	for i=1, num do
		if i <= #allradiuses then
			table.ForceInsert(rtab, allradiuses[i])
		end
	end
	return rtab
end

function mply:GiveRandomWep(tab)
	local mainwep = table.Random(tab)
	self:Give(mainwep)
	local getwep = self:GetWeapon(mainwep)
	if getwep.Primary == nil then
		print("ERROR: weapon: " .. mainwep)
		print(getwep)
		return
	end
	getwep:SetClip1(getwep.Primary.ClipSize)
	self:SelectWeapon(mainwep)
	self:GiveAmmo((getwep.Primary.ClipSize * 4), getwep.Primary.Ammo, false)
end

function mply:ReduceKarma(amount)
	if KarmaEnabled() == false then return end
	self.Karma = math.Clamp((self.Karma - amount), 1, MaxKarma())
end

function mply:AddKarma(amount)
	if KarmaEnabled() == false then return end
	self.Karma = math.Clamp((self.Karma + amount), 1, MaxKarma())
end

function mply:SetKarma(amount)
	if KarmaEnabled() == false then return end
	self.Karma = math.Clamp(amount, 1, MaxKarma())
end

function mply:UpdateNKarma()
	if KarmaEnabled() == false then return end
	if self.SetNKarma != nil then
		self:SetNKarma(self.Karma)
	end
end

function mply:SaveKarma()
	if KarmaEnabled() == false then return end
	if SaveKarma() == false then return end
	self:SetPData( "breach_karma", self.Karma )
end

function mply:GiveNTFwep()
	self:GiveRandomWep({"weapon_chaos_famas", "weapon_mtf_ump45"})
end

function mply:GiveMTFwep()
	self:GiveRandomWep({"weapon_mtf_tmp", "weapon_mtf_ump45", "weapon_mtf_p90"})
end

function mply:GiveCIwep()
	self:GiveRandomWep({"weapon_chaos_famas", "weapon_chaos_ak47", "weapon_chaos_m249"})
end

function mply:DeleteItems()
	for k,v in pairs(ents.FindInSphere( self:GetPos(), 150 )) do
		if v:IsWeapon() then
			if !IsValid(v.Owner) then
				v:Remove()
			end
		end
	end
end

function mply:ApplyArmor(name)
	self.BaseStats = {
		wspeed = self:GetWalkSpeed(),
		rspeed = self:GetRunSpeed(),
		jpower = self:GetJumpPower(),
		 model = self:GetModel()
	}
	local stats = 0.9
	if name == "armor_ntf" then
		self:SetModel("models/player/pmc_4/pmc__07.mdl")
		stats = 0.8
	elseif name == "armor_mtfguard" then
		self:SetModel("models/mtf/mtf remasteredhd.mdl")
		stats = 0.85
	elseif name == "armor_mtfcom" then
		self:SetModel("models/mtf/mtf remasteredhd.mdl")
		stats = 0.9
	elseif name == "armor_mtfl" then
		self:SetModel("models/mw2/skin_04/mw2_soldier_04.mdl")
		stats = 0.85
	elseif name == "armor_mtfmedic" then
		self:SetModel("models/payday2/units/medic_player.mdl")
		stats = 0.9
	elseif name == "armor_security" then
		self:SetModel(table.Random(SECURITYMODELS))
		stats = 0.92
	elseif name == "armor_fireproof" then
		self:SetModel("models/player/kerry/class_securety.mdl")
		stats = 0.9
	elseif name == "armor_chaosins" then
		self:SetModel("models/friskiukas/bf4/us_01.mdl")
		stats = 0.85
	elseif name == "armor_hazmat" then
		self:SetModel("models/player/hazmat/hazmat1980.mdl")
		stats = 0.93
	end
	self:SetWalkSpeed(self.BaseStats.wspeed * stats)
	self:SetRunSpeed(self.BaseStats.rspeed * stats)
	self:SetJumpPower(self.BaseStats.jpower * stats)
	self.UsingArmor = name
end

function mply:UnUseArmor()
	if self.UsingArmor == nil then return end
	self:SetWalkSpeed(self.BaseStats.wspeed)
	self:SetRunSpeed(self.BaseStats.rspeed)
	self:SetJumpPower(self.BaseStats.jpower)
	self:SetModel(self.BaseStats.model)
	local item = ents.Create( self.UsingArmor )
	if IsValid( item ) then
		item:Spawn()
		item:SetPos( self:GetPos() )
		self:EmitSound( Sound("npc/combine_soldier/zipline_clothing".. math.random(1, 2).. ".wav") )
	end
	self.UsingArmor = nil
end

function mply:SetSpectator()
	self:Flashlight( false )
	self:AllowFlashlight( false )
	self.handsmodel = nil
	self:Spectate(6)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SPEC)
	self:SetNoDraw(true)
	if self.SetNClass then
		self:SetNClass(ROLES.ROLE_SPEC)
	end
	self.Active = true
	print("adding " .. self:Nick() .. " to spectators")
	self.canblink = false
	self:SetNoTarget( true )
	self.BaseStats = nil
	self.UsingArmor = nil
	//self:Spectate(OBS_MODE_IN_EYE)
end

function mply:SetSCP173()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_173)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP173)
	self:SetModel("models/breach173.mdl")
	self:SetHealth(2000)
	self:SetMaxHealth(2000)
	self:SetArmor(0)
	self:SetWalkSpeed(350)
	self:SetRunSpeed(350)
	self:SetMaxSpeed(350)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_173")
	self:SelectWeapon("weapon_scp_173")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP106()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_106)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP106)
	self:SetModel("models/vinrax/player/scp106_player.mdl")
	self:SetHealth(2500)
	self:SetMaxHealth(2500)
	self:SetArmor(0)
	self:SetWalkSpeed(175)
	self:SetRunSpeed(175)
	self:SetMaxSpeed(175)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_106")
	self:SelectWeapon("weapon_scp_106")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP049()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_049)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP049)
	self:SetModel("models/vinrax/player/scp049_player.mdl")
	self:SetHealth(1650)
	self:SetMaxHealth(1650)
	self:SetArmor(0)
	self:SetWalkSpeed(130)
	self:SetRunSpeed(130)
	self:SetMaxSpeed(130)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_049")
	self:SelectWeapon("weapon_scp_049")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP457()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_457)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP457)
	self:SetModel("models/player/corpse1.mdl")
	//self:SetMaterial( "models/flesh", false )
	self:SetHealth(2500)
	self:SetMaxHealth(2500)
	self:SetArmor(0)
	self:SetWalkSpeed(135)
	self:SetRunSpeed(135)
	self:SetMaxSpeed(135)
	self:SetJumpPower(190)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_457")
	self:SelectWeapon("weapon_scp_457")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:SetSCP966()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_966)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SCP)
	self:SetNClass(ROLES.ROLE_SCP966)
	self:SetModel("models/immigrant/outlast/walrider_pm.mdl")
	//self:SetMaterial("966black/966black", false)
	self:SetHealth(500)
	self:SetMaxHealth(500)
	self:SetArmor(0)
	self:SetWalkSpeed(150)
	self:SetRunSpeed(150)
	self:SetMaxSpeed(150)
	self:SetJumpPower(190)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_966")
	self:SelectWeapon("weapon_scp_966")
	self.BaseStats = nil
	self.UsingArmor = nil
end

function mply:DropWep(class, clip)
	local wep = ents.Create( class )
	if IsValid( wep ) then
		wep:SetPos( self:GetPos() )
		wep:Spawn()
		if isnumber(clip) then
			wep:SetClip1(clip)
		end
	end
end

function mply:SetSCP0082()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:SetGTeam(TEAM_SCP)
	self:SetModel("models/player/zombie_classic.mdl")
	self:SetHealth(850)
	self:SetMaxHealth(850)
	self:SetArmor(0)
	self:SetWalkSpeed(160)
	self:SetRunSpeed(160)
	self:SetMaxSpeed(160)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self:SetNClass(ROLES.ROLE_SCP0082)
	self.Active = true
	print("adding " .. self:Nick() .. " to zombies")
	self:SetupHands()
	WinCheck()
	self.canblink = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	net.Start("RolesSelected")
	net.Send(self)
	if #self:GetWeapons() > 0 then
		local pos = self:GetPos()
		for k,v in pairs(self:GetWeapons()) do
			local wep = ents.Create( v:GetClass() )
			if IsValid( wep ) then
				wep:SetPos( pos )
				wep:Spawn()
				wep:SetClip1(v:Clip1())
			end
			self:StripWeapon(v:GetClass())
		end
	end
	self:Give("weapon_br_zombie_infect")
	self:SelectWeapon("weapon_br_zombie_infect")
	self.BaseStats = nil
	self.UsingArmor = nil
	self:SetupHands()
end

function mply:SetSCP0492()
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:SetGTeam(TEAM_SCP)
	self:SetModel("models/player/zombie_classic.mdl")
	local hzom = math.Clamp(1000 - (#player.GetAll() * 14), 300, 800)
	self:SetHealth(hzom)
	self:SetMaxHealth(hzom)
	self:SetArmor(0)
	self:SetWalkSpeed(160)
	self:SetRunSpeed(160)
	self:SetMaxSpeed(160)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self:SetNClass(ROLES.ROLE_SCP0492)
	self.Active = true
	print("adding " .. self:Nick() .. " to zombies")
	self:SetupHands()
	WinCheck()
	self.canblink = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	net.Start("RolesSelected")
	net.Send(self)
	if #self:GetWeapons() > 0 then
		local pos = self:GetPos()
		for k,v in pairs(self:GetWeapons()) do
			local wep = ents.Create( v:GetClass() )
			if IsValid( wep ) then
				wep:SetPos( pos )
				wep:Spawn()
				wep:SetClip1(v:Clip1())
			end
			self:StripWeapon(v:GetClass())
		end
	end
	self:Give("weapon_br_zombie")
	self:SelectWeapon("weapon_br_zombie")
	self.BaseStats = nil
	self.UsingArmor = nil
	self:SetupHands()
end

function mply:SetupNormal()
	self.BaseStats = nil
	self.UsingArmor = nil
	self:UnSpectate()
	self:Spawn()
	self:GodDisable()
	self:SetNoDraw(false)
	self:SetNoTarget(false)
	self:SetupHands()
	self:RemoveAllAmmo()
	self:StripWeapons()
	self.canblink = true
end

function mply:ApplyRoleStats(role)
	self:SetNClass(role.name)
	self:SetGTeam(role.team)
	for k,v in pairs(role.weapons) do
		self:Give(v)
	end
	for k,v in pairs(role.ammo) do
		self:GiveAmmo(v[2],v[1], false)
	end
	self:SetHealth(role.health)
	self:SetWalkSpeed(100 * role.walkspeed)
	self:SetRunSpeed(210 * role.runspeed)
	self:SetJumpPower(190 * role.jumppower)
	self:SetModel( table.Random(role.models) )
	self:Flashlight( false )
	self:AllowFlashlight( role.flashlight )
	if role.vest != nil then
		self:ApplyArmor(role.vest)
	end
	if role.pmcolor != nil then
		self:SetPlayerColor(Vector(role.pmcolor.r / 255, role.pmcolor.g / 255, role.pmcolor.b / 255))
	end
	net.Start("RolesSelected")
	net.Send(self)
	self:SetupHands()
end

function mply:SetSecurityI1()
	local thebestone = nil
	local usechaos = false
	if math.random(1,6) == 6 then usechaos = true end
	for k,v in pairs(ALLCLASSES["security"]["roles"]) do
		if v.importancelevel == 1 then
			local skip = false
			if usechaos == true then
				if v.team == TEAM_GUARD then
					skip = true
				end
			else
				if v.team == TEAM_CHAOS then
					skip = true
				end
			end
			if skip == false then
				local can = true
				if v.customcheck != nil then
					if v.customcheck(self) == false then
						can = false
					end
				end
				local using = 0
				for _,pl in pairs(player.GetAll()) do
					if pl:GetNClass() == v.name then
						using = using + 1
					end
				end
				if using >= v.max then can = false end
				if can == true then
					if self:GetLevel() >= v.level then
						if thebestone != nil then
							if thebestone.sorting < v.sorting then
								thebestone = v
							end
						else
							thebestone = v
						end
					end
				end
			end
		end
	end
	if thebestone == nil then
		thebestone = ALLCLASSES["security"]["roles"][1]
	end
	self:SetupNormal()
	self:ApplyRoleStats(thebestone)
end

function mply:SetClassD()
	self:SetRoleBestFrom("classds")
end

function mply:SetResearcher()
	self:SetRoleBestFrom("researchers")
end

function mply:SetRoleBestFrom(role)
	local thebestone = nil
	for k,v in pairs(ALLCLASSES[role]["roles"]) do
		local can = true
		if v.customcheck != nil then
			if v.customcheck(self) == false then
				can = false
			end
		end
		local using = 0
		for _,pl in pairs(player.GetAll()) do
			if pl:GetNClass() == v.name then
				using = using + 1
			end
		end
		if using >= v.max then can = false end
		if can == true then
			if self:GetLevel() >= v.level then
				if thebestone != nil then
					if thebestone.level < v.level then
						thebestone = v
					end
				else
					thebestone = v
				end
			end
		end
	end
	if thebestone == nil then
		thebestone = ALLCLASSES[role]["roles"][1]
	end
	self:SetupNormal()
	self:ApplyRoleStats(thebestone)
end

function mply:IsActivePlayer()
	return self.Active
end

hook.Add( "KeyPress", "keypress_spectating", function( ply, key )
	if ply:GTeam() != TEAM_SPEC then return end
	if ( key == IN_ATTACK ) then
		ply:SpectatePlayerLeft()
	elseif ( key == IN_ATTACK2 ) then
		ply:SpectatePlayerRight()
	elseif ( key == IN_RELOAD ) then
		ply:ChangeSpecMode()
	end
end )

function mply:SpectatePlayerRight()
	if !self:Alive() then return end
	if self:GetObserverMode() != OBS_MODE_IN_EYE and
	   self:GetObserverMode() != OBS_MODE_CHASE 
	then return end
	self:SetNoDraw(true)
	local allply = GetAlivePlayers()
	if #allply == 1 then return end
	if not self.SpecPly then
		self.SpecPly = 0
	end
	self.SpecPly = self.SpecPly - 1
	if self.SpecPly < 1 then
		self.SpecPly = #allply 
	end
	for k,v in pairs(allply) do
		if k == self.SpecPly then
			self:SpectateEntity( v )
		end
	end
end

function mply:SpectatePlayerLeft()
	if !self:Alive() then return end
	if self:GetObserverMode() != OBS_MODE_IN_EYE and
	   self:GetObserverMode() != OBS_MODE_CHASE 
	then return end
	self:SetNoDraw(true)
	local allply = GetAlivePlayers()
	if #allply == 1 then return end
	if not self.SpecPly then
		self.SpecPly = 0
	end
	self.SpecPly = self.SpecPly + 1
	if self.SpecPly > #allply then
		self.SpecPly = 1
	end
	for k,v in pairs(allply) do
		if k == self.SpecPly then
			self:SpectateEntity( v )
		end
	end
end

function mply:ChangeSpecMode()
	if !self:Alive() then return end
	if !(self:GTeam() == TEAM_SPEC) then return end
	self:SetNoDraw(true)
	local m = self:GetObserverMode()
	local allply = #GetAlivePlayers()
	if allply < 2 then
		self:Spectate(OBS_MODE_ROAMING)
		return
	end
	/*
	if m == OBS_MODE_CHASE then
		self:Spectate(OBS_MODE_IN_EYE)
	else
		self:Spectate(OBS_MODE_CHASE)
	end
	*/
	
	if m == OBS_MODE_IN_EYE then
		self:Spectate(OBS_MODE_CHASE)
		self:SpectatePlayerLeft()
	elseif m == OBS_MODE_CHASE then
		self:Spectate(OBS_MODE_ROAMING)
	elseif m == OBS_MODE_ROAMING then
		self:Spectate(OBS_MODE_IN_EYE)
		self:SpectatePlayerLeft()
	else
		self:Spectate(OBS_MODE_ROAMING)
	end
	
end

function mply:SaveExp()
	self:SetPData( "breach_exp", self:GetExp() )
end

function mply:SaveLevel()
	self:SetPData( "breach_level", self:GetLevel() )
end

function mply:AddExp(amount, msg)
	amount = amount * GetConVar("br_expscale"):GetInt()
	if self.Member == true then amount = amount * 1.15 end
	amount = math.Round(amount)
	if not self.GetNEXP then
		player_manager.RunClass( self, "SetupDataTables" )
	end
	if self.GetNEXP and self.SetNEXP then
		self:SetNEXP( self:GetNEXP() + amount )
		if msg != nil then
			self:PrintMessage(HUD_PRINTTALK, "LevelS: Earned " .. amount .. " Experience, your EXP now: " .. self:GetNEXP())
		else
			self:PrintMessage(HUD_PRINTCONSOLE, "LevelS: Earned " .. amount .. " Experience, your EXP now: " .. self:GetNEXP())
		end
		local xp = self:GetNEXP()
		local lvl = self:GetNLevel()
		if lvl == 0 then
			if xp >= 3000 then
				self:AddLevel(1)
				self:SetNEXP(xp - 3000)
				self:SaveLevel()
				PrintMessage(HUD_PRINTTALK, self:Nick() .. " reached level 1! Congratulations!")
			end
		elseif lvl == 1 then
			if xp >= 5000 then
				self:AddLevel(1)
				self:SetNEXP(xp - 5000)
				self:SaveLevel()
				PrintMessage(HUD_PRINTTALK, self:Nick() .. " reached level 2! Congratulations!")
			end
		elseif lvl == 2 then
			if xp >= 7500 then
				self:AddLevel(1)
				self:SetNEXP(xp - 7500)
				self:SaveLevel()
				PrintMessage(HUD_PRINTTALK, self:Nick() .. " reached level 3! Congratulations!")
			end
		elseif lvl == 3 then
			if xp >= 11000 then
				self:AddLevel(1)
				self:SetNEXP(xp - 11000)
				self:SaveLevel()
				PrintMessage(HUD_PRINTTALK, self:Nick() .. " reached level 4! Congratulations!")
			end
		elseif lvl == 4 then
			if xp >= 14000 then
				self:AddLevel(1)
				self:SetNEXP(xp - 14000)
				self:SaveLevel()
				PrintMessage(HUD_PRINTTALK, self:Nick() .. " reached level 5! Congratulations!")
			end
		elseif lvl == 5 then
			if xp >= 25000 then
				self:AddLevel(1)
				self:SetNEXP(xp - 25000)
				self:SaveLevel()
				PrintMessage(HUD_PRINTTALK, self:Nick() .. " reached level OMNI! Congratulations!")
			end
		elseif lvl == 6 then
			if xp >= 100000 then
				self:AddLevel(1)
				self:SetNEXP(xp - 100000)
				self:SaveLevel()
				PrintMessage(HUD_PRINTTALK, self:Nick() .. " is a now a Veteran! Congratulations!")
			end
		elseif lvl > 6 then
			if xp >= 20000 then
				self:AddLevel(1)
				self:SetNEXP(xp - 20000)
				self:SaveLevel()
				PrintMessage(HUD_PRINTTALK, self:Nick() .. " reached level "..lvl.."! Congratulations!")
			end
		end
		self:SetPData( "breach_exp", self:GetExp() )
	else
		if self.SetNEXP then
			self:SetNEXP( 0 )
		else
			ErrorNoHalt( "Cannot set the exp, SetNEXP invalid" )
		end
	end
end

function mply:AddLevel(amount)
	if not self.GetNLevel then
		player_manager.RunClass( self, "SetupDataTables" )
	end
	if self.GetNLevel and self.SetNLevel then
		self:SetNLevel( self:GetNLevel() + amount )
		self:SetPData( "breach_level", self:GetNLevel() )
	else
		if self.SetNLevel then
			self:SetNLevel( 0 )
		else
			ErrorNoHalt( "Cannot set the exp, SetNLevel invalid" )
		end
	end
end


function mply:SetRoleName(name)
	local rl = nil
	for k,v in pairs(ALLCLASSES) do
		for _,role in pairs(v.roles) do
			if role.name == name then
				rl = role
			end
		end
	end
	if rl != nil then
		self:ApplyRoleStats(rl)
	end
end

