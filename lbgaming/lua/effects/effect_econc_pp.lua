function EFFECT:Init(data)		
	local Startpos = data:GetOrigin()
			
		self.Emitter = ParticleEmitter(Startpos)
	
		for i = 200, 400 do
			local p = self.Emitter:Add("effects/redflare", Startpos)
			
			p:SetDieTime(math.Rand(0.5, 2))
			p:SetStartAlpha(255)
			p:SetEndAlpha(0)
			p:SetStartSize(math.Rand(10, 20))
			p:SetEndSize(1)
		//	p:SetRoll(math.random(-60, 60))
		//	p:SetRollDelta(math.random(-60, 60))	
			p:SetVelocity(VectorRand() * 30)
			p:SetGravity(Vector(0, 0, math.random(-50, 0)))
			p:SetCollide(true)
		end
		
		self.Emitter:Finish()
end
		
function EFFECT:Think()
	return false
end

function EFFECT:Render()
end