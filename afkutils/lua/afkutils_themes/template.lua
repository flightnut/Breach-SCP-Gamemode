--[[=============================================================================]]--
--[[==== Away from Keyboard Utilities - Version 1.1.3                        ====]]--
--[[==== Made by Red @ https://scriptfodder.com/users/view/76561198151769476 ====]]--
--[[=============================================================================]]--


--[[==== Please Read ====]]--
-- First off let me just say, this is a badly written theme system. So making your own theme might be a little hard and advanced.
-- But if you are good with lua, then go right ahead.
-- I will try and keep making this as easy as I can, but please bare with me :)


-- When editing themes, you must restart your server after you save in order for afkutil to re-write certain settings.

-- Theme id
-- The id string of this theme
-- Must be a lowercase string with no spaces
-- This is what you use in the config
-- Required
theme.id = "template"

-- Theme name
-- The name of this theme
-- Required
theme.name = "Template Theme"

-- Theme author
-- The name of the person who made this theme
-- Not required
theme.author = "Red"

-- Theme author's website
-- The website of the author
-- Not required
theme.website = "http://www.thebigredforest.com/"

-- Theme information
-- The basic information of the theme
-- Not required
theme.information = "This is a simple template theme"

-- Theme's draw uid
-- If you need to modify the draw hook, then this is usefull
-- Not required
theme.drawuid = "drawafkwarning_"..theme.id

-- Prevent server from reading stuff below
-- Required
if SERVER then return end

-- Variables
-- You really should make these local variables to prevent broken stuff
local drawwarning = false

-- Init theme
-- This is called before anything else, and all vgui stuff goes here
-- Required
function theme:InitWarning()
    -- Make sure to have this hook here
    hook.Add("HUDPaint",theme.drawuid,function()
        if drawwarning then
            draw.RoundedBox( 0, 0, (ScrH()/2)-ScreenScale(60), ScrW(), ScreenScale(120), Color(0,0,0,fadevalue) )
            draw.DrawText( afkutil.config.warnmsgtitle, "afkutil.font.120", ScrW() * 0.5, (ScrH()*0.5)-(ScreenScale(50)), Color( 255, 0 ,0 , fadevalue ), TEXT_ALIGN_CENTER )
			if #player.GetAll() >= afkutil.config.minplayers then
				draw.DrawText( afkutil.config.warnmsgbody_kick, "afkutil.font.25", ScrW() * 0.5, (ScrH()*0.5), Color( 255,255,255, fadevalue ), TEXT_ALIGN_CENTER )
			else
				draw.DrawText( afkutil.config.warnmsgbody_slay, "afkutil.font.25", ScrW() * 0.5, (ScrH()*0.5), Color( 255,255,255, fadevalue ), TEXT_ALIGN_CENTER )
			end 
        end
    end)
end

-- Toggle warning
-- This function makes the warning show and not show
function theme:ToggleWarningDraw()
    if drawwarning == true then
        drawwarning = false
    else
        drawwarning = true
    end
end