
local ConVarsDefault = {
	ez2_swep_proto_ar2_plr_dmg = "16",
	ez2_swep_proto_ar2_npc_dmg = "8",
	ez2_swep_proto_ar2_num = "2",
	ez2_swep_proto_ar2_ball_explode_time = "1",
	ez2_swep_ar2_plr_dmg = "16",
	ez2_swep_ar2_npc_dmg = "16",
	ez2_swep_ar2_ball_explode_time = "2",
	ez2_swep_smg1_plr_dmg = "13",
	ez2_swep_smg1_npc_dmg = "5",
	ez2_swep_mp5k_plr_dmg = "18",
	ez2_swep_mp5k_npc_dmg = "7",
	ez2_swep_pulse_pistol_dmg = "15",
	ez2_swep_357_plr_dmg = "75",
	ez2_swep_357_npc_dmg = "75",
	ez2_swep_shotgun_madcop_dmg = "18",
	ez2_swep_shotgun_madcop_num = "7",
	ez2_swep_shotgun_plr_dmg = "18",
	ez2_swep_shotgun_plr_num = "7",
	ez2_swep_shotgun_npc_dmg = "5",
	ez2_swep_shotgun_npc_num = "8",
	ez2_swep_pistol_madcop_dmg = "18",
	ez2_swep_pistol_plr_dmg = "18",
	ez2_swep_pistol_npc_dmg = "7"
}

hook.Add("AddToolMenuTabs", "EZ_ADDMENU", function()
	spawnmenu.AddToolCategory("Options", "EZ Settings", "#ez_swep.swep.settings")
end)

concommand.Add( "ez_swep_reset_commands", function( ply )
	RunConsoleCommand( "ez_swep_no_recoil", 0 )
	RunConsoleCommand( "ez_swep_no_bullet_spread", 0 )
	RunConsoleCommand( "ez_swep_infinite_ammo", 0 )
	RunConsoleCommand( "ez_swep_firstdraw_animation", 1 )
	RunConsoleCommand( "ez_swep_firstdraw_by_reload", 1 )
	RunConsoleCommand( "ez_swep_lower_on_ally", 0 )
	RunConsoleCommand( "ez_swep_replacement", 0 )
	RunConsoleCommand( "ez_swep_fov", 54 )
end )

