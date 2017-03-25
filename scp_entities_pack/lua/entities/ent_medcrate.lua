if CLIENT then
function ENT:Initialize()
end
local dpanel = NULL
local mousepos = Vector(ScrW()/2, ScrH()/2)
local LastMenuTime = 0
net.Receive("med_Open_Crate_Menu", function(len)
local my_table = net.ReadTable()
local CrateEnt = net.ReadEntity()
local DermaPanel = vgui.Create( "DFrame" )
LastMenuTime = CurTime()
		local Pos = Vector(ScrW()/2 + 1,ScrH()/2 + 1)
		DermaPanel:SetSize( 325 + 5*2, 125 + 25*2 )
		DermaPanel:SetTitle( "Ящик" )
		DermaPanel:SetVisible( true )
		DermaPanel:SetDraggable( true )
		DermaPanel:ShowCloseButton( true )
		DermaPanel:MakePopup()
		input.SetCursorPos(mousepos.x, mousepos.y)
		dpanel = DermaPanel
local BG = vgui.Create( "DImage",DermaPanel)
		BG:SetPos(5, 25)
		BG:SetImage("phoenix_storms/white")
		BG:SetSize( 325, 145 ) -- Set the size of the panel
		BG:SetImageColor(Color(0,0,0,0))
local Scroll = vgui.Create( "DScrollPanel", DermaPanel ) //Create the Scroll panel
Scroll:SetSize( 550, 300 )
Scroll:SetPos( 10, 30 )
Scroll:SetBGColor(255,255,0,255)
Scroll:SetPaintBackgroundEnabled(true)


local List   = vgui.Create( "DIconLayout", Scroll ) //Create the DIconLayout and put it inside of the Scroll Panel.
List:SetSize( 350, 150 )
List:SetPos( 0, 0 )
List:SetSpaceY( 0 ) //Sets the space inbetween the panels on the X Axis by 5
List:SetSpaceX( 0 ) //Sets the space inbetween the panels on the Y Axis by 5
List:SetBGColor(0,0,0,0)
List:SetPaintBackgroundEnabled(true)


for k,v in pairs(my_table) do
local icon = List:Add("SpawnIcon", button)
icon:SetModel(v:GetModel())
icon:SetTooltip(language.GetPhrase(v:GetClass()))
icon.DoClick = function()
local x,y = input.GetCursorPos()
mousepos = Vector(x,y)
DermaPanel:Remove()
net.Start("med_Crate_Spawn_Item")
net.WriteEntity(CrateEnt)
net.WriteFloat(k)
net.SendToServer()
end
end
DermaPanel:SizeToContents()
end)
net.Receive("med_Refresh_Crate_Menu", function(len)
if dpanel != NULL and IsValid(dpanel) then
local x,y = input.GetCursorPos()
mousepos = Vector(x,y)
dpanel:Remove()
end
end)

hook.Add("Think", "CloseCrateMenu", function()
if LastMenuTime < CurTime() - 0.1 then
if input.IsButtonDown(KEY_E) then

if IsValid(dpanel) and dpanel != NULL then
local x,y = dpanel:GetPos()
//MsgN(dpanel:GetSize())
mousepos = Vector(x, y) + Vector(dpanel:GetWide()/2, dpanel:GetTall()/2)
dpanel:Remove()
end

end
else
if input.IsButtonDown(KEY_E) then
LastMenuTime = CurTime()
end
end
end)

end
function ENT:SpawnFunction( Player, Trace )

	if ( !Trace.Hit ) then return end
	
	local SpawnPos = Trace.HitPos + ( Trace.HitNormal * 32 );
	
	if SERVER then
	local Entity = ents.Create( "ent_medcrate" );
	Entity:SetPos( SpawnPos );
	Entity:Spawn();
	Entity:Activate();
	
	return Entity;
	end
end
if SERVER then
util.AddNetworkString("med_Open_Crate_Menu")
util.AddNetworkString("med_Refresh_Crate_Menu")
util.AddNetworkString("med_Crate_Spawn_Item")
AddCSLuaFile("ent_medcrate.lua")
net.Receive("med_Crate_Spawn_Item", function(len,ply)
local Crate = net.ReadEntity()
local indx = net.ReadFloat()
local Ent = Crate.Contents[indx]
if IsValid(Ent) and IsValid(Ent:GetPhysicsObject()) then
Ent:GetPhysicsObject():EnableMotion(false)
table.remove(Crate.Contents,indx)
constraint.RemoveAll(Ent)
Ent:SetPos(Crate:GetPos() + Vector(0,0,30))
Ent:SetGravity(1)
Ent:GetPhysicsObject():EnableMotion(true)
Ent:SetNoDraw(false)
Ent:SetNWBool("IsInCrate")
end
net.Start("med_Open_Crate_Menu")
net.WriteTable(Crate.Contents)
net.WriteEntity(Crate)
net.Send(ply)
end)
function ENT:Initialize()
//MsgN(self.Contents)
	self.Contents = {}
	self:SetHealth(1000000)
	self:SetModel("models/props_junk/wood_crate001a.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()

	if phys and phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use(ply)
if ply:IsValid() and ply:IsPlayer() then
net.Start("med_Open_Crate_Menu")
net.WriteTable(self.Contents)
net.WriteEntity(self)
net.Send(ply)
end
end

function ENT:OnTakeDamage(dmginfo)
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce()/self:GetPhysicsObject():GetMass())
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	if self:Health() < 1 then
	self:PrecacheGibs()
	self:GibBreakClient(dmginfo:GetDamageForce()/self:GetPhysicsObject():GetMass())
	self:EmitSound("physics/wood/wood_crate_break" .. math.random(1,5) .. ".wav", 50, 100)
	for k,v in pairs(self.Contents) do
	v:SetNoDraw(false)
	v:SetNWBool("IsInCrate", false)
	v:TakeDamage(dmginfo)
	end
	self:Remove()
	end
