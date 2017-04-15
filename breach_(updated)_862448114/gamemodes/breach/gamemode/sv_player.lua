
local mply = FindMetaTable( "Player" )

--For SpecDM
function mply:IsActive()
	return self:Team() ~= TEAM_SCP
end

-- just for finding a bad spawns :p
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

function mply:MTFArmor()
	self.BaseStats = {
		wspeed = self:GetWalkSpeed(),
		rspeed = self:GetRunSpeed(),
		jpower = self:GetJumpPower(),
		 model = "models/player/kerry/class_scientist_"..math.random(1,7)..".mdl"
	}
	self:SetWalkSpeed(self.BaseStats.wspeed * 0.85)
	self:SetRunSpeed(self.BaseStats.rspeed * 0.85)
	self:SetJumpPower(self.BaseStats.jpower * 0.85)
	self:SetModel("models/player/kerry/class_securety.mdl")
	self.UsingArmor = "armor_mtfguard"
end

function mply:MTFComArmor()
	self.BaseStats = {
		wspeed = self:GetWalkSpeed(),
		rspeed = self:GetRunSpeed(),
		jpower = self:GetJumpPower(),
		 model = "models/player/kerry/class_scientist_"..math.random(1,7)..".mdl"
	}
	self:SetWalkSpeed(self.BaseStats.wspeed * 0.90)
	self:SetRunSpeed(self.BaseStats.rspeed * 0.90)
	self:SetJumpPower(self.BaseStats.jpower * 0.90)
	--self:SetModel("models/player/riot.mdl")
	self:SetModel("models/player/kerry/class_securety_2.mdl")
	self.UsingArmor = "armor_mtfcom"
end

function mply:NTFArmor()
	self.BaseStats = {
		wspeed = self:GetWalkSpeed(),
		rspeed = self:GetRunSpeed(),
		jpower = self:GetJumpPower(),
		 model = "models/player/kerry/class_scientist_"..math.random(1,7)..".mdl"
	}
	self:SetWalkSpeed(self.BaseStats.wspeed * 0.85)
	self:SetRunSpeed(self.BaseStats.rspeed * 0.85)
	self:SetJumpPower(self.BaseStats.jpower * 0.85)
	--self:SetModel("models/player/urban.mdl")
	self:SetModel("models/player/kerry/ntf.mdl")
	self.UsingArmor = "armor_ntf"
end

function mply:ChaosInsArmor()
	self.BaseStats = {
		wspeed = self:GetWalkSpeed(),
		rspeed = self:GetRunSpeed(),
		jpower = self:GetJumpPower(),
		 model = "models/player/kerry/class_scientist_"..math.random(1,7)..".mdl"
	}
	self:SetWalkSpeed(self.BaseStats.wspeed * 0.86)
	self:SetRunSpeed(self.BaseStats.rspeed * 0.86)
	self:SetJumpPower(self.BaseStats.jpower * 0.86)
	--self:SetModel("models/mw2/skin_04/mw2_soldier_04.mdl")
	self:SetModel("models/mw2/skin_05/mw2_soldier_04.mdl")
	self.UsingArmor = "armor_chaosins"
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
	self.handsmodel = nil
	self:DropObject() --Drop the object they're holding (i.e. The stupidly OP melon), Link2006's fix.
	self:Spectate(6)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetTeam(TEAM_SPEC)
	self:SetNoDraw(true)
	if self.SetNClass then
		self:SetNClass(ROLE_SPEC)
	end
	self.Active = true
	print("adding " .. self:Nick() .. " to spectators")
	self.canblink = false
	self:AllowFlashlight( false )
	self:SetNoTarget( true )
	self.BaseStats = nil
	self.UsingArmor = nil
	//self:Spectate(OBS_MODE_IN_EYE)
	self:SetNoCollideWithTeammates(true)
	--Set player's model to scale
	self:SetModelScale(1.0,0)
end

