--[[=============================================================================]]--
--[[==== Away from Keyboard Utilities - Version 1.1.3                        ====]]--
--[[==== Made by Red @ https://scriptfodder.com/users/view/76561198151769476 ====]]--
--[[=============================================================================]]--

-- If you want to edit this file make a duplicate of it, then rename the id in the new duplicate.

theme.id = "minimal1"
theme.name = "Minimal1 Theme"
theme.author = "Red"
theme.website = "http://www.thebigredforest.com/"
theme.information = "Version 1 of a simple minimalistic theme"

if SERVER then return end

local drawwarning = false
local drawwarningsub = false
local fadevalue = 0
local maxfadevalue = 240
local fadespeed = 1
local mat = Material( "materials/afkutil/icon.png" )
local half = ScrW()/2/2

local function vgui()
    draw.RoundedBox( 0, ScrW()/2-half/2, (ScrH()/2)-ScreenScale(60)-10, ScrW()/2/2, ScreenScale(120)/2, Color(0,0,0,fadevalue) )
	if #player.GetAll() >= afkutil.config.minplayers then
		draw.DrawText( afkutil.config.warnmsgbody_kick, "afkutil.font.25", ScrW() * 0.5, (ScrH()*0.5-(ScreenScale(50))), Color( 255,255,255, fadevalue ), TEXT_ALIGN_CENTER )
	else
		draw.DrawText( afkutil.config.warnmsgbody_slay, "afkutil.font.25", ScrW() * 0.5, (ScrH()*0.5-(ScreenScale(50))), Color( 255,255,255, fadevalue ), TEXT_ALIGN_CENTER )
	end 
    surface.SetDrawColor( 255, 255, 255, fadevalue )
    surface.SetMaterial( mat ) -- If you use Material, cache it!
	surface.DrawTexturedRect( ScrW()/2-half/2+half-half/2-25/2, (ScrH()/2)-ScreenScale(60)-10+100, 25, 25 )
end

function theme:InitWarning()
    hook.Add("HUDPaint","drawafkWarning",function()
        if drawwarning then
            vgui()
        else
            if drawwarningsub then
                vgui()
                if fadevalue == 0 then
                    drawwarningsub = false
                else
                    fadevalue = fadevalue - fadespeed
                end
            end
        end
        if drawwarning then
            if fadevalue == maxfadevalue then
                drawwarningsub = true
            else
                fadevalue = fadevalue + fadespeed
            end
        end
    end)
end

function theme:ToggleWarningDraw()
    if drawwarning == true then
        drawwarning = false
    else
        drawwarning = true
    end
end