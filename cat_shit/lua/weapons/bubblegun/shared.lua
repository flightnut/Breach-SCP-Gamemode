if SERVER then
	AddCSLuaFile ("shared.lua")
	resource.AddFile("vgui/entities/bubblegun.vmt")
	resource.AddFile("vgui/entities/bubblegun.vtf")
	resource.AddFile("models/bubblegun/bubble.vmt")
	resource.AddFile("models/bubblegun/bubble.vtf")
	resource.AddFile("models/bubblegun/bubble_lod2.vmt")
	resource.AddFile("models/bubblegun/bubble_lod2.vtf")
	resource.AddFile("models/bubblegun/bubble_lod3.vmt")
	resource.AddFile("models/bubblegun/bubble_lod3.vtf")
	resource.AddFile("models/bubblegun/bubble_lod4.vmt")
	resource.AddFile("models/bubblegun/bubblegun_film.vmt")
	resource.AddFile("models/bubblegun/bubblegun_film.vtf")
	resource.AddFile("models/bubblegun/bubblegun_handle.vmt")
	resource.AddFile("models/bubblegun/bubblegun_handle.vtf")
	resource.AddFile("models/bubblegun/bubblegun_inside.vmt")
	resource.AddFile("models/bubblegun/bubblegun_inside.vtf")
	resource.AddFile("models/bubblegun/bubblegun_nozzle.vmt")
	resource.AddFile("models/bubblegun/bubblegun_nozzle.vtf")
	resource.AddFile("models/bubblegun/bubblegun_trigger.vmt")
	resource.AddFile("models/bubblegun/bubblegun_trigger.vtf")
	resource.AddFile("models/bubblegun/bubblegun1.vmt")
	resource.AddFile("models/bubblegun/bubblegun1.vtf")
	resource.AddFile("models/bubblegun/bubblegun2.vmt")
	resource.AddFile("models/bubblegun/bubblegun2.vtf")
	resource.AddFile("models/bubblegun/bubblegun3.vmt")
	resource.AddFile("models/bubblegun/bubblegun3.vtf")
	resource.AddFile("models/bubblegun/bubblegun4.vmt")
	resource.AddFile("models/bubblegun/bubblegun4.vtf")
	resource.AddFile("models/bubblegun/bubblegun5.vmt")
	resource.AddFile("models/bubblegun/bubblegun5.vtf")
	resource.AddFile("models/bubblegun/bubblesuds.vmt")
	resource.AddFile("models/bubblegun/bubblesuds.vtf")
	resource.AddFile("models/bubblegun/bubblesuds_lod2.vmt")
	resource.AddFile("models/bubblegun/bubblesuds_lod3.vmt")
	resource.AddFile("models/bubblegun/bubblesuds_lod3.vtf")
	resource.AddFile("models/bubblegun/v_hand_sheet.vmt")
	resource.AddFile("models/bubblegun/v_hand_sheet.vtf")
	resource.AddFile("models/bubblegun/v_hand_sheet_normal.vtf")

	SWEP.Weight = 3
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom = true
 
elseif CLIENT then
 
	SWEP.PrintName = "BubbleGun"
	SWEP.Icon = "vgui/entities/bubblegun"
	SWEP.Slot = 1
	SWEP.SlotPos = 5
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	language.Add("Undone_Thrown_SWEP_Entity","Undone Bubble")
end
 
SWEP.Author = "cat"
SWEP.Contact = "Meow in the wind"
SWEP.Purpose = "Shoot scary things with bubbles"
SWEP.Instructions = "Primary=Blow | Secondary=Bomb"

SWEP.Category = "BubbleGun"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
 
SWEP.ViewModel = "models/weapons/bubblegun/v_bubblegun.mdl"
SWEP.WorldModel = "models/weapons/bubblegun/w_bubblegun.mdl"
SWEP.ViewModelFOV = 68
SWEP.HoldType = "revolver"
SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Spread	= 0.1
//SWEP.MinSpread		= 0.1
//SWEP.MaxSpread		= 0.1
//SWEP.ConeSpray		= 0.1
//SWEP.ConeIncrement	= 0.1
//SWEP.ConeMax		= 0.1
//SWEP.ConeDecrement	= 0.1

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 2
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "Pistol"
 
function SWEP:Initialize()
	util.PrecacheSound("bubblegun/bubble1.wav")
	util.PrecacheSound("bubblegun/bubble2.wav")
	util.PrecacheSound("bubblegun/bubble3.wav")
	util.PrecacheSound("bubblegun/bubble4.wav")
	util.PrecacheSound("bubblegun/bubble5.wav")
	util.PrecacheSound("bubblegun/bubble6.wav")
	util.PrecacheSound("bubblegun/bubble7.wav")
	util.PrecacheSound("bubblegun/bubble8.wav")
	local ShootSound1 = util.PrecacheSound("bubblegun/bubble1.wav")
	local ShootSound2 = util.PrecacheSound("bubblegun/bubble2.wav")
	local ShootSound3 = util.PrecacheSound("bubblegun/bubble3.wav")
	local ShootSound4 = util.PrecacheSound("bubblegun/bubble4.wav")
	local ShootSound1 = util.PrecacheSound("bubblegun/bubble5.wav")
	local ShootSound2 = util.PrecacheSound("bubblegun/bubble6.wav")
	local ShootSound3 = util.PrecacheSound("bubblegun/bubble7.wav")
	local ShootSound4 = util.PrecacheSound("bubblegun/bubble8.wav")

end

function SWEP:Reload()
end
 
function SWEP:Think()
end
 
 
function SWEP:throw_attack (model_file)

	local tr = self.Owner:GetEyeTrace()
	self:EmitSound("bubblegun/bubble" .. math.random(1,8) .. ".wav")
	self.BaseClass.ShootEffects(self)

	if (!SERVER) then return end
 
	local ent = ents.Create("prop_physics")
	ent:SetModel(model_file)
	ent:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 50))
	ent:SetAngles(self.Owner:EyeAngles())
	ent:Spawn()
 
	local phys = ent:GetPhysicsObject()

	if !(phys && IsValid(phys)) then ent:Remove() return end
 
	phys:ApplyForceCenter(self.Owner:GetAimVector():GetNormalized() *  math.pow(tr.HitPos:Length(), 1))
 
	cleanup.Add(self.Owner, "props", ent)
 
	undo.Create ("Thrown_SWEP_Entity")
		undo.AddEntity (ent)
		undo.SetPlayer (self.Owner)
	undo.Finish()
end
 
function SWEP:PrimaryAttack()
	self:throw_attack("models/bubblegun/bubble" .. math.random(1,6) .. ".mdl")
end
 
function SWEP:SecondaryAttack()
	self:throw_attack("models/bubblegun/bubblebomb.mdl")
end
 