function mply:SetSCP1048a()
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_173 + Vector(0, 30, 0))
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetTeam(TEAM_SCP)
	self:SetNClass(ROLE_SCP1048A)
	self:SetModel("models/player/mrsilver/SCP-1048-A.mdl")
	self:SetHealth(500)
	self:SetMaxHealth(500)
	self:SetArmor(0)
	self:SetWalkSpeed(100)
	self:SetRunSpeed(180)
	self:SetMaxSpeed(180)
	self:SetJumpPower(250)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_1048a")
	self:SelectWeapon("weapon_scp_1048a")
	self.BaseStats = nil
	self.UsingArmor = nil
	self:SetNoCollideWithTeammates(false)
	--Set player's model to scale
	self:SetModelScale(1.0,0)
	--ForceShow the objectives for the current player. (Link2006)
	net.Start("RolesSelected")
	net.Send(self)
end

function mply:SetSCP035()
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_035)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetTeam(TEAM_SCP)
	self:SetNClass(ROLE_SCP035)
	self:SetModel("models/vinrax/player/035_player.mdl")
	self:SetHealth(350)
	self:SetMaxHealth(350)
	self:SetArmor(0)
	self:SetWalkSpeed(140)
	self:SetRunSpeed(235)
	self:SetMaxSpeed(235)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self.canblink = false
	self:AllowFlashlight( true )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	timer.Create( "035weps", 5, 1, function()
	if self:GetNClass() == ROLE_SCP035 then
	--self:GiveNTFwep()
	self:Give("weapon_mtf_deagle") --YOU GET A DEAGLE INSTEAD. >:(
	--self:GiveAmmo(450, "SMG1", true) --No.
	--self:GiveAmmo(450, "AR2", true) -- Nope.
	self:GiveAmmo(1000, "Pistol") --Yes.
	self:Give("weapon_crowbar")
	self:Give("keycard_level3")
	self:Give("item_radio")
	self:Give("nightvision") --Give Nightvision to 035 :)
	self:SelectWeapon("weapon_mtf_deagle")
	end
	end)
	self:SetupHands()
	self.BaseStats = nil
	self.UsingArmor = nil
	self:SetNoCollideWithTeammates(false)
	--Set player's model to scale
	self:SetModelScale(1.0,0)
	--ForceShow the objectives for the current player. (Link2006)
	net.Start("RolesSelected")
	net.Send(self)
end

function mply:SetClassD()
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetTeam(TEAM_CLASSD)
	self:SetModel("models/player/kerry/class_d_"..math.random(1,7)..".mdl")
	self:SetHealth(100)
	self:SetMaxHealth(100)
	self:SetArmor(0)
	self:SetWalkSpeed(120)
	self:SetRunSpeed(240)
	self:SetMaxSpeed(240)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self:SetNClass(ROLE_CLASSD)
	self.Active = true
	self:SetupHands()
	self.canblink = true
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_CLASSD
	self:SetNoTarget( false )
	self.BaseStats = nil
	self.UsingArmor = nil
	self:SetNoCollideWithTeammates(true)
	--Set player's model to scale
	self:SetModelScale(1.0,0)
	--ForceShow the objectives for the current player. (Link2006)
	net.Start("RolesSelected")
	net.Send(self)
end

function mply:SetScientist()
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetTeam(TEAM_SCI)
	self:SetModel("models/player/kerry/class_scientist_"..math.random(1,7)..".mdl")
	self:SetHealth(100)
	self:SetMaxHealth(100)
	self:SetArmor(0)
	self:SetWalkSpeed(120)
	self:SetRunSpeed(240)
	self:SetMaxSpeed(240)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self:SetNClass(ROLE_RES)
	self.Active = true
	self:SetupHands()
	self.canblink = true
	self:AllowFlashlight( true )
	self.WasTeam = TEAM_SCI
	self:SetNoTarget( false )
	self:Give("keycard_level2")
	self.BaseStats = nil
	self.UsingArmor = nil
	self:SetNoCollideWithTeammates(true)
	--Set player's model to scale
	self:SetModelScale(1.0,0)
	--ForceShow the objectives for the current player. (Link2006)
	net.Start("RolesSelected")
	net.Send(self)
end

