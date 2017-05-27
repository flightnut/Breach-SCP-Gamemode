resource.AddWorkshop( "882082976" )
hook.Add("PlayerDeath","Remove freeze after death SCP-173",function(ply)
	if ply:IsFrozen() then
		ply:Freeze(false)
	end
end)