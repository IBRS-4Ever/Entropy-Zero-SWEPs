
-- Damage Cvars
CreateConVar( "sk_ez_proto_ar2_dmg", 16 , FCVAR_SERVER_CAN_EXECUTE, "Sets Proto AR2's Damage.")
CreateConVar( "sk_ez_proto_ar2_num", 2 , FCVAR_SERVER_CAN_EXECUTE, "Sets Proto AR2's Bullet Num.")
CreateConVar( "sk_ez_proto_ar2_ball_explode_time", 1 , FCVAR_SERVER_CAN_EXECUTE, "Sets Proto AR2's Energy Ball Explode Time.")
CreateConVar( "sk_ez2_mp5k_dmg", 8 , FCVAR_SERVER_CAN_EXECUTE, "Sets MP5K's Damage.")
CreateConVar( "sk_ez2_pulse_pistol_dmg", 15 , FCVAR_SERVER_CAN_EXECUTE, "Sets Pulse Pistol's Damage.")
CreateConVar( "sk_ez2_357_dmg", 75 , FCVAR_SERVER_CAN_EXECUTE, "Sets 357 (EZ2)'s damage.")
CreateConVar( "ez_swep_shotgun_madcop_dmg", 18 , FCVAR_SERVER_CAN_EXECUTE, "Sets Shotgun (Madcop)'s damage.")
CreateConVar( "ez_swep_shotgun_madcop_num", 7 , FCVAR_SERVER_CAN_EXECUTE, "Sets Shotgun (Madcop)'s bullet num.")
CreateConVar( "ez_swep_pistol_madcop_dmg", 18 , FCVAR_SERVER_CAN_EXECUTE, "Sets Pistol (Madcop)'s damage.")
CreateConVar( "ez_swep_pistol_ez2_dmg", 18 , FCVAR_SERVER_CAN_EXECUTE, "Sets Pistol (EZ2)'s damage.")

-- Misc Cvars
CreateConVar( "ez_swep_infinite_ammo", 0 , FCVAR_SERVER_CAN_EXECUTE, "Infinite ammo.", 0, 1)
CreateConVar( "ez_swep_no_recoil", 0 , FCVAR_SERVER_CAN_EXECUTE, "No Recoil.", 0, 1)
CreateConVar( "ez_swep_no_bullet_spread", 0 , FCVAR_SERVER_CAN_EXECUTE, "No Bullet Spread.", 0, 1)
CreateConVar( "ez_swep_lower_on_ally", 0 , FCVAR_SERVER_CAN_EXECUTE, "Make the weapons lower down when aiming at an ally.", 0, 1)
CreateConVar( "ez_swep_firstdraw_animation", 1 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "Enable/disable 'Firstdraw' animation.", 0, 1)
CreateConVar( "ez_swep_firstdraw_by_reload", 0 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "Enable/disable play 'Firstdraw' animation when pressed [RELOAD] Key.", 0, 1)
CreateConVar( "ez_swep_fov", 54 , FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE + FCVAR_REPLICATED, "Sets Entropy Zero SWEPs' FOV.", 0, 180)