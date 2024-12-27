SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "#EZ_Sweps.Category_EZ2"
SWEP.Spawnable				= true
SWEP.PrintName				= "#ez2_swep.shotgun_madcop"
SWEP.Slot				= 3
SWEP.SlotPos				= 20
SWEP.UseHands = false
SWEP.ViewModel        = "models/weapons/madcop/v_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"

if CLIENT then
	SWEP.WepSelectIcon	= surface.GetTextureID("selector/weapon_ez2_shotgun.vmt")
end

SWEP.Primary.ClipSize = 1
SWEP.Primary.Delay = 0.8
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Ammo = "buckshot"

SWEP.HoldType = "shotgun"
SWEP.FirstDrawAnimation = "drawfirst"

SWEP.CrosshairY		= 0.5

SWEP.SelectIcon = "h"

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	if ( IsFirstTimePredicted() ) then
		self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		local bullet = {}
		bullet.Num = GetConVar( "ez2_swep_shotgun_madcop_num" ):GetInt()
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = (self.Owner:EyeAngles()+self.Owner:GetViewPunchAngles()):Forward() 
		bullet.Spread = Vector( 0.05, 0.05, 0 )
		bullet.Force = 5
		bullet.Damage = GetConVar( "ez2_swep_shotgun_madcop_dmg" ):GetInt()
		bullet.TracerName = "Tracer"
		self.Owner:FireBullets( bullet )
		
		if GetConVar( "ez_swep_no_recoil" ):GetInt() == 0 then
			self.Owner:ViewPunch(Angle( -4, math.Rand( -2, 2 ),0))
		end
	
		self:PlayActivity(ACT_VM_PRIMARYATTACK, true)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		
		if GetConVar( "ez_swep_infinite_ammo" ):GetInt() == 0 then
			self:TakePrimaryAmmo( 1 )
		else
			self:TakePrimaryAmmo( 0 )
		end
			
		self:EmitSound("Weapon_shotgun.Single")
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	end
end

function SWEP:Reload() end

if ( SERVER ) then return end
killicon.AddFont( "weapon_ez2_shotgun_madcop", "EZ2HUD_Kill_ICON", SWEP.SelectIcon, Color( 255, 80, 0, 255 ) )
