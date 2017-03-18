
function AssaultGamemode()
	local all = GetActivePlayers()
	for i=1, math.Round(#player.GetAll() / 2) do
		local pl = table.Random(all)
		if pl == nil then break end  --WE'RE OUT OF USERS???
		pl:SetNTF()
		pl:SetPos(table.Random(SPAWN_GUARD))
		--pl:SetPos(SPAWN_GUARD[i])
		table.RemoveByValue(all, pl)
	end

	--This here is useless now that we're nocolliding people when in the assault gamemode
	for i=1, math.Round(#player.GetAll() / 2) do
		local pl = table.Random(all)
		if pl == nil then break end --WE'RE OUT OF USERS ??? 
		pl:SetChaosInsurgency(4)
		pl:SetPos(table.Random(SPAWN_CLASSD))
		--pl:SetPos(SPAWN_GUARD[i])
		table.RemoveByValue(all, pl)
	end

	local assTeam = false -- when false, MTF, when true, Chaos; Makes sure EVERYONE gets a team :)
	--Do the rest of the players that didn't spawn...
	for k,pl in pairs (all) do
		if assTeam then
			--local pl = table.Random(all) --We're cycling through the rest of them RN...
			pl:SetChaosInsurgency(4)
			pl:SetPos(table.Random(SPAWN_CLASSD))
			--pl:SetPos(SPAWN_GUARD[i])
			--table.RemoveByValue(all, pl) --We dont need to clean that table anymore
			assTeam = false
		else
			--local pl = table.Random(all) --We're cyclingt through the rest of them RN...
			pl:SetNTF()
			pl:SetPos(table.Random(SPAWN_GUARD))
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
	local all = GetActivePlayers()
	local allspawns = {}
	table.Add(allspawns, SPAWN_GUARD)
	--table.Add(allspawns, SPAWN_OUTSIDE)
	table.Add(allspawns, SPAWN_SCIENT)
	table.Add(allspawns, SPAWN_CLASSD)
	for i=1, #all do
		local pl = table.Random(all)
		local spawn = table.Random(allspawns)
		pl:SetGuard()
		pl:SetPos(spawn)
		table.RemoveByValue(allspawns, spawn)
		table.RemoveByValue(all, pl)
	end

	--Link2006's ZombieGamemode fix
	--InfectPeople()
end

function InfectPeople()
	local all = GetActivePlayers()
	local zombSpawns = table.Copy(SPAWN_ZOMBIES)
	for i=1, #all / 4 do
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
	local all = GetActivePlayers()
	local allspawns = {}
	table.Add(allspawns, SPAWN_GUARD)
	//table.Add(allspawns, SPAWN_OUTSIDE)
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
	spies = {
		playersetup = SpyGamemode,
		name = "Trouble in SCP Town",
		minplayers = 4,
		allowntfspawn = false,
		mtfandscpdelay = false,
		onroundstart = nil
	},
	multiplebreaches = {
		playersetup = function()
			local pnum = #GetActivePlayers()
			if pnum < 7 then
				SetupPlayers(GetRoleTableCustom(#GetActivePlayers(), 1, 0, 0, 0, false))
			elseif pnum > 6 and pnum < 13 then
				SetupPlayers(GetRoleTableCustom(#GetActivePlayers(), 2, 0, 0, 0, false))
			elseif pnum > 12 and pnum < 20 then
				SetupPlayers(GetRoleTableCustom(#GetActivePlayers(), 3, 0, 0, 0, false))
			else
				SetupPlayers(GetRoleTableCustom(#GetActivePlayers(), 4, 0, 0, 0, false))
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
