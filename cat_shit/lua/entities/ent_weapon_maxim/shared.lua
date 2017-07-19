AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Maxim Maxhine Gun"
ENT.Author = "Annoying Rooster"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.Category = "World War 2"
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.Primary = {}
ENT.Primary.Delay = 1/(600/80)
ENT.Primary.Recoil = 1
ENT.Primary.Spread = .01
ENT.Primary.Damage = 44
ENT.Primary.Sound = Sound("Mounted_MaximGun.Single")
ENT.Primary.Clip = 50
ENT.Primary.ReloadTime = 13

local sndt = {
	channel = CHAN_WEAPON,
	volume = 1,
	soundlevel = 130,
	pitchstart = 95,
	pitchend = 100,
}

sndt.name = "Mounted_MaximGun.Single"
sndt.sound = {
	"m14_fire1.wav",
}
sound.Add( sndt )

function ENT:GetShootPos()
	local pos, ang = self:GetPos(), self:GetAngles()
	local modPos = Vector(42, 0, 15)

	pos = pos + ang:Up() * modPos[3]
	pos = pos + ang:Right() * modPos[2]
	pos = pos + ang:Forward() * modPos[1]

	return pos
end

function ENT:GetShootDir()
	local pos, ang = self:GetPos(), self:GetAngles()
	return ang:Forward() * 1
end

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/red orchestra 2/russians/weapons/maxim.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		-- DT 0: isReloading?
		self:SetDTBool(0, false)
		-- DT 1: isJammed?
		self:SetDTBool(0, false)
		local physicsObject = self:GetPhysicsObject()

		self:SetBodygroup(1, 0)
		self:SetBodygroup(2, 1)
		self.spread = 0

		if (IsValid(physicsObject)) then
			physicsObject:Wake()
		end
	end

	function ENT:CanFire()
		return (
			self:GetDTBool(0) != true
			and self:GetDTBool(1) != true
			and (!self.nextFire or self.nextFire < CurTime())
		)
	end

	function ENT:Use(client)
		local parent = self:GetParent()
		if (parent and IsValid(parent)) then
			parent:OnUse(client)
		end
	end

	function ENT:ShootBullet()

		if (self:CanFire() != true) then

			return
		end

		self:EmitSound(self.Primary.Sound)
		self:SetDTInt(0, self:GetDTInt(0) - 1)
		if (self:GetDTInt(0) == 0) then
			self:SetBodygroup()
		end

		local e = EffectData()
		e:SetEntity(self)
		e:SetScale(1)
		e:SetOrigin(self:GetShootPos())
		e:SetNormal(self:GetShootDir())
		util.Effect("KordBurst", e)

		local e = EffectData()
		e:SetScale(1)
		e:SetOrigin(self:GetPos() + self:GetRight() * 13 + self:GetUp() * -10)
		e:SetNormal(self:GetForward() * 1)
		util.Effect("KordShell", e)

		local bullet = {}
		if IsValid(self:GetParent()) then
			if IsValid(self:GetParent().Owner) then
				bullet.Attacker = self:GetParent().Owner
			end
		end
		bullet.Num    = 1
		bullet.Src    = self:GetShootPos()
		bullet.Dir    = self:GetShootDir()
		bullet.Spread = Vector( self.Primary.Spread + self.spread, self.Primary.Spread + self.spread, 0 )
		bullet.Tracer = 0
		bullet.Force  = 10
		bullet.Damage = self.Primary.Damage
		self:FireBullets(bullet)
		self.spread = self.spread + .001
		self.nextFire = CurTime() + self.Primary.Delay
	end

	function ENT:Think()
		if (self.spread) then
			self.spread = math.Clamp(self.spread - .0001, 0, .025)
		end

		self:NextThink(CurTime())
		return true
	end
