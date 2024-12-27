
-- Damage Cvars
CreateConVar( "ez2_swep_proto_ar2_plr_dmg", 16 , FCVAR_SERVER_CAN_EXECUTE, "Sets Proto AR2's Damage.")
CreateConVar( "ez2_swep_proto_ar2_npc_dmg", 8 , FCVAR_SERVER_CAN_EXECUTE, "Sets Proto AR2's Damage.")
CreateConVar( "ez2_swep_proto_ar2_num", 2 , FCVAR_SERVER_CAN_EXECUTE, "Sets Proto AR2's Bullet Num.")
CreateConVar( "ez2_swep_proto_ar2_ball_explode_time", 1 , FCVAR_SERVER_CAN_EXECUTE, "Sets Proto AR2's Energy Ball Explode Time.")
CreateConVar( "ez2_swep_ar2_plr_dmg", 16 , FCVAR_SERVER_CAN_EXECUTE, "Sets AR2's Damage.")
CreateConVar( "ez2_swep_ar2_npc_dmg", 16 , FCVAR_SERVER_CAN_EXECUTE, "Sets AR2's Damage.")
CreateConVar( "ez2_swep_ar2_ball_explode_time", 2 , FCVAR_SERVER_CAN_EXECUTE, "Sets AR2's Energy Ball Explode Time.")
CreateConVar( "ez2_swep_smg1_plr_dmg", 13 , FCVAR_SERVER_CAN_EXECUTE, "Sets SMG's Damage.")
CreateConVar( "ez2_swep_smg1_npc_dmg", 5 , FCVAR_SERVER_CAN_EXECUTE, "Sets SMG's Damage.")
CreateConVar( "ez2_swep_mp5k_plr_dmg", 18 , FCVAR_SERVER_CAN_EXECUTE, "Sets MP5K's Damage.")
CreateConVar( "ez2_swep_mp5k_npc_dmg", 7 , FCVAR_SERVER_CAN_EXECUTE, "Sets MP5K's Damage.")
CreateConVar( "ez2_swep_pulse_pistol_dmg", 15 , FCVAR_SERVER_CAN_EXECUTE, "Sets Pulse Pistol's Damage.")
CreateConVar( "ez2_swep_357_plr_dmg", 75 , FCVAR_SERVER_CAN_EXECUTE, "Sets 357 (EZ2)'s damage.")
CreateConVar( "ez2_swep_357_npc_dmg", 75 , FCVAR_SERVER_CAN_EXECUTE, "Sets 357 (EZ2)'s damage.")
CreateConVar( "ez2_swep_shotgun_madcop_dmg", 18 , FCVAR_SERVER_CAN_EXECUTE, "Sets Shotgun (Madcop)'s damage.")
CreateConVar( "ez2_swep_shotgun_madcop_num", 7 , FCVAR_SERVER_CAN_EXECUTE, "Sets Shotgun (Madcop)'s bullet num.")
CreateConVar( "ez2_swep_shotgun_plr_dmg", 18 , FCVAR_SERVER_CAN_EXECUTE, "Sets Shotgun (EZ2)'s damage.")
CreateConVar( "ez2_swep_shotgun_plr_num", 7 , FCVAR_SERVER_CAN_EXECUTE, "Sets Shotgun (EZ2)'s bullet num.")
CreateConVar( "ez2_swep_shotgun_npc_dmg", 5 , FCVAR_SERVER_CAN_EXECUTE, "Sets Shotgun (EZ2)'s damage.")
CreateConVar( "ez2_swep_shotgun_npc_num", 8 , FCVAR_SERVER_CAN_EXECUTE, "Sets Shotgun (EZ2)'s bullet num.")
CreateConVar( "ez2_swep_pistol_madcop_dmg", 18 , FCVAR_SERVER_CAN_EXECUTE, "Sets Pistol (Madcop)'s damage.")
CreateConVar( "ez2_swep_pistol_plr_dmg", 18 , FCVAR_SERVER_CAN_EXECUTE, "Sets Pistol (EZ2)'s damage.")
CreateConVar( "ez2_swep_pistol_npc_dmg", 7 , FCVAR_SERVER_CAN_EXECUTE, "Sets Pistol (EZ2)'s damage.")

-- Misc Cvars
CreateConVar( "ez_swep_infinite_ammo", 0 , FCVAR_SERVER_CAN_EXECUTE, "Infinite ammo.", 0, 1)
CreateConVar( "ez_swep_no_recoil", 0 , FCVAR_SERVER_CAN_EXECUTE, "No Recoil.", 0, 1)
CreateConVar( "ez_swep_no_bullet_spread", 0 , FCVAR_SERVER_CAN_EXECUTE, "No Bullet Spread.", 0, 1)
CreateConVar( "ez_swep_lower_on_ally", 0 , FCVAR_SERVER_CAN_EXECUTE, "Make the weapons lower down when aiming at an ally.", 0, 1)
CreateConVar( "ez_swep_firstdraw_animation", 1 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "Enable/disable 'Firstdraw' animation.", 0, 1)
CreateConVar( "ez_swep_firstdraw_by_reload", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "Enable/disable play 'Firstdraw' animation when pressed [RELOAD] Key.", 0, 1)
CreateConVar( "ez_swep_fov", 54 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "Sets Entropy Zero SWEPs' FOV. Default: 54", 0, 180)
CreateConVar( "ez_swep_replacement", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "Replace NPC's weapons with Entropy Zero SWEP's.", 0, 1)
CreateConVar( "ez_swep_replacement_player", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "Replace player's weapons with Entropy Zero SWEP's.", 0, 1)
CreateConVar( "ez_swep_bullet_penetrate", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "Bullet Penetrate.", 0, 1)

CreateClientConVar( "ez_swep_icon_use_font", 1 , 0, 1 )