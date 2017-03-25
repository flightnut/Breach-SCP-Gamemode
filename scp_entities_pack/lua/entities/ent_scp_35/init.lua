AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" ) 
include('shared.lua')

function ENT:Initialize()
self:SetModel( "models/vinrax/props/scp035/035_mask.mdl" )
self:PhysicsInit( SOLID_VPHYSICS ) 
self:SetMoveType( MOVETYPE_VPHYSICS ) 
self:SetSolid( SOLID_VPHYSICS )
self:SetUseType(SIMPLE_USE)
self.Free = true
local phys = self:GetPhysicsObject()
if (phys:IsValid()) then
phys:Wake()
end
end

function ENT:Use( ply, caller )
ply:SetForwardSpeed( 8000 ) 
end

function ENT:Think()
	for k,v in pairs (ents.FindInSphere(self:GetPos(), 170) ) do
		if v:IsPlayer() && v:Alive() && self.Free == true && !v.MaskControl then
			print(v.SCP35mindControl)
			if v.SCP35mindControl == nil then
				v.SCP35mindControl = 0
			end
			if v.SCP35mindControl < 100 then
			v.SCP35mindControl = v.SCP35mindControl + 1
			
			if v.SCP35mindControl == 15 then
				net.Start("SCP35manipulation_lvl1")
					net.WriteInt(1,16)
				net.Send(v)
				v:SetFOV(110, 8 ) 
				timer.Simple(2.5, function() v:SetFOV(60, 1 ) end )
			end
			
			if v.SCP35mindControl == 26 then
				net.Start("SCP35manipulation_lvl1")
					net.WriteInt(2,16)
				net.Send(v)
				v:SetFOV(110, 4 ) 
				timer.Simple(2.5, function() v:SetFOV(60, 2 ) end )
			end
			
			if v.SCP35mindControl == 35 then
				net.Start("SCP35manipulation_lvl1")
				net.WriteInt(2,16)
				net.Send(v)
				v:SetFOV(110, 2 ) 
				timer.Simple(2, function() v:SetFOV(60, 1 ) end )
			end
			
				if v.SCP35mindControl == 50 then
				net.Start("SCP35manipulation_lvl1")
				net.WriteInt(2,16)
				net.Send(v)
				v:SetFOV(110, 2 ) 
				timer.Simple(2.5, function() v:SetFOV(60, 1 ) end )
				local vec1 = self:GetPos()
				local vec2 = v:GetShootPos()
				v:SetEyeAngles( ( vec1 - vec2 ):Angle() )
				v:ViewPunch( Angle( math.random(-5,5), math.random(-5,5), math.random(-5,5) ) )
				v:SetVelocity( v:GetAimVector() * 10 )
				end
				
				if v.SCP35mindControl == 62 then
				net.Start("SCP35manipulation_lvl1")
				net.WriteInt(2,16)
				net.Send(v)
					timer.Create("SCP35_View",0.2, 8, function()
					local vec1 = self:GetPos()
					local vec2 = v:GetShootPos()
					v:SetEyeAngles( ( vec1 - vec2 ):Angle() )
					v:ViewPunch( Angle( math.random(-5,5), math.random(-5,5), math.random(-5,5) ) )
					end)
				end
				
				if v.SCP35mindControl == 70 then
				net.Start("SCP35manipulation_lvl1")
				net.WriteInt(2,16)
				net.Send(v)
					timer.Create("SCP35_View",0.2, 8, function()
					local vec1 = self:GetPos()
					local vec2 = v:GetShootPos()
					v:SetEyeAngles( ( vec1 - vec2 ):Angle() )
					v:ViewPunch( Angle( math.random(-5,5), math.random(-5,5), math.random(-5,5) ) )
					end)
				end
				
				if v.SCP35mindControl == 76 then
					net.Start("SCP35manipulation_lvl1")
					net.WriteInt(2,16)
					net.Send(v)
					timer.Create("SCP35_View",0.2, 15, function()
					local vec1 = self:GetPos()
					local vec2 = v:GetShootPos()
					v:SetEyeAngles( ( vec1 - vec2 ):Angle() )
					v:ViewPunch( Angle( math.random(-5,5), math.random(-5,5), math.random(-5,5) ) )
					end)
				end
				
					if v.SCP35mindControl == 80 then
						net.Start("SCP35manipulation_lvl1")
						net.WriteInt(2,16)
						net.Send(v)
						v:Freeze( true )
						timer.Create("SCP35_View",0.2, 15, function()
						local vec1 = self:GetPos()
						local vec2 = v:GetShootPos()
						v:SetEyeAngles( ( vec1 - vec2 ):Angle() )
						v:ViewPunch( Angle( math.random(-5,5), math.random(-5,5), math.random(-5,5) ) )
						end)
					end
					
					if v.SCP35mindControl == 90  then
						net.Start("SCP35manipulation")
						net.WriteInt(2,16)
						net.Send(v)
						v:Freeze(false)
						self.Free = false
						v:SetFOV(10, 1 ) 
						timer.Simple(3, function() v:SetFOV(60, 1 ) end )
						v:SetModel("models/vinrax/player/035_player.mdl")
						v.MaskControl = true
						self:Remove()
					end

			end
		end	
	end
		
	self:NextThink( CurTime() + 1)
	return true
end


				-- local vec1 = self:GetPos()
				-- local vec2 = v:GetShootPos()
				-- v:SetEyeAngles( ( vec1 - vec2 ):Angle() )
				-- v:ViewPunch( Angle( math.random(-5,5), math.random(-5,5), math.random(-5,5) ) )
				-- v:SetVelocity( pl:GetAimVector() * 1000 )