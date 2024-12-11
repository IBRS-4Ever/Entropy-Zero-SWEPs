
-- Pistol (EZ2 Chapter 0)
sound.Add(
{
    name = "Weapon_EZ2_Pistol_Madcop.Clipout",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/madcop/pistol/pistol_clipout.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_Pistol_Madcop.Clipin",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/madcop/pistol/pistol_clipin.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_Pistol_Madcop.Slideback",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/madcop/pistol/pistol_slideback.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_Pistol_Madcop.Slideforward",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/madcop/pistol/pistol_slideforward.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_Pistol_Madcop.Reload",
    channel = CHAN_ITEM,
    volume = 1,
    soundlevel = SNDLVL_NORM,
    pitch = PITCH_NORM,
    sound = "weapons/madcop/pistol/pistol_reload1.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_Pistol_Madcop.Single",
    channel = CHAN_WEAPON,
    volume = 0.55,
    soundlevel = SNDLVL_GUNFIRE,
    pitch = math.random(98, 102),
    sound = "weapons/madcop/pistol/pistol_fire3.wav"
} )

-- 357 (EZ2)
sound.Add(
{
    name = "Weapon_ez2_357.Single",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = { "weapons/ez2/357/357_fire2.wav", "weapons/ez2/357/357_fire3.wav" }
} )

sound.Add(
{
    name = "Weapon_ez2_357.Reload",
    channel = CHAN_ITEM,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = { "weapons/ez2/357/reload1.wav", "weapons/ez2/357/357_fire3.wav" }
} )

sound.Add(
{
    name = "Weapon_ez2_357.OpenLoader",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/357/357_reload1.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_357.RemoveLoader",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/357/357_reload4.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_357.ReplaceLoader",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/357/357_reload3.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_357.Spin",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/357/357_Spin1.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_357.Draw",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/357/357_draw.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_357.Spin",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/357/357_Spin1.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_357.Cock",
    channel = CHAN_AUTO,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/357/357_hammer_prepare.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_357.FirstDraw",
    channel = CHAN_AUTO,
    volume = 1,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/357/357_pickup.wav"
} )

-- Pulse Pistol
sound.Add(
{
    name = "Weapon_EZ2_PulsePistol.Single",
    channel = CHAN_WEAPON,
    volume = 0.92,
    soundlevel = SNDLVL_GUNFIRE,
    pitch = math.random(95, 105),
    sound = "weapons/ez2/pulsepistol/pistol_fire3.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_PulsePistol.Reload",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/pulsepistol/pulse_pistol_working.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_PulsePistol.Charge",
    channel = CHAN_WEAPON,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/pulsepistol/pulse_pistol_charging.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_PulsePistol.ChargeFire",
    channel = CHAN_WEAPON,
    volume = 0.95,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/pulsepistol/pulse_pistol_chargedfire.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_PulsePistol.FirstDraw",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/pulsepistol/pulse_pistol_firstdraw.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_PulsePistol.Draw",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/pulsepistol/pulse_pistol_draw.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_PulsePistol.Slide",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/pulsepistol/pulse_pistol_Slide.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_PulsePistol.SlideBack",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/pulsepistol/pulse_pistol_SlideBack.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_PulsePistol.SlideForward",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/pulsepistol/pulse_pistol_SlideForward.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_PulsePistol.Movement1",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/pulsepistol/pulse_pistol_Movement1.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_PulsePistol.Movement2",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/pulsepistol/pulse_pistol_Movement2.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_PulsePistol.Movement3",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/pulsepistol/pulse_pistol_Movement3.wav"
} )

-- Prototype AR2 (EZ2) 
sound.Add(
{
    name = "Weapon_EZ2_AR2_Proto.Single",
    channel = CHAN_WEAPON,
    volume = 0.8,
    soundlevel = SNDLVL_GUNFIRE,
    pitch = math.random(85, 95),
    sound = "weapons/ez2/proto_ar2/fire1.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2_Proto.Reload_Push",
    channel = CHAN_ITEM,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/proto_ar2/ar2_reload_push.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2_Proto.Reload_Slideback",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/proto_ar2/ar2_slideback.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2_Proto.Reload_Sliderelease",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/proto_ar2/ar2_sliderelease.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2_Proto.Reload_Magdraw",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/proto_ar2/ar2_magdraw.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2_Proto.Reload_Magin",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/proto_ar2/ar2_magin.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2_Proto.AltFire_Single",
    channel = CHAN_WEAPON,
    volume = 0.55,
    soundlevel = SNDLVL_GUNFIRE,
    sound = "weapons/ez2/proto_ar2/irifle_fire2.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2_Proto.Special1",
    channel = CHAN_WEAPON,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/proto_ar2/charging.wav"
} )

-- AR2 (EZ2) 
sound.Add(
{
    name = "Weapon_EZ2_AR2.Single",
    channel = CHAN_WEAPON,
    volume = 0.8,
    soundlevel = SNDLVL_GUNFIRE,
    pitch = math.random(85, 95),
    sound = "weapons/ez2/ar2/fire1.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2.Reload_Rotate",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/ar2/ar2_reload_rotate.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2.Reload_Push",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/ar2/ar2_reload_push.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2.Draw",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/ar2/ar2_draw.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2.FirstDraw",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/ar2/ar2_FirstDraw.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2.Inspect1",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/ar2/ar2_inspect1.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2.Inspect2",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/ar2/ar2_inspect2.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2.Movement1",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/ar2/ar2_movement1.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2.Movement2",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/ar2/ar2_movement2.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2.Movement3",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/ar2/ar2_movement3.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2.Special1",
    channel = CHAN_WEAPON,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/sniper/sniper_zoomin.wav"
} )

