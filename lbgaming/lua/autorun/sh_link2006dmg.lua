hook.Add("ScalePlayerDamage","Link2006_ScaleDamage",function(ply,hitgroup,dmginfo)
    if dmginfo then
        if dmginfo:GetAttacker() then
            if dmginfo:GetAttacker():IsPlayer() then
                if dmginfo:GetAttacker():GetActiveWeapon() then
                    if dmginfo:GetAttacker():GetActiveWeapon():GetClass() then
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
    end
    --Don't block the damage on our hook.
    return false
end)
