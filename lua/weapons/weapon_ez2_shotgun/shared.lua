SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "Entropy : Zero 2" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep..
SWEP.Spawnable				= true --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable			= true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.AdminOnly = false
SWEP.PrintName				= "Shotgun (EZ2)"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 3		-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 20			-- Position in the slot
SWEP.UseHands = true
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

SWEP.SelectIcon = "b"

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

function SWEP:PrimaryAttack()
	if !self.Owner:IsNPC() then
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
			self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
		end
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	else
		if ( !self:NPCCanPrimaryAttack() ) then return end
		local bullet = {}
		bullet.Num = GetConVar( "ez2_swep_shotgun_npc_num" ):GetInt()
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector( 0.05, 0.05, 0 )
		bullet.Force = 5
		bullet.Damage = GetConVar("ez2_swep_shotgun_npc_dmg"):GetInt()
		bullet.TracerName = "Tracer"
		self.Owner:FireBullets( bullet )
		
		self:EmitSound("Weapon_shotgun.Single")
		self:TakePrimaryAmmo( 1 )
		self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	end
end

function SWEP:SecondaryAttack()
	if self:Clip1() >= 2 then
		if !self.Owner:IsNPC() then
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
				
					if GetConVar( "ez_swep_no_recoil" ):GetInt() == 0 then
						self.Owner:ViewPunch(Angle( -4, math.Rand( -2, 2 ),0))
					end
			
				self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
				self.Owner:SetAnimation( PLAYER_ATTACK1 )
				
					if GetConVar( "ez_swep_infinite_ammo" ):GetInt() == 0 then
						self:TakePrimaryAmmo( 2 )
					else
						self:TakePrimaryAmmo( 0 )
					end
					
				self:EmitSound("Weapon_shotgun.Single")
				self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
				self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
			end
		self.Idle = 0
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		else
			local bullet = {}
			bullet.Num = GetConVar( "ez2_swep_shotgun_npc_num" ):GetInt() * 2
			bullet.Src = self.Owner:GetShootPos()
			bullet.Dir = self.Owner:GetAimVector()
			bullet.Spread = Vector( 0.05, 0.05, 0 )
			bullet.Force = 5
			bullet.Damage = GetConVar("ez2_swep_shotgun_npc_dmg"):GetInt()
			bullet.TracerName = "Tracer"
			self.Owner:FireBullets( bullet )
			
			self:EmitSound("Weapon_shotgun.Single")
			self:TakePrimaryAmmo( 2 )
			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
				self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
		end
	else
		self:PrimaryAttack()
	end
end

function SWEP:GetNPCRestTimes()
    return 0.8, 1.2
end

function SWEP:GetNPCBurstSettings()
    -- return 6, 12, 0.1
end

function SWEP:GetNPCBulletSpread( proficiency )
    return 1
end

list.Add( "NPCUsableWeapons", { class = "weapon_ez2_shotgun", title = "Shotgun (EZ2)" } )

if ( SERVER ) then return end
killicon.AddAlias( "weapon_ez2_shotgun_madcop", "weapon_shotgun" )
