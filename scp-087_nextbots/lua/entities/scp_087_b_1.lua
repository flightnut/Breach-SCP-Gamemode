AddCSLuaFile()

--SCP-087-B-1 Coded by me Yay! Don't download if you don't like Horror Games! :-)

ENT.Base 				=	"base_nextbot"
ENT.Spawnable			=	false

CreateConVar( "087b1_chatmassage", 0, FCVAR_NOTIFY, FCVAR_ARCHIVE, "Enable or disable the chatbox massages when killed by SCP-087-B-1! [Default '0']" )
CreateConVar( "087b1_doorprops", 1, FCVAR_NOTIFY, FCVAR_ARCHIVE, "If set to 1 doors will create props after beeing destroyed. If set to 0 they just get removed by SCP-087-B-1! [Default '1']" )
CreateConVar( "087b1_tp", 1, FCVAR_NOTIFY, FCVAR_ARCHIVE, "Enable or disable SCP-087-B-1's teleporting. [Default '1']" )
CreateConVar( "087b1_health", 8000, FCVAR_NOTIFY, FCVAR_ARCHIVE, "SCP-087-B-1's health. [Default '8000']" )
CreateConVar( "087b1_speed", 500, FCVAR_NOTIFY, FCVAR_ARCHIVE, "SCP-087-B-1's speed. [Default '500']" )

util.PrecacheSound( "sound/gman/doorbreak.wav" )

if CLIENT then
language.Add( "scp_087_b_1", "SCP-087-B-1" )
end

function ENT:Initialize()
local hlth = GetConVar( "087b1_health" )

	self.Oeightsevenambience = CreateSound(self,"087_ambient.wav")
	self:SetModel( "models/scp/scp_087_b_1.mdl" )
	self:SetHealth( hlth:GetFloat() )
	EnemyRadius	= 100000000
	self.Entity:SetCollisionBounds( Vector(-4,-4,0), Vector(4,4,64) )

end

function ENT:SetEnemy( ent )
	self.Enemy = ent
end

function ENT:GetEnemy()
	return self.Enemy
end

function ENT:HaveEnemy()
	if ( self:GetEnemy() and IsValid( self:GetEnemy() ) ) then
		if ( self:GetRangeTo( self:GetEnemy():GetPos() ) > EnemyRadius ) then
			return self:FindEnemy()
		elseif ( self:GetEnemy():IsPlayer() and !self:GetEnemy():Alive() ) then --They died...
			return self:FindEnemy() --They're not valid for breach
		elseif ( self:GetEnemy():IsPlayer() and self:GetEnemy():Alive() ) then --They're alive but...
			if ( self:GetEnemy():Team() == TEAM_SPEC or self:GetEnemy():Team() == TEAM_SCP ) then  --They're a Spectator/SCP ... 
				return self:FindEnemy() --They're not valid for breach. 
			end 
		end
		return true
	else
		return self:FindEnemy()
	end
end