hook.Add("PopulateToolMenu","EZ_MENU",function()
	spawnmenu.AddToolMenuOption("Options","EZ Settings","EZ_Settings","#ez_swep.settings","","",function(pnl)
	pnl:ClearControls()
	pnl:AddControl( "CheckBox", { Label = "#ez_swep.no.recoil", Command = "ez_swep_no_recoil" } )
	pnl:AddControl( "CheckBox", { Label = "#ez_swep.no.bullet.spread", Command = "ez_swep_no_bullet_spread" } )
	pnl:AddControl( "CheckBox", { Label = "#ez_swep.infinite.ammo", Command = "ez_swep_infinite_ammo" } )
	pnl:AddControl( "CheckBox", { Label = "#ez_swep.bullet.penetrate", Command = "ez_swep_bullet_penetrate" } )
	pnl:AddControl( "CheckBox", { Label = "#ez_swep.icon_use_font", Command = "ez_swep_icon_use_font" } )
	pnl:AddControl( "CheckBox", { Label = "#ez_swep.firstdraw.animation", Command = "ez_swep_firstdraw_animation" } )
	pnl:ControlHelp( "#ez_swep.firstdraw.animation.desc" )
	pnl:AddControl( "CheckBox", { Label = "#ez_swep.firstdraw.by_reload", Command = "ez_swep_firstdraw_by_reload" } )
	pnl:ControlHelp( "#ez_swep.firstdraw.by_reload.desc" )
	pnl:AddControl( "CheckBox", { Label = "#ez_swep.lower_on_ally", Command = "ez_swep_lower_on_ally" } )
	pnl:ControlHelp( "#ez_swep.lower_on_ally.desc" )
	pnl:AddControl( "CheckBox", { Label = "#ez_swep.replacement", Command = "ez_swep_replacement" } )
	pnl:ControlHelp( "#ez_swep.replacement.desc" )
	pnl:KeyBinder( "#ez_swep.send_recall.bind", "ez_swep_send_squad" )
	pnl:ControlHelp("#ez_swep.send_recall.bind.help")
	pnl:AddControl( "Button", { Label = "#ez_swep.reset.commands", Command = "ez_swep_reset_commands" } )
	end)
	spawnmenu.AddToolMenuOption("Options","EZ Settings","EZ_Values","#ez_swep.values","","",function(pnl)
	pnl:AddControl( "ComboBox", { MenuButton = 1, Folder = "entropy_zero_sweps", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )
	pnl:AddControl( "Slider", { Label = "#ez_swep.fov", Type = "Integer", Command = "ez_swep_fov", Min = "0", Max = "180" } )
	pnl:AddControl( "label", { Text = "#ez2_swep.title" } )
	pnl:ControlHelp("#ez2_swep.pistol")
	pnl:AddControl( "textbox", { Label = "#ez2_swep.plr_dmg", Command = "ez2_swep_pistol_plr_dmg" } )
	pnl:AddControl( "textbox", { Label = "#ez2_swep.npc_dmg", Command = "ez2_swep_pistol_npc_dmg" } )
	pnl:ControlHelp("#ez2_swep.pistol_madcop")
	pnl:AddControl( "textbox", { Label = "#ez2_swep.dmg", Command = "ez2_swep_pistol_madcop_dmg" } )
	pnl:ControlHelp("#ez2_swep.357")
	pnl:AddControl( "textbox", { Label = "#ez2_swep.plr_dmg", Command = "ez2_swep_357_plr_dmg" } )
	pnl:AddControl( "textbox", { Label = "#ez2_swep.npc_dmg", Command = "ez2_swep_357_npc_dmg" } )
	pnl:ControlHelp("#ez2_swep.pulse_pistol")
	pnl:AddControl( "textbox", { Label = "#ez2_swep.dmg", Command = "ez2_swep_pulse_pistol_dmg" } )
	pnl:ControlHelp("#ez2_swep.smg1")
	pnl:AddControl( "textbox", { Label = "#ez2_swep.plr_dmg", Command = "ez2_swep_smg1_plr_dmg" } )
	pnl:AddControl( "textbox", { Label = "#ez2_swep.npc_dmg", Command = "ez2_swep_smg1_npc_dmg" } )
	pnl:ControlHelp("#ez2_swep.mp5k")
	pnl:AddControl( "textbox", { Label = "#ez2_swep.plr_dmg", Command = "ez2_swep_mp5k_plr_dmg" } )
	pnl:AddControl( "textbox", { Label = "#ez2_swep.npc_dmg", Command = "ez2_swep_mp5k_npc_dmg" } )
	pnl:ControlHelp("#ez2_swep.ar2")
	pnl:AddControl( "textbox", { Label = "#ez2_swep.plr_dmg", Command = "ez2_swep_ar2_plr_dmg" } )
	pnl:AddControl( "textbox", { Label = "#ez2_swep.npc_dmg", Command = "ez2_swep_ar2_npc_dmg" } )
	pnl:AddControl( "textbox", { Label = "#ez2_swep.energy_ball.explode.time", Command = "ez2_swep_ar2_ball_explode_time" } )
	pnl:ControlHelp("#ez2_swep.ar2_proto")
	pnl:AddControl( "textbox", { Label = "#ez2_swep.plr_dmg", Command = "ez2_swep_proto_ar2_plr_dmg" } )
	pnl:AddControl( "textbox", { Label = "#ez2_swep.npc_dmg", Command = "ez2_swep_proto_ar2_npc_dmg" } )
	pnl:AddControl( "textbox", { Label = "#ez2_swep.num", Command = "ez2_swep_proto_ar2_num" } )
	pnl:AddControl( "textbox", { Label = "#ez2_swep.energy_ball.explode.time", Command = "ez2_swep_proto_ar2_ball_explode_time" } )
	pnl:ControlHelp("#ez2_swep.shotgun")
	pnl:AddControl( "textbox", { Label = "#ez2_swep.plr_dmg", Command = "ez2_swep_shotgun_plr_dmg" } )
	pnl:AddControl( "textbox", { Label = "#ez2_swep.npc_dmg", Command = "ez2_swep_shotgun_npc_dmg" } )
	pnl:AddControl( "textbox", { Label = "#ez2_swep.plr_num", Command = "ez2_swep_shotgun_plr_num" } )
	pnl:AddControl( "textbox", { Label = "#ez2_swep.npc_num", Command = "ez2_swep_shotgun_npc_num" } )
	pnl:ControlHelp("#ez2_swep.shotgun_madcop")
	pnl:AddControl( "textbox", { Label = "#ez2_swep.dmg", Command = "ez2_swep_shotgun_madcop_dmg" } )
	pnl:AddControl( "textbox", { Label = "#ez2_swep.num", Command = "ez2_swep_shotgun_madcop_num" } )
	pnl:AddControl( "Button", { Label = "#ez_swep.reset.commands", Command = "ez_swep_reset_commands" } )
	end)
end)