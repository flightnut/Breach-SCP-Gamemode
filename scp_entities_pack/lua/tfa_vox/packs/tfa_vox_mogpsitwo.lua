TFAVOX_Models = TFAVOX_Models or {}

--replace wav with a SOUNDSCRIPT ID
--replace 1 with a TABLE{min,max} or a 1BER

TFAVOX_Models["models/mw2/skin_05/mw2_soldier_02.mdl"] = {
	['callouts'] = {
		['ClassDFo'] = {
			['name'] = "Found Class D!",
			['delay']= 1,
			['sound'] = { "player/SCP/foundclassd.wav" }
		},
		['OverThere'] = {
			['name'] = "Over there!",
			['delay']= 1,
			['sound'] = { "player/SCP/overthere.wav" }
		},
		['ClassDDe'] = {
			['name'] = "Class D detected!",
			['delay']= 1,
			['sound'] = { "player/SCP/detected.wav" } 
		},
		['Stop'] = {
			['name'] = "STOP!",
			['delay']= 1,
			['sound'] = { "player/SCP/deultstopt.wav", "player/SCP/heyheyhold.wav", "player/SCP/stopthere.wav" } 
		},
		['terminated'] = {
			['name'] = "Terminated!",
			['delay']= 1,
			['sound'] = { "player/SCP/terminated.wav", "player/SCP/hesdead.wav" }
		},
		['comeon'] = {
			['name'] = "Come on!",
			['delay']= 1,
			['sound'] = { "player/SCP/comeon.wav" }
		},
		['unsure'] = {
			['name'] = "Where are you!",
			['delay']= 1,
			['sound'] = { "player/SCP/whereau.wav", "player/SCP/ahaufuckedbit.wav", "player/SCP/where.wav" } 
		}
	}
}