function ENT:FindEnemy() --Currently gets the first valid enemy it finds...
	if preparing then --Breach can't let us get enemies yet. return false. 
		self:SetEnemy( nil )
		self.Oeightsevenambience:Stop()
		return false --Oops, sorry :( 
	end
	local _players = player.GetAll() 
	for k,v in pairs(player.GetAll()) do -- Go Through Everyone, until there's no players to select from. 
		_newTarget = table.Random(_players) --Get a random player
		if _newTarget:Team() ~= TEAM_SCP and _newTarget:Team() ~= TEAM_SPEC and _newTarget:Alive() then --Not SCP, Not Spectator, Still Alive? GO! :)
			self:SetEnemy( _newTarget ) --Set new target 
			self:EmitSound("087_alert_" .. math.random(1, 2) .. ".wav", 100, 100) --Play a sound 
			self.Oeightsevenambience:Play() -- ?
			return true	--Return true, we got our enemy :) 
		else
			table.RemoveByValue(_players,_newTarget) -- He's not a possible target, skip over him. 
		end 
	end 
	-- OLD CODE HERE, go lower. 
	--[[
	local _ents = player.GetAll()
	for k, v in pairs( _ents ) do
		if ( v:Alive() and v:Team() ~= TEAM_SPEC and v:Team() ~= TEAM_SCP ) then
			self:SetEnemy( v ) 
			self:EmitSound("087_alert_" .. math.random(1, 2) .. ".wav", 100, 100)
			self.Oeightsevenambience:Play()
			return true	
		end
	end
	]]--

	--Wait, we didn't get an enemy ? 
	self:SetEnemy( nil )
	self.Oeightsevenambience:Stop()
	return false --Oops, sorry :( 
end

function ENT:RunBehaviour()
	while ( true ) do
		if ( self:HaveEnemy() ) then
			if ( GetConVar( "087b1_speed" ):GetFloat() <= 200 ) then
				self:StartActivity( ACT_WALK )
				self.loco:SetDesiredSpeed( GetConVar( "087b1_speed" ):GetFloat() )
				self.loco:SetAcceleration( 900 )
				self:ChaseEnemy()
				self:StartActivity( ACT_IDLE_ON_FIRE )
			else
				self:StartActivity( ACT_HL2MP_RUN_FIST )
				self.loco:SetDesiredSpeed( GetConVar( "087b1_speed" ):GetFloat() )
				self.loco:SetAcceleration( 900 )
				self:ChaseEnemy()
				self:StartActivity( ACT_IDLE_ON_FIRE )
			end
		end
		coroutine.wait( 2 )

	end

end

function ENT:ChaseEnemy( options )
	
	local options = options or {}
	local cvar = GetConVar( "ai_ignoreplayers" )
	local cvar2 = GetConVar( "ai_disabled" )
	local gcvar = GetConVar( "087b1_doorprops" )
	local gcvar2 = GetConVar( "087b1_tp" )
	local massage = GetConVar( "087b1_chatmassage" )
	
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 0 )
	path:Compute( self, self:GetEnemy():GetPos() )

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() and self:HaveEnemy() and cvar:GetFloat() == 0 and cvar2:GetFloat() == 0 ) do

		if ( path:GetAge() > 0.1 ) then
			path:Compute( self, self:GetEnemy():GetPos() )
		end
		path:Update( self )

		if ( options.draw ) then path:Draw() end
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end
		
		coroutine.yield()
	
		if self:GetRangeTo( self:GetEnemy():GetPos() ) >= 6000 then
			if gcvar2:GetFloat() == 1 then do
				self:Teleport()
			end
		end
	end	
		local door = ents.FindInSphere( self:GetPos(), 30 )
		local prop = ents.Create( "prop_physics" )
		if gcvar:GetFloat() == 1 then do
			if door then
				for i = 1, #door do
					local v = door[ i ]
					if v:GetClass() == "func_door" || v:GetClass() == "prop_door_rotating" then	
						if !v:GetSkin() then
							v:EmitSound( "087_door_break.wav" )
							v:Remove()
						else
							prop:SetModel( v:GetModel() )
							prop:SetSkin( v:GetSkin() )
							prop:SetPos( v:GetPos() )
							prop:SetAngles( v:GetAngles() )
							prop:SetCollisionGroup( COLLISION_GROUP_NONE )
							v:Remove()
							prop:Spawn()
							v:EmitSound( "087_door_break.wav" )
					local phys = prop:GetPhysicsObject()
						if ( phys != nil && phys != NULL && phys:IsValid() ) then
							phys:ApplyForceCenter( self:GetForward():GetNormalized()*20000 + Vector( 0, 0, 2 ) )
								end
							end
						end
					end
				end
			end
			
		else
			for i = 1, #door do
					local v = door[ i ]
					if v:GetClass() == "func_door" || v:GetClass() == "prop_door_rotating" then
						v:Remove()
						v:EmitSound( "087_door_break.wav" )
					end
			end
		
			
		end
		
		for k, enemy in pairs( ents.FindInSphere( self:GetPos(), 30 ) ) do
			if enemy then
					if enemy:IsPlayer() || enemy:IsNPC() then
						self:Gotcha()
						if enemy:Health() > 0 then
							if ( ( self:GetRangeTo( enemy:GetPos() ) ) < 30 ) then do
								enemy:TakeDamage( 99999999999, self, enemy ) end
							for k, ply in pairs( player.GetAll() ) do
								if massage:GetFloat() == 1 then do
									if enemy:GetName() == "" then
										ply:ChatPrint( "The Gman has caught the soul of a NPC!" )

									else
										--ply:ChatPrint( "The Gman has caught the soul of " .. enemy:GetName() .. "!" )
										ply:ChatPrint( "SCP-087-B-1 caught another soul!") --hmf.
										
										end
									end
								end
							end
							if enemy:GetName() ~= "" then 
								print("Gman killed: "..enemy:GetName())
							end 
						end
					end
				end
			end
		end
	end
		
	return "ok"

end

function ENT:OnKilled( dmginfo )

	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
self.Oeightsevenambience:Stop()
	self:BecomeRagdoll( dmginfo )

end

function ENT:OnStuck()
	self:Teleport()
end

--function ENT:OnContact( ent )
--local gcvar = GetConVar( "087b1_chatmassage" )
--
	--if ent:IsPlayer() || ent:IsNPC() then
		--if ent:Health() > 0 then do
	--ent:TakeDamage( 99999999999, self, ent ) end
	--if gcvar:GetFloat() == 1 then do
	--ply:ChatPrint( "The Gman has caught the soul of " .. ent:GetName() .. "!" )
					--end
				--end
			--end
		--end
	--end
--end

function ENT:OnLeaveGround()
	self:StartActivity( ACT_JUMP )
end

function ENT:OnLandOnGround()
	if self:HaveEnemy() then
		if ( GetConVar( "087b1_speed" ):GetFloat() <= 200 ) then
			self:StartActivity( ACT_WALK )
		else
			self:StartActivity( ACT_HL2MP_RUN_FIST )
		end
	else
		self:StartActivity( ACT_IDLE_ON_FIRE )
	end
end

function ENT:Teleport()
	self:SetPos( self:GetEnemy():GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 250 )
	self:EmitSound("087_spooky_" .. math.random(1, 3) .. ".wav", 100, 100)
end

function ENT:Gotcha()
self:EmitSound("087_death.wav")
end

function ENT:OnRemove()
self.Oeightsevenambience:Stop()
end