function mply:SetCommander()
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetTeam(TEAM_GUARD)
	//self:SetModel("models/player/riot.mdl")
	self:SetHealth(100)
	self:SetMaxHealth(100)
	self:SetWalkSpeed(120)
	self:SetRunSpeed(240)
	self:SetMaxSpeed(240)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self:SetNClass(ROLE_MTFCOM)
	self.Active = true
	self:Give("keycard_level4")
	self:Give("item_medkit")
	self:Give("weapon_stunstick")
	self:Give("weapon_mtf_mp5")
	self:Give("item_radio")
	self:Give("nightvision")
	self:GetWeapon("weapon_mtf_mp5"):SetClip1(30)
	self:SelectWeapon("weapon_mtf_mp5")
	self:GiveAmmo(150, "SMG1", false)
	self:SetupHands()
	self.canblink = true
	self:AllowFlashlight( true )
	self.WasTeam = TEAM_GUARD
	self:SetNoTarget( false )
	self:MTFComArmor()
	self:SetNoCollideWithTeammates(false)
	--Set player's model to scale
	self:SetModelScale(1.0,0)
	--ForceShow the objectives for the current player. (Link2006)
	net.Start("RolesSelected")
	net.Send(self)
end

function mply:SetGuard()
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetTeam(TEAM_GUARD)
	//self:SetModel("models/player/swat.mdl")
	self:SetHealth(100)
	self:SetMaxHealth(100)
	self:SetWalkSpeed(120)
	self:SetRunSpeed(240)
	self:SetMaxSpeed(240)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self:SetNClass(ROLE_MTFGUARD)
	self.Active = true
	self:Give("keycard_level3")
	self:Give("weapon_stunstick")
	self:Give("item_radio")
	self:GiveMTFwep()
	self:SetupHands()
	//PrintTable(debug.getinfo( self.SetupHands ))
	self.canblink = true
	self:AllowFlashlight( true )
	self.WasTeam = TEAM_GUARD
	self:SetNoTarget( false )
	self:MTFArmor()
	self:SetNoCollideWithTeammates(false)
	--Set player's model to scale
	self:SetModelScale(1.0,0)
	--ForceShow the objectives for the current player. (Link2006)
	net.Start("RolesSelected")
	net.Send(self)
end

function mply:SetChaosInsurgency(stealth)
	self.handsmodel = {
		model = "models/weapons/c_arms_cstrike.mdl",
		body = 10000000,
		skin = 0
	}
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetTeam(TEAM_CHAOS)
	self:SetHealth(100)
	self:SetMaxHealth(100)
	self:SetArmor(25)
	self:SetWalkSpeed(120)
	self:SetRunSpeed(240)
	self:SetMaxSpeed(240)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:Give("weapon_slam")
	self:Give("weapon_stunstick")
	self:Give("item_radio")
	self:Give("nightvision")
	if stealth == 1 then
		//self:SetModel("models/player/swat.mdl")
		self:MTFArmor()
		self:Give("keycard_level3")
		self:GiveMTFwep()
		self:SetNClass(ROLE_MTFGUARD)
	elseif stealth == 2 then
		//self:SetModel("models/player/urban.mdl")
		self:NTFArmor()
		self:Give("keycard_level4")
		self:GiveNTFwep()
		self:SetNClass(ROLE_MTFNTF)
	else
		self:GiveCIwep()
		self:Give("keycard_omni")
		//self:SetModel("models/mw2/skin_04/mw2_soldier_04.mdl")
		self:ChaosInsArmor()
		if stealth == 3 then
			self:SetNClass(ROLE_MTFNTF)
		else
			self:SetNClass(ROLE_CHAOS)
		end
	end
	self:SetupHands()
	self.canblink = true
	self:AllowFlashlight( true )
	self.WasTeam = TEAM_CHAOS
	self:SetNoTarget( false )
	self:SetNoCollideWithTeammates(false)
	--Set player's model to scale
	self:SetModelScale(1.0,0)
	--ForceShow the objectives for the current player. (Link2006)
	net.Start("RolesSelected")
	net.Send(self)
end

