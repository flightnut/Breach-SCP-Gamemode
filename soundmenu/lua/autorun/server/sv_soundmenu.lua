util.AddNetworkString("sm_emitsound")

net.Receive("sm_emitsound",function(ln, ply)
	--Link2006 fixed the exploit that allowed anyone to play any sound ._.
	local says = {
		['a'] = {"049_3.wav","Oh my..."},
		['b'] = {"049_4.wav","You are not a doctor."},
		['c'] = {"049_5.wav","I sense the disease in you."},
		['d'] = {"049_6.wav","I am the cure."},
		['e'] = {"049_7.wav","Do not be afraid..."},
		['f'] = {"049_8.wav","Stop resisting..."},
		['g'] = {"049_alert_1.wav","Hello."},
		['h'] = {"049_alert_2.wav","Greetings."},
		['i'] = {"049_9.wav","*Singing*"},
		['j'] = {"049_10.wav","Oh my...(2)"},
	}

		
	if ply:GetNClass() != ROLE_SCP049 then return end
	if ply:GetNWBool("sm_emitallowed",true) == true then ply:SetNWBool("sm_emitallowed",true) end
	if ply:GetNWBool("sm_emitallowed") == false then return end
	local SndKey = net.ReadString()
	--Makes sure that we don't try to play a nil sound :)
	if says[SndKey] == nil then SndKey = 'g' end 
	
	local Snd = says[SndKey][1] --The sound file in the table,with the key that the client sent. :) 
	
	--sound,level,pitch,volume,channel
	--ply:EmitSound( Sound(Snd), 100, 100, 1, CHAN_AUTO )
	--Attempt at making this actually 3D
	
	--EmitSound( string soundName, Vector position, number entity, number channel=CHAN_AUTO, number volume=1, number soundLevel=75, number soundFlags=0, number pitch=100 )
	EmitSound(Sound(Snd),ply:GetPos(),ply:EntIndex(), CHAN_AUTO, 1, SNDLVL_80dB, SND_NOFLAGS, 100)
	
	ply:SetNWBool("sm_emitallowed",false)

	timer.Create("sm"..math.random(30100,30500),5,1,function()
		ply:SetNWBool("sm_emitallowed",true)
	end)
end)

resource.AddFile("sound/049_3.wav")
resource.AddFile("sound/049_4.wav")
resource.AddFile("sound/049_5.wav")
resource.AddFile("sound/049_6.wav")
resource.AddFile("sound/049_7.wav")
resource.AddFile("sound/049_8.wav")
resource.AddFile("sound/049_alert_1.wav")
resource.AddFile("sound/049_alert_2.wav")
resource.AddFile("sound/049_9.wav")
resource.AddFile("sound/049_10.wav")