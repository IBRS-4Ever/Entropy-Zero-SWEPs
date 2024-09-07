SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "Entropy : Zero 2" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep..
SWEP.Spawnable				= true --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable			= true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.AdminOnly = false
SWEP.PrintName				= "Pistol (EZ2)"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 1			-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 20			-- Position in the slot
SWEP.UseHands = true
SWEP.ViewModel        = "models/weapons/ez2/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.Automatic			= false
SWEP.Primary.ClipSize = 18
SWEP.Primary.Delay = 0.1
SWEP.Primary.DefaultClip = 24
SWEP.Primary.Ammo = "pistol"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 0
SWEP.Secondary.Damage = 0
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "pistol"
SWEP.ReloadSound = "Weapon_EZ2_Pistol_Madcop.Reload"
SWEP.NPCReloadSound = "Weapon_EZ2_Pistol_Madcop.Reload"

SWEP.SelectIcon = "d"

function SWEP:PrimaryAttack()
	if !self.Owner:IsNPC() then
		if ( !self:CanPrimaryAttack() ) then return end
		if ( IsFirstTimePredicted() ) then
			self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			local bullet = {}
			bullet.Num = 1
			bullet.Src = self.Owner:GetShootPos()
			bullet.Dir = (self.Owner:EyeAngles()+self.Owner:GetViewPunchAngles()):Forward() 
			if GetConVar( "ez_swep_no_bullet_spread" ):GetInt() == 0 then
				bullet.Spread = Vector( 0.025, 0.025, 0 )
			else
				bullet.Spread = Vector( 0, 0, 0 )
			end
			bullet.Force = 5
			bullet.Damage = GetConVar( "ez2_swep_pistol_plr_dmg" ):GetInt()
			bullet.TracerName = "Tracer"
			bullet.Callback	= function(a,b,c)
				self:BulletPenetrate(a,b,c)
			end
			self.Owner:FireBullets( bullet )
				
			if GetConVar( "ez_swep_no_recoil" ):GetInt() == 0 then
				self.Owner:ViewPunch(Angle( -0.5, math.Rand( -0.5, 0.5 ),0))
			end
			
			self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
				
			if GetConVar( "ez_swep_infinite_ammo" ):GetInt() == 0 then
				self:TakePrimaryAmmo( 1 )
			else
				self:TakePrimaryAmmo( 0 )
			end
			self:EmitSound("Weapon_EZ2_Pistol_Madcop.Single")
			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
			self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
		end
		self.Idle = 0
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	else
		if ( !self:NPCCanPrimaryAttack() ) then return end
		local bullet = {}
		bullet.Num = 1
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector( 0.025, 0.025, 0 )
		bullet.Force = 5
		bullet.Damage = GetConVar( "ez2_swep_pistol_npc_dmg" ):GetInt()
		bullet.TracerName = "Tracer"
		bullet.Callback	= function(a,b,c)
			self:BulletPenetrate(a,b,c)
		end
		self.Owner:FireBullets( bullet )
		
		self:EmitSound("Weapon_EZ2_Pistol_Madcop.Single")
		self:TakePrimaryAmmo( 1 )
		self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	end
end

function SWEP:SecondaryAttack()

end

function SWEP:GetNPCRestTimes()
    return 0.4, 0.8
end

function SWEP:GetNPCBurstSettings()
    -- return 6, 12, 0.1
end

function SWEP:GetNPCBulletSpread( proficiency )
    return 4
end

list.Add( "NPCUsableWeapons", { class = "weapon_ez2_pistol", title = "Pistol (EZ2)" } )

if ( SERVER ) then return end
killicon.AddAlias( "weapon_ez2_pistol", "weapon_pistol" )
