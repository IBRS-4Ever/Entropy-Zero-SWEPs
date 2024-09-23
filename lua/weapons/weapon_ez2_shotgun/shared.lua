SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "#EZ_Sweps.Category_EZ2"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.AdminOnly = false
SWEP.PrintName				= "#ez2_swep.shotgun"
SWEP.Slot				= 3
SWEP.SlotPos				= 20
SWEP.ViewModel        = "models/weapons/ez2/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"

SWEP.Primary.Automatic			= true
SWEP.Primary.ClipSize = 6
SWEP.Primary.Delay = 0.8
SWEP.Primary.DefaultClip = 18
SWEP.Primary.Ammo = "buckshot"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 1.4
SWEP.Secondary.Damage = 0
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "shotgun"
SWEP.ReloadSound = ""
SWEP.NPCReloadSound = "Weapon_Shotgun.Reload"

SWEP.CrosshairX		= 0
SWEP.CrosshairY		= 0.5

SWEP.SelectIcon = "h"

SWEP.ReloadStart = 0
SWEP.ReloadStartTimer = CurTime()
SWEP.Reloading = 0
SWEP.ReloadTimer = CurTime()
SWEP.ReloadEnd = 0
SWEP.ReloadEndTimer = CurTime()

function SWEP:Reload()
	if !self.Owner:IsNPC() then
		if self:Clip1() == self.Primary.ClipSize and self.NextFirstDrawTimer < CurTime() and self.FirstDrawing == 0 and GetConVar( "ez_swep_firstdraw_by_reload" ):GetInt() == 1 then
			self:PlayAnim( self.FirstDrawAnimation )
			self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		end
		if self.Weapon:DefaultReload(ACT_VM_RELOAD) then
			self:EmitSound( self.ReloadSound )
		end
		self.Idle = 0
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	
	else
		self.Owner:SetSchedule(SCHED_RELOAD)
		self:EmitSound( self.NPCReloadSound ) 
	end
end

function SWEP:NPCShoot_Primary( shootPos, shootDir )
	if !(IsValid(self.Owner)) then return end
	if ( !self:NPCCanPrimaryAttack() ) then return end
	if self:Clip1() >= 2 && IsValid(self.Owner:GetEnemy()) && self.Owner:GetEnemy():GetPos():Distance(self.Owner:GetPos()) <= 250 then
		self:NPCShoot_Secondary()
	else
		local bullet = {}
		bullet.Num = GetConVar( "ez2_swep_shotgun_npc_num" ):GetInt()
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector( 0.05, 0.05, 0 )
		bullet.Force = 5
		bullet.Damage = GetConVar("ez2_swep_shotgun_npc_dmg"):GetInt()
		bullet.TracerName = "Tracer"
		bullet.Callback	= function(a,b,c)
			self:BulletPenetrate(a,b,c)
		end
		self.Owner:FireBullets( bullet )
				
		self:EmitSound("Weapon_shotgun.Single")
		self:TakePrimaryAmmo( 1 )
	end
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
end

function SWEP:NPCShoot_Secondary( shootPos, shootDir )
	local bullet = {}
	bullet.Num = GetConVar( "ez2_swep_shotgun_npc_num" ):GetInt() * 2
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector( 0.05, 0.05, 0 )
	bullet.Force = 5
	bullet.Damage = GetConVar("ez2_swep_shotgun_npc_dmg"):GetInt()
	bullet.TracerName = "Tracer"
	bullet.Callback	= function(a,b,c)
		self:BulletPenetrate(a,b,c)
	end
	self.Owner:FireBullets( bullet )
		
	self:EmitSound("Weapon_shotgun.Double")
	self:TakePrimaryAmmo( 2 )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	if ( IsFirstTimePredicted() ) then
	self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		local bullet = {}
		bullet.Num = GetConVar( "ez2_swep_shotgun_plr_num" ):GetInt()
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = (self.Owner:EyeAngles()+self.Owner:GetViewPunchAngles()):Forward() 
		bullet.Spread = Vector( 0.05, 0.05, 0 )
		bullet.Force = 5
		bullet.Damage = GetConVar( "ez2_swep_shotgun_plr_dmg" ):GetInt()
		bullet.TracerName = "Tracer"
		bullet.Callback	= function(a,b,c)
			self:BulletPenetrate(a,b,c)
		end
		self.Owner:FireBullets( bullet )
			
		if !GetConVar( "ez_swep_no_recoil" ):GetBool() then
			self.Owner:ViewPunch( Angle( -4, math.Rand( -2, 2 ),0) )
		end
		
		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
		if GetConVar( "ez_swep_infinite_ammo" ):GetBool() then
			self:TakePrimaryAmmo( 0 )
		else
			self:TakePrimaryAmmo( 1 )
		end
				
		self:EmitSound("Weapon_shotgun.Single")
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	end
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:SecondaryAttack()
	if self:Clip1() >= 2 then
		if ( IsFirstTimePredicted() ) then
			self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			local bullet = {}
			bullet.Num = GetConVar( "ez2_swep_shotgun_plr_num" ):GetInt() * 2
			bullet.Src = self.Owner:GetShootPos()
			bullet.Dir = (self.Owner:EyeAngles()+self.Owner:GetViewPunchAngles()):Forward() 
			bullet.Spread = Vector( 0.05, 0.05, 0 )
			bullet.Force = 5
			bullet.Damage = GetConVar( "ez2_swep_shotgun_plr_dmg" ):GetInt()
			bullet.TracerName = "Tracer"
			self.Owner:FireBullets( bullet )
				
			if !GetConVar( "ez_swep_no_recoil" ):GetBool() then
				self.Owner:ViewPunch(Angle( -4, math.Rand( -2, 2 ),0))
			end
			
			self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
				
			if GetConVar( "ez_swep_infinite_ammo" ):GetBool() then
				self:TakePrimaryAmmo( 0 )
			else
				self:TakePrimaryAmmo( 2 )
			end
					
			self:EmitSound("Weapon_shotgun.Single")
			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
			self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
		end
		self.Idle = 0
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	else
		self:PrimaryAttack()
	end
end

function SWEP:GetNPCRestTimes()
    return 0.8, 1.2
end

function SWEP:GetNPCBurstSettings()
    return 6, 12, 1.4
end

list.Add( "NPCUsableWeapons", { class = "weapon_ez2_shotgun", title = "Shotgun (EZ2)" } )

if ( SERVER ) then return end
killicon.AddFont( "weapon_ez2_shotgun", "EZ2HUD_Kill_ICON", SWEP.SelectIcon, Color( 255, 80, 0, 255 ) )
