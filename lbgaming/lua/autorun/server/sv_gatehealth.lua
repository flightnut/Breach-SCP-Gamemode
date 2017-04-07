gateHealth = CreateConVar('br_gatehealth','10000',{FCVAR_SERVER_CAN_EXECUTE,FCVAR_REPLICATED},"Sets Gate A/B's Health")

function GateHealth_Init()
    for k,prop in pairs(ents.GetAll()) do
        if IsValid(prop) then
            if prop:GetClass() == 'prop_dynamic' then
                if string.lower(prop:GetModel()) == 'models/foundation/containment/door01.mdl' then
                    prop:SetHealth(gateHealth:GetInt()) --Should be 10K here
                end
            end
        end
    end
end

--Initialize the doors (On Map Load & Map Reset)
hook.Add('PostCleanupMap','GateHealth.Reset',GateHealth_Init)
hook.Add('InitPostEntity','GateHealth.Init',GateHealth_Init)

--Hook the entity damages...
hook.Add('EntityTakeDamage','GateHealth.EntityTakeDamage',function(prop,dmginfo)
    if prop:GetClass() == 'prop_dynamic' then
        if string.lower(prop:GetModel()) == 'models/foundation/containment/door01.mdl' then
            --The model seems to match a gate a model
            if IsValid(prop:GetParent()) then --Does it have a parent?
                if prop:Health() >= 0 then
                    if prop:GetParent():GetClass() == 'func_door' then --Is it a door?
                        prop:SetHealth(prop:Health() - dmginfo:GetDamage()) --Lower this by that much health
                        if prop:Health() <= 0 then --Yes it's Gate A or B, Destroy it.
                            prop:EmitSound(Sound('Metal_Box.Break'))
                            prop:GetParent():Fire('Open') --Force it to open.
                            prop:GetParent():Fire("Lock") --They can't touch the gate anymore!
                            prop:SetHealth(prop:Health() - 3) --It's dead now, for sure
                            --Notify everyone it's been broken
                            if IsValid(dmginfo:GetAttacker()) then
                                if dmginfo:GetAttacker():IsPlayer() then
                                    dmginfo:GetAttacker():ChatPrint("You broke the gate!")
                                end
                            end
                            --[[ --emergency hotfix in the event my code breaks
                            timer.Simple(3,function()
                                prop:GetParent():Remove() --Remove the parent to make sure they dont unlock it and "fix it"
                            end)
                            ]]--
                        end
                    end
                end
            end
        end
    end
end)
