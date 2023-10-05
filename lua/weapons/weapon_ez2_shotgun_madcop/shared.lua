SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "Entropy : Zero 2" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep..
SWEP.Spawnable				= true --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable			= true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.AdminOnly = false
SWEP.PrintName				= "Shotgun (Madcop)"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 3		-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 20			-- Position in the slot
SWEP.UseHands = false
SWEP.ViewModel        = "models/weapons/madcop/v_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"

SWEP.Primary.Automatic			= true
SWEP.Primary.ClipSize = 1
SWEP.Primary.Delay = 0.8
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Ammo = "buckshot"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 0
SWEP.Secondary.Damage = 0
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "shotgun"
SWEP.FirstDrawAnimation = "drawfirst"

SWEP.SelectIcon = "b"

function SWEP:Reload()
	if self.NextFirstDrawTimer < CurTime() and self.FirstDrawing == 0 and GetConVar( "ez_swep_firstdraw_by_reload" ):GetInt() == 1 then
		self:PlayAnim( self.FirstDrawAnimation )
		self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	end
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:PrimaryAttack()
	if self:Clip1() < 1 then
		self:Remove()
    end
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
		
			self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
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
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:SecondaryAttack()

end

if ( SERVER ) then return end
killicon.AddAlias( "weapon_ez2_shotgun_madcop", "weapon_shotgun" )
