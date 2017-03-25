
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "B/U suit ''Omega-7''"
ENT.Author			= "Joni"
ENT.Information		= ""
ENT.Category		= "SCP Entity"

ENT.Spawnable		= true
ENT.AdminOnly		= false
	
if SERVER then

function ENT:Initialize()
	self:SetModel("models/omega/omegaseven/merc.mdl")
	self:SetNoDraw(false)
	self:DrawShadow(true)
	self:SetOwner(self.Owner)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	local phys1 = self:GetPhysicsObject()
if ( IsValid( phys1 ) ) then	
	phys1:Wake()
end
end

function ENT:Use( activator, ent )
if ( activator.CombineSuitUser == true ) then
	else
	self:SetNoDraw(true)
	self:DrawShadow(false)
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
    self:SetModel("models/weapons/shell.mdl")
	self.CombineSuitOwner = activator
	-- AI --
	self.cai = ents.Create("npc_combine_s")
	self.cai:Spawn()
	self.cai:DrawShadow(false)
	self.cai:SetSolid(SOLID_NONE)
	self.cai:SetParent(self.CombineSuitOwner)
	self.cai:SetKeyValue( "squadname", "Omega-7" )
	self.cai:Fire("setparentattachment", self.CombineSuitOwner:GetAttachments()[1].name)
	self.cai:SetKeyValue( "spawnflags", "256" + "8192" + "262144" )
	self.cai:SetModel("models/player/omega-7/Omega7.mdl")
	self.cai:AddEffects(EF_BONEMERGE)
	self.cai:SetHealth(99999999)
	self.cai:SetMaxHealth(99999999)
	self.cai.SuitAI = true
	--end--
	--Booleans--
	self.CombineSuitOwner.CombineSuitUser = true
	self.CombineSuitOwner.CombineSuitUsercop = nil
	self.CombineSuitOwner.Elite = true
	--end--
	if GetConVarNumber("overlay_mask") == 1 then
	self.CombineSuitOwner:ConCommand( "pp_mat_overlay morganicism/metroredux/gasmask/metromask6.vmt" )
	end
	--Add.Effects--
	self.CombineSuitOwner:EmitSound("gasmask.Wear")
	self.CombineSuitOwner:SetColor( Color( 255, 255, 255, 0 ) )
	self.CombineSuitOwner:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.CombineSuitOwner:SetHealth(100)
	self.CombineSuitOwner:SetMaxHealth(100)
	self.CombineSuitOwner:SetArmor(0)
	self.CombineSuitOwner.SetMaxArmor = 100
	--end-- 			
	--Info--
	timer.Simple(1.5, function()
	if IsValid(self.CombineSuitOwner) and IsValid(self) then
	if GetConVarNumber("Weapon_spawn") == 0 then
	elseif GetConVarNumber("Weapon_spawn") == 1 then
	elseif GetConVarNumber("Weapon_spawn") == 2 then
	end

	end
	end)
	--end--
	end
 
end

function ENT:Think()
if IsValid( self.cai ) then
self:Relations(self.cai)
if self.cai:IsOnFire() then
self.cai:Extinguish()
end
if self.CombineSuitOwner.CombineSuitUser == true then

if self.CombineSuitOwner:KeyDown(IN_DUCK) and self.CombineSuitOwner:KeyDown(IN_USE) and self.CombineSuitOwner:KeyDown(IN_RELOAD) then
if GetConVarNumber("suits_take_off") == 1 then
	local drop = ents.Create(self:GetClass())
	drop:SetPos(self.CombineSuitOwner:GetPos() + self.CombineSuitOwner:GetForward() * 35 + self.CombineSuitOwner:GetUp() * 15)
	drop:SetAngles(self.CombineSuitOwner:GetAngles() + Angle(0,180,0))
	drop:Spawn()
	drop:Activate()
	drop:SetOwner(self.Owner)
	
undo.Create( self.PrintName )
 undo.AddEntity( drop )
 undo.SetPlayer( self.CombineSuitOwner )
undo.Finish()
	
end
self:TakeOff(self.CombineSuitOwner)
end

if self.CombineSuitOwner:Armor() > self.CombineSuitOwner.SetMaxArmor then
self.CombineSuitOwner:SetArmor(self.CombineSuitOwner.SetMaxArmor)
end

if not self.CombineSuitOwner:Alive() then
self:Death(self.CombineSuitOwner)
end
end
end
end

function ENT:Death(ent) 
if IsValid(ent) then
if self.DeadBody == nil then
self.DeadBody = false
local ragdoll = ent:GetRagdollEntity()
local body = ents.Create( "prop_ragdoll" )
body:SetModel( self.cai:GetModel() )
body:SetPos( ent:GetPos() )
body:SetAngles( ent:GetAngles() )
body:Spawn()
body:SetSkin( self.cai:GetSkin() )
body:SetColor( self.cai:GetColor() )
body:SetMaterial( self.cai:GetMaterial() )
body:Fire( "FadeAndRemove", "", 10)

//position bones the same way.
for i=1,128 do
local bone = body:GetPhysicsObjectNum( i )
if IsValid( bone ) then
local bonepos, boneang = ent:GetBonePosition( body:TranslatePhysBoneToBone( i ) )
bone:SetPos( bonepos )
bone:SetAngles( boneang )
end
end
if IsValid(ragdoll) then
ragdoll:Remove()
end
end
ent.CombineSuitUser = false
self.CombineSuitOwner.Elite = false
ent:ConCommand( "pp_mat_overlay \"\"" )
ent:SetRenderMode(RENDERMODE_NORMAL)
ent:SetColor( Color( 255, 255, 255, 255 ) )
self:Remove()
if IsValid(self.cai) then
self.cai:Remove()
end
end
end

function ENT:TakeOff(ent)
if IsValid(ent) then
if self.CombineSuitOwner.CombineSuitUser == true then
self.CombineSuitOwner.CombineSuitUser = false
self.CombineSuitOwner:ConCommand( "pp_mat_overlay \"\"" )
self.CombineSuitOwner:SetArmor(0)
self.CombineSuitOwner:SetMaxHealth(100)
self.CombineSuitOwner:SetWalkSpeed(250) -- 250
self.CombineSuitOwner:SetRunSpeed(500) -- 500
self.CombineSuitOwner:SetCrouchedWalkSpeed(0.5) -- 0.5
self.CombineSuitOwner.Elite = false
self.CombineSuitOwner:EmitSound("gasmask.Drop")
self.CombineSuitOwner:SetRenderMode(RENDERMODE_NORMAL)
self.CombineSuitOwner:SetColor( Color( 255, 255, 255, 255 ) )
if(self.CombineSuitOwner:Health() > 100) then
	self.CombineSuitOwner:SetHealth(100)
end
end
self:Remove()
if IsValid( self.cai ) then
self.cai:Remove()
end
end
end

function ENT:Relations(ent)
if IsValid(ent) then
for _, enemy in pairs( ents.GetAll() ) do
if enemy:IsNPC() and enemy:Disposition(self.cai) == 1 then
enemy:AddEntityRelationship( ent, D_NU, 99 )
end
end
end
end

function ENT:PhysicsCollide(data,phys)
if data.Speed > 50 and data.Speed < 350 then
self:EmitSound("gasmask.PhysSoft")
end
if data.Speed > 350 then
self:EmitSound("gasmask.PhysHard")
end
end

function ENT:OnRemove()
self.Remove = true
self:TakeOff(self.CombineSuitOwner)
end




end


