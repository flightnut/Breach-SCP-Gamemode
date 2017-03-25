if !ConVarExists("overlay_mask") then	
   CreateClientConVar("overlay_mask", '1', (FCVAR_GAMEDLL), "If set to 1, actives overlay in suits. True by default.", true, true)
end
if !ConVarExists("Weapon_spawn") then	
   CreateClientConVar("Weapon_spawn", '1', (FCVAR_GAMEDLL), "If set to 1, removes all player weapons and gives appropriate for the suit type.. True by default.", true, true)
end
if !ConVarExists("foot_steps") then	
   CreateClientConVar("foot_steps", '1', (FCVAR_GAMEDLL), "If set to 1, Enables combine foot steps when player wears the suit.", false, false)
end
if !ConVarExists("suits_take_off") then	
   CreateClientConVar("suits_take_off", '1', (FCVAR_GAMEDLL), "If set to 1, You'll drop the suit after taking it off.", true, true)
end
if !ConVarExists("player_speed") then	
   CreateClientConVar("player_speed", '1', (FCVAR_GAMEDLL), "If set to 1, It will sets players speed to the same as combie soldiers/metro police has.", false, false)
end
if !ConVarExists("own_model") then	
   CreateClientConVar("own_model", '1', (FCVAR_GAMEDLL), "If set to 1, Having correct player model will force combine units to be friendly.", true, true)
end
if !ConVarExists("combine_friendly") then	
   CreateClientConVar("combine_friendly", '1', (FCVAR_GAMEDLL), "", false, false)
end

sound.Add( {
	name = "gasmask.Die",
	channel = CHAN_VOICE,
	volume = VOL_NORM,
	level = SNDLVL_80dB,
	pitch = PITCH_NORM,
	sound = { "npc/combine_soldier/die1.wav", "npc/combine_soldier/die2.wav", "npc/combine_soldier/die3.wav" }
} )

sound.Add( {
	name = "gasmask.DieMetr",
	channel = CHAN_VOICE,
	volume = VOL_NORM,
	level = SNDLVL_80dB,
	pitch = PITCH_NORM,
	sound = { "npc/metropolice/die1.wav", "npc/metropolice/die2.wav", "npc/metropolice/die3.wav", "npc/metropolice/die4.wav" }
} )

sound.Add( {
	name = "gasmask.Wear",
	channel = CHAN_ITEM,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = { 90, 110 },
	sound = { "npc/combine_soldier/zipline_clothing1.wav", "npc/combine_soldier/zipline_clothing2.wav" }
} )

sound.Add( {
	name = "gasmask.WearDone",
	channel = CHAN_VOICE,
	volume = VOL_NORM,
	level = SNDLVL_80dB,
	pitch = PITCH_NORM,
	sound = { "npc/combine_soldier/vo/overwatch.wav", "npc/combine_soldier/vo/goactiveintercept.wav", "npc/combine_soldier/vo/priority1objective.wav", "npc/combine_soldier/vo/prison_soldier_activatecentral.wav", "npc/combine_soldier/vo/prosecuting.wav", "npc/combine_soldier/vo/readyweapons.wav", "npc/combine_soldier/vo/teamdeployedandscanning.wav", "npc/combine_soldier/vo/unitisinbound.wav" }
} )

sound.Add( {
	name = "gasmask.WearDoneMetro",
	channel = CHAN_VOICE,
	volume = VOL_NORM,
	level = SNDLVL_80dB,
	pitch = PITCH_NORM,
	sound = { "npc/metropolice/vo/allunitsmovein.wav", "npc/metropolice/vo/anticitizen.wav", "npc/metropolice/vo/apply.wav", "npc/metropolice/vo/gota10-107sendairwatch.wav", "npc/metropolice/vo/ptatlocationreport.wav", "npc/metropolice/vo/readytojudge.wav", "npc/metropolice/vo/readytoprosecute.wav", "npc/metropolice/vo/repurposedarea.wav" }
} )

sound.Add( {
	name = "gasmask.Drop",
	channel = CHAN_BODY,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = { 90, 110 },
	sound = { "npc/combine_soldier/zipline_hitground1.wav", "npc/combine_soldier/zipline_hitground2.wav" }
} )

sound.Add( {
	name = "gasmask.PhysSoft",
	channel = CHAN_ITEM,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = { 90, 110 },
	sound = { "physics/rubber/rubber_tire_impact_soft1.wav", "physics/rubber/rubber_tire_impact_soft2.wav", "physics/rubber/rubber_tire_impact_soft3.wav" }
} )

sound.Add( {
	name = "gasmask.PhysHard",
	channel = CHAN_ITEM,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = { 90, 110 },
	sound = { "physics/rubber/rubber_tire_impact_hard1.wav", "physics/rubber/rubber_tire_impact_hard2.wav", "physics/rubber/rubber_tire_impact_hard3.wav" }
} )

sound.Add( {
	name = "gasmask.PhysSoftCard",
	channel = CHAN_ITEM,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = { 90, 110 },
	sound = { "physics/body/body_medium_impact_soft1.wav", "physics/body/body_medium_impact_soft2.wav", "physics/body/body_medium_impact_soft3.wav", "physics/body/body_medium_impact_soft4.wav", "physics/body/body_medium_impact_soft5.wav", "physics/body/body_medium_impact_soft6.wav", "physics/body/body_medium_impact_soft7.wav" }
} )

sound.Add( {
	name = "gasmask.PhysHardCard",
	channel = CHAN_ITEM,
	volume = 0.7,
	level = SNDLVL_NORM,
	pitch = { 90, 110 },
	sound = { "physics/flesh/flesh_impact_hard1.wav", "physics/flesh/flesh_impact_hard2.wav", "physics/flesh/flesh_impact_hard3.wav", "physics/flesh/flesh_impact_hard4.wav", "physics/flesh/flesh_impact_hard5.wav", "physics/flesh/flesh_impact_hard6.wav" }
} )

sound.Add( {
	name = "gasmask.WalkMetr",
	channel = CHAN_ITEM,
	volume = 0.800,
	level = SNDLVL_TALKING,
	pitch = { 95, 110 },
	sound = { "npc/metropolice/gear1.wav", "npc/metropolice/gear2.wav", "npc/metropolice/gear3.wav", "npc/metropolice/gear4.wav", "npc/metropolice/gear5.wav", "npc/metropolice/gear6.wav" }
} )

sound.Add( {
	name = "gasmask.PainSold",
	channel = CHAN_BODY,
	volume = 0.800,
	level = SNDLVL_TALKING,
	pitch = { 90, 110 },
	sound = { "npc/combine_soldier/pain1.wav", "npc/combine_soldier/pain2.wav", "npc/combine_soldier/pain3.wav" }
} )