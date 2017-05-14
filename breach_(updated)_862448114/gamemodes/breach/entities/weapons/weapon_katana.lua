if( SERVER ) then
	AddCSLuaFile( "weapon_katana.lua" )
	resource.AddFile("models/weapons/w_katana.mdl");
	resource.AddFile("models/weapons/v_katana.mdl");
	resource.AddFile("materials/models/weapons/v_katana/katana_normal.vtf");
	resource.AddFile("materials/models/weapons/v_katana/katana.vtf");
	resource.AddFile("materials/models/weapons/v_katana/katana.vmt");
end

if( CLIENT ) then
	SWEP.PrintName = "SCP-076 Katana"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end

SWEP.Author						= "Vorius"
SWEP.Instructions				= "Click to slash"
SWEP.Contact					= ""
SWEP.Purpose					= "SCP-076 Katana"
SWEP.Category					= "SCP Weapons"
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= true
SWEP.Thinkdelay       		    = 0
SWEP.Primary.Delay				= 0.25
SWEP.Primary.Recoil				= 0
SWEP.Primary.Damage				= math.random(28,45)
SWEP.Primary.NumShots			= 1
SWEP.Primary.Cone				= 0
SWEP.Primary.ClipSize			= -1
SWEP.ISSCP 						= true
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic   		= false
SWEP.Primary.Ammo         		= "none"
SWEP.Cloaked                    = false
SWEP.CSMuzzleFlashes			= true
SWEP.Secondary.Delay			= 5
SWEP.Secondary.Recoil			= 0
SWEP.Secondary.Damage			= 2
SWEP.Secondary.NumShots			= 1
SWEP.Secondary.Cone				= 0
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic  	 	= false
SWEP.Primary.Sound				= Sound( "Weapon_Knife.Slash" )
SWEP.HitDistance				= 75
SWEP.HitInclination				= 0.4
SWEP.HitPushback				= 850
SWEP.HoldType 					= "melee2"
SWEP.ViewModelFOV				= 60
SWEP.ViewModelFlip				= false
SWEP.ViewModel					= "models/weapons/v_katana.mdl"
SWEP.WorldModel 				= "models/weapons/w_katana.mdl"
SWEP.ThrowTimer    		        = false
SWEP.MeleeRevert    	        = false
SWEP.droppable 					= false
SWEP.IronSightsPos				= Vector (0, 0, 0)
SWEP.IronSightsAng 				= Vector (-66.4823, 4.1536, 0)

function SWEP:Initialize()
	self:SetWeaponHoldType("melee2");
	self.mode = 1
	self.changemode = 0
	self.CanPrimary = true
	self.Weapon:SetNetworkedBool( "Ironsights", false )

	self.Hit = {
		Sound( "weapons/rpg/shotdown.wav" )
	};
	self.FleshHit = {
  		Sound( "ambient/machines/slicer1.wav" ),
  		Sound( "ambient/machines/slicer2.wav" ),
		Sound( "ambient/machines/slicer3.wav" ),
  		Sound( "ambient/machines/slicer4.wav" ),
	} ;
end

function SWEP:StatIncrease()
	timer.Simple(0.5, function()
  		if not IsValid(self) or not IsValid(self.Owner) then return end
			if self.Owner:Health() <= 100 then
	 			self.Owner:SetHealth(self.Owner:Health() + 200)
	 		end
  		end)
end

function SWEP:Holster()
	if self:IsValid() and self.Owner:IsValid() then
		self.Owner:SetJumpPower(200)
		--[[
		self:SetNWBool( "Katana_View_Cloak", false)
		if self:GetNWBool("Katana_Cloak") == true then
			if not self.Owner:Alive() then
				self.Owner:SetMaterial("")
		 		if SERVER then
					self.Owner:DrawWorldModel( true )
		  		end
			else
				timer.Destroy("CloakTime")
				self:SetNWBool( "Katana_Cloak", false )
				self:EmitSound("npc/dog/dog_idle1.wav")
				self.Owner:DrawShadow( true )
				self.Owner:SetMaterial("")

				if SERVER then
					self.Owner:DrawWorldModel( true )
					self.Owner:SetNoTarget(false)
				end
			end
		end
		]]--
	end
end

--[[  ???
	return true
end
]]--

function SWEP:OnRemove()

end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	if not IsValid(self) or not IsValid(self.Owner) then return end

	if SERVER then
		self.Owner:DrawWorldModel( true )
	end
	self.Owner:SetJumpPower(400)

	return true
