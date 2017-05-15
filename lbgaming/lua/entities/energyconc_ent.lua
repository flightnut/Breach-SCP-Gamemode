AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false

function ENT:Draw()
	self:DrawModel()
	
    local dlight = DynamicLight(self:EntIndex())	
	
	if dlight then
		local r, g, b, a = self:GetColor()
		dlight.Pos = self:GetPos() + self:GetForward() * 30
		dlight.r = 255
		dlight.g = 0
		dlight.b = 0
		dlight.Brightness = 0
		dlight.Size = 500
		dlight.Decay = 0
		dlight.DieTime = CurTime() + 0.1
	end   
end

if CLIENT then return end

function ENT:Initialize()
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMaterial("models/effects/vol_light001")
	self:SetPhysicsAttacker(self.Owner)
	
	timer.Create("effe35dfs" .. self:EntIndex(), 0.01, 0, function()
		if not IsValid(self) then timer.Stop("effedfs" .. self:EntIndex()) return end
		
		local ef = EffectData()
		ef:SetOrigin(self:GetPos())
		ef:SetAttachment(1)
		util.Effect("effect_econc_fly", ef, true, true)	
	end)
end

function ENT:Think()
	if self:WaterLevel() == 3 then self:Remove() end
end

function ENT:Damage(data, physobj)

	local ind = math.random(1,100)
	
	local npcs = {
		"npc_fastzombie",
		"npc_poisonzombie",
		"npc_zombie",
		"npc_headcrab",
		"npc_headcrab_black",
		"npc_headcrab_fast",
		"npc_turret_floor",
		"npc_manhack",
		"npc_cscanner",
		"npc_crow",
		"npc_pigeon",
		"npc_seagull",
		"npc_clawscanner"
	}
	
	local models = {
		"models/props_c17/oildrum001_explosive.mdl",
		"models/props_borealis/bluebarrel001.mdl",
		"models/props_c17/FurnitureCouch002a.mdl",
		"models/Gibs/HGIBS.mdl",
		"models/Gibs/Fast_Zombie_Legs.mdl",
		"models/props_lab/monitor02.mdl",
		"models/props_junk/garbage_glassbottle003a.mdl",
		"models/props_junk/metal_paintcan001a.mdl",
		"models/props_junk/watermelon01.mdl",
		"models/props_junk/TrashBin01a.mdl",
		"models/props_junk/PopCan01a.mdl",
		"models/props_lab/crematorcase.mdl",
		"models/props_vehicles/carparts_wheel01a.mdl",
		"models/props_lab/cactus.mdl",
		"models/props_c17/FurnitureFridge001a.mdl",
		"models/props_c17/FurnitureRadiator001a.mdl",
		"models/props_interiors/VendingMachineSoda01a.mdl",
		"models/props_junk/CinderBlock01a.mdl",
		"models/props_interiors/pot01a.mdl",
		"models/props_combine/breenchair.mdl",
		"models/props_junk/MetalBucket01a.mdl",
		"models/props_junk/TrafficCone001a.mdl",
		"models/props_trainstation/trashcan_indoor001a.mdl",
		"models/props_junk/wood_crate001a.mdl",
		"models/props_junk/gascan001a.mdl",
		"models/props_lab/reciever01b.mdl",
		"models/props_c17/TrapPropeller_Engine.mdl",
		"models/props_vehicles/carparts_door01a.mdl",
		"models/props_junk/Shoe001a.mdl",
		"models/props_junk/garbage_metalcan001a.mdl",
		"models/props_c17/gravestone004a.mdl",
		"models/props_c17/doll01.mdl",
		"models/props_c17/BriefCase001a.mdl",
		"models/props_lab/huladoll.mdl",
		"models/props_junk/garbage_newspaper001a.mdl",
		"models/props_lab/citizenradio.mdl",
		"models/props_interiors/Furniture_Couch02a.mdl",
		"models/props_combine/breenbust.mdl",
		"models/props_interiors/Furniture_Lamp01a.mdl",
		"models/props_c17/cashregister01a.mdl"
	}

	local dmgtyp = {
			DMG_SONIC,
			DMG_BLAST,
			DMG_ACID,
			DMG_POISON,
			DMG_DROWN,
			DMG_FALL,
			DMG_BULLET,
			DMG_CRUSH,
			DMG_SLASH,
			DMG_BURN,
			DMG_SHOCK,
			DMG_ENERGYBEAM,
			DMG_NERVEGAS,
			DMG_PLASMA,
			DMG_RADIATION,
			DMG_PHYSGUN
	}
	
	local dmg = DamageInfo()
	
	local owner = self:GetOwner()
	if not IsValid(owner) then owner = self end
	
	dmg:SetAttacker(owner)
	dmg:SetInflictor(self)
	
	local npc2 = npcs[math.random(1,#npcs)]
	
	randd = math.random(1,100)
	
	if randd >= 41 and randd <= 46 then npc2 = "npc_antlionguard" end
	if randd >= 36 and randd <= 39 then npc2 = "npc_combinegunship" end
	if randd == 58 then npc2 = "npc_strider" end
	
	if ind >= 1 and ind <= 20 then 	
		dmg:SetDamage(math.random(30,60))
		dmg:SetDamageType(dmgtyp[math.random(1,#dmgtyp)])
		data.HitEntity:TakeDamageInfo(dmg)
	end
	
	if ind >= 21 and ind <= 23 then 
		self.Owner:TakeDamage(self.Owner:Health(), self.Owner, self)
	end
	
	if ind >= 24 and ind <= 30 then 
		data.HitEntity:TakeDamage(data.HitEntity:Health(), self.Owner, self)
	end
	
	if ind >= 31 and ind <= 43 then
		if data.HitEntity:IsPlayer() or data.HitEntity:IsNPC() then
	
			local damg = math.random(30,60)
			if data.HitEntity:Health() < damg then damg = data.HitEntity:Health() end
	
			dmg:SetDamage(damg)
			dmg:SetDamageType(dmgtyp[math.random(1,#dmgtyp)])
			data.HitEntity:TakeDamageInfo(dmg)
			owner:SetHealth(owner:Health()+damg)
		end
	end
	
	if ind >= 44 and ind <= 50 then
		data.HitEntity:SetHealth(data.HitEntity:GetMaxHealth())
	end
	
	if ind >= 51 and ind <= 57 then
		if data.HitEntity:IsPlayer() or data.HitEntity:IsNPC() then
			data.HitEntity:SetMaterial("models/effects/vol_light001")
			data.HitEntity:DrawShadow(false)
		end
		
		if data.HitEntity:IsPlayer() then 		
			timer.Create("shsf"..self:EntIndex(), 30, 1, function()
				if not data.HitEntity or not IsValid(data.HitEntity) then return end
				data.HitEntity:SetMaterial("bom")
				data.HitEntity:DrawShadow(true)				
			end)
		end
	end
	
	if ind >= 58 and ind <= 68 then
		if data.HitEntity:IsNPC() then
			data.HitEntity:Remove()
				
			local npc21 = ents.Create(npc2)						
			npc21:SetPos(data.HitPos + Vector(0,0,100))
			npc21:Spawn()			
			npc21:Activate()
		end
		
		if data.HitEntity:IsPlayer() then
			data.HitEntity:KillSilent()	
		
			local npc21 = ents.Create(npc2)
			npc21:SetPos(data.HitPos + Vector(0,0,100))
			npc21:Spawn()			
			npc21:Activate()
		end
	end
	
	if ind >= 69 and ind <= 79 then	
		if data.HitEntity:IsNPC() then
			data.HitEntity:Remove()
		
			local prop13 = ents.Create("prop_physics")
			prop13:SetModel(models[math.random(1,#models)])
			prop13:SetPos(data.HitPos)
			prop13:Spawn()
		end
		
		if data.HitEntity:IsPlayer() then
			data.HitEntity:KillSilent()	
		
			local prop13 = ents.Create("prop_physics")
			prop13:SetModel(models[math.random(1,#models)])
			prop13:SetPos(data.HitPos)
			prop13:Spawn()
		end
	end
	
	if ind >= 80 and ind <= 90 then
		local explode = ents.Create("env_explosion")
		explode:SetPos(data.HitPos)
		explode:Spawn()
		explode:Fire( "Explode", 0, 0 )
		explode:SetKeyValue( "iMagnitude", "0" )
		
		util.BlastDamage(self, owner, data.HitPos, 200, 200)
	end
	
	if ind >= 91 and ind <= 100 then
		local npc21 = ents.Create(npc2)
		
		npc21:SetPos(data.HitPos + Vector(0,0,100))		
		npc21:Spawn()		
		npc21:Activate()
	end
end

function ENT:PhysicsCollide(data, physobj)	
	local ef = EffectData()
	ef:SetOrigin(self:GetPos())
	ef:SetAttachment(1)
	util.Effect("effect_econc_pp", ef, true, true)
	
	self:Damage(data, physobj)
	
	self:EmitSound("physics/nearmiss/whoosh_large4.wav", 100, 200)
	
	self:Remove()
end