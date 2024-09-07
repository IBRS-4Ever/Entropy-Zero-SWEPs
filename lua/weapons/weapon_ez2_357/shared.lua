SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "Entropy : Zero 2" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep..
SWEP.Spawnable				= true --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable			= true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.AdminOnly = false
SWEP.PrintName				= "357 (EZ2)"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 1			-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 20			-- Position in the slot
SWEP.ViewModel        = "models/weapons/ez2/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.Primary.Automatic			= true
SWEP.Primary.ClipSize = 6
SWEP.Primary.Delay = 0.8
SWEP.Primary.DefaultClip = 6
SWEP.Primary.Ammo = "357"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 0
SWEP.Secondary.Damage = 0
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "revolver"
SWEP.ReloadSound = ""
SWEP.NPCReloadSound = "Weapon_ez2_357.Reload"

SWEP.SelectIcon = "e"

function SWEP:PrimaryAttack()
	if !self.Owner:IsNPC() then
		if ( !self:CanPrimaryAttack() ) then return end
		if ( IsFirstTimePredicted() ) then
			self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			local bullet = {}
			bullet.Num = 1
			bullet.Src = self.Owner:GetShootPos()
			bullet.Dir = (self.Owner:EyeAngles()+self.Owner:GetViewPunchAngles()):Forward() 
			bullet.Spread = Vector( 0, 0, 0 )
			bullet.Force = 15
			bullet.Damage = GetConVar( "ez2_swep_357_plr_dmg" ):GetInt()
			bullet.TracerName = "Tracer"
			bullet.Callback	= function(a,b,c)
				self:BulletPenetrate(a,b,c)
			end
			self.Owner:FireBullets( bullet )
			
			if GetConVar( "ez_swep_no_recoil" ):GetInt() == 0 then
				self.Owner:ViewPunch(Angle( -8, math.Rand( -2, 2 ),0))
					
				-- 获取玩家准星的位置
				local punch = Angle(math.Rand(-1,1), math.Rand(-1,1), 0)
				local eyeang = self.Owner:EyeAngles() + punch

				-- 应用准星移动和视角效果
				self.Owner:SetEyeAngles(eyeang)
			end
		
			self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
			if GetConVar( "ez_swep_infinite_ammo" ):GetInt() == 0 then
				self:TakePrimaryAmmo( 1 )
			else
				self:TakePrimaryAmmo( 0 )
			end
				
			self:EmitSound("Weapon_ez2_357.Single")
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
		bullet.Spread = Vector( 0, 0, 0 )
		bullet.Force = 15
		bullet.Damage = GetConVar( "ez2_swep_357_npc_dmg" ):GetInt()
		bullet.TracerName = "Tracer"
		bullet.Callback	= function(a,b,c)
			self:BulletPenetrate(a,b,c)
		end
		self.Owner:FireBullets( bullet )
		
		self:EmitSound("Weapon_ez2_357.Single")
		self:TakePrimaryAmmo( 1 )
		self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	end
end

function SWEP:SecondaryAttack()

end

function SWEP:GetNPCRestTimes()
    return 0.75, 0.75
end

function SWEP:GetNPCBurstSettings()
    -- return 6, 12, 0.1
end

function SWEP:GetNPCBulletSpread( proficiency )
    return 4
end

list.Add( "NPCUsableWeapons", { class = "weapon_ez2_357", title = "357 (EZ2)" } )

if ( SERVER ) then return end
killicon.AddAlias( "weapon_ez2_357", "weapon_357" )
