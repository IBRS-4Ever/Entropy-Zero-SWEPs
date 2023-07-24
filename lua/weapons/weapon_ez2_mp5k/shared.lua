SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "Entropy : Zero" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep..
SWEP.Spawnable				= true --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable			= true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.AdminOnly = false
SWEP.PrintName				= "MP5K (EZ2)"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 2		-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 20			-- Position in the slot
SWEP.UseHands = true
SWEP.ViewModel        = "models/weapons/ez2/c_mp5k.mdl"
SWEP.WorldModel = "models/weapons/w_mp5k.mdl"

SWEP.Primary.Automatic			= true
SWEP.Primary.ClipSize = 30
SWEP.Primary.Delay = 0.10 
SWEP.Primary.DefaultClip = 200
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Sound = Sound ( "Weapon_MP5K.Single" )

SWEP.Secondary.ClipSize = 3
SWEP.Secondary.Delay = 1
SWEP.Secondary.Damage = 0
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "smg"
SWEP.ReloadSound = ""

SWEP.PrimaryDamage = "sk_ez2_mp5k_dmg"
SWEP.SelectIcon = "f"

function SWEP:PrimaryAttack()
 	if ( !self:CanPrimaryAttack() ) then return end
		if ( IsFirstTimePredicted() ) then
		self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			local bullet = {}
			bullet.Num = 1
			bullet.Src = self.Owner:GetShootPos()
			bullet.Dir = self.Owner:GetAimVector()
			
				if GetConVar( "ez_swep_no_recoil" ):GetInt() == 0 then
					self.Owner:ViewPunch(Angle( -0.5, math.Rand( -0.05, 0.05 ),0))
				end
			
				if GetConVar( "ez_swep_no_bullet_spread" ):GetInt() == 0 then
					bullet.Spread = Vector( 0.03, 0.03, 0 )
				else
					bullet.Spread = Vector( 0, 0, 0 )
				end
			bullet.Force = 5
			bullet.Damage = self.Primary.Damage
			self.Owner:FireBullets( bullet )
			
			self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
				if GetConVar( "ez_swep_infinite_ammo" ):GetInt() == 0 then
					self:TakePrimaryAmmo( 1 )
				else
					self:TakePrimaryAmmo( 0 )
				end
			self:EmitSound(self.Primary.Sound)
			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
			self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
		end
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:SecondaryAttack()

end

if ( SERVER ) then return end
killicon.AddFont( "weapon_ez2_mp5k", "WeaponIcons", "f", Color( 255, 80, 0, 255 ) )