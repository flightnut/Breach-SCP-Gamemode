DrinkList = {}
SCP294BasicText = "A pretty good drink..." --We have nothing for this.

function SimpleDrink(name, text, col)
	DrinkList[name] = 	{
		color 		= col,
		effect 		= function(meta) meta:Say( text ) meta:EmitSound("scp294/slurp.ogg") end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
end

SimpleDrink("champagne", "This is a very good champagne !", Color(180,160,40))
SimpleDrink("cider", "A bit too sugary for me.", Color(130,110,70))
SimpleDrink("chocolate", "Mmmh ~ ... This is good !", Color(130,110,70))
SimpleDrink("carrot", "Pretty good.", Color(255,95,0))
SimpleDrink("coconut", "A refreshing flavour of coconut milk ~", Color(170,0,0))
SimpleDrink("cola", "It's cold and refreshing.", Color(75,50,15))
SimpleDrink("egg", "It tastes just like raw eggs.", Color(255,190,0))

DrinkList["water"] = 	{
		color 		= Color(40,200,200,200),
		effect 		= function(meta)
			meta:Say( "Slurp ... this is a fresh water !" )
			meta:EmitSound("scp294/slurp.ogg")
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end
	}
DrinkList["air"] = {
	color 		= Color(0,0,0,0),
	effect 		= function(meta) meta:Say( "There is nothing to drink in the cup." ) end, }
DrinkList["nothing"] = {
	color 		= Color(0,0,0,0),
	effect 		= function(meta) meta:Say( "There is nothing to drink in the cup." ) end, }
DrinkList["hl3"] = {
	color 		= Color(0,0,0,0),
	effect 		= function(meta) meta:Say( "There is nothing to drink in the cup." ) end, }
DrinkList["no"] = {
		color 		= Color(0,0,0,0),
		effect 		= function(meta) meta:Say( "There is nothing to drink in the cup." ) end, }
DrinkList["beer"] = {
	color 		= Color(200,200,40,250),
	effect 		= function(meta)
		meta:SetNWBool("294Drunk", true)
		meta:EmitSound("scp294/slurp.ogg")
		timer.Simple(5 , function()
		meta:SetNWBool("294Drunk", false)
		end)
	end,
	dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["carbon"] = {
		color 		= Color(30,30,30,250),
		effect 		= function(meta)
			meta:EmitSound("scp294/cough.ogg")
			meta:Kill()
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end
	}
DrinkList["death"] = {
		color 		= Color(0,0,0,255),
		effect 		= function(meta)
			meta:EmitSound("scp294/burn.ogg")
			meta:Kill()
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["acid"] = {
		color 		= Color(100,255,100,50),
		effect 		= function(meta)
			meta:EmitSound("scp294/burn.ogg")
			meta:Kill()
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["estus"] = {
	color 		= Color(205,170,20,220),
	effect 		= function(meta)
		meta:Say( "The taste is hard to describe. You feel refreshed." )
		meta:SetHealth(100)
		meta:EmitSound("scp294/slurp.ogg")
	end,
	dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["immortality"] = {
	color 		= Color(200,0,0,240),
	effect 		= function(meta)
		meta:Say( "Wow ..." )
		meta:SetHealth(99999999)
		meta:EmitSound("scp294/ahh.ogg")
		local function disableGodMod(ply)
			local hp = ply:Health()
			if ply:IsValid() then
				if hp > 100 then
					ply:SetHealth(100)
				end
			end
		end
		timer.Simple(10, function() disableGodMod(meta) end)
	end,
	dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["chim"] = {
	color 		= Color(255,255,0,240),
	effect 		= function(meta)
		meta:Say( "There are no words in any human language to describe the taste of the liquid." )
		meta:SetHealth(99999999)
		meta:SetNWBool("294Crazy", true)
		meta:EmitSound("scp294/ahh.ogg")
		local function disableGodMod(ply)
			local hp = ply:Health()
			if ply:IsValid() then
				if hp > 100 then
					ply:SetHealth(100)
				end
			end
		end
		timer.Simple(10, function() disableGodMod(meta) meta:SetNWBool("294Crazy", false) end)
	end,
	dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["life"] = {
	color 		= Color(200,0,0,240),
	effect 		= function(meta)
		meta:Say( "The drink tastes unlike anything you've drink before. You feel better than ever." )
		meta:SetHealth(100)
		meta:EmitSound("scp294/ahh.ogg")
	end,
	dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["blood"] = {
	color 		= Color(90,0,0,255),
	effect 		= function(meta)
		meta:Say( "The drink tastes like red wine." )
		meta:SetNWBool("294Blur", true)
		meta:EmitSound("scp294/spit.ogg")
		local function bleed(ply)
			local hp = ply:Health()
			if ply:IsValid() then
				if ply:GetNWBool("294Blur") then
					if hp > 0 then
						ply:SetHealth(hp - 4)
					end
					if ply:Health() <= 0 and ply:Alive() then
						ply:Kill()
					end
				end
			end
		end
		timer.Simple(1, function() bleed(meta) end)
		timer.Simple(2, function() bleed(meta) end)
		timer.Simple(3, function() bleed(meta) end)
		timer.Simple(4, function() bleed(meta) end)
		timer.Simple(5, function() bleed(meta) end)
		timer.Simple(5, function() meta:SetNWBool("294Blur", false) end)
	end,
	dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["scp-106"] = {
	color 		= Color(0,0,0,255),
	effect 		= function(meta)
		meta:Say( "I feel something moving in my stomach..." )
		meta:SetNWBool("294Blur", true)
		meta:EmitSound("scp294/spit.ogg")
		local function bleed(ply)
			local hp = ply:Health()
			if ply:IsValid() then
				if ply:GetNWBool("294Blur") then
					if hp > 0 then
						ply:SetHealth(hp - 10)
					end
					if ply:Health() <= 0 and ply:Alive() then
						ply:Kill()
					end
				end
			end
		end
		timer.Simple(1, function() bleed(meta) end)
		timer.Simple(2, function() bleed(meta) end)
		timer.Simple(3, function() bleed(meta) end)
		timer.Simple(4, function() bleed(meta) end)
		timer.Simple(5, function() bleed(meta) end)
		timer.Simple(5, function() meta:SetNWBool("294Blur", false) end)
	end,
	dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["love"] = {
	color 		= Color(255,127,233,170),
	effect 		= function(meta)
		meta:Say( "I feel like ... happy ?!" )
		meta:SetNWBool("294Love", true)
		meta:EmitSound("scp294/slurp.ogg")
		local function die(ply)
			if ply:IsValid() then
				if ply:Alive() and ply:GetNWBool("294Love") then
					ply:SetNWBool("294Love", false)
					ply:Kill()
				end
			end
		end
		timer.Simple(15, function() die(meta) end)
	end,
	dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["oil"] = {
	color 		= Color(10,10,10,255),
	effect 		= function(meta)
		meta:Say( "Beurk ... !" )
		meta:SetNWBool("294Blur", true)
		meta:EmitSound("scp294/cough.ogg")
		local function die(ply)
			if ply:IsValid() then
				if ply:Alive() then
					ply:SetNWBool("294Blur", false)
					ply:Kill()
				end
			end
		end
		timer.Simple(10, function() die(meta) end)
	end,
	dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["rage"] = {
	color 		= Color(255,100,0,255),
	effect 		= function(meta)
		meta:Say( "Grrr ..." )
		meta:SetNWBool("294Rage", true)
		meta:SetHealth(350)
		meta:EmitSound("scp294/slurp.ogg")
		local function die(ply)
			if ply:IsValid() then
				if ply:Alive() and ply:GetNWBool("294Rage") then
					ply:SetNWBool("294Rage", false)
					ply:Kill()
				end
			end
		end
		local function shake(ply)
			if ply:IsValid() then
				ply:ViewPunch( Angle( math.random(-10,10), math.random(-10,10), math.random(-10,10) ) )
			end
		end
		shake(meta)
		timer.Simple(1, function() shake(meta) end)
		timer.Simple(2, function() shake(meta) end)
		timer.Simple(3, function() shake(meta) end)
		timer.Simple(4, function() shake(meta) end)
		timer.Simple(6, function() shake(meta) end)
		timer.Simple(8, function() shake(meta) end)
		timer.Simple(10, function() die(meta) end)
	end,
	dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["anger"] = {
	color 		= Color(255,100,0,255),
	effect 		= function(meta)
		meta:Say( "Grrr ..." )
		meta:SetNWBool("294Rage", true)
		meta:SetHealth(350)
		meta:EmitSound("scp294/slurp.ogg")
		local function die(ply)
			if ply:IsValid() then
				if ply:Alive() and ply:GetNWBool("294Rage") then
					ply:SetNWBool("294Rage", false)
					ply:Kill()
				end
			end
		end
		local function shake(ply)
			if ply:IsValid() then
				ply:ViewPunch( Angle( math.random(-10,10), math.random(-10,10), math.random(-10,10) ) )
			end
		end
		shake(meta)
		timer.Simple(1, function() shake(meta) end)
		timer.Simple(2, function() shake(meta) end)
		timer.Simple(3, function() shake(meta) end)
		timer.Simple(4, function() shake(meta) end)
		timer.Simple(6, function() shake(meta) end)
		timer.Simple(8, function() shake(meta) end)
		timer.Simple(10, function() die(meta) end)
	end,
	dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["perfection"] = {
	color 		= Color(255,255,255,255),
	effect 		= function(meta)
		meta:Say( "It's beautifull ... Uhh .. r .." )
		meta:Kill()
		meta:EmitSound("scp294/burn.ogg")
	end,
	dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["happiness"] = {
	color 		= Color(0,255,255,255),
	effect 		= function(meta)
		meta:Say( "I feel so happy ~" )
		meta:SetNWBool("294Happy", true)
		meta:EmitSound("scp294/ahh.ogg")
		local function die(ply)
			if ply:IsValid() then
				if ply:Alive() and ply:GetNWBool("294Happy") then
					ply:SetNWBool("294Happy", false)
					ply:Kill()
				end
			end
		end
		timer.Simple(20, function() die(meta) end)
	end,
	dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["amnesia"] = {
	color 		= Color(80,80,80,255),
	effect 		= function(meta)
		meta:Say( "rhh .. bllsokijjihgsdijo .. !" )
		meta:SetNWBool("294Crazy", true)
		meta:EmitSound("scp294/slurp.ogg")
		local function die(ply)
			if ply:IsValid() then
				if ply:Alive()  and ply:GetNWBool("294Crazy")  then
					ply:SetNWBool("294Crazy", false)
					ply:Kill()
				end
			end
		end
		timer.Simple(10, function() die(meta) end)
	end,
	dispense 	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["bleach"] = {
	color 		= Color(240,240,240,255),
	effect 		= function(meta)
		meta:Say( "The liquid burns in my mouth and throat." )
		meta:SetNWBool("294Blur", true)
		meta:EmitSound("scp294/beurk.ogg")
		local function die(ply)
			if ply:IsValid() then
				if ply:Alive() and ply:GetNWBool("294Blur") then
					ply:SetNWBool("294Blur", false)
					ply:Kill()
				end
			end
		end
		timer.Simple(50, function() die(meta) end)
	end,
	dispense 	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }

-- ADDED IN VERSION 1.1
DrinkList["blood of jesus"] = 	{
		color 		= Color(120,0,0,200),
		effect 		= function(meta)
			meta:Say( "The drink tastes like red wine.." )
			meta:EmitSound("scp294/slurp.ogg")
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end
	}
DrinkList["gold"] = {
		color 		= Color(255,255,0,255),
		effect 		= function(meta)
			meta:EmitSound("scp294/burn.ogg")
			meta:Kill()
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["lava"] = {
		color 		= Color(255,130,0,255),
		effect 		= function(meta)
			meta:EmitSound("scp294/burn.ogg")
			meta:Kill()
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["fire"] = {
		color 		= Color(255,130,0,255),
		effect 		= function(meta)
			meta:EmitSound("scp294/burn.ogg")
			meta:Say( "HOT HOT HOT!" )
			meta:Ignite( 60 )
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["meme"] = {
		color 		= Color(0,50,200,200),
		effect 		= function(meta)
			meta:Say( "Me gusta xDD lel !" )
			meta:SetNWBool("294Drunk", true)
			meta:EmitSound("scp294/slurp.ogg")
			local function removeBuff(ply)
				if ply:IsValid() then
					if ply:GetNWBool("294Drunk") then
						ply:SetNWBool("294Drunk", false)
					end
				end
			end
			timer.Simple(10, function() removeBuff(meta) end)
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["memes"] = {
		color 		= Color(0,50,200,200),
		effect 		= function(meta)
			meta:Say( "Me gusta xDD lel !" )
			meta:SetNWBool("294Drunk", true)
			meta:EmitSound("scp294/slurp.ogg")
			local function removeBuff(ply)
				if ply:IsValid() then
					if ply:GetNWBool("294Drunk") then
						ply:SetNWBool("294Drunk", false)
					end
				end
			end
			timer.Simple(10, function() removeBuff(meta) end)
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["milk"] = {
		color 		= Color(240,240,240,200),
		effect 		= function(meta)
			meta:Say( "This milk is pretty good !" )
			meta:EmitSound("scp294/slurp.ogg")
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["tea"] = {
		color 		= Color(255,180,100,80),
		effect 		= function(meta)
			meta:Say( "It's too hot!" )
			meta:EmitSound("scp294/slurp.ogg")
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["orange"] = {
		color 		= Color(255,130,0,180),
		effect 		= function(meta)
			meta:Say( "The drink tastes sweet and has quite a bit of pulp." )
			meta:EmitSound("scp294/slurp.ogg")
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["orange juice"] = {
		color 		= Color(255,130,0,180),
		effect 		= function(meta)
			meta:Say( "The drink tastes sweet and has quite a bit of pulp." )
			meta:EmitSound("scp294/slurp.ogg")
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["hot tea"] = {
		color 		= Color(255,180,100,80),
		effect 		= function(meta)
			meta:Say( "It's too hot!" )
			meta:EmitSound("scp294/slurp.ogg")
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["green tea"] = {
		color 		= Color(0,180,50,80),
		effect 		= function(meta)
			meta:Say( "Mmh, good tea." )
			meta:EmitSound("scp294/slurp.ogg")
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["explosion"] = {
		color 		= Color(255,180,100,80),
		effect 		= function(meta)
			meta:EmitSound("scp294/slurp.ogg")
			local explode = ents.Create( "env_explosion" )
			explode:SetPos( meta:GetPos() )
			explode:SetOwner( meta )
			explode:Spawn()
			explode:SetKeyValue( "iMagnitude", "150" )
			explode:Fire( "Explode", 0, 0 )
			explode:EmitSound( "weapon_AWP.Single", 400, 400 )
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["tnt"] = {
		color 		= Color(255,180,100,80),
		effect 		= function(meta)
			meta:EmitSound("scp294/slurp.ogg")
			local explode = ents.Create( "env_explosion" )
			explode:SetPos( meta:GetPos() )
			explode:SetOwner( meta )
			explode:Spawn()
			explode:SetKeyValue( "iMagnitude", "150" )
			explode:Fire( "Explode", 0, 0 )
			explode:EmitSound( "weapon_AWP.Single", 400, 400 )
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["pain killer"] = {
		color 		= Color(255,50,20,150),
		effect 		= function(meta)
			meta:Say( "This is very pleasant ..." )
			meta:EmitSound("scp294/slurp.ogg")
			meta:SetNWBool("294Blur", true)
				local function ktp(ply)
				local hp = ply:Health()
				if ply:IsValid() then
					if ply:GetNWBool("294Blur") then
						if hp < 100 then
							ply:SetHealth(hp + 5)
						end
						if ply:Health() > 100 then
							ply:SetHealth(100)
						end
					end
				end
			end
			timer.Simple(1, function() ktp(meta) end)
			timer.Simple(2, function() ktp(meta) end)
			timer.Simple(3, function() ktp(meta) end)
			timer.Simple(4, function() ktp(meta) end)
			timer.Simple(5, function() ktp(meta) end)
			timer.Simple(6, function() ktp(meta) end)
			timer.Simple(7, function() meta:SetNWBool("294Blur", false) end)
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["mercury"] = {
		color 		= Color(240,240,240,150),
		effect 		= function(meta)
			meta:Say( "This is very pleasant ..." )
			meta:EmitSound("scp294/slurp.ogg")
			meta:SetNWBool("294Blur", true)
				local function ktp(ply)
				local hp = ply:Health()
				if ply:IsValid() then
					if ply:Alive() and ply:GetNWBool("294Blur") then
						if hp > 100 then
							ply:SetHealth(hp - 5)
						end
						if hp < 0 then
							ply:Kill()
						end
					end
				end
			end
			timer.Simple(1, function() ktp(meta) end)
			timer.Simple(2, function() ktp(meta) end)
			timer.Simple(3, function() ktp(meta) end)
			timer.Simple(4, function() ktp(meta) end)
			timer.Simple(5, function() ktp(meta) end)
			timer.Simple(6, function() ktp(meta) end)
			timer.Simple(7, function() meta:SetNWBool("294Blur", false) end)
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["random drink"] = {
		color 		= Color(240,240,240,150),
		effect 		= function(meta)
			local allKey = {}
			for k , v in pairs (DrinkList) do
				allKey[#allKey + 1] =  k
			end
			local id 	= math.random(1, #allKey)
			print(allKey[id])

			if allKey[id] == "random drink" then
				meta:EmitSound("scp294/burn.ogg")
				meta:Kill()
			else
				DrinkList[allKey[id]].effect(meta)
			end
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["ammunition"] = {
		color 		= Color(240,240,240,150),
		effect 		= function(meta)
			for k , v in pairs (meta:GetWeapons()) do
				local ammo = v:GetPrimaryAmmoType()
				meta:GiveAmmo( 10, ammo, false )
			end
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
DrinkList["me"] = {
		color 		= Color(240,240,240,150),
		effect 		= function(meta)
				meta:EmitSound("scp294/burn.ogg")
				meta:KillSilent()
		end,
		dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }

SimpleDrink("hl2", "I think you dropped this back at black mesa.", Color(255,190,0))
