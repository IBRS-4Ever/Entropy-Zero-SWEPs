AddCSLuaFile()
DEFINE_BASECLASS("weapon_ez2_base")

SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "#EZ_Sweps.Category_EZ2"
SWEP.Spawnable				= true
SWEP.PrintName				= "#ez2_swep.ar2"
SWEP.Slot				= 2
SWEP.SlotPos				= 20
SWEP.ViewModel        = "models/weapons/ez2/c_ar2.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"

if CLIENT then
	SWEP.WepSelectIcon	= surface.GetTextureID("selector/weapon_ez2_ar2.vmt")
end

SWEP.Primary.ClipSize = 30
SWEP.Primary.Delay = 0.1
SWEP.Primary.DefaultClip = 180
SWEP.Primary.Ammo = "ar2"
SWEP.PrimarySound = "Weapon_EZ2_AR2.Single"

SWEP.Secondary.Delay = 1.95
SWEP.Secondary.Damage = 125
SWEP.Secondary.Ammo = "AR2AltFire"

SWEP.HoldType = "ar2"
SWEP.ReloadSound = ""
SWEP.NPCReloadSound = "Weapon_AR2.Reload"

SWEP.CrosshairY		= 0.25

SWEP.SelectIcon = "g"

SWEP.TracerName = "AR2Tracer"

function SWEP:Holster( wep )
	timer.Remove( "AR2AltFire"..self.Owner:EntIndex() )
	-- self:PlayActivity(ACT_VM_HOLSTER, true, 0.8)
	return true
end

function SWEP:NPCShoot_Primary( shootPos, shootDir )
	if !(IsValid(self.Owner)) then return end
	if ( !self:NPCCanPrimaryAttack() ) then return end
	local bullet = {}
	bullet.Num = 1
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector( 0.015, 0.015, 0 )
	bullet.Force = 5
	bullet.Damage = GetConVar("ez2_swep_ar2_npc_dmg"):GetInt()
	bullet.TracerName = self.TracerName
	bullet.Callback	= function(a,b,c)
		self:BulletPenetrate(a,b,c)
	end
	self.Owner:FireBullets( bullet )
	
	self:EmitSound("Weapon_EZ2_AR2.Single")
	self:TakePrimaryAmmo( 1 )
	
	if self.Owner:GetClass() == "npc_combine_s" && CurTime() > self:GetNextSecondaryFire() then
		if math.random(1, 10) == 1 then
			if SERVER then
				if self.Owner:GetGroundSpeedVelocity()==Vector(0,0,0) then
					timer.Simple(0.5, function()
						if IsValid(self) and IsValid(self.Owner) then
							self.Owner:SetSaveValue( "m_fIsElite", true )
							self.Owner:SetSaveValue("m_hForcedGrenadeTarget", self.Owner:GetEnemy())
						end
					end)
				end
			end
		end
	end
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
end

function SWEP:NPCShoot_Secondary( shootPos, shootDir )
	timer.Create( "NPC_AR2AltFire"..self.Owner:EntIndex(), 0.6, 1, function()
		self:LaunchEnergyBall( 1500, 10, GetConVar("ez2_swep_proto_ar2_ball_explode_time"):GetInt() )
		timer.Remove( "NPC_AR2AltFire"..self.Owner:EntIndex() )
	end)
end

function SWEP:PrimaryAttack() 
	if !self:TakePrimaryAmmo(1) then return end
	local owner = self:GetOwner()

	self:EmitSound("Weapon_EZ2_AR2.Single")

	owner:SetAnimation( PLAYER_ATTACK1 )
	self:PlayActivity( self:GetPrimaryAttackActivity() )
	self:ApplyViewKick()

	if SERVER then
		sound.EmitHint(SOUND_COMBAT, self:GetPos(), 1500, 0.2, owner)
	end
	owner:MuzzleFlash()

	self:ShootBullet(Vector( 0.015, 0.015, 0.015 ), GetConVar( "ez2_swep_ar2_plr_dmg" ):GetInt(), 1)

	self:SetShotsFired( self:GetShotsFired() + 1 )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self:SetLastShootTime()
end

function SWEP:ApplyViewKick()
	if GetConVar( "ez_swep_no_recoil" ):GetBool() then return end
	self:DoMachineGunKick(1, self:GetFireDuration(), 2)
end

function SWEP:SecondaryAttack()
	if ( IsFirstTimePredicted() ) then
		if self.Owner:GetAmmoCount( self.Secondary.Ammo ) > 0 or GetConVar( "ez_swep_infinite_ammo" ):GetInt() == 1 then
			self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			self:EmitSound("Weapon_CombineGuard.Special1")
			self:SendWeaponAnim( ACT_VM_FIDGET, true )
			timer.Create( "AR2AltFire"..self.Owner:EntIndex(), 0.6, 1, function()
				self:LaunchEnergyBall( 1500, 10, GetConVar("ez2_swep_ar2_ball_explode_time"):GetInt() )
				self:ApplyViewPunch( Angle(-10,0,0) )
				self:TakeSecondaryAmmo(1)
				timer.Remove( "AR2AltFire"..self.Owner:EntIndex() )
			end)
			self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
			self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
			
		else 
			self:EmitSound("Weapon_IRifle.Empty")
			self:SetNextPrimaryFire( CurTime() + 0.25 )
			self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
		end
	end
end

function SWEP:DoImpactEffect( tr, nDamageType )
	if ( tr.HitSky ) then return end
	local effectdata = EffectData()
	effectdata:SetOrigin( tr.HitPos + tr.HitNormal )
	effectdata:SetNormal( tr.HitNormal )
	util.Effect( "AR2Impact", effectdata )
end

function SWEP:GetNPCRestTimes()
    return 0.1, 0.1
end

function SWEP:GetNPCBurstSettings()
    return 6, 12, 0.1
end

list.Add( "NPCUsableWeapons", { class = "weapon_ez2_ar2", title = "AR2 (EZ2)" } )

if ( SERVER ) then return end
killicon.AddFont( "weapon_ez2_ar2", "EZ2HUD_Kill_ICON", SWEP.SelectIcon, Color( 255, 80, 0, 255 ) )