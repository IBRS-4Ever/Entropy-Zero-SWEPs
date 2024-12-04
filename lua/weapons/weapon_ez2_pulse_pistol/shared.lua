SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "#EZ_Sweps.Category_EZ2"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.AdminOnly = false
SWEP.PrintName				= "#ez2_swep.pulse_pistol"
SWEP.Slot				= 1
SWEP.SlotPos				= 20
SWEP.ViewModel        = "models/weapons/ez2/c_pulsepistol.mdl"
SWEP.WorldModel = "models/weapons/w_pulsepistol.mdl"

SWEP.Primary.Automatic			= true
SWEP.Primary.ClipSize = 50
SWEP.Primary.Delay = 0.6
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Ammo = "none"

SWEP.MaxAmmo = 50

SWEP.Charge = 0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 1.95
SWEP.Secondary.Damage = 125
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "revolver"
SWEP.ReloadSound = ""

SWEP.TracerName = "AR2Tracer"

SWEP.SelectIcon = "c"

function SWEP:Initialize()
self:SetWeaponHoldType( self.HoldType )
self.Idle = 0
self.IdleTimer = CurTime() + 4
if ( CLIENT ) then return end

	timer.Create( "pulse_ammo" .. self:EntIndex(), 0.2, 0, function()
		if ( self:Clip1() < self.MaxAmmo ) then self:SetClip1( math.min( self:Clip1() + 1, self.MaxAmmo ) ) end
	end )
end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
		if self:Clip1() > 10 then
			if ( IsFirstTimePredicted() ) then
				self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
				local bullet = {}
				bullet.Num = 2
				bullet.Src = self.Owner:GetShootPos()
				bullet.Dir = (self.Owner:EyeAngles()+self.Owner:GetViewPunchAngles()):Forward() 
					if GetConVar( "ez_swep_no_bullet_spread" ):GetInt() == 0 then
						bullet.Spread = Vector( 0.01, 0.01, 0 )
					else
						bullet.Spread = Vector( 0, 0, 0 )
					end
				bullet.Force = 5
				bullet.Damage = GetConVar( "ez2_swep_pulse_pistol_dmg" ):GetInt()
				bullet.TracerName = self.TracerName
				self.Owner:FireBullets( bullet )
					if GetConVar( "ez_swep_no_recoil" ):GetInt() == 0 then
						self.Owner:ViewPunch(Angle( -2, math.Rand( -2, 2 ),0))
					end
				
				self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
				self.Owner:SetAnimation( PLAYER_ATTACK1 )
					if GetConVar( "ez_swep_infinite_ammo" ):GetInt() == 0 then
						self:TakePrimaryAmmo( 10 )
					else
						self:TakePrimaryAmmo( 0 )
					end
				self:EmitSound("Weapon_EZ2_PulsePistol.Single")
				self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
				self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
			end
		else
			self:SendWeaponAnim( ACT_VM_DRYFIRE )
			self:SetClip1(50)
			self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
			self:SetNextSecondaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
			self.Idle = 0
			self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		end
end

function SWEP:SecondaryAttack()
    if self:Clip1() > 10 then
	self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		local bullet = {}
		bullet.Num = 20
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = (self.Owner:EyeAngles()+self.Owner:GetViewPunchAngles()):Forward() 
		bullet.Spread = Vector( 0.03, 0.03, 0 )
		bullet.Force = 5
		bullet.Damage = GetConVar( "ez2_swep_pulse_pistol_dmg" ):GetInt()
		bullet.TracerName = self.TracerName
		self.Owner:FireBullets( bullet )
		self.Owner:ViewPunch(Angle( -2, math.Rand( -2, 2 ),0))
		
		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
			if GetConVar( "ez_swep_infinite_ammo" ):GetInt() == 0 then
				self:TakePrimaryAmmo(self:Clip1() - 10)
			else
				self:TakePrimaryAmmo( 0 )
			end
		self:EmitSound("Weapon_EZ2_PulsePistol.ChargeFire")

		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
end
		self.Idle = 0
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:OnRemove()

	timer.Stop( "pulse_ammo" .. self:EntIndex() )

end

function SWEP:CustomAmmoDisplay()

	self.AmmoDisplay = self.AmmoDisplay or {}
	self.AmmoDisplay.Draw = true
	self.AmmoDisplay.PrimaryClip = self:Clip1()

	return self.AmmoDisplay

end

function SWEP:DoImpactEffect( tr, nDamageType )

	if ( tr.HitSky ) then return end
	
	local effectdata = EffectData()
	effectdata:SetOrigin( tr.HitPos + tr.HitNormal )
	effectdata:SetNormal( tr.HitNormal )
	util.Effect( "AR2Impact", effectdata )

end

if ( SERVER ) then return end
killicon.AddFont( "weapon_ez2_pulse_pistol", "EZ2HUD_Kill_ICON", SWEP.SelectIcon, Color( 255, 80, 0, 255 ) )
