ENT.Type = "anim"
ENT.Base = "durgz_base"
ENT.PrintName = "SCP-420-J"
ENT.Nicknames = {"SCP-420-J","Top drug","The best"}
ENT.OverdosePhrase = {"got lost in","flew on a one way mission to","will not escape","refuses to leave","decided to stay with"}
ENT.Author = "Joni"
ENT.Spawnable = true
ENT.AdminSpawnable = true 
ENT.Information	 = "" 
ENT.Category = "SCP Entity"
ENT.TRANSITION_TIME = 20

--function for high visuals

if(CLIENT)then

	killicon.Add("scp","killicons/durgz_lsd_killicon",Color( 255, 80, 0, 255 ))

	local TRANSITION_TIME = ENT.TRANSITION_TIME; --transition effect from sober to high, high to sober, in seconds how long it will take etc.
	local HIGH_INTENSITY = 1; --1 is max, 0 is nothing at all
	
	
	local function Doscp420j()
		if(!DURGZ_LOST_VIRGINITY)then return; end
		--self:SetNetworkedFloat( "SprintSpeed"
		local pl = LocalPlayer();
		
		
		local tab = {}
		tab[ "$pp_colour_addr" ] = 0
		tab[ "$pp_colour_addg" ] = 0
		tab[ "$pp_colour_addb" ] = 0
		//tab[ "$pp_colour_brightness" ] = 0
		//tab[ "$pp_colour_contrast" ] = 1
		tab[ "$pp_colour_mulr" ] = 0
		tab[ "$pp_colour_mulg" ] = 0
		tab[ "$pp_colour_mulb" ] = 0
		
		
		if( pl:GetNetworkedFloat("durgz_scp420j_high_start") && pl:GetNetworkedFloat("durgz_scp420j_high_end") > CurTime() )then
		
			if( pl:GetNetworkedFloat("durgz_scp420j_high_start") + TRANSITION_TIME > CurTime() )then
			
				local s = pl:GetNetworkedFloat("durgz_scp420j_high_start");
				local e = s + TRANSITION_TIME;
				local c = CurTime();
				local pf = (c-s) / (e-s);
				pl:SetDSP(12);
				
				tab[ "$pp_colour_colour" ] =   pf*5
				tab[ "$pp_colour_brightness" ] = -pf*0.21
				tab[ "$pp_colour_contrast" ] = pf*0.5
				
				DrawColorModify( tab ) 
				DrawMotionBlur(0.1,1*pf,0.01)
				DrawMaterialOverlay("effects/water_warp01",-0.1*pf)
				DrawSharpen(20*pf,5)
				DrawSobel((1-pf)*0.15)
				
			elseif( pl:GetNetworkedFloat("durgz_scp420j_high_end") - TRANSITION_TIME < CurTime() )then
			
				local e = pl:GetNetworkedFloat("durgz_scp420j_high_end");
				local s = e - TRANSITION_TIME;
				local c = CurTime();
				local pf = 1 - (c-s) / (e-s);
				
				pl:SetDSP(1)
				
				tab[ "$pp_colour_colour" ] =   pf*5
				tab[ "$pp_colour_brightness" ] = -pf*0.21
				tab[ "$pp_colour_contrast" ] = pf*0.5
				
				DrawColorModify( tab ) 
				DrawMotionBlur(0.1,1*pf,0.01)
				DrawMaterialOverlay("effects/water_warp01",-0.1*pf)
				DrawSharpen(20*pf,5)
				DrawSobel((1-pf)*0.15)
				
			else
				
				tab[ "$pp_colour_colour" ] =   5
				tab[ "$pp_colour_brightness" ] = -0.21
				tab[ "$pp_colour_contrast" ] = 0.5
				
				DrawColorModify( tab ) 
				DrawMotionBlur(0.1,1,0.01)
				DrawMaterialOverlay("effects/water_warp01",-0.1)
				DrawSharpen(20,5)
				DrawSobel(0.15)
				
			end
			
			
		end
	end
	
	
	/*local function DoMsgscp420j()
		local pl = LocalPlayer();
		
		
		
		if( pl:GetNetworkedFloat("durgz_scp420j_high_start") && pl:GetNetworkedFloat("durgz_scp420j_high_end") > CurTime() )then
		
			local say = "main"
			
			if( pl:GetNetworkedFloat("durgz_scp420j_high_start") + TRANSITION_TIME > CurTime() )then
			
				say = "trans"
				
			elseif( pl:GetNetworkedFloat("durgz_scp420j_high_end") - TRANSITION_TIME < CurTime() )then
			
				say = "trans"
				
			end
			draw.DrawText(say, "ScoreboardHead", ScrW() / 2+1 , ScrH()*0.6+1, Color(255,255,255,255),TEXT_ALIGN_CENTER) 
			draw.DrawText(say, "ScoreboardHead", ScrW() / 2-1 , ScrH()*0.6-1, Color(255,255,255,255),TEXT_ALIGN_CENTER) 
			draw.DrawText(say, "ScoreboardHead", ScrW() / 2-1 , ScrH()*0.6+1, Color(255,255,255,255),TEXT_ALIGN_CENTER) 
			draw.DrawText(say, "ScoreboardHead", ScrW() / 2+1 , ScrH()*0.6-1, Color(255,255,255,255),TEXT_ALIGN_CENTER) 
			draw.DrawText(say, "ScoreboardHead", ScrW() / 2 , ScrH()*0.6, Color(255,9,9,255),TEXT_ALIGN_CENTER) 
		end
	end
	hook.Add("HUDPaint", "durgz_scp420j_msg", DoMsgscp420j)*/
	
	hook.Add("RenderScreenspaceEffects", "durgz_scp420j_high", Doscp420j)
end
