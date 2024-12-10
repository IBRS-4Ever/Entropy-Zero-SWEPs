SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "#EZ_Sweps.Category_EZ2"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.AdminOnly = false
SWEP.PrintName				= "#ez2_swep.pistol"
SWEP.Slot				= 1
SWEP.SlotPos				= 20
SWEP.ViewModel        = "models/weapons/ez2/c_pistol.mdl"
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
SWEP.NPCReloadSound = "Weapon_EZ2_Pistol_Madcop.Reload"

SWEP.CrosshairX		= 0.25

SWEP.SelectIcon = "b"

function SWEP:NPCShoot_Primary( shootPos, shootDir )
	if ( !self:NPCCanPrimaryAttack() ) then return end
	local bullet = {}
	bullet.Num = 1
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector( 0.025, 0.025, 0 )
	bullet.Force = 5
	bullet.Damage = GetConVar( "ez2_swep_pistol_npc_dmg" ):GetInt()
	bullet.TracerName = "Tracer"
	bullet.Callback	= function(a,b,c)
		self:BulletPenetrate(a,b,c)
	end
	self.Owner:FireBullets( bullet )
		
	self:EmitSound("Weapon_EZ2_Pistol_Madcop.Single")
	self:TakePrimaryAmmo( 1 )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
end

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

	self:ShootBullet(Vector( 0.01, 0.01, 0.01 ), GetConVar( "ez2_swep_pistol_plr_dmg" ):GetInt(), 1)

	self:SetShotsFired( self:GetShotsFired() + 1 )
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetLastShootTime()
end

function SWEP:GetNPCRestTimes()
    return 0.4, 0.8
end

function SWEP:GetNPCBurstSettings()
    -- return 6, 12, 0.1
end

list.Add( "NPCUsableWeapons", { class = "weapon_ez2_pistol", title = "Pistol (EZ2)" } )

if ( SERVER ) then return end
killicon.AddFont( "weapon_ez2_pistol", "EZ2HUD_Kill_ICON", SWEP.SelectIcon, Color( 255, 80, 0, 255 ) )
