print("[rounds.lua] Loading...")
function AssaultGamemode()
	for k,v in pairs(GetActivePlayers()) do
		v:SetSpectator() --I dont know anymore :^l
	end

	local all = GetActivePlayers()
	local guardSpawns = {}
	table.Add(guardSpawns, SPAWN_GUARD)
	table.Add(guardSpawns, SPAWN_SCIENT)
	table.Add(guardSpawns, SPAWN_CLASSD)

	local chaosSpawns = {}
	table.Add(chaosSpawns, SPAWN_OUTSIDE)

	for i=1, math.Round(player.GetCount() / 2) do
		local pl = table.Random(all)
		if pl == nil then break end  --WE'RE OUT OF USERS???
		pl:SetNTF()
		pl:SetNoCollideWithTeammates(false) --Force noCollide for this round :)
		local newGuard = table.Random(guardSpawns)
		pl:SetPos(newGuard)
		table.RemoveByValue(guardSpawns, newGuard)
		--pl:SetPos(table.Random(SPAWN_GUARD))
		--pl:SetPos(SPAWN_GUARD[i])
		table.RemoveByValue(all, pl)
	end

	--This here is useless now that we're nocolliding people when in the assault gamemode
	for i=1, math.Round(player.GetCount() / 2) do
		local pl = table.Random(all)
		if pl == nil then break end --WE'RE OUT OF USERS ???
		pl:SetChaosInsurgency(4)
		--pl:SetTeam(TEAM_CLASSD) --WORKAROUND FOR NOCOLLIDE, DO NOT USE OUTSIDE ASSAULT.
		pl:SetNoCollideWithTeammates(false) --Force noCollide for this round :)
		--pl:SetPos(table.Random(SPAWN_OUTSIDE))
		local newChaos = table.Random(chaosSpawns)
		pl:SetPos(newChaos)
		table.RemoveByValue(chaosSpawns, newChaos)
		--pl:SetPos(SPAWN_GUARD[i])
		table.RemoveByValue(all, pl)
	end

	local assTeam = false -- when false, MTF, when true, Chaos; Makes sure EVERYONE gets a team :)
	--Do the rest of the players that didn't spawn...
	for k,pl in pairs (all) do
		if assTeam then
			--local pl = table.Random(all) --We're cycling through the rest of them RN...
			pl:SetChaosInsurgency(4)
			--pl:SetTeam(TEAM_CLASSD) --WORKAROUND FOR NOCOLLIDE, DO NOT USE OUTSIDE ASSAULT.
			pl:SetNoCollideWithTeammates(false) --Force noCollide for this round :)
			--pl:SetPos(table.Random(SPAWN_OUTSIDE))
			local newChaos = table.Random(chaosSpawns)
			pl:SetPos(newChaos)
			table.RemoveByValue(chaosSpawns, newChaos)
			--pl:SetPos(SPAWN_GUARD[i])
			--table.RemoveByValue(all, pl) --We dont need to clean that table anymore
			assTeam = false
		else
			--local pl = table.Random(all) --We're cyclingt through the rest of them RN...
			pl:SetNTF()
			pl:SetNoCollideWithTeammates(false) --Force noCollide for this round :)

			local newGuard = table.Random(guardSpawns)
			pl:SetPos(newGuard)
			table.RemoveByValue(guardSpawns, newGuard)

			--pl:SetPos(table.Random(SPAWN_GUARD))
			--pl:SetPos(SPAWN_GUARD[i])
			--table.RemoveByValue(all, pl) --We dont need to clean that table anymore
			assTeam = true
		end
	end
	--[[
	for k,v in ipairs(all) do
		v:SetChaosInsurgency(4)
		v:SetPos(SPAWN_CLASSD[k])
	end
	]]--
end

function ZombieGamemode()
	for k,v in pairs(GetActivePlayers()) do
		v:SetSpectator() --I dont know anymore :^l
	end
	--Get All players
	local all = GetActivePlayers()
	local allspawns = {}
	table.Add(allspawns, SPAWN_GUARD)
	--table.Add(allspawns, SPAWN_OUTSIDE)
	table.Add(allspawns, SPAWN_SCIENT)
	table.Add(allspawns, SPAWN_CLASSD)

	--Link2006's ZombieGamemode fix
	--New attempt to fix it, again.  This should make it so it has less chances of ending the round too early.


	--Spawn Everyone.
	for i=1, #all do
		local pl = table.Random(all)
		local spawn = table.Random(allspawns)
		pl:SetGuard()
		pl:SetNoCollideWithTeammates(true) --Force noCollide for this round :)
		pl:SetPos(spawn)
		table.RemoveByValue(allspawns, spawn)
		table.RemoveByValue(all, pl)
	end

	--Get everyone again
	all = GetActivePlayers()
	--select 2 players to switch into zombies.
	for i=1,2 do --Only 2 alpha zombies
		local pl = table.Random(all)
		local newZomb = table.Random(SPAWN_ZOMBIES)
		pl:SetSCP0082() --Set a random player as 008-2
		pl:SetPos(newZomb)
		table.RemoveByValue(all, pl)
	end

	--Old fix
	--InfectPeople()
