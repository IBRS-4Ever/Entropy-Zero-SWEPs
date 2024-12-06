SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "#EZ_Sweps.Category_EZ2"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.AdminOnly = false
SWEP.PrintName				= "#ez2_swep.pistol_madcop"
SWEP.Slot				= 1
SWEP.SlotPos				= 20
SWEP.UseHands = false
SWEP.ViewModel        = "models/weapons/madcop/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.Automatic			= false
SWEP.Primary.ClipSize = 18
SWEP.Primary.Delay = 0.1
SWEP.Primary.DefaultClip = 24
SWEP.Primary.Ammo = "pistol"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 0
SWEP.Secondary.Damage = 0
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "pistol"
SWEP.ReloadSound = "Weapon_EZ2_Pistol_Madcop.Reload"
SWEP.FirstDrawAnimation = "drawfirst"

SWEP.CrosshairX		= 0.25
SWEP.CrosshairY		= 0

SWEP.SelectIcon = "b"

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
		if ( IsFirstTimePredicted() ) then
		self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			local bullet = {}
				bullet.Num = 1
				bullet.Src = self.Owner:GetShootPos()
				bullet.Dir = (self.Owner:EyeAngles()+self.Owner:GetViewPunchAngles()):Forward() 
				if GetConVar( "ez_swep_no_bullet_spread" ):GetInt() == 0 then
					bullet.Spread = Vector( 0.025, 0.025, 0 )
				else
					bullet.Spread = Vector( 0, 0, 0 )
				end
				bullet.Force = 5
				bullet.Damage = GetConVar( "ez2_swep_pistol_madcop_dmg" ):GetInt()
				bullet.TracerName = "Tracer"
				self.Owner:FireBullets( bullet )
			
				if GetConVar( "ez_swep_no_recoil" ):GetInt() == 0 then
					self.Owner:ViewPunch(Angle( -0.5, math.Rand( -0.5, 0.5 ),0))
				end
		
			self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
				if GetConVar( "ez_swep_infinite_ammo" ):GetInt() == 0 then
					self:TakePrimaryAmmo( 1 )
				else
					self:TakePrimaryAmmo( 0 )
				end
				
			self:EmitSound("Weapon_EZ2_Pistol_Madcop.Single")
			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
			self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
		end
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:SecondaryAttack()

end

if ( SERVER ) then return end
killicon.AddFont( "weapon_ez2_pistol_madcop", "EZ2HUD_Kill_ICON", SWEP.SelectIcon, Color( 255, 80, 0, 255 ) )
