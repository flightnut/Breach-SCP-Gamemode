print("[sh_link2006dmg] Starting ScalePlayerDamage hook...")
hook.Add("ScalePlayerDamage","Link2006_ScaleDamage",function(ply,hitgroup,dmginfo)
	if IsValid(dmginfo) then 
		if IsValid(dmginfo:GetAttacker()) then 
			if IsValid(dmginfo:GetAttacker():GetActiveWeapon()) then 
				if dmginfo and dmginfo:GetAttacker() and dmginfo:GetAttacker():GetActiveWeapon() and dmginfo:GetAttacker():GetClass() then
					if ply:Team() ~= TEAM_SCP then --
						if dmginfo:GetAttacker():GetActiveWeapon():GetClass() == "weapon_stunstick" then
							dmginfo:ScaleDamage(0.33) --66% Damage nerf
						elseif dmginfo:GetAttacker():GetActiveWeapon():GetClass() == "weapon_crowbar" then
							dmginfo:ScaleDamage(0.35)
						end
					end
				end
			end
		end 
	end 
    --Don't block the damage on our hook.

	--Removes knockback on everyone (!)
    dmginfo:SetDamageForce(Vector(0,0,0)) --Comment this line if you like the knockback on other players via Weapons.
    return false
end)

print("[sh_link2006dmg] Ready.")
