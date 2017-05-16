--I've put it here so we can pre-cache them all and resource.addFile them
local sm_scp457 = {
	['a'] = {"scp_457_yes.mp3","Yes.."},
	['b'] = {"scp_457_want_burn.mp3","Want burn"},
	['c'] = {"scp_457_they_burn.mp3","They burn"},
	['d'] = {"scp_457_hungry.mp3","Hungry"},
	['e'] = {"scp_457_grow.mp3","Grow"},
	['f'] = {"scp_457_dislike.mp3","Dislike"},
	['g'] = {"scp_457_cannot_burn.mp3","Cannot Burn"},
}

local sm_scp049 = {
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

	if ply:GetNClass() ~= ROLE_SCP049 and ply:GetNClass() ~= ROLE_SCP457 then return end

	if ply:GetNWBool("sm_emitallowed",true) == false then return end

	local SndKey = net.ReadString()
	local Snd = nil --The sound file in the table,with the key that the client sent. :)

	if ply:GetNClass() == ROLE_SCP049 then
		if sm_scp049[SndKey] == nil then
			Snd = sm_scp049['g'][1]
		else
			Snd = sm_scp049[SndKey][1]
		end
	else
		if sm_scp457[SndKey] == nil then
			Snd = sm_scp457['g'][1]
		else
			Snd = sm_scp457[SndKey][1]
		end
	end

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

for k,sndFile in pairs(sm_scp457) do
	print("Loading sound/"..sndFile[1].." ...")
	util.PrecacheSound(sndFile[1])
	resource.AddFile("sound/"..sndFile[1])
end

for k,sndFile in pairs(sm_scp049) do
	print("Loading sound/"..sndFile[1].." ...")
	util.PrecacheSound(sndFile[1])
	resource.AddFile("sound/"..sndFile[1])
end
