SWEP.Base           = "weapon_base"
SWEP.Category				= "#EZ_Sweps.Category_EZ"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.AdminOnly = false
SWEP.DrawCrosshair			= true
SWEP.DrawCrosshairIS = false
SWEP.PrintName				= "#ez_swep.stunstick"
SWEP.Slot				= 0
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= false
SWEP.DrawWeaponInfoBox			= false
SWEP.BounceWeaponIcon   		= 	false
SWEP.AutoSwitchTo			= true
SWEP.AutoSwitchFrom			= true
SWEP.Weight				= 30
SWEP.UseHands = true
SWEP.ViewModel        = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.ViewModelFlip = false
SWEP.BobScale = 0.2
SWEP.SwayScale = 1

SWEP.Primary.Automatic			= true
SWEP.Primary.ClipSize = 1
SWEP.Primary.Delay = 1.5
SWEP.Primary.Damage = 20
SWEP.Primary.DefaultClip = 3
SWEP.Primary.Ammo = "none"
SWEP.Primary.DelayMiss = 0.75
SWEP.Primary.DelayHit = 0.5
SWEP.Primary.Force = 1000

SWEP.HoldType = "melee"
SWEP.FiresUnderwater = true

SWEP.Idle = 0
SWEP.IdleTimer = CurTime()
SWEP.Charging = 0
SWEP.ChargingTimer = CurTime()

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 1
SWEP.Secondary.Damage = 60
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.DelayMiss = 0.75
SWEP.Secondary.DelayHit = 0.5
SWEP.Secondary.Force = 2000

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	return true
end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	self.Idle = 0
	self.IdleTimer = CurTime() + 4
end

function SWEP:SetupWeaponHoldTypeForAI( t )
	local owner = self:GetOwner()
	if ( !owner:IsNPC() ) then return end

	self.ActivityTranslateAI = {}

	self.ActivityTranslateAI[ ACT_IDLE ]					= ACT_IDLE
	self.ActivityTranslateAI[ ACT_IDLE_ANGRY ]				= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_IDLE_RELAXED ]			= ACT_IDLE
	self.ActivityTranslateAI[ ACT_IDLE_STIMULATED ]			= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_IDLE_AGITATED ]			= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_IDLE_AIM_RELAXED ]		= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_IDLE_AIM_STIMULATED ]		= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_IDLE_AIM_AGITATED ]		= ACT_IDLE_ANGRY_MELEE

	self.ActivityTranslateAI[ ACT_RANGE_ATTACK1 ]			= ACT_RANGE_ATTACK_THROW
	self.ActivityTranslateAI[ ACT_RANGE_ATTACK1_LOW ]		= ACT_MELEE_ATTACK_SWING
	self.ActivityTranslateAI[ ACT_MELEE_ATTACK1 ]			= ACT_MELEE_ATTACK_SWING
	self.ActivityTranslateAI[ ACT_MELEE_ATTACK2 ]			= ACT_MELEE_ATTACK_SWING
	self.ActivityTranslateAI[ ACT_SPECIAL_ATTACK1 ]			= ACT_RANGE_ATTACK_THROW

	self.ActivityTranslateAI[ ACT_RANGE_AIM_LOW ]			= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_COVER_LOW ]				= ACT_IDLE_ANGRY_MELEE

	self.ActivityTranslateAI[ ACT_WALK ]					= ACT_WALK
	self.ActivityTranslateAI[ ACT_WALK_RELAXED ]			= ACT_WALK
	self.ActivityTranslateAI[ ACT_WALK_STIMULATED ]			= ACT_WALK
	self.ActivityTranslateAI[ ACT_WALK_AGITATED ]			= ACT_WALK

	self.ActivityTranslateAI[ ACT_RUN_CROUCH ]				= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN_CROUCH_AIM ]			= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN ]						= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN_AIM_RELAXED ]			= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN_AIM_STIMULATED ]		= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN_AIM_AGITATED ]		= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN_AIM ]					= ACT_RUN
	self.ActivityTranslateAI[ ACT_SMALL_FLINCH ]			= ACT_RANGE_ATTACK_PISTOL
	self.ActivityTranslateAI[ ACT_BIG_FLINCH ]				= ACT_RANGE_ATTACK_PISTOL

	if ( owner:GetClass() == "npc_metropolice" ) then

	self.ActivityTranslateAI[ ACT_IDLE ]					= ACT_IDLE
	self.ActivityTranslateAI[ ACT_IDLE_ANGRY ]				= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_IDLE_RELAXED ]			= ACT_IDLE
	self.ActivityTranslateAI[ ACT_IDLE_STIMULATED ]			= ACT_IDLE
	self.ActivityTranslateAI[ ACT_IDLE_AGITATED ]			= ACT_IDLE_ANGRY_MELEE

	self.ActivityTranslateAI[ ACT_MP_RUN ]					= ACT_HL2MP_RUN_SUITCASE
	self.ActivityTranslateAI[ ACT_WALK ]					= ACT_WALK_SUITCASE
	self.ActivityTranslateAI[ ACT_MELEE_ATTACK1 ]			= ACT_MELEE_ATTACK_SWING
	self.ActivityTranslateAI[ ACT_RANGE_ATTACK1 ]			= ACT_MELEE_ATTACK_SWING
	self.ActivityTranslateAI[ ACT_SPECIAL_ATTACK1 ]			= ACT_RANGE_ATTACK_THROW
	self.ActivityTranslateAI[ ACT_SMALL_FLINCH ]			= ACT_RANGE_ATTACK_PISTOL
	self.ActivityTranslateAI[ ACT_BIG_FLINCH ]				= ACT_RANGE_ATTACK_PISTOL

	return end
