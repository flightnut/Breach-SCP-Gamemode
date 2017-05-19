local MODULE = {}

--Pointshop2 Breach integration
MODULE.Name = "Breach Integration"
MODULE.Author = "Kamshak & Link2006" --Modded by Link2006
MODULE.RestrictGamemodes = { "breach" } --Only load for TTT

MODULE.Blueprints = {}

MODULE.SettingButtons = {
	{
		label = "Point Rewards",
		icon = "pointshop2/hand129.png",
		control = "DBreachConfigurator"
	}
}

MODULE.Settings = {}

--These are sent to the client on join
MODULE.Settings.Shared = { }

--These are not sent
MODULE.Settings.Server = {
	Kills = {
		--[[
		info = {
			label = "Kill Rewards"
		},
		]]--
		EnableKillRewards = {
			value = false,
			label = "Enable Kill Rewards",
			tooltip = "Enables Kill Rewards",
		},
		PlayerKilledSCP = {
			value = 10,
			label = "Player kills SCP",
			tooltip = "Points awarded to a player when they kills an SCP",
		},

		PlayerKilledChaos = {
			value = 5,
			label = "Player Kills Chaos",
			tooltip = "Points awarded to a player when they kills a CI",
		},
		ClassDKilledMTF = {
			value = 4,
			label = "ClassD Kills MTF",
			tooltip = "Points awarded to a ClassD when they kill an MTF Guard",
		},
		PlayerKilledOther = {
			value = 2,
			label = "Player Kills Other",
			tooltip = "Points awarded to a player when he kills a generic enemy (eg. Classd -> MTF)",
		},
	},
	Escapes = {

		EnableEscapeRewards = {
			value = false,
			label = "Enable Escape Rewards",
			tooltip = "Enables Escape Rewards",
		},
		PlayerEscapesAlone = {
			value = 1,
			label = "Player Escapes",
			tooltip = "Points awarded when a player escapes"
		},
		PlayerGetsEscorted = {
			value = 2,
			label = "Player Gets Escorted",
			tooltip = "Points awarded when a player is escorted by MTF/Chaos"
		},
		SCPEscapes = {
			value = 4,
			label = "SCP Escapes",
			tooltip = "Points awarded when an SCP Escapes"
		},
	},
	SpecDM = {
		SpecDMEnable ={
			value = false,
			label = "Enable SpecDM Support",
			tooltip = "Gives points when someone gets a kill in SpecDM",
		},
		SpecDMPoints = {
			value = 1,
			label = "SpecDM Points",
			tooltip = "How many points to give per kill in SpecDM?",
		},
	}
}

Pointshop2.RegisterModule( MODULE )
Pointshop2.NotifyGamemodeModuleLoaded( "breach", MODULE )
