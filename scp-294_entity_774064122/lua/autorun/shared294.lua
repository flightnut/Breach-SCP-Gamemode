
if ( SERVER ) then
	util.AddNetworkString("OpenSCP294Edtior")
	util.AddNetworkString("ReceiveDrinkInfo")
	util.AddNetworkString("RefreshDrinkListStep1")
	util.AddNetworkString("RefreshDrinkListStep2")
	util.AddNetworkString("DeleteDrinkData")
	
	hook.Add("PlayerSpawn", "SCP294Spawn", function(ply)
		ply:SetNWBool("294Drunk", false)
		ply:SetNWBool("294Love", false)
		ply:SetNWBool("294Blur", false)
		ply:SetNWBool("294Rage", false)
		ply:SetNWBool("294Happy", false)
		ply:SetNWBool("294Crazy", false)
		ply:SetNWBool("294Boost", false)
		
		if timer.Exists( ply:SteamID() .. "294" ) then
			timer.Remove( ply:SteamID() .. "294"  )
		end
	end)
	
	-- OPEN EDITOR
	hook.Add( "PlayerSay", "SCP294Chat", function( ply, text, team )
		if ( ply:IsAdmin() and text == "!294editor" ) then
			local FData = file.Read( "drinklist.txt" , "DATA" )
			local DL = util.JSONToTable( FData )
			net.Start("OpenSCP294Edtior")
				net.WriteTable(DL)
			net.Send(ply)
			return false --Nothing to show up in chat please
		end
		--Link2006 was here to make every other hook AT LEAST WORK FFS :L
		--return text
	end )
	
	-- CREATE THE DATA FILE
	function SetDataFile()
		if  not file.Exists( "drinklist.txt", "DATA" ) then
			MsgC(Color(255,0,0), "DATA Drink List donnot exist , creating ...\n")
			DrinkListData = 	{}
			DrinkListData["default"] = { color = Color(200,0,0,255), text = "This is the default drink", kill = false }
			local tab = util.TableToJSON( DrinkListData )
			file.Write( "drinklist.txt", tab )
			MsgC(Color(0,255,0), "DATA Drink List created !\n")
		end
	end
	
	-- UPDATE TABLE TO SERVER
	function UpdateDrinkList()
		local file = file.Read( "drinklist.txt" , "DATA" )
		local tab = util.JSONToTable( file )
		for k , v in pairs (tab) do
			DrinkList[k] =  {			
			color 		= v["color"],
			effect 		= function(meta)
				PrintTable(v)
				meta:EmitSound("scp294/slurp.ogg")
				meta:Say(v["text"])
				-- DID IT KILL ?
				if v["kill"] then 
					meta:Kill() 
				end
				-- DID IT HEAL ?
				if v["heal"] then 
					if meta:Health() < 100 then
						meta:SetHealth(meta:Health() + 10)
					end
				end
				-- DID IT BURN ?
				if v["burn"] then 
					meta:Ignite(20) 
				end
				-- DID IT EXPLODE ?
				if v["explode"] then 
					print("BOUM")
					local explode = ents.Create( "env_explosion" )
					explode:SetPos( meta:GetPos() )
					explode:SetOwner( meta )
					explode:Spawn()
					explode:SetKeyValue( "iMagnitude", "800" )
					explode:Fire( "Explode", 0, 0 )
					explode:EmitSound( "weapon_AWP.Single", 400, 400 )
				end
				
			end,
			dispense 	= function(ent)	
				ent:EmitSound("scp294/dispense1.ogg")
			end }
		end
		
		MsgC(Color(0,255,255), "SCP-294 : Custom Drink are updated (server) !!!\n")
	end
	
	-- SEND TABLE TO CLIENT
	function SendDrinkData( ply )
		local file = file.Read( "drinklist.txt" , "DATA" )
		local tab = util.JSONToTable( file )
		net.Start("RefreshDrinkListStep2")
			net.WriteTable(tab)
		net.Send(ply)
		MsgC(Color(0,255,0), "Sending table to " .. tostring(ply) .. " \n")
	end

	-- ADD DRINK
	function AddDrink()
		local NTab = net.ReadTable()
		
			if  not file.Exists( "drinklist.txt", "DATA" ) then
				MsgC(Color(255,0,0), "DATA Drink List donnot exist , creating ...\n")
				DrinkListData = 	{}
				DrinkListData["default"] = { color = Color(200,0,0,255), text = "This is the default drink", kill = false }
				local tab = util.TableToJSON( DrinkListData )
				file.Write( "drinklist.txt", tab )
				MsgC(Color(0,255,0), "DATA Drink List created !\n")
			end
			
			local FData = file.Read( "drinklist.txt" , "DATA" )
			local DL = util.JSONToTable( FData )
			DL[NTab["name"]] = { color = NTab["color"] , text = NTab["text"], kill = NTab["kill"], heal = NTab["heal"], burn = NTab["burn"], explode = NTab["explode"] }			
			local result = util.TableToJSON( DL )
			file.Write( "drinklist.txt", result )
			
			for _, v in pairs (player.GetAll()) do
				SendDrinkData(v)
			end
			UpdateDrinkList()
	end
	
	-- REMOVE A DRINK
	function RemoveDrink()
		local Key = net.ReadString()		
		local FData = file.Read( "drinklist.txt" , "DATA" )
		local DL = util.JSONToTable( FData )
		DL[Key] = nil
		
		local result = util.TableToJSON( DL )
		file.Write( "drinklist.txt", result )
			
		for _, v in pairs (player.GetAll()) do
			SendDrinkData(v)
		end
		UpdateDrinkList()
	end
	
	net.Receive("RefreshDrinkListStep1", function(len, ply) SendDrinkData( ply ) end )
	net.Receive("ReceiveDrinkInfo", AddDrink)
	net.Receive("DeleteDrinkData", RemoveDrink)
	
	SetDataFile()
	UpdateDrinkList()
