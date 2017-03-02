local function AddPlayerModel( name, model )

    list.Set( "PlayerOptionsModel", name, model )
    player_manager.AddValidModel( name, model )
    player_manager.AddValidHands( "bms_citizen_male", "models/weapons/c_arms_citizen.mdl", 0, "00000000" )
    player_manager.AddValidHands( "bms_refugee_male", "models/weapons/c_arms_refugee.mdl", 0, "00000000" )	
    player_manager.AddValidHands( "bms_medic_male", "models/weapons/c_arms_citizen.mdl", 0, "00000000" )	
    player_manager.AddValidHands( "bms_rebel_male", "models/weapons/c_arms_citizen.mdl", 0, "00000000" )
    player_manager.AddValidHands( "bms_citizen_female", "models/weapons/c_arms_citizen.mdl", 0, "00000000" )	
    player_manager.AddValidHands( "bms_refugee_female", "models/weapons/c_arms_citizen.mdl", 0, "00000000" )		
    player_manager.AddValidHands( "bms_medic_female", "models/weapons/c_arms_citizen.mdl", 0, "00000000" )	
    player_manager.AddValidHands( "bms_rebel_female", "models/weapons/c_arms_citizen.mdl", 0, "00000000" )	
end

AddPlayerModel( "bms_citizen_male", "models/sirgibs/ragdolls/bms_citizens/male_citizen_player.mdl" )
AddPlayerModel( "bms_refugee_male", "models/sirgibs/ragdolls/bms_citizens/male_refugee_player.mdl" )
AddPlayerModel( "bms_rebel_male", "models/sirgibs/ragdolls/bms_citizens/male_rebel_player.mdl" )
AddPlayerModel( "bms_medic_male", "models/sirgibs/ragdolls/bms_citizens/male_medic_player.mdl" )
AddPlayerModel( "bms_citizen_female", "models/sirgibs/ragdolls/bms_citizens/female_citizen_player.mdl" )
AddPlayerModel( "bms_refugee_female", "models/sirgibs/ragdolls/bms_citizens/female_refugee_player.mdl" )
AddPlayerModel( "bms_rebel_female", "models/sirgibs/ragdolls/bms_citizens/female_rebel_player.mdl" )
AddPlayerModel( "bms_medic_female", "models/sirgibs/ragdolls/bms_citizens/female_medic_player.mdl" )

--add npc or i no DL!!!!!!1111 i frends with steam admin and gonna ban your account if you dont rrraaaaaaaaaggggggggg!!!!!!!!!!!!
local Category = "Sirgibs Black Mesa Citizens"
local sg_bmsmodel = {"models/humans/group01/male_bms_citizen_npc.mdl", "models/humans/group02/male_bms_refugee_npc.mdl", "models/humans/group03/male_bms_rebel_npc.mdl", "models/humans/group03m/male_bms_medic_npc.mdl", "models/humans/group01/female_bms_citizen_npc.mdl", "models/humans/group02/female_bms_refugee_npc.mdl", "models/humans/group03/female_bms_rebel_npc.mdl", "models/humans/group03m/female_bms_medic_npc.mdl"}

local NPC = {
	Name = "BMS Male Citizen",
	Class = "npc_citizen",
	Model = "models/humans/group01/male_bms_citizen_npc.mdl",	
	Category = Category,
	KeyValues = { citizentype = CT_DOWNTRODDEN }
}
list.Set( "NPC", "BMSMaleCitizen", NPC )

local NPC = {
	Name = "BMS Male Refugee",
	Class = "npc_citizen",
	Model = "models/humans/group02/male_bms_refugee_npc.mdl",	
	Category = Category,
	KeyValues = { citizentype = CT_REFUGEE },
	Weapons = { "weapon_pistol", "weapon_smg1" }
}
list.Set( "NPC", "BMSMaleRefugee", NPC )

local NPC = {
	Name = "BMS Male Rebel",
	Class = "npc_citizen",
	Model = "models/humans/group03/male_bms_rebel_npc.mdl",	
	Category = Category,
	KeyValues = { citizentype = CT_REBEL },
	Weapons = { "weapon_pistol", "weapon_ar2", "weapon_smg1", "weapon_ar2", "weapon_shotgun" }
}
list.Set( "NPC", "BMSMaleRebel", NPC )

local NPC = {
	Name = "BMS Male Medic",
	Class = "npc_citizen",
	Model = "models/humans/group03m/male_bms_medic_npc.mdl",	
	Category = Category,
	SpawnFlags = SF_CITIZEN_MEDIC,
	KeyValues = { citizentype = CT_REBEL },
	Weapons = { "weapon_pistol", "weapon_smg1", "weapon_ar2", "weapon_shotgun" }
}
list.Set( "NPC", "BMSMaleMedic", NPC )

local NPC = {
	Name = "BMS Female Citizen",
	Class = "npc_citizen",
	Model = "models/humans/group01/female_bms_citizen_npc.mdl",	
	Category = Category,
	KeyValues = { citizentype = CT_DOWNTRODDEN }
}
list.Set( "NPC", "BMSFemaleCitizen", NPC )

local NPC = {
	Name = "BMS Female Refugee",
	Class = "npc_citizen",
	Model = "models/humans/group02/female_bms_refugee_npc.mdl",	
	Category = Category,
	KeyValues = { citizentype = CT_REFUGEE },
}
list.Set( "NPC", "BMSFemaleRefugee", NPC )

local NPC = {
	Name = "BMS Female Rebel",
	Class = "npc_citizen",
	Model = "models/humans/group03/female_bms_rebel_npc.mdl",	
	Category = Category,
	KeyValues = { citizentype = CT_REBEL },
	Weapons = { "weapon_pistol", "weapon_ar2", "weapon_smg1", "weapon_ar2", "weapon_shotgun" }
}
list.Set( "NPC", "BMSFemaleRebel", NPC )

local NPC = {
	Name = "BMS Female Medic",
	Class = "npc_citizen",
	Model = "models/humans/group03m/female_bms_medic_npc.mdl",	
	Category = Category,
	SpawnFlags = SF_CITIZEN_MEDIC,
	KeyValues = { citizentype = CT_REBEL },
	Weapons = { "weapon_pistol", "weapon_smg1", "weapon_ar2", "weapon_shotgun" }
}
list.Set( "NPC", "BMSFemaleMedic", NPC )

--is there REALLY no better way to do this?
hook.Add( "PlayerSpawnedNPC", "RandomSkin", function(ply,npc) 
	if table.HasValue( sg_bmsmodel, npc:GetModel() ) then npc:SetSkin( math.random(0,21) );
	end
 end )