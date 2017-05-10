AddCSLuaFile()

if CLIENT then
	SWEP.BounceWeaponIcon = false
end

SWEP.PushSounds = {
	"physics/body/body_medium_impact_hard1.wav",
	"physics/body/body_medium_impact_hard2.wav",
	"physics/body/body_medium_impact_hard3.wav",
	"physics/body/body_medium_impact_hard5.wav",
	"physics/body/body_medium_impact_hard6.wav",
	"physics/body/body_medium_impact_soft5.wav",
	"physics/body/body_medium_impact_soft6.wav",
	"physics/body/body_medium_impact_soft7.wav",
}
SWEP.PushDelay = 5
SWEP.NextPush = 0

SWEP.Author			= "Link2006/Parsee"
SWEP.Contact		= "N/A"
SWEP.Purpose		= "Push players"
SWEP.Instructions	= [[Primary Attack - Push player]]

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/props_junk/cardboard_box004a.mdl"
SWEP.WorldModel		= "models/props_junk/cardboard_box004a.mdl"
SWEP.PrintName		= "Push/Shove"
SWEP.Slot			= 5
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.droppable				= false
SWEP.teams					= {2,3,4,6} --TEAM_GUARD,TEAM_CLASSD,TEAM_SCI,TEAM_CHAOS

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end
function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end
function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:SecondaryAttack()
    --Lol what are you doing.
end

function SWEP:PrimaryAttack()
    --DO NOT PUSH
    --TODO: FIX NOT BEING ABLE TO PUSH!???
    --The push mod goes here, also add delay of PushDelay.
    if SERVER then
        if self.NextPush >= CurTime() then
            return
        end
        local ent = self.Owner:GetEyeTrace().Entity
        if ent and ent:IsValid() then
            if ent:IsPlayer() and ent:Team() != TEAM_SCP and ent:Team() != TEAM_SPEC then
                --Link2006's Fix here: PRevent ClassD pushing other ClassDs
                --			Same goes for Researchers pushing themselves.
    			if (self.Owner:Team() == TEAM_CLASSD and ent:Team() == TEAM_CLASSD)
    				or (self.Owner:Team() == TEAM_SCI and ent:Team() == TEAM_SCI) then
    				return --Stop the function.
                end
    			--Or else, Push them.
    			if self.Owner:GetPos():Distance( ent:GetPos() ) <= 100 then
    				if ent:Alive() and ent:GetMoveType() == MOVETYPE_WALK then
                        self.NextPush = CurTime() + self.PushDelay
                        if self.Owner:IsValid() and ent:IsValid() then
                            if self.Owner:IsPlayer() and ent:IsPlayer() then
                                local shoveLogContent = "[weapon_shove] <"..os.date("%H:%M:%S - %d/%m/%Y",os.time()).."> \""..self.Owner:Nick().."\" ("..self.Owner:SteamID()..") has pushed \""..ent:Nick().."\" ("..ent:SteamID()..")"
                                print(shoveLogContent)
								for k,v in pairs(player.GetAll()) do
									v:PrintMessage(HUD_PRINTCONSOLE,shoveLogContent)
								end
                                file.Append("weapon_shove_log.txt",shoveLogContent..'\r\n') --We gotta add a new line, with stupid windows support :^l
                            end
                        end
    					self.Owner:EmitSound( table.Random(self.PushSounds), 100, 100 )
    					local velAng = self.Owner:EyeAngles():Forward()
    					ent:SetVelocity( velAng * 500 )
    					ent:ViewPunch( Angle( math.random( -3, 3 ), math.random( -3, 3 ), 0 ) )
    				end
    			end
    		end
    	end
    end
end
