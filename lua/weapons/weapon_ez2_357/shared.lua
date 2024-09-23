SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "#EZ_Sweps.Category_EZ2"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.AdminOnly = false
SWEP.PrintName				= "#ez2_swep.357"
SWEP.Slot				= 1
SWEP.SlotPos				= 20
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

SWEP.CrosshairX		= 0.5
SWEP.CrosshairY		= 0.0

SWEP.SelectIcon = "d"

function SWEP:ApplyViewKick()
	local owner = self:GetOwner()
	if (IsFirstTimePredicted() and CLIENT) or (game.SinglePlayer() and SERVER) then
		local angs = owner:EyeAngles()

		angs = angs + Angle(util.SharedRandom(self:GetClass(), -1, 1),
							util.SharedRandom(self:GetClass(), -1, 1),
							0)

		owner:SetEyeAngles(angs)
	end

	local punch = Angle()
	punch.x = -8
	punch.y = util.SharedRandom(self:GetClass(), -2, 2, 0)

	owner:ViewPunch( punch )
end

function SWEP:NPCShoot_Primary( shootPos, shootDir )
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

function SWEP:PrimaryAttack()
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
			
		if !GetConVar( "ez_swep_no_recoil" ):GetBool() then
			self:ApplyViewKick()
		end
		
		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		
		if GetConVar( "ez_swep_infinite_ammo" ):GetBool() then
			self:TakePrimaryAmmo( 0 )
		else
			self:TakePrimaryAmmo( 1 )
		end
				
		self:EmitSound("Weapon_ez2_357.Single")
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	end
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:SecondaryAttack()

end

function SWEP:GetNPCRestTimes()
    return 0.75, 0.75
end

function SWEP:GetNPCBurstSettings()
    -- return 6, 12, 0.1
end

list.Add( "NPCUsableWeapons", { class = "weapon_ez2_357", title = "357 (EZ2)" } )

if ( SERVER ) then return end
killicon.AddFont( "weapon_ez2_357", "EZ2HUD_Kill_ICON", SWEP.SelectIcon, Color( 255, 80, 0, 255 ) )
