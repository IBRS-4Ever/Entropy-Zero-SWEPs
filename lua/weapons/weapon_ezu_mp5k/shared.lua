AddCSLuaFile()
DEFINE_BASECLASS("weapon_ez2_base")

SWEP.Base           = "weapon_ez2_mp5k"
SWEP.Category				= "#EZ_Sweps.Category_EZ"
SWEP.SubCategory				= "#EZ_Sweps.Category_EZU"
SWEP.Spawnable				= true --Can you, as a normal user, spawn this?
SWEP.PrintName				= "MP5K (EZU)"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 2		-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 20			-- Position in the slot
SWEP.ViewModel        = "models/weapons/ezu/c_mp5k.mdl"
SWEP.WorldModel = "models/weapons/ezu/w_mp5k.mdl"
SWEP.FirstDrawAnimation = false