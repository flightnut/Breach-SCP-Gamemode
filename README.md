# README #

This README would normally document whatever steps are necessary to get your application up and running.

### Commands Index ###

* !rcon br_specialround_forcenext spies
* !rcon br_specialround_forcenext assault
* !rcon br_specialround_forcenext multiplebreaches
* !rcon br_specialround_forcenext zombieplague
* !rcon br_roundnospec 1
* !rcon br_friendlyfire 1
* antirdm_enable
* antirdm_disable
* antirdm_status
* ulx ent weapon_physgun

For Bots: (replace 58 with the number of bots you want) 

* ulx luarun for i=1,58 do timer.Simple(i/10,function() RunConsoleCommand('bot') end) end

For Setting Karma to max for everyone 

* ulx luarun for k,v in pairs(player.GetAll()) do v:SetKarma(1200) end
* ulx luarun for k,v in pairs(player.GetAll()) do v:UpdateNKarma() end
* ulx luarun for k,v in pairs(player.GetAll()) do v:SaveKarma() end


* ulx ent prop_physics model:"models/vinrax/scp294/scp294.mdl"

To add an entity you wish to make persistent to the database, look at it and run: 
* PermaWorld_Add

To make an entity no-longer persistent and remove it from the database, look at it and run: 
* PermaWorld_Remove

To reload the persistent entities for any reason (see: accidental deletion), run: 
* PermaWorld_Restore

To purge the persistent world database of all entities, run: 
* PermaWorld_Purge

To remove all persistent world entities from the map, run: 
* PermaWorld_CleanMap