function mply:SetChaosInsCom(spawn)
	self.handsmodel = {
		model = "models/weapons/c_arms_cstrike.mdl",
		body = 10000000,
		skin = 0
	}
	self:UnSpectate()
	self:GodDisable()
	local lpos = self:GetPos()
	if spawn == true then
		self:Spawn()
		self:SetPos(lpos)
	else
		self:Spawn()
	end
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetTeam(TEAM_CHAOS)
	self:SetHealth(100)
	self:SetMaxHealth(100)
	self:SetArmor(25)
	self:SetWalkSpeed(135)
	self:SetRunSpeed(255)
	self:SetMaxSpeed(255)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:Give("weapon_slam")
	self:Give("weapon_stunstick")
	self:Give("item_radio")
	self:Give("keycard_omni")
	self:GiveCIwep()
	self:SetModel("models/mw2/skin_05/mw2_soldier_04.mdl")
	self:SetBodyGroups( "1411" )
	self:SetupHands()
	self.canblink = true
	self:AllowFlashlight( true )
	self.WasTeam = TEAM_CHAOS
	self:SetNClass(ROLE_CHAOSCOM)
	self:SetNoTarget( false )
	self:SetNoCollideWithTeammates(false)
	--Set player's model to scale
	self:SetModelScale(1.0,0)
	--ForceShow the objectives for the current player. (Link2006)
	net.Start("RolesSelected")
	net.Send(self)
end

function mply:SetSiteDirector(spawn)
	self:UnSpectate()
	self:GodDisable()
	local lpos = self:GetPos()
	if spawn == true then
		self:Spawn()
		self:SetPos(lpos)
	else
		self:Spawn()
	end
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetTeam(TEAM_GUARD)
	self:SetHealth(100)
	self:SetMaxHealth(100)
	self:SetWalkSpeed(135)
	self:SetRunSpeed(255)
	self:SetMaxSpeed(255)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self.Active = true
	self:Give("item_radio")
	self:Give("keycard_level5")
	self:Give("weapon_mtf_deagle")
	self:GiveAmmo(35, "Pistol", false)
	self:SetModel("models/player/breen.mdl")
	self:SetPlayerColor( Vector(0,0,0) )
	self:SetupHands()
	self.canblink = true
	self:AllowFlashlight( true )
	self.WasTeam = TEAM_GUARD
	self:SetNClass(ROLE_SITEDIRECTOR)
	self:SetNoTarget( false )
	self:SetNoCollideWithTeammates(false)
	--Set player's model to scale
	self:SetModelScale(1.0,0)
	--ForceShow the objectives for the current player. (Link2006)
	net.Start("RolesSelected")
	net.Send(self)
end

function mply:SetNTF()
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetTeam(TEAM_GUARD)
	self:SetModel("models/player/urban.mdl")
	self:SetHealth(100)
	self:SetMaxHealth(100)
	self:SetArmor(25)
	self:SetWalkSpeed(120)
	self:SetRunSpeed(240)
	self:SetMaxSpeed(240)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self:SetNClass(ROLE_MTFNTF)
	self.Active = true
	self:Give("keycard_level4")
	self:Give("weapon_stunstick")
	self:Give("item_radio")
	self:Give("nightvision")
	self:GiveNTFwep()
	self:SetupHands()
	self.canblink = true
	self:AllowFlashlight( true )
	self.WasTeam = TEAM_GUARD
	self:SetNoTarget( false )
	net.Start("RolesSelected")
	net.Send(self)
	self:NTFArmor()
	self:SetNoCollideWithTeammates(false)
	--Set player's model to scale
	self:SetModelScale(1.0,0)
end

function mply:SetSCP173()
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_173)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetTeam(TEAM_SCP)
	self:SetNClass(ROLE_SCP173)
	self:SetModel("models/breach173.mdl")
	self:SetHealth(1700)
	self:SetMaxHealth(1700)
	self:SetArmor(0)
	self:SetJumpPower(175)
	self:SetWalkSpeed(500)
	self:SetRunSpeed(500)
	self:SetMaxSpeed(500)
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
	self:SetNoCollideWithTeammates(false)
	--Set player's model to scale
	self:SetModelScale(1.0,0)
	--ForceShow the objectives for the current player. (Link2006)
	net.Start("RolesSelected")
	net.Send(self)
