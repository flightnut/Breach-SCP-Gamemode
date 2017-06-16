if SERVER then AddCSLuaFile() end

local path = "weapons/tfa_l4d2/ct_m200/"

TFA.AddFireSound("TFA_L4D2_CTM200.1", path .. "gunfire/awp1.wav" , false, ")" )

TFA.AddWeaponSound("TFA_L4D2_CTM200.Deploy", path .. "gunother/awp_deploy.wav")
TFA.AddWeaponSound("TFA_L4D2_CTM200.Clipout", path .. "gunother/awp_clipin.wav")
TFA.AddWeaponSound("TFA_L4D2_CTM200.Clipin", path .. "gunother/awp_clipout.wav")
TFA.AddWeaponSound("TFA_L4D2_CTM200.Bolt", path .. "gunother/awp_bolt.wav")
TFA.AddWeaponSound("TFA_L4D2_CTM200.BoltForward", path .. "gunother/awp_bolt_forward.wav")