else
	-- register gun effect
	-- emit :DD
	local META = FindMetaTable("CLuaEmitter")
	if not META then return end
	function META:DrawAt(pos, ang, fov)
		local pos, ang = WorldToLocal(EyePos(), EyeAngles(), pos, ang)
		cam.Start3D(pos, ang, fov)
			self:Draw()
		cam.End3D()
	end

	local EFFECT = {}

	function EFFECT:FixedParticle()
		local function maxLife(min, max)
			return math.Rand(math.min(min, self.lifeTime), math.min(max or self.lifeTime, self.lifeTime))
		end

		local p = self.emitter:Add("particle/smokesprites_000"..math.random(1,9), Vector(0, 0, 0))
		p:SetVelocity(150*Vector(1, 0, 0))
		p:SetDieTime(maxLife(.1, .2))
		p:SetStartAlpha(math.Rand(115,215))
		p:SetEndAlpha(0)
		p:SetStartSize(math.random(10,20)*self.scale)
		p:SetEndSize(math.random(22,44)*self.scale)
		p:SetRoll(math.Rand(180,480))
		p:SetRollDelta(math.Rand(-3,3))
		p:SetColor(150,150,150)
		p:SetGravity( Vector( 0, 0, 100 )*math.Rand( .2, 1 ) )

		local max = 8
		for i = 1, max do
			local p = self.emitter:Add("effects/muzzleflash" .. math.random(1, 4), Vector(i*7 + i, 0, 0))
			p:SetVelocity(math.Rand(120, 150)*Vector(1, 0, 0)*(self.scale*1.5))
			p:SetDieTime(maxLife(.05, .07))
			p:SetStartAlpha(255)
			p:SetEndAlpha(150)
			p:SetStartSize(math.random(6,8)*self.scale*(max - i)/2)
			p:SetEndSize(math.random(6,8)*self.scale*(max - i)/1.2)
			p:SetRoll(math.Rand(180,480))
			p:SetRollDelta(math.Rand(-3,3))
			p:SetColor(255,255,255)
		end

		local angle = Angle(0, 0, 0)
		for i = 1, 2 do
			angle:RotateAroundAxis(Vector(1, 0, 0), 180)

			local p = self.emitter:Add("effects/muzzleflash1", angle:Right()*-4)
			p:SetVelocity(400*angle:Right())
			p:SetDieTime(maxLife(.07, .1))
			p:SetStartAlpha(255)
			p:SetEndAlpha(150)
			p:SetStartSize(math.random(6,8)*self.scale*2)
			p:SetEndSize(math.random(13,25)*self.scale*1.2)
			p:SetRoll(math.Rand(180,480))
			p:SetRollDelta(math.Rand(-3,3))
			p:SetColor(255,255,255)
		end
	end

	function EFFECT:FreeParticle(at)
		local p = self.freeEmitter:Add("particle/smokesprites_000"..math.random(1,9), self.origin)
		local dir = self.dir

		for i = 1, 11 do
			p:SetVelocity(20*dir*(self.scale*2)*i*1)
			p:SetDieTime(math.Rand(.4, .5))
			p:SetStartAlpha(math.Rand(55,75))
			p:SetEndAlpha(0)
			p:SetStartSize(math.Rand(11,15)*self.scale)
			p:SetEndSize(math.Rand(4,5)*self.scale*i*1.2)
			p:SetRoll(math.Rand(180,480))
			p:SetRollDelta(math.Rand(-2,2))
			p:SetColor(150,150,150)
			p:SetGravity( Vector( 0, 0, 100 )*math.Rand( .2, 1 ) )
			p:SetAirResistance(150)
		end
	end

	function EFFECT:Init(data)
		self.ent = data:GetEntity()
		--self.scale = data:GetScale()
		self.scale = math.Rand(1, 1.5)
		self.origin = data:GetOrigin()
		self.dir = data:GetNormal()
		self.lifeTime = .2
		self.decayTime = CurTime() + self.lifeTime
		self.emitter = self.ent.emitter or ParticleEmitter(Vector(0, 0, 0))
		self.freeEmitter =  ParticleEmitter(Vector(0, 0, 0))
		local hvec = Vector(65536, 65536, 65536)
		self:SetRenderBounds(-hvec, hvec)
		self.fired = false
		self.emitter:SetNoDraw(true)

		self:FreeParticle()
		self:FixedParticle()

		local vec = Vector(0, 2, 0)
		self.ent.push = vec
	end

	function EFFECT:Render()
		return false
	end

	function EFFECT:Think()
		if (self.decayTime < CurTime()) then
			-- garbage collecting process

			self:Remove()
			return false
		end

		return true
	end

	effects.Register(EFFECT, "KordBurst")

	local EFFECT = {}

	function EFFECT:Init(data)
		local ejectPos = data:GetOrigin()
		local ejectDir = data:GetNormal() + Vector(math.Rand(-.3, .3), math.Rand(-.5, 0), math.Rand(-.2, .5))

		self.emitter =  ParticleEmitter(Vector(0, 0, 0))
		self.lifeTime = CurTime() + 1
		self.Entity:SetPos(ejectPos)
		self.Entity:SetModel("models/weapons/rifleshell.mdl")
		self.Entity:PhysicsInitBox( Vector(-1,-1,-1), Vector(1,1,1) )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		self.Entity:SetCollisionBounds(Vector( -128 -128, -128 ), Vector( 128, 128, 128 ))
		self.Entity:SetModelScale(.6, 0)
		local phys = self.Entity:GetPhysicsObject()

		if (phys:IsValid()) then
			phys:Wake()
			phys:SetDamping( 0, 15 )
			phys:SetVelocity( ejectDir * math.random( 150, 200 ) )
			self.Entity.spinVector = ( VectorRand() * 5000 )
			phys:AddAngleVelocity( self.Entity.spinVector )
			phys:SetMass( .1 )
			phys:SetMaterial( "gmod_silent" )
		end

		local p = self.emitter:Add("particle/smokesprites_000"..math.random(1,9), ejectPos)
		p:SetVelocity(40*ejectDir)
		p:SetDieTime(.1)
		p:SetStartAlpha(math.Rand(5,15))
		p:SetEndAlpha(0)
		p:SetStartSize(math.random(2,4)*1)
		p:SetEndSize(math.random(6,8)*1)
		p:SetRoll(math.Rand(180,480))
		p:SetRollDelta(math.Rand(-3,3))
		p:SetColor(255,255,255)
		p:SetGravity( Vector( 0, 0, 100 )*math.Rand( .2, 1 ) )
	end

	function EFFECT:Think()
		if self.lifeTime < CurTime() then
			self.Entity:Remove()

			self:Remove()
		end

		if (!self.air) then
			local phys = self.Entity:GetPhysicsObject()
			if ( phys ):IsValid() then
				phys:AddAngleVelocity( self.Entity.spinVector )
			end
		end

		return true
	end

	function EFFECT:PhysicsCollide(data)
		if (!self.air) then
			self.air = true

			self:EmitSound("player/pl_shell".. math.random(1, 3) .. ".wav", 28, math.random(90, 95))
		end

		if (data.Speed and data.Speed > 50) then
			local phys = self.Entity:GetPhysicsObject()
			local impulse = -data.Speed * data.HitNormal * .01 + (data.OurOldVelocity * -0.02)
			phys:AddAngleVelocity( self.Entity.spinVector )
			phys:ApplyForceCenter(impulse)
		end
	end

	effects.Register(EFFECT, "KordShell")

	function ENT:Initialize()
		self.emitter = ParticleEmitter( self:GetPos() )
		self.emittime = CurTime()
	end

	local function fTime() return math.Clamp(FrameTime(), 1/60, 1) end
	local GLOW_MATERIAL = Material("sprites/glow04_noz.vmt")
	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:DrawTranslucent()
		self.emitter:DrawAt(self:GetShootPos(), self:GetShootDir():Angle())

		local data = {}
			data.start = self:GetShootPos()
			data.endpos = data.start + self:GetShootDir() * 65535
		local trace = util.TraceLine(data)

		local size = 16
		render.SetMaterial(GLOW_MATERIAL)
		render.DrawSprite(trace.HitPos + trace.HitNormal * size/4, size, size, Color( 255, 0, 0, 255 ) )

		if (self.push) then
			self.push = LerpVector(fTime()*5, self.push, Vector(0, 0, 0))

			self:ManipulateBonePosition(0, self.push)
		end
	end
end