end

function SWEP:NPCShoot_Primary()
	if !self:IsValid() or !self.Owner:IsValid() then return end 	
	if self.Owner:GetEnemy():GetPos():Distance(self:GetPos()) > 70 then
		self.Owner:SetSchedule( SCHED_CHASE_ENEMY )
	end
	
	if self.Owner:GetEnemy():GetPos():Distance(self:GetPos()) <= 85 then

		self.Owner:SetSchedule( SCHED_MELEE_ATTACK1 )
		
		self.Owner:SetActivity( ACT_MELEE_ATTACK1 )
		local tr = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 100,
			filter = self.Owner,
			mask = MASK_SHOT_HULL,
		} )
		if SERVER and IsValid( tr.Entity ) then
			local dmginfo = DamageInfo()
			local attacker = self.Owner
			if !IsValid( attacker ) then
				attacker = self
			end
			dmginfo:SetAttacker( attacker )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( self.Primary.Damage )
			dmginfo:SetDamageForce( self.Owner:GetForward() * self.Primary.Force )
			tr.Entity:GetPhysicsObject():ApplyForceCenter( self.Owner:GetForward() * self.Primary.Force )
			tr.Entity:TakeDamageInfo( dmginfo )
			if !tr.Hit then
				self:EmitSound( "Weapon_ez_StunStick.Swing" )
				self:SetNextPrimaryFire( CurTime() + self.Primary.DelayMiss )
				self:SetNextSecondaryFire( CurTime() + self.Primary.DelayMiss )
			else
				self:EmitSound( "Weapon_ez_StunStick.Melee_Hit" )
				self:SetNextPrimaryFire( CurTime() + self.Primary.DelayHit )
				self:SetNextSecondaryFire( CurTime() + self.Primary.DelayHit )
			end
		end
		print("Primary Attack...")
	end

end

