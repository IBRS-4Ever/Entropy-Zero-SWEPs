SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "Entropy : Zero 2" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep..
SWEP.Spawnable				= true --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable			= true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.AdminOnly = false
SWEP.PrintName				= "MP5K (EZ2)"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 2		-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 20			-- Position in the slot
SWEP.UseHands = true
SWEP.ViewModel        = "models/weapons/ez2/c_mp5k.mdl"
SWEP.WorldModel = "models/weapons/w_mp5k.mdl"
SWEP.FiresUnderwater = false

SWEP.Primary.Automatic			= true
SWEP.Primary.ClipSize = 30
SWEP.Primary.Delay = 0.10 
SWEP.Primary.DefaultClip = 200
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Sound = Sound ( "Weapon_ez2_MP5K.Single" )

SWEP.Secondary.ClipSize = 3
SWEP.Secondary.Delay = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "smg"
SWEP.ReloadSound = ""
SWEP.NPCReloadSound = Sound ( "Weapon_ez2_MP5K.Reload" )

SWEP.SelectIcon = "f"

function SWEP:PrimaryAttack()
 	
	if !self.Owner:IsNPC() then
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
			bullet.Damage = GetConVar("ez2_swep_mp5k_plr_dmg"):GetInt()
			self.Owner:FireBullets( bullet )
				
			self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			if GetConVar( "ez_swep_infinite_ammo" ):GetInt() == 0 then
				self:TakePrimaryAmmo( 1 )
			else
				self:TakePrimaryAmmo( 0 )
			end
			self:EmitSound(self.Primary.Sound)
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
		bullet.Spread = Vector( 0.03, 0.03, 0 )
		bullet.Force = 5
		bullet.Damage = GetConVar("ez2_swep_mp5k_npc_dmg"):GetInt()
		bullet.AmmoType = self.Primary.Ammo
		self.Owner:FireBullets( bullet )
		
		self:EmitSound(self.Primary.Sound)
		self:TakePrimaryAmmo( 1 )
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	end
end

function SWEP:SecondaryAttack()

end

function SWEP:GetNPCRestTimes()
    return 0.4, 0.6
end

function SWEP:GetNPCBurstSettings()
    return 6, 12, 0.1
end

function SWEP:GetNPCBulletSpread( proficiency )
    return 1
end

list.Add( "NPCUsableWeapons", { class = "weapon_ez2_mp5k", title = "MP5K (EZ2)" } )

if ( SERVER ) then return end
killicon.AddFont( "weapon_ez2_mp5k", "WeaponIcons", "f", Color( 255, 80, 0, 255 ) )