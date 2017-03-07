--I've put it here so we can pre-cache them all and resource.addFile them
local sm_says = {
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
util.AddNetworkString("sm_emitsound")


net.Receive("sm_emitsound",function(ln, ply)
	--Link2006 fixed the exploit that allowed anyone to play any sound ._.

	if ply:GetNClass() ~= ROLE_SCP049 then return end
	if ply:GetNWBool("sm_emitallowed",true) == true then ply:SetNWBool("sm_emitallowed",true) end
	if ply:GetNWBool("sm_emitallowed") == false then return end
	local SndKey = net.ReadString()
	--Makes sure that we don't try to play a nil sound :)
	if sm_says[SndKey] == nil then SndKey = 'g' end

	local Snd = sm_says[SndKey][1] --The sound file in the table,with the key that the client sent. :)

	--sound,level,pitch,volume,channel
	--ply:EmitSound( Sound(Snd), 100, 100, 1, CHAN_AUTO )

	--'Stolen' from Breach itself.
	--lua_run for k,bot in pairs ( player.GetBots ( ) ) do bot:EmitSound ("049_9.wav", 75, 100, CHAN_WEAPON ) end
	ply:EmitSound( Sound(Snd), 75, 100, CHAN_WEAPON )  
	--Attempt at making this actually 3D
	--This DOES NOT Work when a server restarts
	-- sound is not precached?
	--EmitSound(Sound(Snd),ply:GetPos(),ply:EntIndex(), CHAN_AUTO, 1, SNDLVL_80dB, SND_NOFLAGS, 100)

	ply:SetNWBool("sm_emitallowed",false)

	timer.Create("sm"..math.random(30100,30500),5,1,function()
		ply:SetNWBool("sm_emitallowed",true)
	end)
end)

for k,sndFile in pairs(sm_says) do
	print("Loading sound/"..sndFile[1].." ...")
	util.PrecacheSound(sndFile[1])
	resource.AddFile("sound/"..sndFile[1])
end