end

if ( CLIENT ) then
	
	function OpenDrinkEditor()	
		local NTab = net.ReadTable()
		local W, H = ScrW(), ScrH()
		SCP294Menu = vgui.Create( "DFrame" )
		SCP294Menu:SetPos( 0, 0 )
		SCP294Menu:SetSize( W*0.6, H*0.6 )
		SCP294Menu:SetTitle( "" )
		SCP294Menu:SetDraggable( false )
		SCP294Menu:ShowCloseButton( false )
		SCP294Menu:MakePopup()
		SCP294Menu:Center()
		SCP294Menu.Paint = function()
			draw.RoundedBox( 0, 0, 0, W, H, Color(180,180,180,255) )
			draw.RoundedBox( 0, 0, 0, W*0.2, H*0.6, Color(150,150,150,255) )
			draw.RoundedBox( 0, W*0.475, 0, W*0.125, H*0.6, Color(150,150,150,255) )
			draw.RoundedBox( 0, 0, 0, W, H*0.05, Color(50,50,50,255) )
			draw.RoundedBox( 0, W*0.205, H*0.075, W*0.25, H*0.25, Color(150,150,150,255) )
			draw.RoundedBox( 0, 0, H*0.525, W*0.6, H*0.075, Color(80,80,80,255) )
			
			draw.DrawText( "SCP-294 List editor", "DermaLarge", W*0.01, H*0.005, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
			draw.DrawText( "Delete custom drink", "DermaLarge", W*0.45, H*0.005, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
			draw.DrawText( "The name : ", "Trebuchet18", W*0.01, H*0.075, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT )
			draw.DrawText( "What the player will said : ", "Trebuchet18", W*0.01, H*0.125, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT )
			draw.DrawText( "The color of the liquid : ", "Trebuchet18", W*0.205, H*0.05, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT )
			
			draw.DrawText( "Did the liquid kill ?", "Trebuchet18", W*0.025, H*0.1975, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT )
			draw.DrawText( "Did the liquid heal ?", "Trebuchet18", W*0.025, H*0.221, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT )
			draw.DrawText( "Did the liquid burn ?", "Trebuchet18", W*0.025, H*0.245, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT )
			draw.DrawText( "Did the liquid explode ?", "Trebuchet18", W*0.025, H*0.27, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT )
		end
	
		local Mixer = vgui.Create( "DColorMixer", SCP294Menu )
		Mixer:SetPos( W*0.205, H*0.075 )
		Mixer:SetSize( W*0.25, H*0.25 )
		Mixer:SetPalette( true )
		Mixer:SetAlphaBar( true )
		Mixer:SetWangs( true )
		Mixer:SetColor( Color( 255, 255, 255 ) )
		
		local Name = vgui.Create( "DTextEntry", SCP294Menu ) 
		Name:SetPos( W*0.01, H*0.1 )
		Name:SetSize( W*0.175, H*0.025 )
		Name:SetText( "" )

		local Text = vgui.Create( "DTextEntry", SCP294Menu ) 
		Text:SetPos( W*0.01, H*0.15 )
		Text:SetSize( W*0.175, H*0.025 )
		Text:SetText( "" )
		
		local CheckKill = vgui.Create( "DCheckBox" , SCP294Menu )
		CheckKill:SetPos( W*0.01, H*0.2 )
		CheckKill:SetSize( W*0.01, H*0.015 )
		CheckKill:SetValue( 0 )
		
		local CheckHeal = vgui.Create( "DCheckBox" , SCP294Menu )
		CheckHeal:SetPos( W*0.01, H*0.225 )
		CheckHeal:SetSize( W*0.01, H*0.015 )
		CheckHeal:SetValue( 0 )	
		
		local CheckBurn = vgui.Create( "DCheckBox" , SCP294Menu )
		CheckBurn:SetPos( W*0.01, H*0.25 )
		CheckBurn:SetSize( W*0.01, H*0.015 )
		CheckBurn:SetValue( 0 )

		local CheckExplode = vgui.Create( "DCheckBox" , SCP294Menu )
		CheckExplode:SetPos( W*0.01, H*0.275 )
		CheckExplode:SetSize( W*0.01, H*0.015 )
		CheckExplode:SetValue( 0 )
		
		local ValidDrink = vgui.Create( "DButton", SCP294Menu )
		ValidDrink:SetText( "Validate" )
		ValidDrink:SetPos( W*0.01, H*0.54 )
		ValidDrink:SetSize( W*0.1, H*0.05 )
		ValidDrink.DoClick = function()
			if Name:GetValue() == "" then 
				surface.PlaySound("buttons/button11.wav")
			return end
			
			local NTab = {}
			NTab["text"] = Text:GetValue()
			NTab["name"] = string.lower(Name:GetValue())
			NTab["kill"] = CheckKill:GetChecked()
			NTab["heal"] = CheckHeal:GetChecked()
			NTab["burn"] = CheckBurn:GetChecked()
			NTab["color"] = Mixer:GetColor()
			NTab["explode"] = CheckExplode:GetChecked()
			
			net.Start("ReceiveDrinkInfo")
				net.WriteTable(NTab)
			net.SendToServer()
			SCP294Menu:Remove()
		end	
		
		local Exit = vgui.Create( "DButton", SCP294Menu )
		Exit:SetText( "Exit" )
		Exit:SetPos( W*0.12, H*0.54 )
		Exit:SetSize( W*0.1, H*0.05 )
		Exit.DoClick = function()
			SCP294Menu:Remove()			
		end
		
		local DScrollPanel = vgui.Create( "DScrollPanel", SCP294Menu )
		DScrollPanel:SetPos( W*0.475, H*0.05 )
		DScrollPanel:SetSize( W*0.125, H*0.475 )

		local function SetList()
			List = {} 
			local y = 0
			for k , v in pairs (NTab) do
				local name = k
				List[k] = vgui.Create( "DButton", DScrollPanel )
				List[k]:SetText( "Delete " .. name )
				List[k]:SetPos( 20, H*y)
				List[k]:SetSize( W*0.1, H*0.05 )
				List[k].DoClick = function()
					net.Start("DeleteDrinkData")
						net.WriteString(name)
					net.SendToServer()
					NTab[k] = nil
					for k , v in pairs (List) do
						v:Remove()
					end
					SetList()
				end
				y = y + 0.05
			end
		end
		
		SetList()
	end
	net.Receive("OpenSCP294Edtior", OpenDrinkEditor)
	
	
	-- REFRESH THE TABLE
	function RefreshDL()
		MsgC(Color(0,255,0), "Update the drink list (client)\n")
		local NTab = net.ReadTable()
		for k , v in pairs (NTab) do
			DrinkList[k] = {  
				color 		= v["color"],
				effect 		= function(meta) meta:EmitSound("scp294/slurp.ogg")	end,
				dispense	= function(ent)	ent:EmitSound("scp294/dispense1.ogg") end }
		end
	end
	net.Receive("RefreshDrinkListStep2", function() RefreshDL( ) end )
	 
	net.Start("RefreshDrinkListStep1")
	net.SendToServer()

	
	
	-- VISUAL EFFECT
	
	local love = 
	{
		[ "$pp_colour_addr" ] = 1,
		[ "$pp_colour_addg" ] = 0.75,
		[ "$pp_colour_addb" ] = 0.9,
		[ "$pp_colour_brightness" ] = 0,
		[ "$pp_colour_contrast" ] = 0.5,
		[ "$pp_colour_colour" ] = 5,
		[ "$pp_colour_mulr" ] = 0,
		[ "$pp_colour_mulg" ] = 0.02,
		[ "$pp_colour_mulb" ] = 0
	}

	local rage = 
	{
		[ "$pp_colour_addr" ] = 0.05,
		[ "$pp_colour_addg" ] = 0.0,
		[ "$pp_colour_addb" ] = 0.0,
		[ "$pp_colour_brightness" ] = 0,
		[ "$pp_colour_contrast" ] = 1,
		[ "$pp_colour_colour" ] = 5,
		[ "$pp_colour_mulr" ] = 0.5,
		[ "$pp_colour_mulg" ] = 0,
		[ "$pp_colour_mulb" ] = 0
	}
	
	local normal_color = 
	{
		[ "$pp_colour_addr" ] = 0.0,
		[ "$pp_colour_addg" ] = 0.0,
		[ "$pp_colour_addb" ] = 0.0,
		[ "$pp_colour_brightness" ] = 0,
		[ "$pp_colour_contrast" ] = 1,
		[ "$pp_colour_colour" ] = 1,
		[ "$pp_colour_mulr" ] = 0,
		[ "$pp_colour_mulg" ] = 0,
		[ "$pp_colour_mulb" ] = 0
	}
	
	hook.Add("RenderScreenspaceEffects", "SCP294RSE", function()
		if LocalPlayer():GetNWBool("294Blur") then
			DrawMotionBlur( 0.2, 0.8, 0.05 )
			DrawToyTown( 20, ScrH()/2 )
		elseif LocalPlayer():GetNWBool("294Crazy") then
			DrawMotionBlur( 0.2, 0.5, 0.1 )
			DrawSobel( 0.21 )
			DrawBloom( 0.4, 80, 9, 9, 6, 1, 1, 1, 1 )
			DrawToyTown( 40, ScrH()*0.8 )
		elseif LocalPlayer():GetNWBool("294Happy") then
			DrawMotionBlur( 0.2, 0.8, 0.05 )
			DrawBloom( 0.5, 1, 9, 9, 6, 10, 1, 1, 1 )
		elseif LocalPlayer():GetNWBool("294Drunk") then
			DrawMotionBlur( 0.2, 0.8, 0.01 )
		elseif LocalPlayer():GetNWBool("294Rage") then
			DrawMotionBlur( 0.2, 0.8, 0.05 )
			DrawColorModify( rage )
		elseif LocalPlayer():GetNWBool("294Love") then
			DrawMotionBlur( 0.1, 1, 0.01 )
			DrawColorModify( love )
		end
		--HACK: Force all of these values back to false when the player is dead.
		if LocalPlayer():Alive() ~= true then 
			LocalPlayer():SetNWBool("294Blur",false)
			LocalPlayer():SetNWBool("294Crazy",false)
			LocalPlayer():SetNWBool("294Happy",false)
			LocalPlayer():SetNWBool("294Drunk",false)
			LocalPlayer():SetNWBool("294Rage",false)
			LocalPlayer():SetNWBool("294Love",false)
			DrawMotionBlur( 0.1, 0, 0.01 )
			DrawColorModify( normal_color )
		end 
	end)
end