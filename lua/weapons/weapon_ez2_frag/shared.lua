SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "#EZ_Sweps.Category_EZ2"
SWEP.Spawnable				= false 
SWEP.AdminSpawnable			= false 
SWEP.AdminOnly = false
SWEP.PrintName				= "#ez2_swep.grenade"
SWEP.Slot				= 1
SWEP.SlotPos				= 20
SWEP.ViewModel        = "models/weapons/ez2/c_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"

SWEP.Primary.Automatic			= false
SWEP.Primary.ClipSize = -1
SWEP.Primary.Delay = 0.1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "grenade"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 0
SWEP.Secondary.Damage = 0
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "grenade"
SWEP.ReloadSound = "Weapon_EZ2_Pistol_Madcop.Reload"
SWEP.NPCReloadSound = "Weapon_EZ2_Pistol_Madcop.Reload"

SWEP.CrosshairX		= 0.25
SWEP.CrosshairY		= 0.75

SWEP.SelectIcon = "m"

SWEP.Ready = 0

function SWEP:PrimaryAttack()
	self:SendWeaponAnim( ACT_VM_PULLBACK_HIGH )
	timer.Create( "GrenadeTimer", self:SequenceDuration(), 1, function()
		local Pos = self.Owner:GetShootPos() + self.Owner:EyeAngles():Forward() * 32
		local Ang = self.Owner:EyeAngles() + Angle(90,0,0)
		local Vel = self.Owner:GetVelocity() + self.Owner:GetAimVector() * 1200
		local AngVel = Vector( 600, math.Rand( -1200, 1200 ) )
		self:SendWeaponAnim( ACT_VM_THROW )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self:SpawnGrenade( Pos, Ang, Vel, AngVel )
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		timer.Create( "GrenadeTimerDeploy", self:SequenceDuration(), 1, function()
			self:SendWeaponAnim( ACT_VM_DRAW )
			self.Idle = 0
			self.IdleTimer = CurTime() + self:SequenceDuration()
		end)
	end)
end

function SWEP:SecondaryAttack()
	self:SendWeaponAnim( ACT_VM_PULLBACK_LOW )
	timer.Create( "GrenadeTimer", self:SequenceDuration(), 1, function()
		local Pos = self.Owner:GetShootPos() + self.Owner:EyeAngles():Forward() * 32
		local Ang = Angle(0, self.Owner:GetLocalAngles().y, -90 )
		local Vel = self.Owner:GetVelocity() + self.Owner:GetAimVector() * 700
		local AngVel = Vector( 0, 0, 720 )
		self:SendWeaponAnim( ACT_VM_HAULBACK )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self:SpawnGrenade( Pos, Ang, Vel, AngVel )
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		timer.Create( "GrenadeTimerDeploy", self:SequenceDuration(), 1, function()
			self:SendWeaponAnim( ACT_VM_DRAW )
			self.Idle = 0
			self.IdleTimer = CurTime() + self:SequenceDuration()
		end)
	end)
end

function SWEP:SpawnGrenade(position, angle, velocity, angvel)
	if CLIENT then return end
	local Grenade = ents.Create("npc_grenade_frag")
	Grenade:SetOwner(self:GetOwner())
	Grenade:SetPos(position)
	Grenade:SetAngles(angle)
	Grenade:Fire("SetTimer", 3, 0)
	Grenade:Spawn()
	Grenade:GetPhysicsObject():SetVelocity(velocity)
	Grenade:GetPhysicsObject():SetAngleVelocity(angvel)
end