end

function InfectPeople()
	local all = GetActivePlayers()
	local zombSpawns = table.Copy(SPAWN_ZOMBIES)
	for i=1,math.Round(#all/16) do --Attempt at nerfing how many zombies spawn
	--for i=1, #all / 4 do
		if #zombSpawns > 0 then --Shuffle players into random Zombie spawns until we have no more spawns available for them.
			local pl = table.Random(all)
			pl:SetSCP0082()
			--[[
			--Link2006's ZombieGamemode Fix
			local newZomb = table.Random(zombSpawns)
			pl:SetPos(newZomb)
			table.RemoveByValue(zombSpawns,newZomb)
			table.RemoveByValue(all, pl)
			]]--
		end
	end
end

function SpyGamemode()
	for k,v in pairs(GetActivePlayers()) do
		v:SetSpectator() --I dont know anymore :^l
	end
	local all = GetActivePlayers()
	local allspawns = {}
	table.Add(allspawns, SPAWN_GUARD)
	--table.Add(allspawns, SPAWN_OUTSIDE)
	table.Add(allspawns, SPAWN_SCIENT)
	table.Add(allspawns, SPAWN_CLASSD)
	for i=1, (#GetActivePlayers() / 3) do
		local pl = table.Random(all)
		local spawn = table.Random(allspawns)
		pl:SetChaosInsurgency(1)
		pl:SetPos(spawn)
		table.RemoveByValue(allspawns, spawn)
		table.RemoveByValue(all, pl)
	end
	for i,pl in ipairs(all) do
		local spawn = table.Random(allspawns)
		pl:SetGuard()
		pl:SetPos(spawn)
		table.RemoveByValue(allspawns, spawn)
	end
end

if not ConVarExists("br_superbreach_hpmult") then CreateConVar( "br_superbreach_hpmult", "1.5", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Multiplies SCP's Health by this much" ) end


function SuperBreachRound()
	-- Format for SetupPlayers()
	--
	for k,v in pairs(GetActivePlayers()) do
		v:SetSpectator() --I dont know anymore :^l
	end

	local pnum = #GetActivePlayers()
	local scpsnum = 1

	--print('[rounds DEBUG] '..tostring(pnum))
	if pnum < 7 then -- 0 to 6 players
		--SetupPlayers({1, pnum, 0, 0, 0}) -- 1 SCP, Rest MTFs + 1 commander :^)
		scpsnum = 1
	elseif pnum > 6 and pnum < 13 then --7 to 12 players
		--SetupPlayers({2, pnum, 0, 0, 0}) -- 2 SCPs, Rest MTFs + 1 commander :^)
		scpsnum = 2
	elseif pnum > 12 and pnum < 20 then --13 to 19 players
		--SetupPlayers({3, pnum, 0, 0, 0})-- 3 SCPs, Rest MTFs + 1 commander :^)
		scpsnum = 3
	elseif pnum > 19 and pnum < 40 then -- 20 to 39 players
		--SetupPlayers({4, pnum, 0, 0, 0}) -- 4 SCPs, Rest MTFs + 1 commander :^)
		scpsnum = 4
	elseif pnum > 39 and pnum < 60 then -- 40 to 59 players
		--SetupPlayers({5, pnum, 0, 0, 0}) -- 5 SCPs, Rest MTFs + 1 commander :^)
		scpsnum = 5
	else --60+ Players
		--SetupPlayers({6, pnum, 0, 0, 0}) -- 6 SCPs, Rest MTFs + 1 commander :^)
		scpsnum = 6
	end
	--Reduce the number of players because we got how many SCPs we have to spawn

	pnum = pnum - scpsnum
	--print('[rounds DEBUG] SetupPlayers done.')


	local allply = GetActivePlayers()
	--print('[rounds DEBUG] '..tostring(allply))
	local allspawns = {}
	table.Add(allspawns, SPAWN_GUARD)
	--table.Add(allspawns, SPAWN_OUTSIDE)
	table.Add(allspawns, SPAWN_SCIENT)
	table.Add(allspawns, SPAWN_CLASSD)
	--print('[rounds DEBUG] '..tostring(allspawns))

	local scpplys = {}
	for k,v in pairs(allply) do
		if v:GetNWBool("HasBeenSCP") ~= true then
			table.insert(scpplys,v)
		end
	end
	-- SCP
	local spctab = table.Copy(SPCS)
	for i=1, scpsnum do
		if #spctab < 1 then
			spctab = table.Copy(SPCS)
			--print("not enough scps, copying another table")
		end
		--local pl = table.Random(allply)
		local pl = table.Random(scpplys)
		local scp = table.Random(spctab)
		scp["func"](pl)
		table.RemoveByValue(spctab, scp)
		table.RemoveByValue(allply, pl)
	end
	scpplys = nil --Delete that table, we do not need it anymore
	-- MTF Commander
	for k,v in pairs(player.GetAll()) do
		if v:Team() == TEAM_SCP then --The SCPs will get the flag set to true
			v:SetNWBool("HasBeenSCP", true)
		else --everyone else that DID NOT get this team, will have their flag reset.
			v:SetNWBool("HasBeenSCP", false)
		end
	end


	--print('[rounds DEBUG] GetActivePlayer is'..tostring(GetActivePlayers()))
	--print('[rounds DEBUG] GetActivePlayer Count is'..tostring(#GetActivePlayers()))
	--print('[rounds DEBUG] player.GetCount() is '..tostring(player.GetCount()))
	for i=1,pnum do

		--print('[rounds DEBUG] I:'..tostring(i))
		local pl = table.Random(allply)

		--print('[rounds DEBUG] pl:'..tostring(pl))
		--print('[rounds DEBUG] pl is spectator')
		pl:SetGuard()
		pl:SetPos(table.Random(allspawns))
		--print('[rounds DEBUG] === spawned player ===')
		--print('[rounds DEBUG] Setting NoCollide...')
		pl:SetNoCollideWithTeammates(true) --Force noCollide for this round, no matter who :)
		table.RemoveByValue(allply, pl)
		--print('[rounds DEBUG] =======done========')
	end


	local superbreach_convar = GetConVar("br_superbreach_hpmult")

	if superbreach_convar == nil then
		print("[Rounds.lua] GetConVar returned nil!")
	end

	for k,v in pairs(team.GetPlayers(TEAM_SCP)) do
		--print('[rounds DEBUG] Setting Health on '..tostring(v).. ' ['..tostring(v:GetNClass())..'] with '..tostring(v:Health()*superbreach_convar:GetFloat())..'/'..tostring(v:GetMaxHealth()*superbreach_convar:GetFloat()))
		v:SetMaxHealth(v:GetMaxHealth()*superbreach_convar:GetFloat())
		v:SetHealth(v:Health()*superbreach_convar:GetFloat())
		--print('[rounds DEBUG] Done health boost')
	end
end

normalround = {
	playersetup = function()
		SetupPlayers( GetRoleTable(#GetActivePlayers()) )
	end,
	name = "Containment breach",
	minplayers = 3,
	allowntfspawn = true,
	mtfandscpdelay = true,
	onroundstart = nil
}

ROUNDS = {
	assault = {
		playersetup = AssaultGamemode,
		name = "Assault",
		minplayers = 4,
		allowntfspawn = false,
		mtfandscpdelay = false,
		onroundstart = nil
	},
	superbreach = {
		playersetup = SuperBreachRound,
		name = "Super breach",
		minplayers = 4,
		allowntfspawn = false,
		mtfandscpdelay = false, --Due to Guards spawning outside MTF spawn anyway.
		onroundstart = nil --I could make this play some sound tbh
	},
	--[[
	spies = {
		playersetup = SpyGamemode,
		name = "Trouble in SCP Town",
		minplayers = 4,
		allowntfspawn = false,
		mtfandscpdelay = false,
		onroundstart = nil
	},
	]]--
	multiplebreaches = {
		playersetup = function()
			local pnum = #GetActivePlayers()
			if pnum < 7 then -- 0 to 6 players
				SetupPlayers(GetRoleTableCustom(pnum, 1, 0, 0, 0, false)) -- 1 SCP
			elseif pnum > 6 and pnum < 13 then --7 to 12 players
				SetupPlayers(GetRoleTableCustom(pnum, 2, 0, 0, 0, false)) -- 2 SCPs
			elseif pnum > 12 and pnum < 20 then --13 to 19 players
				SetupPlayers(GetRoleTableCustom(pnum, 3, 0, 0, 0, false)) -- 3 SCPs
			elseif pnum > 19 and pnum < 40 then -- 20 to 39 players
				SetupPlayers(GetRoleTableCustom(pnum, 4, 0, 0, 0, false)) -- 4 SCPs
			elseif pnum > 39 and pnum < 60 then -- 40 to 59 players
				SetupPlayers(GetRoleTableCustom(pnum, 5, 0, 0, 0, false)) -- 5 SCPs
			else --60+ Players
				SetupPlayers(GetRoleTableCustom(pnum, 6, 0, 0, 0, false)) -- 6 SCPs
			end
		end,
		name = "Multiple breaches",
		minplayers = 4,
		allowntfspawn = false,
		mtfandscpdelay = true,
		onroundstart = nil
	},
	zombieplague = {
		playersetup = ZombieGamemode,
		name = "Zombie Plague",
		minplayers = 6,
		allowntfspawn = false,
		mtfandscpdelay = false,
		onroundstart = InfectPeople --Disabled to make it so people gets Infected
	},
}

print("[rounds.lua] Loaded.")
