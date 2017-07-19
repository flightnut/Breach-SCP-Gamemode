AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Maxim Machine Gun"
ENT.Author = "Annoying Rooster"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "World War 2"

if (SERVER) then
	function ENT:GetTurretAngle()
		local modAng = Angle(0, 90, 180)
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), modAng[1])
		ang:RotateAroundAxis(ang:Right(0), modAng[2])
		ang:RotateAroundAxis(ang:Forward(), modAng[3])

		ang:RotateAroundAxis(ang:Up(), 180)

		return ang
	end

	function ENT:GetTurretPos()
		local pos, ang = self:GetPos(), self:GetAngles()
		local modPos = Vector(-3, 0, 0)

		pos = pos + ang:Up() * modPos[3]
		pos = pos + ang:Right() * modPos[2]
		pos = pos + ang:Forward() * modPos[1]

		return pos
	end

	function ENT:Initialize()
		self:SetModel("models/props_lab/tpplug.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:Wake()
		end

		self.gun = ents.Create("ent_weapon_maxim")
		self.gun:SetPos(self:GetTurretPos())
		self.gun:SetAngles(self:GetTurretAngle())
		self.gun:Spawn()
		self.gun:Activate()
		self.gun:SetParent(self)
		self:DeleteOnRemove(self.gun)
		self.gunAng = Angle(0, 0, 0)
	end

	function ENT:AddGunAngle(ang)
		self.gunAng = self.gunAng + ang

	end

	function ENT:OnRemove()
		if (self.Owner and IsValid(self.Owner)) then
			if string.StartWith(self.Owner:GetActiveWeapon():GetClass(),"keycard_") or string.StartWith(self.Owner:GetActiveWeapon():GetClass(),"item_") then
				self.Owner:GetViewModel():SetNoDraw(true) -- leave it ok thx
			else
				self.Owner:GetViewModel():SetNoDraw(false)
			end
			self.Owner.Turret = nil
		end
	end

	function ENT:Think()
		if (self.Owner and IsValid(self.Owner) and self.Owner:Alive() and self:GetPos():Distance(self.Owner:GetPos()) <= 64) then
			local aimVector = self.Owner:GetAimVector()
			local turretForward = self:GetUp()
			local turretDot = turretForward:Dot(aimVector)

			if (turretDot > 0 or math.abs(turretDot) < .2) then
				if string.StartWith(self.Owner:GetActiveWeapon():GetClass(),"keycard_") or string.StartWith(self.Owner:GetActiveWeapon():GetClass(),"item_") then
					self.Owner:GetViewModel():SetNoDraw(true) -- leave it ok thx
				else
					self.Owner:GetViewModel():SetNoDraw(false)
				end
				self.Owner.Turret = nil
				self.Owner = nil
				return
			end

			local data = {}
				data.start = self.Owner:GetShootPos()
				data.endpos = data.start + aimVector*10000
				data.filter = {self.Owner, self, self.gun}
			local trace = util.TraceLine(data)

			local cappedVector = (turretForward + trace.Normal)
			cappedVector.x = math.Clamp( cappedVector.x, -.5, .5)
			cappedVector.y = math.Clamp( cappedVector.y, -.5, .5)
			cappedVector.z = math.Clamp( cappedVector.z, -.4, .2)

			local ang = (turretForward - cappedVector):Angle()
			ang:RotateAroundAxis(ang:Up(), 180)

			self.gunAng = LerpAngle( .03, self.gunAng, ang )
			self.gun:SetAngles(self.gunAng)

			if self.Owner:GetActiveWeapon():IsValid() then
				self.Owner:GetActiveWeapon():SetNextPrimaryFire(CurTime()+1)
				self.Owner:GetActiveWeapon():SetNextSecondaryFire(CurTime()+1)
			end

			if self.Owner:KeyDown( IN_ATTACK ) then
				self.gun:ShootBullet()
			end
		else
			if (self.Owner and IsValid(self.Owner)) then
				if string.StartWith(self.Owner:GetActiveWeapon():GetClass(),"keycard_") or string.StartWith(self.Owner:GetActiveWeapon():GetClass(),"item_") then
					self.Owner:GetViewModel():SetNoDraw(true) -- leave it ok thx
				else
					self.Owner:GetViewModel():SetNoDraw(false)
				end
				self.Owner.Turret = nil
				self.Owner = nil
			end
		end

		self:NextThink(CurTime())
		return true
	end

	function ENT:Use(client)
		self:OnUse(client)
	end

	function ENT:OnUse(client)
		if (self.Owner and IsValid(self.Owner)) then
			if (self.Owner == client) then
				self:EmitSound("Func_Tank.BeginUse")
				if string.StartWith(self.Owner:GetActiveWeapon():GetClass(),"keycard_") or string.StartWith(self.Owner:GetActiveWeapon():GetClass(),"item_") then
					self.Owner:GetViewModel():SetNoDraw(true) -- leave it ok thx
				else
					self.Owner:GetViewModel():SetNoDraw(false)
				end
				self.Owner.Turret = nil
				self.Owner = nil
			end
		else
			local aimVector = client:GetAimVector()
			local turretForward = self:GetUp()
			local turretDot = turretForward:Dot(aimVector)

			if (turretDot > 0 or math.abs(turretDot) < .2) then
				return
			end

			if (client.Turret and IsValid(client.Turret)) then
				return
			end

			self.gun.nextFire = CurTime() + .7
			self:EmitSound("Func_Tank.BeginUse")
			self.Owner = client
			self.Owner:GetViewModel():SetNoDraw(true) -- leave it ok thx
			self.Owner.Turret = self
		end
	end
end
