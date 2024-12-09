SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "#EZ_Sweps.Category_EZ2"
SWEP.Spawnable				= true
SWEP.PrintName				= "#ez2_swep.pistol_madcop"
SWEP.Slot				= 1
SWEP.SlotPos				= 20
SWEP.UseHands = false
SWEP.ViewModel        = "models/weapons/madcop/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

if CLIENT then
	SWEP.WepSelectIcon	= surface.GetTextureID("selector/weapon_ez2_pistol.vmt")
end

SWEP.Primary.Automatic			= false
SWEP.Primary.ClipSize = 18
SWEP.Primary.Delay = 0.1
SWEP.Primary.DefaultClip = 24
SWEP.Primary.Ammo = "pistol"

SWEP.HoldType = "pistol"
SWEP.ReloadSound = "Weapon_EZ2_Pistol_Madcop.Reload"
SWEP.FirstDrawAnimation = "drawfirst"

SWEP.CrosshairX		= 0.25

SWEP.SelectIcon = "b"

function SWEP:PrimaryAttack()
	if !self:TakePrimaryAmmo(1) then return end
	local owner = self:GetOwner()

	self:EmitSound("Weapon_EZ2_Pistol_Madcop.Single")

	owner:SetAnimation( PLAYER_ATTACK1 )
	self:PlayActivity( self:GetPrimaryAttackActivity() )
	self:ApplyViewKick(Angle( -0.5, math.Rand( -0.5, 0.5 ),0)) 

	if SERVER then
		sound.EmitHint(SOUND_COMBAT, self:GetPos(), 1500, 0.2, owner)
	end
	owner:MuzzleFlash()

	self:ShootBullet(Vector( 0.025, 0.025, 0.01 ), GetConVar( "ez2_swep_pistol_plr_dmg" ):GetInt(), 1)

	self:SetShotsFired( self:GetShotsFired() + 1 )
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetLastShootTime()
end

if ( SERVER ) then return end
killicon.AddFont( "weapon_ez2_pistol_madcop", "EZ2HUD_Kill_ICON", SWEP.SelectIcon, Color( 255, 80, 0, 255 ) )
