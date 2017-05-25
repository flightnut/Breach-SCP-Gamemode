print("[sv_nukes] Preparing sv_nukes hooks...")
hook.Add('PostCleanupMap','gm_site19_nukes_reset', function()
	print("[sv_nukes] Resetting Nukes...")
	--Reinitialize some variables here.
		CanTriggerNukes = false --They haven't enabled the nukes !
		TriggeredNukes = false --
end)

hook.Add("AcceptInput","gm_site19_nukes_for_lb",function(ent,inp,act,cal,val)
	if ent:GetName() == 'relay_914_1' then --Why is it named relay_914_1, wtf ?
		print("[sv_nukes] "..tostring(ent).. " '"..tostring(ent:GetName()).."' was fired with '"..tostring(inp).."' by "..tostring(act).." & "..tostring(cal))
		if inp == "Enable" then
			CanTriggerNukes = true
			TriggeredNukes = false
		elseif inp == "Trigger" then
			print("[sv_nukes] "..tostring(act).." Tried to nuke!")
			if preparing then return true end --DO NOT FIRE BEFORE THE ROUND STARTED
			if postround then return true end --DO NOT FIRE AFTER THE ROUND ENDED
			if not CanTriggerNukes then return true end --Stop, we cannot trigger nukes.
			if TriggeredNukes then return true end --Do not do anything!
			TriggeredNukes = true

			umsg.Start( "ulib_sound" )
			umsg.String( Sound( 'nukes/siren.ogg' ) ) --
			umsg.End()

			timer.Simple(14,function()
				if preparing then return true end --DO NOT FIRE BEFORE THE ROUND STARTED
				if postround then return true end --DO NOT FIRE AFTER THE ROUND ENDED
				print("[sv_nukes] "..'Nukes Sound 1')
				umsg.Start( "ulib_sound" ) --Requires Ulib
				umsg.String( Sound( 'nukes/nuke1.ogg' ) ) --BOOM SOUND
				umsg.End()
			end)
			timer.Simple(14.5,function()
				if preparing then return true end --DO NOT FIRE BEFORE THE ROUND STARTED
				if postround then return true end --DO NOT FIRE AFTER THE ROUND ENDED
					print("[sv_nukes] "..'Nukes Flash') --Requires SCP1123
				net.Start('SCP1123flash_lvl1') --White flash
				net.Broadcast() -- Send to everyone :)
			end)
			timer.Simple(15,function()
				if preparing then return true end --DO NOT FIRE BEFORE THE ROUND STARTED
				if postround then return true end --DO NOT FIRE AFTER THE ROUND ENDED
					print("[sv_nukes] "..'Nukes Explosion')
				umsg.Start( "ulib_sound" ) --Requires Ulib
				umsg.String( Sound( 'nukes/nuke2.ogg' ) ) --BOOM SOUND
				umsg.End()
				for k,v in pairs(player.GetAll()) do
					if v:Team() ~= TEAM_SPEC then
						v:Kill() --Dead!
					end
				end
			end)
			print("[sv_nukes] ".."Nukes started!")
			return true --Nuke actually went off, dont use map's nukes.
		end
	end
end)
print("[sv_nukes] Ready.")
