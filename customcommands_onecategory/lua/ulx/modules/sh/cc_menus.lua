------------------------------------------
--  This file holds menu related items  --
------------------------------------------

function ulx.donate( calling_ply )

	calling_ply:SendLua([[gui.OpenURL( "]] .. GetConVarString("donate_url") .. [[" )]])
	
end

local donate = ulx.command( "Custom", "ulx donatefucku", ulx.donate, "!donatefucku" )
donate:defaultAccess( ULib.ACCESS_ALL )
donate:help( "View donation information." )