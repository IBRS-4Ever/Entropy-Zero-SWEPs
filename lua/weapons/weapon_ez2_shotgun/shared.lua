AddCSLuaFile()
DEFINE_BASECLASS("weapon_ez2_base")

SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "#EZ_Sweps.Category_EZ2"
SWEP.Spawnable				= true
SWEP.PrintName				= "#ez2_swep.shotgun"
SWEP.Slot				= 3
SWEP.SlotPos				= 20
SWEP.ViewModel        = "models/weapons/ez2/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"

if CLIENT then
	SWEP.WepSelectIcon	= surface.GetTextureID("selector/weapon_ez2_shotgun.vmt")
end

SWEP.Primary.ClipSize = 6
SWEP.Primary.Delay = 0.6
SWEP.Primary.DefaultClip = 18
SWEP.Primary.Ammo = "buckshot"

SWEP.Secondary.Delay = 1

SWEP.HoldType = "shotgun"
SWEP.ReloadSound = "Weapon_ez2_Shotgun.Reload"
SWEP.NPCReloadSound = "Weapon_Shotgun.Reload"

SWEP.CrosshairY		= 0.5

SWEP.SelectIcon = "h"

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	self:NetworkVar( "Bool", "NeedPump" )
	self:NetworkVar( "Bool", "InterruptReload" )

	if SERVER then
		self:SetNeedPump(false)
	end
end

function SWEP:BeginReload()
	if self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()) <= 0 then return end -- no shells ?

	self:PlayActivity(ACT_SHOTGUN_RELOAD_START, true)
	self:GetOwner():SetAnimation( PLAYER_RELOAD )
	self:SetIsReloading(true)
	self:SetInterruptReload(false)
end

function SWEP:LoadShell()
	local owner = self:GetOwner()
	if self:Clip1() == self:GetMaxClip1() or owner:GetAmmoCount(self:GetPrimaryAmmoType()) <= 0 then return end -- no shells ?

	self:SetClip1(self:Clip1() + 1)
	owner:RemoveAmmo(1, self:GetPrimaryAmmoType())
end

function SWEP:ReloadCycle()
	self:PlayActivity(ACT_VM_RELOAD, true)
	self:EmitSound(self.ReloadSound)
	if IsFirstTimePredicted() then self:LoadShell() end
end

function SWEP:FinishReload()
	self:PlayActivity(ACT_SHOTGUN_RELOAD_FINISH, true)
	self:SetIsReloading(false)
end

function SWEP:Pump()
	self:PlayActivity(ACT_SHOTGUN_PUMP, true)
	self:EmitSound("Weapon_ez2_Shotgun.Special1")
	self:SetNeedPump(false)
end

function SWEP:ShouldInterrupt()
	local owner = self:GetOwner()
	return owner:KeyDown(IN_ATTACK) or owner:KeyDown(IN_ATTACK2)
end

function SWEP:Think()
	if game.SinglePlayer() and CLIENT then self.ViewModelFOV = GetConVar("ez_swep_fov"):GetInt() return end
	local owner = self:GetOwner()

	if not self:GetIsReloading() and self:Clip1() == 0 and self:CanReload() then
		self:Reload()
	end

	if self:GetNextIdleTime() <= CurTime() then
		if self:GetIsReloading() then
			-- if the player is holding down the trigger, let them interrupt
			if self:GetInterruptReload() then
				if self:ShouldInterrupt() then
					self:SetIsReloading(false)
					self:SetNextPrimaryFire(CurTime())
					self:SetNextSecondaryFire(CurTime())
				else
					self:FinishReload()
				end
				return
			end

			if self:Clip1() < self:GetMaxClip1() and owner:GetAmmoCount(self:GetPrimaryAmmoType()) > 0 then
				self:ReloadCycle()
			else
				self:FinishReload()
			end
		else
			self:PlayActivity(ACT_VM_IDLE)

			if self:GetNeedPump() and not self:GetIsReloading() then
				self:Pump()
				return
			end
		end
	end

	if self:GetIsReloading() and self:ShouldInterrupt() and self:Clip1() > 0 then
		self:SetInterruptReload(true)
	end
