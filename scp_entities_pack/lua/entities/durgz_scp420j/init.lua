AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = "models/rottweiler/drugs/joint.mdl"

sound.Add( {
	name = "scp420j",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 75,
	pitch = 100,
	sound = "scppack/scp420j.wav"
} )

ENT.LASTINGEFFECT = 85; --how long the high lasts in seconds

--called when you use it (after it sets the high visual values and removes itself already)
function ENT:High(activator,caller)
    caller:StopSound('scp420j')
    caller:EmitSound('scp420j')

    --sound.Play("scppack/scp420j.wav", activator:GetPos(), 75, 100, 1)

	--[[--
    local sayings = {
        "Бля, чувак это ахуенно!",
		"Каааеф",
		"Эта вещь, боже, оргазм!",
		"а а а а а а а",
		"Я как на море! Хорошо...",
		"Мля, я маслину поймал!",
		"Тот океан где нет проблем...",
		"Надо с Андрюхой накурится!"
    }
    self:Say(activator, sayings)
	--]]--
end
