SWEP.Base           = "weapon_base"
SWEP.Category				= "#EZ_Sweps.Category_EZ"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.AdminOnly = false
SWEP.DrawCrosshair			= true
SWEP.DrawCrosshairIS = false
SWEP.PrintName				= "#ez_swep.manhack_toss"
SWEP.Slot				= 5
SWEP.SlotPos				= 20
SWEP.DrawAmmo				= true
SWEP.DrawWeaponInfoBox			= false
SWEP.BounceWeaponIcon   		= 	false
SWEP.AutoSwitchTo			= true
SWEP.AutoSwitchFrom			= true
SWEP.Weight				= 30
SWEP.UseHands = true
SWEP.ViewModel        = "models/weapons/c_manhackcontrol.mdl"
SWEP.WorldModel = "models/weapons/w_manhackcontrol.mdl"

SWEP.Primary.Automatic			= true
SWEP.Primary.ClipSize = 1
SWEP.Primary.Delay = 1.5
SWEP.Primary.Damage = 8
SWEP.Primary.DefaultClip = 3
SWEP.Primary.Ammo = "manhack"

SWEP.HoldType = "grenade"

SWEP.Idle = 0
SWEP.IdleTimer = CurTime()

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 1
SWEP.Secondary.Damage = 125
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

function SWEP:Reload()
	self.Weapon:DefaultReload(ACT_VM_RELOAD) 
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	return true 
end

function SWEP:Initialize()
	game.AddAmmoType( { name = "manhack" } )
	self:SetWeaponHoldType( self.HoldType )
	self.Idle = 0
	self.IdleTimer = CurTime() + 4
end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	if ( IsFirstTimePredicted() ) then
		if SERVER then
			local Manhack = ents.Create("npc_manhack")
			Manhack:SetOwner(self.Owner)
			Manhack:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector()*50 )
			Manhack:SetAngles(self.Owner:EyeAngles())
			Manhack:Spawn()
			Manhack:Activate()
			Manhack:SetVelocity(self.Owner:GetAimVector()*1000 + Vector(0,0,80))
			Manhack:SetHealth(200)
			-- Manhack:SetDamage(75)
			Manhack:AddRelationship( "player D_LI 99" )
			Manhack:SetSequence( "deploy" )
			Manhack.IsScripted = true
		
			self:SetNextPrimaryFire( CurTime() + 1 )
			self:SetNextSecondaryFire( CurTime() + 1 )
			self:SendWeaponAnim( ACT_VM_THROW )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			if GetConVar( "ez_swep_infinite_ammo" ):GetInt() == 0 then
				self:TakePrimaryAmmo( 1 )
			else
				self:TakePrimaryAmmo( 0 )
			end
		end

		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
		self:Reload()
		self.Idle = 0
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	end
end

function SWEP:Think()
	self.ViewModelFOV = 54
	if self.Idle == 0 and self.IdleTimer < CurTime() then
		if SERVER then
			self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
		end
		self.Idle = 1
	end
end