end

function SWEP:NPCShoot_Primary( shootPos, shootDir )
	if !(IsValid(self.Owner)) then return end
	if ( !self:NPCCanPrimaryAttack() ) then return end
	if self:Clip1() >= 2 && IsValid(self.Owner:GetEnemy()) && self.Owner:GetEnemy():GetPos():Distance(self.Owner:GetPos()) <= 250 then
		self:NPCShoot_Secondary()
	else
		self:ShootBullet(Vector( 0.1, 0.1, 0.1 ), GetConVar( "ez2_swep_shotgun_npc_dmg" ):GetInt(), GetConVar( "ez2_swep_shotgun_npc_num" ):GetInt()*2)
				
		self:EmitSound("Weapon_ez2_Shotgun.NPC_Single")
		self:TakePrimaryAmmo( 1 )
	end
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
end

function SWEP:NPCShoot_Secondary( shootPos, shootDir )
	self:ShootBullet(Vector( 0.1, 0.1, 0.1 ), GetConVar( "ez2_swep_shotgun_npc_dmg" ):GetInt(), GetConVar( "ez2_swep_shotgun_npc_num" ):GetInt()*2)
	self:EmitSound("Weapon_ez2_Shotgun.Double")
	self:TakePrimaryAmmo( 2 )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
end

function SWEP:PrimaryAttack()
	if self:GetNeedPump() or self:GetIsReloading() then return end
	if !self:TakePrimaryAmmo(1) then return end
	local owner = self:GetOwner()
	self.SetInterruptReload(true)

	self:EmitSound("Weapon_ez2_Shotgun.Single")

	owner:SetAnimation( PLAYER_ATTACK1 )
	self:SetIsReloading(false)
	self:SetNeedPump(true)
	self:ApplyViewKick(Angle( -4, math.Rand( -2, 2 ),0))
	self:PlayActivity( ACT_VM_PRIMARYATTACK, true )

	if SERVER then
		sound.EmitHint(SOUND_COMBAT, self:GetPos(), 1500, 0.2, owner)
	end
	owner:MuzzleFlash()

	self:ShootBullet(Vector( 0.05, 0.05, 0.05 ), GetConVar( "ez2_swep_shotgun_plr_dmg" ):GetInt(), GetConVar( "ez2_swep_shotgun_plr_num" ):GetInt())

	self:SetNextPrimaryFire(CurTime() + 100.0)
	self:SetNextSecondaryFire(CurTime() + 100.0)
end

function SWEP:SecondaryAttack()
	if self:GetNeedPump() or self:GetIsReloading() then return end
	if !self:TakePrimaryAmmo(2) then return self:PrimaryAttack() end
	local owner = self:GetOwner()
	self.SetInterruptReload(true)

	self:EmitSound("Weapon_ez2_Shotgun.Double")

	owner:SetAnimation( PLAYER_ATTACK1 )
	self:SetIsReloading(false)
	self:SetNeedPump(true)
	self:PlayActivity( ACT_VM_PRIMARYATTACK, true )
	self:ApplyViewKick(Angle( -4, math.Rand( -2, 2 ),0))

	if SERVER then
		sound.EmitHint(SOUND_COMBAT, self:GetPos(), 1500, 0.2, owner)
	end
	owner:MuzzleFlash()

	self:ShootBullet(Vector( 0.05, 0.05, 0.05 ), GetConVar( "ez2_swep_shotgun_plr_dmg" ):GetInt(), GetConVar( "ez2_swep_shotgun_plr_num" ):GetInt() * 2)

	self:SetShotsFired( self:GetShotsFired() + 1 )
	self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	self:SetLastShootTime()	
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
