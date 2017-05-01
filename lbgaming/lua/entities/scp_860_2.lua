AddCSLuaFile()
local scale = 1.1
if TEAM_SCP == nil or TEAM_SPEC == nil then
	TEAM_SCP = math.huge
	TEAM_SPEC = math.huge
end
ENT.Base = "base_nextbot"
ENT.Class			= "scp_860_2"
ENT.Spawnable		= true
ENT.PrintName 		= "SCP-860-2"
ENT.Author 			= "Cat"
ENT.Contact 		= "http://steamcommunity.com/id/DoNotuwu/"
ENT.Purpose 		= "Kill anyone entering SCP-860-1"
ENT.Instructions 	= "Spawn in 860"
ENT.Category		= "SCP"

function ENT:Initialize()
	self:SetModel("models/cultist_kun/scp860_v1.mdl")
	self.LoseTargetDist	= 2000
	self.EyesightDistance = 1000
	self.AttentionSpan = 120
	self.next_sound = "860ambient1.ogg"
	self.Running = false
	self.Enemys = {}
	self.VisionTable = {}
	self.Target = nil
	self:SetModelScale(scale)
	self:SetCollisionBounds(Vector(36.5*scale,16.5*scale,0),Vector(-93*scale,-16.5*scale,55*scale))
end

