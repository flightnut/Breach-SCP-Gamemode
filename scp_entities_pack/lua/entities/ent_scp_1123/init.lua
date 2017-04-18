AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" ) 
include('shared.lua')

function ENT:Initialize()
self:SetModel( "models/Gibs/HGIBS.mdl" )
self:PhysicsInit( SOLID_VPHYSICS ) 
self:SetMoveType( MOVETYPE_VPHYSICS ) 
self:SetSolid( SOLID_VPHYSICS )
self:SetUseType(SIMPLE_USE)
local phys = self:GetPhysicsObject()
if (phys:IsValid()) then
phys:Wake()
end
end

function ENT:Use( ply, caller )
	if preparing or postround or ply:Team() == TEAM_SPEC or ply:Team() == TEAM_SCP then 
		return  --Does nothing if round starts or stops or the player is an SCP or a SPEC
	end
	
	if ply.HasTouched1123 == nil or ply.HasTouched1123 == false then
		net.Start("SCP1123flash")
		net.Send(ply) 
		ply.HasTouched1123 = true
		timer.Create(ply:SteamID64().."1123",0.1,100, function()
		ply:SetEyeAngles( Angle(math.random(-50,360),math.random(50,-360),0 ) ) 
		end) 
		timer.Create(ply:SteamID64().."1123_death",37,1, function()
			ply:EmitSound("scp/damage2.mp3")
			ply:Kill()
		end) 
	end
end

function ENT:Think()
	if preparing or postround then 
		return 
	end 
	for k,ply in pairs(player.GetAll()) do 
		if ply:Team() == TEAM_SPEC or ply:Team() == TEAM_SCP then 
			timer.Remove(ply:SteamID64().."1123_death")
			timer.Remove(ply:SteamID64().."1123")
		end 
		if ply:Alive() == false then 
			timer.Remove(ply:SteamID64().."1123_death")
			timer.Remove(ply:SteamID64().."1123")
		end 
	end 
	
	for k,v in pairs (ents.FindInSphere(self:GetPos(), 100) ) do
		if v:IsPlayer() && v:Alive() && v:Team() ~= TEAM_SCP && v:Team() ~= TEAM_SPEC then --No Spectator / No SCPs
			if v.HasSCP1123_lvl == 0 then
				net.Start("SCP1123flash_lvl1") 
				net.Send(v) 
				v.HasSCP1123_lvl =1
			elseif v.HasSCP1123_lvl == 1 then
				net.Start("SCP1123flash_lvl1")
				net.Send(v) 
				v.HasSCP1123_lvl = 2
			elseif v.HasSCP1123_lvl == 2 then
				net.Start("SCP1123flash_lvl1")
				net.Send(v) 
				v.HasSCP1123_lvl = 3
				
			
			elseif v.HasSCP1123_lvl == 3 then
				v.HasTouched1123 = true
				net.Start("SCP1123flash")
				net.Send(v) 
				
				timer.Create(v:SteamID64().."1123",0.1,100, function()
				v:SetEyeAngles( Angle(math.random(-50,360),math.random(50,-360),0 ) ) 
				if preparing or postround then 
					timer.Remove(v:SteamID64().."1123_death")
					timer.Remove(v:SteamID64().."1123")
					return 
				end 
				if v:Team() == TEAM_SPEC or v:Team() == TEAM_SCP then 
					timer.Remove(v:SteamID64().."1123_death")
					timer.Remove(v:SteamID64().."1123")
					return 
				end 
				if v:Alive() == false then 
					timer.Remove(v:SteamID64().."1123_death")
					timer.Remove(v:SteamID64().."1123")
					return 
				end 
				end) 
				
				timer.Create(v:SteamID64().."1123_death",37,1, function()
					if preparing or postround then return end --NO DONT KILL HIM ITS A NEW ROUND (i think)
					if v:Team() == TEAM_SPEC or v:Team() == TEAM_SCP then return end --He's spectating OR is an SCP, STOP IT 
					if v:Alive() == false then return end -- v:Alive() 
					
					v:EmitSound("scp/damage2.mp3")
					v:Kill() 
				end) 
				v.HasSCP1123_lvl = 4
			end
		end	
	end
		
	self:NextThink( CurTime() + 3 )
	return true
end