end

if SERVER then
	function SWEP:Equip( NewOwner )
		self:StatIncrease()
		--[[
		self:SetNWBool( "KatanaJump", false )
		self:SetNWBool( "Katana_View_Cloak", false )
		self:SetNWBool( "Katana_Cloak", false )
		]]--
	end
end

function SWEP:SecondaryAttack()

end

function SWEP:PrimaryAttack()
	if not IsValid(self) or not IsValid(self.Owner) then return end
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound )	--slash in the wind sound here
	--[[
	timer.Simple(0.2, function()
		if IsValid(self) then
			self:Slash()
		end
	end)
	]]--
	self:Slash()
	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:Slash()
  local trace = self.Owner:GetEyeTrace();
  if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 114 then
    if not IsValid(self) or not IsValid(self.Owner) then return end
    pos = self.Owner:GetShootPos()
    ang = self.Owner:GetAimVector()
    damagedice = math.Rand(0.9,1.50)
    pain = self.Primary.Damage * damagedice
    if SERVER and IsValid(self.Owner) then
      local slash = {}
      slash.start = pos
      slash.endpos = pos + (ang * 70)
      slash.filter = self.Owner
      slash.mins = Vector(1,1,1) * -20
      slash.maxs = Vector(1,1,1) * 20
      local slashtrace = util.TraceHull(slash)
      if slashtrace.Hit then
        targ = slashtrace.Entity
        if targ:IsPlayer() or targ:IsNPC() then
          if targ:Team() == TEAM_SCP then
            return
          end
          self.Owner:EmitSound( self.FleshHit[math.random(1,#self.FleshHit)] );
          paininfo = DamageInfo()
          paininfo:SetDamage(pain)
          paininfo:SetDamageType(DMG_SLASH)
          paininfo:SetAttacker(self.Owner)
          paininfo:SetInflictor(self.Weapon)
          local RandomForce = math.random(1000,20000)
          paininfo:SetDamageForce(slashtrace.Normal * RandomForce)
          if targ:IsPlayer() then
            targ:ViewPunch( Angle( -10, -20, 0 ) )
          end
          if SERVER then
            local blood = targ:GetBloodColor()
            local fleshimpact = EffectData()
            fleshimpact:SetEntity(self.Weapon)
            fleshimpact:SetOrigin(slashtrace.HitPos)
            fleshimpact:SetNormal(slashtrace.HitPos)
            if blood >= 0 then
              fleshimpact:SetColor(blood)
              util.Effect("BloodImpact", fleshimpact)
            end
          end
          if SERVER then targ:TakeDamageInfo(paininfo) end
        else
          self.Owner:EmitSound( self.Hit[math.random(1,#self.Hit)] )
          look = self.Owner:GetEyeTrace()
          util.Decal("ManhackCut", look.HitPos + look.HitNormal, look.HitPos - look.HitNormal )
        end
      end
    end
    if( trace.Entity:IsPlayer() or trace.Entity:IsNPC() or trace.Entity:GetClass()=="prop_ragdoll" ) then
      if trace.Entity:IsPlayer() then
        if trace.Entity:Team() == TEAM_SCP then
          --Don't Shoot them!
          return -- We cannot slash them, they're our friend
        end
      end
    end
  end
end

-----------------------------------Credit for this part goes to RobotBoy655, Just rewritten so I can learn it for myself and altered to my liking-----------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------

--[[
function SWEP:Think()


	if not IsValid(self) or not IsValid(self.Owner) then return end

	if self:GetNWBool("GrenadeHoldType") == true then
		self:SetWeaponHoldType("grenade")
	end

	if self:GetNWBool("GrenadeHoldType") == false then
		self:SetWeaponHoldType("melee2")
	end

	if self:GetNWBool("KatanaJump") == true then
		self:SetWeaponHoldType("melee")
	end

	if self:GetNWBool("Katana_View_Cloak") == true then
		self.Owner:GetViewModel():SetMaterial("sprites/heatwave")
		 else
		self.Owner:GetViewModel():SetMaterial("")
	end

	self.Owner:RemoveAllDecals()


	if not self.Owner:OnGround() then
	 self:SetNWBool( "KatanaJump", true )
	else
	 self:SetNWBool( "KatanaJump", false )
	end

	if self.Idle and CurTime()>=self.Idle then
		self.Idle = nil
		self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
	end

end
]]--