function SWEP:PrimaryAttack()
	if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then return end
	self.Owner:LagCompensation( true )
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 56,
		filter = self.Owner,
		mask = MASK_SHOT_HULL,
	} )
	if !IsValid( tr.Entity ) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 56,
			filter = self.Owner,
			mins = Vector( -16, -16, 0 ),
			maxs = Vector( 16, 16, 0 ),
			mask = MASK_SHOT_HULL,
		} )
	end
	if SERVER and IsValid( tr.Entity ) then
		local dmginfo = DamageInfo()
		local attacker = self.Owner
		if !IsValid( attacker ) then
			attacker = self
		end
		dmginfo:SetAttacker( attacker )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( self.Primary.Damage )
		dmginfo:SetDamageForce( self.Owner:GetForward() * self.Primary.Force )
		tr.Entity:GetPhysicsObject():ApplyForceCenter( self.Owner:GetForward() * self.Primary.Force )
		tr.Entity:TakeDamageInfo( dmginfo )
	end
	if !tr.Hit then
		self:EmitSound( "Weapon_ez_StunStick.Swing" )
		self:SetNextPrimaryFire( CurTime() + self.Primary.DelayMiss )
		self:SetNextSecondaryFire( CurTime() + self.Primary.DelayMiss )
		self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	else
		self:EmitSound( "Weapon_ez_StunStick.Melee_Hit" )
		self:SetNextPrimaryFire( CurTime() + self.Primary.DelayHit )
		self:SetNextSecondaryFire( CurTime() + self.Primary.DelayHit )
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	end
	self.Owner:LagCompensation( false )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	-- self.Owner:ViewPunchReset()
	-- self.Owner:ViewPunch( Angle( math.Rand( 1, 2 ), math.Rand( -3.5, -1.5 ), 0 ) )
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:SecondaryAttack()
	-- if !( self.Charging == 0 ) then return end
	if SERVER then
		self.Owner:EmitSound( "Weapon_ez_StunStick.Charge" )
	end
	self.Charging = 1
	self.ChargingTimer = CurTime() + 1.5
	self.Idle = 0
	self.IdleTimer = CurTime() + 7
end

function SWEP:Think()
	if self.Idle == 0 and self.IdleTimer < CurTime() then
		if SERVER then
			self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
		end
		self.Idle = 1
	end
		
	if self.Charging == 1 and self.ChargingTimer > CurTime() and self.Owner:KeyDown( IN_ATTACK2 ) then
		self.Owner:LagCompensation( true )
		local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 56,
		filter = self.Owner,
		mask = MASK_SHOT_HULL,
	} )
	if !IsValid( tr.Entity ) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 56,
			filter = self.Owner,
			mins = Vector( -16, -16, 0 ),
			maxs = Vector( 16, 16, 0 ),
			mask = MASK_SHOT_HULL,
		} )
	end
	if SERVER and IsValid( tr.Entity ) then
		local dmginfo = DamageInfo()
		local attacker = self.Owner
		if !IsValid( attacker ) then
			attacker = self
		end
		dmginfo:SetAttacker( attacker )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( self.Secondary.Damage )
		dmginfo:SetDamageForce( self.Owner:GetForward() * self.Secondary.Force )
		tr.Entity:GetPhysicsObject():ApplyForceCenter( self.Owner:GetForward() * self.Primary.Force )
		tr.Entity:TakeDamageInfo( dmginfo )
	end
	if !tr.Hit then
		self:EmitSound( "Weapon_ez_StunStick.Swing" )
		self:SetNextPrimaryFire( CurTime() + self.Primary.DelayMiss )
		self:SetNextSecondaryFire( CurTime() + self.Secondary.DelayMiss )
		self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
		self.Idle = 0
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		self.Charging = 0
		self.ChargingTimer = CurTime()
	else
		self:EmitSound( "Weapon_ez_StunStick.Charged_Hit" )
		self:SetNextPrimaryFire( CurTime() + self.Primary.DelayHit )
		self:SetNextSecondaryFire( CurTime() + self.Secondary.DelayHit )
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
		self.Idle = 0
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		self.Charging = 0
		self.ChargingTimer = CurTime()
	end
	self.Owner:LagCompensation( false )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	-- self.Owner:ViewPunchReset()
	-- self.Owner:ViewPunch( Angle( math.Rand( 1, 2 ), math.Rand( -3.5, -1.5 ), 0 ) )
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	end
end
