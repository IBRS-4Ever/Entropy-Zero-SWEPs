SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "#EZ_Sweps.Category_EZ2"
SWEP.Spawnable				= true
SWEP.PrintName				= "#ez2_swep.pulse_pistol"
SWEP.Slot				= 1
SWEP.SlotPos				= 20
SWEP.ViewModel        = "models/weapons/ez2/c_pulsepistol.mdl"
SWEP.WorldModel = "models/weapons/w_pulsepistol.mdl"

if CLIENT then
	SWEP.WepSelectIcon	= surface.GetTextureID("selector/weapon_ez2_pulse_pistol.vmt")
end

SWEP.Primary.ClipSize = 50
SWEP.Primary.Delay = 0.6
SWEP.Primary.DefaultClip = 50

SWEP.MaxAmmo = 50

SWEP.Charge = 0

SWEP.Secondary.Delay = 1.95
SWEP.Secondary.Damage = 125

SWEP.HoldType = "revolver"
SWEP.ReloadSound = ""

SWEP.TracerName = "AR2Tracer"

SWEP.SelectIcon = "c"

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	if ( CLIENT ) then return end

	timer.Create( "pulse_ammo" .. self:EntIndex(), 0.2, 0, function()
		if ( self:Clip1() < self.MaxAmmo ) then self:SetClip1( math.min( self:Clip1() + 1, self.MaxAmmo ) ) end
	end )
end

function SWEP:PrimaryAttack()
	if !self:TakePrimaryAmmo(10) then return end
	if self:Clip1() > 10 then
		local owner = self:GetOwner()
		self:EmitSound("Weapon_EZ2_PulsePistol.Single")
		self:PlayActivity( self:GetPrimaryAttackActivity() )

		self:ApplyViewKick(Angle( -2, math.Rand( -2, 2 ),0))

		if SERVER then
			sound.EmitHint(SOUND_COMBAT, self:GetPos(), 1500, 0.2, owner)
		end
		owner:MuzzleFlash()

		self:ShootBullet(Vector( 0.01, 0.01, 0.01 ), GetConVar( "ez2_swep_pulse_pistol_dmg" ):GetInt(), 2)

		self:SetShotsFired( self:GetShotsFired() + 1 )
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
		self:SetLastShootTime()
	else
		self:PlayActivity( ACT_VM_DRYFIRE, true )
		self:SetClip1(50)
	end
end

function SWEP:SecondaryAttack()
	if !self:TakePrimaryAmmo(10) then return end
	if self:Clip1() > 10 then
		local owner = self:GetOwner()
		self:EmitSound("Weapon_EZ2_PulsePistol.ChargeFire")
		self:PlayActivity( ACT_VM_PRIMARYATTACK )

		self:ApplyViewKick(Angle( -2, math.Rand( -2, 2 ),0))

		if SERVER then
			sound.EmitHint(SOUND_COMBAT, self:GetPos(), 1500, 0.2, owner)
		end
		owner:MuzzleFlash()

		self:ShootBullet(Vector( 0.03, 0.03, 0.03 ), GetConVar( "ez2_swep_pulse_pistol_dmg" ):GetInt(), 20)

		self:SetShotsFired( self:GetShotsFired() + 1 )
		self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)
		self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
		self:SetLastShootTime()
		self:SetClip1(10)
	end
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