end

function mply:SetSCP106()
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_106)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetTeam(TEAM_SCP)
	self:SetNClass(ROLE_SCP106)
	self:SetModel("models/vinrax/player/scp106_player.mdl")
	self:SetHealth(1700)
	self:SetMaxHealth(1700)
	self:SetArmor(0)
	self:SetWalkSpeed(165)
	self:SetRunSpeed(165)
	self:SetMaxSpeed(165)
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
	self:SetNoCollideWithTeammates(false)
	--Set player's model to scale
	self:SetModelScale(1.0,0)
	--ForceShow the objectives for the current player. (Link2006)
	net.Start("RolesSelected")
	net.Send(self)
end

function mply:SetSCP049()
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_049)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetTeam(TEAM_SCP)
	self:SetNClass(ROLE_SCP049)
	self:SetModel("models/vinrax/player/scp049_player.mdl")
	self:SetHealth(1400)
	self:SetMaxHealth(1400)
	self:SetArmor(0)
	self:SetWalkSpeed(140)
	self:SetRunSpeed(140)
	self:SetMaxSpeed(140)
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
	self:SetNoCollideWithTeammates(false)
	--Set player's model to scale
	self:SetModelScale(1.0,0)
	--ForceShow the objectives for the current player. (Link2006)
	net.Start("RolesSelected")
	net.Send(self)
end

--New SCP: 682

function mply:SetSCP682()
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_682) --TODO: Add Spawn position (MapConfig )
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetTeam(TEAM_SCP)
	self:SetNClass(ROLE_SCP682) --TODO: Add Role682 (Roles )
	self:SetModel("models/cultist_kun/scp_crock.mdl")
	self:SetHealth(25000)
	self:SetMaxHealth(25000)
	self:SetArmor(0)
	--Weapon overrides this.
	self:SetWalkSpeed(60)
	self:SetRunSpeed(60)
	self:SetMaxSpeed(60)
	self:SetJumpPower(0)
	self:SetNoDraw(false)
	self.Active = true
	self:SetupHands()
	self.canblink = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	self:Give("weapon_scp_682")
	self:SelectWeapon("weapon_scp_682")
	self.BaseStats = nil
	self.UsingArmor = nil
	self:SetNoCollideWithTeammates(false)
	--Set player's model to scale
	self:SetModelScale(0.75,0)
	--ForceShow the objectives for the current player. (Link2006)
	net.Start("RolesSelected")
	net.Send(self)
end

