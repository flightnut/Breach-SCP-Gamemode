AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = "models/props_c17/briefcase001a.mdl"
ENT.LASTINGEFFECT = 30;
ENT.HASHIGH = true
ENT.MULTIPLY = 1
ENT.LACED = {}

--console commands
CreateConVar( "durgz_witty_sayings", "0", { FCVAR_REPLICATED, FCVAR_ARCHIVE } )  --0 for no witty sayings when you take the drug
CreateConVar( "durgz_roleplay", "1", { FCVAR_REPLICATED, FCVAR_ARCHIVE } ) --set to 1 for none of those "special" side effects (like ultimate speed and really low gravity)

function ENT:SpawnFunction( ply, tr, Classname)

    if ( !tr.Hit ) then return end

    local SpawnPos = tr.HitPos + tr.HitNormal * 16

    local ent = ents.Create(Classname)
    ent:SetPos( SpawnPos )
    ent:Spawn()
    ent:Activate()

    return ent

end

function ENT:Initialize()

	self:SetModel( self.MODEL )

	self:PhysicsInit( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	self.LACED = {};

	if( self.MASS )then
		self.Entity:GetPhysicsObject():SetMass( self.MASS );
	end

end

 function ENT:OnTakeDamage( dmginfo )

 	self.Entity:TakePhysicsDamage( dmginfo )

 end


local function DoHigh(activator, caller, class, lastingeffect, transition_time, overdosephrase, nicknames)
		--if you're transitioning to the end and you take another, smoothen it out
		if activator:GetNetworkedFloat(class.."_high_end") && activator:GetNetworkedFloat(class.."_high_end") > CurTime() && activator:GetNetworkedFloat(class.."_high_end") - transition_time < CurTime() then
			--set the high start in such a way to where it doesn't snap to the start time, goes smoooothly.
			local set = CurTime() - ( activator:GetNetworkedFloat(class.."_high_end") - CurTime() );
			activator:SetNetworkedFloat(class.."_high_start", set);

		--if you're not high at all
		elseif( !activator:GetNetworkedFloat(class.."_high_start") || activator:GetNetworkedFloat(class.."_high_end") < CurTime() )then
			activator:SetNetworkedFloat(class.."_high_start", CurTime());
		end

		--high is done
		local ctime;
		if( !activator:GetNetworkedFloat(class.."_high_end") || activator:GetNetworkedFloat(class.."_high_end") < CurTime() )then
			ctime = CurTime();
		--you're already high on the drug,  add more highness
		else
			ctime = activator:GetNetworkedFloat(class.."_high_end") - lastingeffect/3;
		end
		activator:SetNetworkedFloat(class.."_high_end", ctime + lastingeffect);

		if( activator:GetNetworkedFloat(class.."_high_end") && activator:GetNetworkedFloat(class.."_high_end") - lastingeffect*5 > CurTime() )then
			--kill em
			activator.DURGZ_MOD_DEATH = class;
			activator.DURGZ_MOD_OVERDOSE = overdosephrase[math.random(1, #overdosephrase)];
			activator.DURGZ_MOD_NICKNAMES = nicknames[math.random(1, #nicknames)];
			activator:Kill();

		end
end

hook.Add("PlayerDeath", "durgz_death_notice", function(victim, inflictor, attacker)

	if( victim.DURGZ_MOD_DEATH )then
			--add shmexy killicon
			umsg.Start( "PlayerKilledByDrug" )
					umsg.Entity( victim );
			 		umsg.String( victim.DURGZ_MOD_DEATH );
			umsg.End()
			local s = victim.DURGZ_MOD_OVERRIDE or victim:Nick().." "..victim.DURGZ_MOD_OVERDOSE.." "..victim.DURGZ_MOD_NICKNAMES.." and died.";
			/*for id,pl in pairs(player.GetAll())do
				pl:PrintMessage(HUD_PRINTTALK, s);
			end*/
			MsgAll(s);
			victim.DURGZ_MOD_DEATH = nil;
			victim.DURGZ_MOD_OVERDOSE = nil;
			victim.DURGZ_MOD_NICKNAMES = nil;
			victim.DURGZ_MOD_OVERRIDE = nil;
	return true end

end)

function ENT:Use(activator,caller)
	--No SCP; No Spectators.
	if activator:Team() == TEAM_SPEC then return end
    if activator:Team() == TEAM_SCP then
        if self:GetClass() == "durgz_scp420j" then return end --420-J shouldn't be used by ANY of the SCPs ...
        if self:GetClass() == "durgz_scp500" then --The Cure is allowed but only for 049-2/008-2
            if activator:GetNClass() ~= ROLE_SCP0492 and activator:GetNClass() ~= ROLE_SCP0082 then
                return
            end
        end
    end

	umsg.Start("durgz_lose_virginity", activator)
	umsg.End()

	self:High(activator,caller);
	if( self.HASHIGH )then
		DoHigh( activator, caller, self:GetClass(), self.LASTINGEFFECT, self.TRANSITION_TIME, self.OverdosePhrase, self.Nicknames );
	end
	self:AfterHigh(activator, caller);

	for k,v in pairs(self.LACED)do
		local drug = ents.Create(v);
		drug:Spawn();
		drug:High(activator,caller);
		DoHigh( activator, caller, drug:GetClass(), drug.LASTINGEFFECT, drug.TRANSITION_TIME, drug.OverdosePhrase, drug.Nicknames );
		drug:AfterHigh(activator,caller);
		drug:Remove();
	end

    self.Entity:Remove()
end

--this is pretty much a function you call if you want the person taking the drug to say something, all this function does is check if the console command is a ok.
function ENT:Say(pl, str)
	//if str == nil then return end
    if GetConVar("durgz_witty_sayings"):GetBool() then
        if type(str) == "table" then
            str = str[math.random(1, #str)]
        end
        pl:ConCommand("say "..str)
    end
    return should_say
end

function ENT:Realistic()
    return GetConVar("durgz_roleplay", 0):GetBool()
end


function ENT:High(activator, caller)
end

function ENT:AfterHigh(activator, caller)
end



local function SoberUp(pl, x, y, z, ndeath, didntdie)
    --make a smooth transition and not a instant soberization
    local drugs = {
        "scp420j",
    }

    local ttime = {
        6,
		}

    for i = 1, #drugs do
        local tend = 0
        if( pl:GetNetworkedFloat("durgz_"..drugs[i].."_high_start") + ttime[i] > CurTime() )then
            tend = ( CurTime() - pl:GetNetworkedFloat("durgz_"..drugs[i].."_high_start") ) + CurTime()
        elseif !( pl:GetNetworkedFloat("durgz_"..drugs[i].."_high_end") - ttime[i] < CurTime() )then
            tend = CurTime() + ttime[i]
        elseif( pl:GetNetworkedFloat("durgz_"..drugs[i].."_high_end") > CurTime() )then
            tend = pl:GetNetworkedFloat("durgz_"..drugs[i].."_high_end")
        end

        pl:SetNetworkedFloat("durgz_"..drugs[i].."_high_start", 0)
        pl:SetNetworkedFloat("durgz_"..drugs[i].."_high_end", tend)
    end

    --set speed back to normal

    if pl.durgz_cocaine_fast then
        pl:SetWalkSpeed(DURGZ_DEFAULT_WALK_SPEED)
        pl:SetRunSpeed(DURGZ_DEFAULT_RUN_SPEED)
        pl.durgz_cocaine_fast = false
    end

    --set sound to normal
    pl:SetDSP(1, false)
    --no more floating
    pl:SetGravity(1)

    if( ndeath )then
        pl:EmitSound(Sound("vo/npc/male01/moan0"..math.random(4,5)..".wav"))
    end
end
hook.Add("DoPlayerDeath", "durgz_sober_up_cmd_death", SoberUp)
hook.Add("PlayerSpawn", "durgz_sober_up_cmd_spawn", SoberUp)

function ENT:Soberize(pl)
    SoberUp(pl, true, true, true, true, true);
end