end

function ENT:Think()
if self.Contents == nil or self.Contents == NULL then self.Contents = {} end
local weight = 30
if self:GetCreationTime() <= CurTime() - 1 and #self.Contents < 1 then
self.Contents = {}
local count = 0
	for k,v in pairs(ents.FindInSphere(self:GetPos(), 20)) do
	if v != self and v:GetCreationTime() > CurTime() - 4 then
	table.insert(self.Contents, v)
	//MsgN(v)
	v:SetNWEntity("CrateEnt", self)
	for _,ENT in pairs(self.Contents) do
		constraint.NoCollide(ENT,v,0,0)
	end
	v:SetNoDraw(true)
	count = count + 1
	end
	end
end

self:SetNWInt("HowManyInBox",#self.Contents)
for k,v in pairs(self.Contents) do
if !v:IsValid() or v:GetNWEntity("CrateEnt") != self or (IsValid(v) and !IsValid(v:GetPhysicsObject())) then
table.remove(self.Contents, k)
else
weight = weight + v:GetPhysicsObject():GetMass()
v:NextThink( CurTime() + 1 )
if v:GetPos():Distance(self:GetPos()) > 10 then
v:SetPos(self:GetPos())
//MsgN("Teleport " .. tostring(v) .. tostring(self))
for _,ENT in pairs(self.Contents) do
constraint.NoCollide(ENT,v,0,0)
end
constraint.Weld(v,self,0,0,0,true)
DropEntityIfHeld(v)
end

end
end
self:GetPhysicsObject():SetMass(weight + 50)
end
local LastPickup = 0
local LastDrop = 0
function ENT:PhysicsCollide(data, physobj)
local ent = data.HitEntity

if ent:IsValid() and !ent:IsWorld() then
if LastPickup == 0 and ent:BoundingRadius() < 25 then
local bool = hook.Call("GravGunOnPickedUp", nil, player.GetAll()[1], ent)
local bool1 = hook.Call("GravGunOnDropped", nil, player.GetAll()[1], ent)
if LastPickup == 0 then
PrintMessage(HUD_PRINTCENTER,"Ты не можешь положить коробку в коробку!")
end
end
if ent:GetNWBool("CanBePlaced") and ent:BoundingRadius() < 25 and #self.Contents < 10 then
//MsgN(ent:BoundingRadius())
table.insert(self.Contents, ent)
ent:SetNWBool("IsInCrate", true)
ent:SetNWBool("CanBePlaced", false)
ent:SetPos(self:GetPos())
ent:SetNWEntity("CrateEnt", self)
for k,v in pairs(self.Contents) do
constraint.NoCollide(v,ent,0,0)
end
constraint.Weld(ent,self,0,0,0,true)
DropEntityIfHeld(ent)
end
end
end
hook.Add("GravGunOnPickedUp", "00MakeObjectPlaceableInCrate",function(pl, ent)
if pl:IsValid() and ent:IsValid() then
ent:SetNWBool("CanBePlaced", true)
LastPickup = CurTime()
end
end)
hook.Add("GravGunOnDropped", "UnMakeObjectPlaceableInCrate",function(pl, ent)
if pl:IsValid() and ent:IsValid() then
ent:SetNWBool("CanBePlaced", false)
LastDrop = CurTime()
end
end)
hook.Add("PlayerCanPickupItem", "000BlockItemPickup_siku", function(pl, ent)
if pl:IsValid() and IsValid(ent) then
local count = #ents.FindByClass("ent_medcrate")
if count > 0 then
if ent:GetNWBool("CanBePlaced") or ent:GetNWBool("IsInCrate") then
return false
end
end
end
end)
hook.Add("PlayerCanPickupWeapon", "000BlockWeaponPickup_siku", function(pl, ent)
if IsValid(pl) and IsValid(ent) then
local count = #ents.FindByClass("ent_medcrate")
if count > 0 and ent:GetCreationTime() <= (CurTime() - 0.2) then
if ent:GetNWBool("CanBePlaced") or ent:GetNWBool("IsInCrate") then
return false
end
end
end
end)
timer.Create("CheckIfEntIsInCrate",1,0,function()
for k,v in pairs(ents.GetAll()) do
//v:SetNetworkedBool("IsInCrate",false)
for _,ent in pairs(ents.FindByClass("ent_medcrate"))do
if table.HasValue(ent.Contents,v) then
v:SetNetworkedBool("IsInCrate",true)
v:SetNoDraw(true)
end
end
end
end)
hook.Add("EntityTakeDamage","DamageProtectCrateSIKU",function(ent, dmginfo)
if ent:GetNWBool("IsInCrate") then
dmginfo:ScaleDamage(0)
dmginfo:SetDamageType(0)
end
end)
end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Crate"
ENT.Author = "Joni"
ENT.Spawnable = true
ENT.AdminSpawnable = false