function mply:SetSCP457()
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:Spawn()
	self:SetPos(SPAWN_457)
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetTeam(TEAM_SCP)
	self:SetNClass(ROLE_SCP457)
	self:SetModel("models/player/corpse1.mdl")
	//self:SetMaterial( "models/flesh", false )
	self:SetHealth(2000)
	self:SetMaxHealth(2000)
	self:SetArmor(0)
	self:SetWalkSpeed(175)
	self:SetRunSpeed(200)
	self:SetMaxSpeed(200)
	self:SetJumpPower(215)
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
	self:SetNoCollideWithTeammates(false)
	--Set player's model to scale
	self:SetModelScale(1.0,0)
	--ForceShow the objectives for the current player. (Link2006)
	net.Start("RolesSelected")
	net.Send(self)
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
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:SetTeam(TEAM_SCP)
	print("SCP-008-2 on \""..self:Nick().."\" with model \""..self:GetModel().."\"")
	if string.match(self:GetModel(),"models/player/kerry/class_d_%d.mdl",0) then --Should only replace when
		local newModel = string.Replace(self:GetModel(),"models/player/kerry/class_d_","models/player/kerry/class_d_zombie_")
		print(newModel)
		self:SetModel(newModel)
	elseif string.match(self:GetModel(),"models/player/kerry/class_scientist_%d.mdl",0) then
		local newModel = string.Replace(self:GetModel(),"models/player/kerry/class_scientist_","models/player/kerry/class_c_zombie_")
		print(newModel)
		self:SetModel(newModel)
	elseif self:GetModel() == "models/player/kerry/class_securety_2.mdl" then
		print("Commander Into Zombie!")
		self:SetModel("models/player/kerry/class_securety_zombie.mdl")
	elseif self:GetModel() == "models/player/kerry/class_securety.mdl" then
		--MTF
		print("MTF Into zombie")
		self:SetModel("models/player/kerry/class_securety_zombie.mdl")
	elseif self:GetModel() == "models/player/kerry/ntf.mdl" then
		--NTF
		print("NTF Into zombie")
		--self:SetModel("models/player/kerry/class_securety_zombie.mdl")
		self:SetModel('models/player/kerry/ntf_z.mdl') --New Zombie model for NTF :)
	elseif self:GetModel() == "models/mw2/skin_04/mw2_soldier_04.mdl" then
		--Chaos!
		print("Chaos into zombie")
		self:SetModel("models/player/kerry/class_securety_zombie.mdl")
	else
		print("UNKNOWN MODEL, Setting to zombie_classic!")
		--TODO: maybe actually choose a random model instead of this?
		--		i'll keep this for now though.
		self:SetModel("models/player/zombie_classic.mdl")
	end
	self:SetHealth(425)
	self:SetMaxHealth(425)
	self:SetArmor(0)
	self:SetWalkSpeed(160)
	self:SetRunSpeed(160)
	self:SetMaxSpeed(160)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self:SetNClass(ROLE_SCP0082)
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
	self:SetNoCollideWithTeammates(true)
	--Set player's model to scale
	self:SetModelScale(1.0,0)
end

function mply:SetSCP0492()
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	self:SetTeam(TEAM_SCP)
	--TODO: If Model name starts with ClassD's model, then ClassD zombie
	--		elseif model name starts with Researcher model, then Researcher zombie
	--		elseif model name starts with MTF model, then MTF zombie
	--		elseif model name starts with NTF model, then MTF zombie - TEMPORARY UNTIL WE GET NTF AND CHAOS
	--		elseif model name starts with CHAOS model, then MTF zombies - TEMPORARY ^
	--		else model sets to zombie_classic (NO MODEL AVAILABLE?)
	print("SCP-049-2 on \""..self:Nick().."\" with model \""..self:GetModel().."\"")
	if string.match(self:GetModel(),"models/player/kerry/class_d_%d.mdl",0) then --Should only replace when
		local newModel = string.Replace(self:GetModel(),"models/player/kerry/class_d_","models/player/kerry/class_d_zombie_")
		print(newModel)
		self:SetModel(newModel)
	elseif string.match(self:GetModel(),"models/player/kerry/class_scientist_%d.mdl",0) then
		local newModel = string.Replace(self:GetModel(),"models/player/kerry/class_scientist_","models/player/kerry/class_c_zombie_")
		print(newModel)
		self:SetModel(newModel)
	elseif self:GetModel() == "models/player/kerry/class_securety_2.mdl" then
		print("Commander Into Zombie!")
		self:SetModel("models/player/kerry/class_securety_zombie.mdl")
	elseif self:GetModel() == "models/player/kerry/class_securety.mdl" then
		--MTF
		print("MTF Into zombie")
		self:SetModel("models/player/kerry/class_securety_zombie.mdl")
	elseif self:GetModel() == "models/player/kerry/ntf.mdl" then
		--NTF
		print("NTF Into zombie")
		--self:SetModel("models/player/kerry/class_securety_zombie.mdl")
		self:SetModel('models/player/kerry/ntf_z.mdl') --New Zombie model for NTF :)
	elseif self:GetModel() == "models/mw2/skin_05/mw2_soldier_04.mdl" then
		--Chaos!
		print("Chaos into zombie")
		self:SetModel("models/player/kerry/class_securety_zombie.mdl")
	else
		print("UNKNOWN MODEL, Setting to zombie_classic!")
		--TODO: maybe actually choose a random model instead of this?
		--		i'll keep this for now though.
		self:SetModel("models/player/zombie_classic.mdl")
	end
	self:SetHealth(750)
	self:SetMaxHealth(750)
	self:SetArmor(0)
	self:SetWalkSpeed(160)
	self:SetRunSpeed(160)
	self:SetMaxSpeed(160)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self:SetNClass(ROLE_SCP0492)
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
	self:SetNoCollideWithTeammates(false)
	--Set player's model to scale
	self:SetModelScale(1.0,0)
