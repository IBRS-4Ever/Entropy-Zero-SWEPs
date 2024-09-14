SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "Entropy : Zero 2" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep..
SWEP.Spawnable				= true --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable			= true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.AdminOnly = false
SWEP.PrintName				= "SMG (EZ2)"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 2		-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 20			-- Position in the slot
SWEP.UseHands = false
SWEP.ViewModel        = "models/weapons/ez2/v_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.FiresUnderwater = false

SWEP.Primary.Automatic			= true
SWEP.Primary.ClipSize = 45
SWEP.Primary.Delay = 0.1
SWEP.Primary.DefaultClip = 225
SWEP.Primary.Ammo = "SMG1"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "SMG1_Grenade"

SWEP.HoldType = "smg"
SWEP.ReloadSound = ""
SWEP.NPCReloadSound = "Weapon_smg1.Reload"

SWEP.SelectIcon = "a"

function SWEP:NPCShoot_Primary( shootPos, shootDir )
	if ( !self:NPCCanPrimaryAttack() ) then return end
	local bullet = {}
	bullet.Num = 1
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector( 0.03, 0.03, 0 )
	bullet.Force = 5
	bullet.Damage = GetConVar("ez2_swep_smg1_npc_dmg"):GetInt()
	bullet.AmmoType = self.Primary.Ammo
	bullet.Callback	= function(a,b,c)
		self:BulletPenetrate(a,b,c)
	end
	self.Owner:FireBullets( bullet )
		
	self:EmitSound( "Weapon_smg1.Single" )
	self:TakePrimaryAmmo( 1 )
	
	if !self.Owner:GetEnemy() then return end
	if self.Owner:GetClass() == "npc_combine_s" && CurTime() > self:GetNextSecondaryFire() && self.Owner:GetEnemy():GetPos():Distance(self.Owner:GetPos()) >= 250 && self.Owner:GetEnemy():GetPos():Distance(self.Owner:GetPos()) <= 1300 then
		if math.random(1, 10) == 1 then
			if SERVER then
				if self.Owner:GetGroundSpeedVelocity()==Vector(0,0,0) then
					timer.Simple(0.5, function()
						self.Owner:SetSaveValue( "m_fIsElite", true )
						self.Owner:SetSaveValue("m_hForcedGrenadeTarget", self.Owner:GetEnemy())
					end)
				end
			end
		end
	end
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
end

function SWEP:NPCShoot_Secondary( shootPos, shootDir )
	timer.Simple(0.6,function()
		if IsValid(self) and IsValid(self.Owner) then
			local grenade = ents.Create( "grenade_ar2" )
			grenade:SetAngles( self.Owner:GetAngles() )
			grenade:SetVelocity( (self.Owner:GetEnemy():GetPos()-self.Owner:GetPos()):Length() * 1.5 * self.Owner:GetAimVector() + self.Owner:GetEnemy():GetUp() * 50 )
			grenade:SetPos(self.Owner:GetShootPos() + self.Owner:GetUp()*-8.9 + self.Owner:GetForward()*8 + self.Owner:GetAimVector() * 10)
			grenade:Spawn()
			grenade:SetOwner(self.Owner)
			grenade:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
			self:EmitSound("Weapon_SMG1.Double")
			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
			self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
		end
	end)
end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	if ( IsFirstTimePredicted() ) then
		self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		local bullet = {}
		bullet.Num = 1
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = (self.Owner:EyeAngles()+self.Owner:GetViewPunchAngles()):Forward() 
			
		if GetConVar( "ez_swep_no_recoil" ):GetInt() == 0 then
			self.Owner:ViewPunch(Angle( -0.5, math.Rand( -0.05, 0.05 ),0))
		end
				
		if GetConVar( "ez_swep_no_bullet_spread" ):GetInt() == 0 then
			bullet.Spread = Vector( 0.03, 0.03, 0 )
		else
			bullet.Spread = Vector( 0, 0, 0 )
		end
		bullet.Force = 5
		bullet.Damage = GetConVar("ez2_swep_smg1_plr_dmg"):GetInt()
		bullet.Callback	= function(a,b,c)
			self:BulletPenetrate(a,b,c)
		end
		self.Owner:FireBullets( bullet )
			
		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		if GetConVar( "ez_swep_infinite_ammo" ):GetBool() then
			self:TakePrimaryAmmo( 0 )
		else
			self:TakePrimaryAmmo( 1 )
		end
		self:EmitSound( "Weapon_smg1.Single" )
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	end
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:SecondaryAttack()
	if self.Owner:GetAmmoCount( self.Secondary.Ammo ) > 0 or GetConVar( "ez_swep_infinite_ammo" ):GetInt() == 1 then
		self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		if SERVER then
			local grenade = ents.Create( "grenade_ar2" )
			grenade:SetOwner(self.Owner)
			grenade:SetAngles( self.Owner:EyeAngles() )
			grenade:SetPos( self.Owner:GetShootPos() + self.Owner:GetAimVector()*5 + self.Owner:EyeAngles():Right()*5 + Vector(0,0,-3) )
			grenade:Spawn()
			grenade:Activate()
			grenade:SetVelocity(self.Owner:GetAimVector()*1000 + Vector(0,0,80))
			grenade:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
							
			if GetConVar( "ez_swep_infinite_ammo" ):GetInt() == 0 then
				self:TakeSecondaryAmmo( 1 )
			else
				self:TakeSecondaryAmmo( 0 )
			end
			self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			self:EmitSound("Weapon_SMG1.Double")
		end
		
		self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
		self.Idle = 0
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	else 
		self:EmitSound("Weapon_smg1.Empty")
		self:SetNextPrimaryFire( CurTime() + 0.25 )
		self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
		self.Idle = 0
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	end
end

function SWEP:GetNPCRestTimes()
    return 0.1, 0.2
end

function SWEP:GetNPCBurstSettings()
    return 6, 12, 0.1
end

function SWEP:GetNPCBulletSpread( proficiency )
    return 4
end

list.Add( "NPCUsableWeapons", { class = "weapon_ez2_smg1", title = "SMG (EZ2)" } )

if ( SERVER ) then return end
killicon.AddAlias( "weapon_ez2_smg1", "weapon_smg1" )