--CURRENT VERSION:  1.3 (beta)

if CLIENT then return end --This should be in /autorun/server/, clients can't do anything 

--Configurable eleavtor damage 
local elevDamage = 1

--DON'T TOUCH BELOW PLEASE, THANK YOU 
-- by http://steamcommunity.com/profiles/76561197971790479/
-- || Discord: Link2006#8132

--FREEZES ALL PROPS
print("[Link2006] Script made by: http://steamcommunity.com/profiles/76561197971790479/  :)")

--Update 1.3
-- Attempts to not freeze

--UPDATE 1.2
-- Added FreezeAllProps by Me, Prevents abuse with props.

--UPDATE 1.1
--	Fixed script not starting on any maps
--	added warning when not used on gm_site19 
if !string.StartWith( game.GetMap() , "gm_site19" ) then --if map does not start with gm_site19 \
	print("[Link2006] ========== WARNING ==========")
	print("[Link2006] This script was meant for gm_site19 (and variants)!")
	print("[Link2006] If you have issues, remove this script.")
	print("[Link2006] ========== WARNING ==========")
	--return --Commented to let the script through...
end

--Comment this if you like players get stuck (tbh, they should kill you :| )

--Removing my function before we update it, in case it's still there.
print("[Link2006] Cleaning old hook...")
hook.Remove("PostCleanupMap","Link2006_BlockDamage")

--Generating Functions...
print("[Link2006] Creating Functions...")

function Link2006_FreezeAllProps()
	local Props = ents.FindByClass("prop_physics") 
	for k,v in pairs(Props) do 
		--freeze the props.
		local v_phys = v:GetPhysicsObject()
		if v_phys and v_phys:IsValid() then
			--If it's the melon or the boxes outside, don't freeze them, we can break them.
			if string.lower(v:GetModel()) == "models/props_junk/watermelon01.mdl" or string.lower(v:GetModel()) == "models/props_junk/wood_crate001a.mdl" then 
				v_phys:EnableMotion(true) --Unfreeze them 
				v_phys:Wake() --meme: WAKE ME UP 
			else
				v_phys:Sleep() --Sleep, stops them
				v_phys:EnableMotion(false) --Freeze them 
			end 
		end
	end 
	print("[Link2006] Props frozen")
end

function Link2006_FixElevators()
		for k,elev in pairs(ents.FindByClass("func_movelinear")) do --For every entities of func_movelinear; 
		--Set Crushing damage to 1000 for ALL elevators/func_movelinear, not just a few (<,<)
		elev:SetKeyValue("BlockDamage",elevDamage)
		--And set collision_group to only playes (and props); items/weapons goes through.
		elev:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	end 
	print("[Link2006] Elevators fixed")
end

print("[Link2006] Creating PostCleanupMap hook...")

hook.Add("PostCleanupMap","Link2006_BlockDamage",function() --On New Round
	print("[Link2006] CleanUpMap() called, Waiting a bit...")
	timer.Simple(1.0,function()
		print("[Link2006] Running Fixes...")
		Link2006_FixElevators()
		Link2006_FreezeAllProps()
	end)
end)

print("[Link2006] Forcing changes to the map immediately...")
Link2006_FixElevators()
Link2006_FreezeAllProps()
print("[Link2006] Ready.")


--Link2006 was here