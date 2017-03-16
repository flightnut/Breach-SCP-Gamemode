AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" ) 
include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/vinrax/props/scp_513.mdl" )
	self:SetUseType( SIMPLE_USE )
	self:PhysicsInit( SOLID_VPHYSICS ) 
	self:SetMoveType( MOVETYPE_VPHYSICS ) 
	self:SetSolid( SOLID_VPHYSICS ) 
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
	phys:Wake()
	end
end

function ENT:Use( ply, caller )
	if ( self:IsPlayerHolding() ) then return end
	ply:PickupObject( self )
	self:EmitSound( "scp_pack/bell"..math.random(1,2) ..".ogg" )
	local victim = ents.FindInSphere( self:GetPos(), 175 )
	for k , v in pairs (victim) do
		if v:IsPlayer() then
			v:SetNWBool("SCP513Enabled", true)
		end
	end
end

function ENT:Think()
end