sound.Add(
{
    name = "Weapon_EZ2_AR2.Special2",
    channel = CHAN_WEAPON,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/sniper/sniper_zoomout.wav"
} )

-- MP5K (EZ2)
sound.Add(
{
    name = "Weapon_ez2_MP5K.FirstDraw",
    channel = CHAN_WEAPON,
    volume = 1,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/mp5k/mp5k_firstdraw.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_MP5K.Single",
    channel = CHAN_WEAPON,
    volume = 0.55,
    soundlevel = SNDLVL_GUNFIRE,
    pitch = math.random(98, 102),
    sound = "weapons/ez2/mp5k/mp5k_fire1.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_MP5K.Draw",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/mp5k/mp5k_draw.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_MP5K.Movement1",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/mp5k/mp5k_movement1.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_MP5K.Movement2",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/mp5k/mp5k_movement2.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_MP5K.Inspect1",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/mp5k/mp5k_Inspect1.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_MP5K.Inspect2",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/mp5k/mp5k_Inspect2.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_MP5K.Inspect3",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/mp5k/mp5k_Inspect3.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_MP5K.Grab1",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/mp5k/mp5k_Grab1.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_MP5K.Grab2",
    channel = CHAN_AUTO,
    volume = 0.1,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/mp5k/mp5k_Grab2.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_MP5K.Clipin",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/mp5k/mp5k_Clipin.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_MP5K.Clipout",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/mp5k/mp5k_Clipout.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_MP5K.Slideback",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/mp5k/mp5k_Slideback.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_MP5K.Slideforward",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/mp5k/mp5k_Slideforward.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_MP5K.Slideforward2",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/mp5k/mp5k_Slideforward2.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_MP5K.Reload",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/mp5k/mp5k_reload1.wav"
} )

// Shotgun (EZ2)

sound.Add(
{
    name = "Weapon_ez2_Shotgun.Draw",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/shotgun/shotgun_draw.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_Shotgun.Special1",
    channel = CHAN_ITEM,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/shotgun/shotgun_cock.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_Shotgun.Reload",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = { "weapons/ez2/shotgun/shotgun_reload1.wav", "weapons/ez2/shotgun/shotgun_reload2.wav", "weapons/ez2/shotgun/shotgun_reload3.wav" }
} )

sound.Add(
{
    name = "Weapon_ez2_Shotgun.Single",
    channel = CHAN_WEAPON,
    volume = 1,
    soundlevel = SNDLVL_GUNFIRE,
    pitch = math.random(98, 102),
    sound = "weapons/ez2/shotgun/shotgun_fire7.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_Shotgun.NPC_Single",
    channel = CHAN_WEAPON,
    volume = 0.95,
    soundlevel = SNDLVL_GUNFIRE,
    pitch = math.random(98, 101),
    sound = "weapons/ez2/shotgun/shotgun_fire6.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_Shotgun.Double",
    channel = CHAN_WEAPON,
    volume = 1,
    soundlevel = SNDLVL_GUNFIRE,
    pitch = math.random(90, 95),
    sound = "weapons/ez2/shotgun/shotgun_dbl_fire7.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_Shotgun.Movement1",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/shotgun/shotgun_movement1.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_Shotgun.Movement2",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/shotgun/shotgun_movement2.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_Shotgun.Movement3",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/shotgun/shotgun_movement3.wav"
} )

// SMG1 (EZ2)
sound.Add(
{
    name = "Weapon_ez2_SMG1.Single",
    channel = CHAN_WEAPON,
    volume = 0.55,
    soundlevel = SNDLVL_GUNFIRE,
    pitch = math.random(95, 105),
    sound = "weapons/ez2/smg1/smg1_fire1.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_SMG1.NPC_Single",
    channel = CHAN_WEAPON,
    volume = 0.7,
    soundlevel = SNDLVL_GUNFIRE,
    pitch = math.random(95, 105),
    sound = "weapons/ez2/smg1/npc_smg1_fire1.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_SMG1.FirstDraw",
    channel = CHAN_WEAPON,
    volume = 1,
    soundlevel = SNDLVL_NORM,
    pitch = math.random(98, 105),
    sound = "weapons/ez2/smg1/smg1_firstdraw.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_SMG1.Draw",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/smg1/smg1_draw.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_SMG1.Movement1",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/smg1/smg1_movement1.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_SMG1.Movement2",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/smg1/smg1_movement2.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_SMG1.Movement3",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/smg1/smg1_movement3.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_SMG1.Inspect1",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/smg1/smg1_inspect1.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_SMG1.Inspect2",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/smg1/smg1_inspect2.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_SMG1.Inspect3",
    channel = CHAN_AUTO,
    volume = 0.9,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/smg1/smg1_inspect3.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_SMG1.Reload1",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/smg1/smg1_reload1.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_SMG1.Reload2",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/smg1/smg1_reload2.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_SMG1.Reload3",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/smg1/smg1_reload3.wav"
} )

sound.Add(
{
    name = "Weapon_ez2_SMG1.Reload4",
    channel = CHAN_AUTO,
    volume = 0.7,
    soundlevel = SNDLVL_NORM,
    sound = "weapons/ez2/smg1/smg1_reload4.wav"
} )
