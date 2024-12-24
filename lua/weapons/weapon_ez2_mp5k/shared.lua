AddCSLuaFile()
DEFINE_BASECLASS("weapon_ez2_base")

SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "#EZ_Sweps.Category_EZ2"
SWEP.Spawnable				= true
SWEP.PrintName				= "#ez2_swep.mp5k"
SWEP.Slot				= 2
SWEP.SlotPos				= 20
SWEP.ViewModel        = "models/weapons/ez2/c_mp5k.mdl"
SWEP.WorldModel = "models/weapons/w_mp5k.mdl"
SWEP.FiresUnderwater = false

if CLIENT then
	SWEP.WepSelectIcon	= surface.GetTextureID("selector/weapon_ez2_mp5k.vmt")
end

SWEP.Primary.ClipSize = 30
SWEP.Primary.Delay = 0.1
SWEP.Primary.DefaultClip = 200
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Sound = Sound ( "Weapon_ez2_MP5K.Single" )

SWEP.HoldType = "smg"
SWEP.ReloadSound = ""
SWEP.NPCReloadSound = Sound ( "Weapon_ez2_MP5K.Reload" )

SWEP.CrosshairX		= 0.75
SWEP.CrosshairY		= 0.25

SWEP.SelectIcon = "f"

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	self:NetworkVar( "Int",	"BurstCount" )
end

function SWEP:Holster(wep)
	if self:GetBurstCount() > 0 then return false end
	return BaseClass.Holster(self, wep)
end

function SWEP:NPCShoot_Primary( shootPos, shootDir )
	if ( !self:NPCCanPrimaryAttack() ) then return end
	self:ShootBullet(Vector( 0.07, 0.07, 0.07 ), GetConVar( "ez2_swep_mp5k_npc_dmg" ):GetInt(), 1)

	self:EmitSound(self.Primary.Sound)
	self:TakePrimaryAmmo( 1 )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:PrimaryAttack()
	if CurTime() < self:GetNextPrimaryFire() then return end
	if self:Clip1() < 3 then
		self:SecondaryAttack()
		return
	end

	self:SetBurstCount(3)
	self:Think()
	self:SetNextPrimaryFire(CurTime() + 0.1)
end

function SWEP:SecondaryAttack() 
	if !self:TakePrimaryAmmo(1) then return end
	local owner = self:GetOwner()

	self:EmitSound(self.Primary.Sound)

	owner:SetAnimation( PLAYER_ATTACK1 )
	self:PlayActivity( self:GetPrimaryAttackActivity() )
	self:ApplyViewKick(Angle( -0.5, math.Rand( -0.5, 0.5 ),0)) 

	if SERVER then
		sound.EmitHint(SOUND_COMBAT, self:GetPos(), 1500, 0.2, owner)
	end
	owner:MuzzleFlash()

	self:ShootBullet(Vector( 0.05, 0.05, 0.05 ), GetConVar( "ez2_swep_mp5k_plr_dmg" ):GetInt(), 1)

	self:SetShotsFired( self:GetShotsFired() + 1 )
	self:SetNextPrimaryFire(CurTime() + 0.25)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self:SetLastShootTime()
end

function SWEP:Think()
	BaseClass.Think(self)
	if game.SinglePlayer() and CLIENT then return end

	if self:GetBurstCount() > 0 and self:GetNextPrimaryFire() <= CurTime() then
		if not self:TakePrimaryAmmo(1) then return end

		self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
		self:PlayActivity( self:GetPrimaryAttackActivity() )
		self:ShootBullet(Vector( 0.03, 0.03, 0.03 ), GetConVar( "ez2_swep_mp5k_plr_dmg" ):GetInt(), 1)
		self:ApplyViewKick()
		self:SetBurstCount(self:GetBurstCount() - 1)
		self:EmitSound("Weapon_ez2_MP5K.Single")

		self:SetNextSecondaryFire(CurTime() + 0.1 )
		self:SetNextPrimaryFire(CurTime() + 0.1 )

		if self:GetBurstCount() == 0 then
			self:SetNextPrimaryFire(CurTime() + 0.25)
			self:SetNextSecondaryFire(CurTime() + 0.25)
		end
	end
end

function SWEP:ApplyViewKick()
	if GetConVar( "ez_swep_no_recoil" ):GetBool() then return end
	local ang = Angle()
	ang.x = util.SharedRandom("pewx", -.25, -.5)
	ang.y = util.SharedRandom("pewy", -.25, .25	)
	self:GetOwner():ViewPunch(ang)
end

function SWEP:GetNPCRestTimes()
    return 0.1, 0.1
end

function SWEP:GetNPCBurstSettings()
    return 6, 12, 0.1
end

list.Add( "NPCUsableWeapons", { class = "weapon_ez2_mp5k", title = "MP5K (EZ2)" } )

if ( SERVER ) then return end
killicon.AddFont( "weapon_ez2_mp5k", "EZ2HUD_Kill_ICON", SWEP.SelectIcon, Color( 255, 80, 0, 255 ) )