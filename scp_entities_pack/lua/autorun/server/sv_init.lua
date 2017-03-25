--[[--
	hazmatAbilities = {
	[DMG_SLASH]=.75,
	[DMG_NERVEGAS]=,0
	[DMG_DROWN]=0,
	[DMG_PARALYZE]=0,
	[DMG_POISON]=0,
	[DMG_ACID]=0,
	[DMG_RADIATION]=0}
	
	hook.Add("EntityTakeDamage","hazmatProtection", function(victim,dmginfo)
		for k,v in pairs(hazmatAbilities) do
			if victim.hasHazmat && dmginfo:IsDamageType( k ) then
				dmginfo:ScaleDamage(v) 
			end
		end
	end)
--]]--