function ENT:AddEnemy( ent )
	table.insert(self.Enemys,#self.Enemys,ent)
	table.insert(self.VisionTable,#self.VisionTable,{last_seen_pos=ent:GetPos(),visible=true,lost_interest_count=self.AttentionSpan})
end

function ENT:GetTarget()
	return self.Target
end

function ENT:HaveTarget()
	local target = self:GetTarget()
	if target and IsValid( target ) then
		if self:GetRangeTo(target:GetPos()) >= self.LoseTargetDist or (target:IsPlayer() and not target:Alive()) then
			return self:SelectTarget()
		end
		return true
	else
		return self:SelectTarget()
	end
	return false
end

function ENT:SelectTarget()
	local target = nil
	local visible_only = false
	local found = false
	for i=1,#self.Enemys do
		if self.Enemys[i]:Alive() and self:GetRangeTo(self.Enemys[i]) < self.LoseTargetDist then
			if self.VisionTable[i].visible == true then
				visible_only = true
				if (not target) or (not IsValid(target)) or self:GetRangeTo(target:GetPos()) > self:GetRangeTo(self.Enemys[i]:GetPos()) then
					target = self.Enemys[i]
					found = true
				end
			elseif not visible_only then
				if (not target) or (not IsValid(target)) or self:GetRangeTo(target:GetPos()) > self:GetRangeTo(self.Enemys[i]:GetPos()) then
					target = self.Enemys[i]
					found = true
				end
			end
		end
	end
	self.Target = target
	return found
end

local attack_seqs = {"h2attackleft","h2attackleft_midbite","h2attackright","h2attackright_midbite"}
function ENT:RandomAttackSeq()
	return attack_seqs[math.random(1,#attack_seqs)]
end

function ENT:Tracked(v)
	for i=1,#self.Enemys do
		if v == self.Enemys[i] then
			return true
		end
	end
	return false
end

function ENT:PerformSight()
	local foundEnts = ents.FindInSphere(self:GetPos(),self.EyesightDistance)
	for i=1,#self.Enemys do
		self.VisionTable[i].visible = false
		self.VisionTable[i].lost_interest_count = self.VisionTable[i].lost_interest_count - 1
	end
	for k,v in pairs(foundEnts) do
		if v:IsPlayer() and not self:Tracked(v) and v:Team() ~= TEAM_SPEC and v:Team() ~= TEAM_SCP then
			self:AddEnemy(v)
		elseif v:IsPlayer() then
			for i=1,#self.Enemys do
				if self.Enemys[i] == v then
					self.VisionTable[i].last_seen_pos=v:GetPos()
					self.VisionTable[i].visible = true
					self.VisionTable[i].lost_interest_count = self.AttentionSpan
					break
				end
			end
		end
	end
	local i = 1
	while i < #self.Enemys do
		if self.VisionTable[i].lost_interest_count <= 0 then
			table.remove(self.VisionTable,i)
			table.remove(self.Enemys,i)
		else
			i = i + 1
		end
	end
end

function ENT:MoveToPos( pos, options )

	local options = options or {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do

		path:Update( self )
		self:EmitSound("scp_860_2/860walk"..math.random(1,2)..".ogg")
		self:PerformSight()
		
		if self:HaveTarget() then
			return "ok"
		end

		-- Draw the path (only visible on listen servers or single player)
		if ( options.draw ) then
			path:Draw()
		end

		-- If we're stuck then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then

			self.Target = nil
			
			return "stuck"

		end

		--
		-- If they set maxage on options then make sure the path is younger than it
		--
		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end

		--
		-- If they set repath then rebuild the path every x seconds
		--
		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end

		coroutine.yield()

	end

	return "ok"

end

function ENT:ChaseTarget()
	local options = options or {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, self:GetTarget():GetPos() )		-- Compute the path towards the enemy's position

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() and self:HaveTarget() and self:GetTarget():Alive() ) do

		if ( path:GetAge() > 0.1 ) then
			path:Compute( self, self:GetTarget():GetPos() )
		end
		--self.loco:FaceTowards( (path:GetPositionOnPath(path:GetCursorPosition()+1)*0.25 + self.loco:GetGroundMotionVector()*0.75):GetNormalized())
		path:Update( self )								-- This function moves the bot along the path
		self:EmitSound("scp_860_2/860walk"..math.random(1,2)..".ogg")
		self:PerformSight()
		
		if self:GetRangeTo(self:GetTarget():GetPos()) <= 129.6*scale and self:GetTarget():Alive() then
			self:EmitSound("scp_860_2/860attack"..math.random(1,2)..".ogg")
			self.loco:FaceTowards(self:GetTarget():GetPos())
			self:PlaySequenceAndWait(self:RandomAttackSeq())
			self:GetTarget():TakeDamage(100,self,self)
		end
		
		if ( options.draw ) then path:Draw() end
		-- If we're stuck then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then
			self.Target = nil
			return "stuck"
		end
		coroutine.yield()
	end
end

function ENT:RunBehaviour()
	repeat
		self.next_sound = "860ambient"..math.random(1,3)..".ogg"
		self.loco:SetDeceleration(50)
		self:PerformSight()
		if self:HaveTarget() and not self.Running then
			self.Running = true
			self:PlaySequenceAndWait("h2hequip")
		end
		if self.Running then
			self:StartActivity( ACT_RUN )
			self:PlaySequence("mtfastfoward")
			self.loco:SetDesiredSpeed( 33*8*scale )
			self.loco:SetAcceleration( 900*scale )
			if self:HaveTarget() then
				self:ChaseTarget()
			elseif #self.Enemys > 0 and math.random(1,3) ~= 3 then
				local rand_vision = self.VisionTable[math.random(1,#self.Enemys)]
				self:MoveToPos(rand_vision.last_seen_pos)
			else
				self:PlaySequenceAndWait("h2hunequip")
				self.Running = false
			end
		else
			self:StartActivity( ACT_WALK )
			self:PlaySequence("mtfoward")
			self.loco:SetDesiredSpeed( 33*2*scale )
			self.loco:SetAcceleration( 200*scale )
			self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 200 )
			self:StartActivity( ACT_IDLE )
			self:PlaySequence("mtidle")
			coroutine.wait(1)
		end
		coroutine.yield()
	until false
end

function ENT:OnTakeDamage(d)
	damage:SetDamage(0)
	damage:SetDamageBonus(0)
end

function ENT:OnKilled(damage)
	damage:SetDamage(0)
	damage:SetDamageBonus(0)
end

function ENT:PlaySequence(name,speed)
	self:SetSequence( self:LookupSequence(name) )
	speed = speed or 1
	
	self:ResetSequenceInfo()
	self:SetCycle( 0 )
	self:SetPlaybackRate( speed  );
end
local function playnext()
	local scps = ents.FindByClass("scp_860_2")
	for k,v in pairs(scps) do
		v:EmitSound( "scp_860_2/"..v.next_sound)
	end
end
timer.Create("scp_860_2sounds",75,0,playnext)

list.Set( "NPC", "scp_860_2", {
	Name = "SCP-860-2",
	Class = "scp_860_2",
	Category = "SCP"
} )
