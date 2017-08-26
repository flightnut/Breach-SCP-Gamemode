player_manager.AddValidModel( "Bigfoot",                     "models/winningrook/gtav/bigfoot/bigfoot.mdl" )
list.Set( "PlayerOptionsModel",  "Bigfoot",                     "models/winningrook/gtav/bigfoot/bigfoot.mdl" ) 

--Add NPC
local Category = "Rookie's NPCs"

local NPC = { 	Name = "Bigfoot Friendly", 
				Class = "npc_citizen",
				Model = "models/winningrook/gtav/bigfoot/bigfoot.mdl",
				Health = "25",
				KeyValues = { citizentype = 4 },
                                Category = Category    }

list.Set( "NPC", "bigfootAlly", NPC )

local Category = "Rookie's NPCs"

local NPC = { 	Name = "Bigfoot Hostile", 
				Class = "npc_combine_s",
				Model = "models/winningrook/gtav/bigfoot/bigfoot.mdl",
				Health = "50",
				KeyValues = { citizentype = 4 },
                                Category = Category    }

list.Set( "NPC", "bigfootHostile", NPC )