end

function mply:IsActivePlayer()
	return self.Active
end

hook.Add( "KeyPress", "keypress_spectating", function( ply, key )
	if ply:Team() != TEAM_SPEC then return end
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
	if !(self:Team() == TEAM_SPEC) then return end
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

--simple and it works (for link)
function mply:SetFrozen(frozen,twalkSpeed,tRunSpeed,tjumpPwr)
	if(frozen)then
		self:SetNWBool( "CustomFrozen", true ) --Added by Link2006 Because fuckoff Variables that don't get set for no fucking reason god fucking damn it
		-- 0.00001 is required because -1 is abused lmao
		self:SetWalkSpeed(0.00001)
		self:SetRunSpeed(0.00001)
		self:SetJumpPower(0.00001)
	else
		self:SetNWBool( "CustomFrozen", false ) --same here btw
		self:SetWalkSpeed(twalkSpeed)
		self:SetRunSpeed(tRunSpeed)
		self:SetJumpPower(tjumpPwr)
	end
end

--Moved everything into ONE function so i don't have to keep editing BOTH code
function Link2006_RespawnPlayer(ply,num,target)  --Calling Player (admins), Selected Team (example: Class D), Target Player (Who is getting respawned)
	--Just to be REALLY safe :)
	if !target:IsValid() then return end --Is it a valid target? If not, Abort spawn
	if !target:IsPlayer() then return end  --Is the target a player? If not, Abort spawn

	--if ( table.HasValue( { "Developer", "superadmin", "developer", "admin"}, ply:GetUserGroup() ) ) then
	if ply:IsAdmin() or ply:IsSuperAdmin() then --If admin called the respawn, Respawn target.
		if num == 1 then
			target:SetSpectator() --cool.
		elseif num == 2 then
			target:SetClassD()
			target:SetPos(table.Random(SPAWN_CLASSD))
		elseif num == 3 then
			target:SetScientist()
			target:SetPos(table.Random(SPAWN_SCIENT))
		elseif num == 4 then
			target:SetCommander()
			target:SetPos(table.Random(SPAWN_GUARD))
		elseif num == 5 then
			target:SetGuard()
			target:SetPos(table.Random(SPAWN_GUARD))
		elseif num == 6 then
			target:SetChaosInsurgency(3)
			target:SetPos(table.Random(SPAWN_OUTSIDE))
		elseif num == 7 then
			target:SetSiteDirector(true) --Uh
			target:SetPos(table.Random(SPAWN_SCIENT)) --idk where else to put him.
		elseif num == 8 then
			target:SetNTF()
			target:SetPos(table.Random(SPAWN_OUTSIDE))
		elseif num == 9 then --SCPs are automaticly spwaned in their room. No need to move.
			target:SetSCP173()
		elseif num == 10 then
			target:SetSCP1048a()
		elseif num == 11 then
			target:SetSCP106()
		elseif num == 12 then
			target:SetSCP049()
		elseif num == 13 then
			target:SetSCP457()
		elseif num == 14 then
			target:SetSCP0082() --Plague Zombie (Infects players)
			target:SetPos(table.Random(SPAWN_ZOMBIES))
		elseif num == 15 then
			target:SetSCP0492() --SCP049 Zombie (Kills players)
			target:SetPos(table.Random(SPAWN_ZOMBIES))
		elseif num == 16 then
			target:SetSCP035()
		end
	end
end

net.Receive( "spawnas", function( len, ply )
	local num = net.ReadInt( 32 )
	Link2006_RespawnPlayer(ply,num,ply) --Admin respawns themselves

end)

net.Receive( "spawnthemas", function( len, ply )
	local num = net.ReadInt( 32 )
	local trg = net.ReadEntity()
	Link2006_RespawnPlayer(ply,num,trg) --Admin respawns a player
end)
