SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "Entropy : Zero 2" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep..
SWEP.Spawnable				= true --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable			= true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.AdminOnly = false
SWEP.PrintName				= "AR2 (EZ2)"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 2			-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 20			-- Position in the slot
SWEP.ViewModel        = "models/weapons/ez2/c_ar2.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"

SWEP.Primary.Automatic			= true
SWEP.Primary.ClipSize = 30
SWEP.Primary.Delay = 0.1
SWEP.Primary.DefaultClip = 180
SWEP.Primary.Ammo = "ar2"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 1.95
SWEP.Secondary.Damage = 125
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "AR2AltFire"

SWEP.HoldType = "ar2"
SWEP.ReloadSound = ""
SWEP.NPCReloadSound = "Weapon_AR2.Reload"

SWEP.SelectIcon = "l"

SWEP.TracerName = "AR2Tracer"

function SWEP:NPCShoot_Primary( shootPos, shootDir )
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
	timer.Simple(0.6,function()
		if IsValid(self) and IsValid(self.Owner) then
			local ball = ents.Create( "prop_combine_ball" )
			ball:SetAngles( self.Owner:GetAngles() )
			ball:SetPos( self.Owner:GetShootPos() )
			ball:Spawn()
			ball:Activate()
			ball:SetOwner(self.Owner)
			ball:Fire("explode","", GetConVar( "ez2_swep_ar2_ball_explode_time" ):GetInt())
			ball:SetSaveValue( "m_flRadius", 10 )
			ball:SetSaveValue( "m_bLaunched", true )
			ball:SetSaveValue( "m_bEmit", true )
			ball:SetSaveValue( "m_bForward", true )
			ball:SetSaveValue( "m_nLastThinkTick", -1 )
			ball:SetSaveValue( "m_nMaxBounces", 9999 )
			ball:SetSaveValue( "m_nState", 3 )
			local phys = ball:GetPhysicsObject()
			phys:SetVelocity( self.Owner:GetAimVector() * 1500 )
			phys:AddGameFlag( FVPHYSICS_NO_NPC_IMPACT_DMG )
			phys:SetMass( 750 )
			phys:SetInertia( Vector( 500, 500, 500 ) )
							
			local ball2 = ents.Create( "prop_combine_ball" )
			ball2:SetAngles( self.Owner:GetAngles() )
			ball2:SetPos( self.Owner:GetShootPos() )
			ball2:Spawn()
			ball2:Activate()
			ball2:SetOwner(self.Owner)
			ball2:Fire("explode","", GetConVar( "ez2_swep_ar2_ball_explode_time" ):GetInt())
			ball2:SetSaveValue( "m_flRadius", 10 )
			ball2:SetSaveValue( "m_bLaunched", true )
			ball2:SetSaveValue( "m_bEmit", true )
			ball2:SetSaveValue( "m_bForward", true )
			ball2:SetSaveValue( "m_nLastThinkTick", -1 )
			ball2:SetSaveValue( "m_nMaxBounces", 9999 )
			ball2:SetSaveValue( "m_nState", 3 )
			local phys2 = ball2:GetPhysicsObject()
			phys2:SetVelocity( self.Owner:GetAimVector() * 1500 )
			phys2:AddGameFlag( FVPHYSICS_NO_NPC_IMPACT_DMG )
			phys2:SetMass( 750 )
			phys2:SetInertia( Vector( 500, 500, 500 ) )
			
			local ball3 = ents.Create( "prop_combine_ball" )
			ball3:SetAngles( self.Owner:GetAngles() )
			ball3:SetPos( self.Owner:GetShootPos() )
			ball3:Spawn()
			ball3:Activate()
			ball3:SetOwner(self.Owner)
			ball3:Fire("explode","", GetConVar( "ez2_swep_ar2_ball_explode_time" ):GetInt())
			ball3:SetSaveValue( "m_flRadius", 10 )
			ball3:SetSaveValue( "m_bLaunched", true )
			ball3:SetSaveValue( "m_bEmit", true )
			ball3:SetSaveValue( "m_bForward", true )
			ball3:SetSaveValue( "m_nLastThinkTick", -1 )
			ball3:SetSaveValue( "m_nMaxBounces", 9999 )
			ball3:SetSaveValue( "m_nState", 3 )
			local phys3 = ball3:GetPhysicsObject()
			phys3:SetVelocity( self.Owner:GetAimVector() * 1500 )
			phys3:AddGameFlag( FVPHYSICS_NO_NPC_IMPACT_DMG )
			phys3:SetMass( 750 )
			phys3:SetInertia( Vector( 500, 500, 500 ) )
			
			self:EmitSound("Weapon_EZ2_AR2_Proto.AltFire_Single")
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
				
		if GetConVar( "ez_swep_no_bullet_spread" ):GetBool() then
			bullet.Spread = Vector( 0, 0, 0 )
		else
			bullet.Spread = Vector( 0.015, 0.015, 0 )
		end
				
		bullet.Force = 5
		bullet.Damage = GetConVar( "ez2_swep_ar2_plr_dmg" ):GetInt()
		bullet.TracerName = self.TracerName
		bullet.Callback	= function(a,b,c)
			self:BulletPenetrate(a,b,c)
		end
		self.Owner:FireBullets( bullet )
			
		if !GetConVar( "ez_swep_no_recoil" ):GetBool() then
			self.Owner:ViewPunch(Angle( -0.25, math.Rand( -0.05, 0.05 ),0))
		end
	
		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
		if GetConVar( "ez_swep_infinite_ammo" ):GetBool() then
			self:TakePrimaryAmmo( 0 )
		else
			self:TakePrimaryAmmo( 1 )
		end
				
		self:EmitSound("Weapon_EZ2_AR2.Single")
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	end
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:SecondaryAttack()
	if ( IsFirstTimePredicted() ) then
		if self.Owner:GetAmmoCount( self.Secondary.Ammo ) > 0 or GetConVar( "ez_swep_infinite_ammo" ):GetBool() then
			self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			self:EmitSound("Weapon_CombineGuard.Special1")
			self:SendWeaponAnim( ACT_VM_FIDGET )
				if SERVER then
					timer.Simple( 0.6, function()
						if IsValid(self) and IsValid(self.Owner) then
							local ball = ents.Create( "prop_combine_ball" )
							ball:SetAngles( self.Owner:GetAngles() )
							ball:SetPos( self.Owner:GetShootPos() )
							ball:Spawn()
							ball:Activate()
							ball:SetOwner(self.Owner)
							ball:Fire("explode","", GetConVar( "ez2_swep_ar2_ball_explode_time" ):GetInt())
							ball:SetSaveValue( "m_flRadius", 10 )
							ball:SetSaveValue( "m_bLaunched", true )
							ball:SetSaveValue( "m_bEmit", true )
							ball:SetSaveValue( "m_bForward", true )
							ball:SetSaveValue( "m_nLastThinkTick", -1 )
							ball:SetSaveValue( "m_nMaxBounces", 9999 )
							ball:SetSaveValue( "m_nState", 3 )
							local phys = ball:GetPhysicsObject()
							phys:SetVelocity( self.Owner:GetAimVector() * 1500 )
							phys:AddGameFlag( bit.bor( FVPHYSICS_DMG_DISSOLVE, FVPHYSICS_HEAVY_OBJECT ) )
							phys:SetMass( 750 )
							phys:SetInertia( Vector( 500, 500, 500 ) )
							
							if !GetConVar( "ez_swep_no_recoil" ):GetBool() then
								self.Owner:ViewPunch(Angle( -10,0,0 ))
							end
							if GetConVar( "ez_swep_infinite_ammo" ):GetBool() then
								self:TakeSecondaryAmmo( 0 )
							else
								self:TakeSecondaryAmmo( 1 )
							end
							self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
							self.Owner:SetAnimation( PLAYER_ATTACK1 )
							self:EmitSound("Weapon_EZ2_AR2_Proto.AltFire_Single")
							self.Idle = 0
							self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
						end
					end)
				end
			self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
			self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
		else 
			self:EmitSound("Weapon_IRifle.Empty")
			self:SetNextPrimaryFire( CurTime() + 0.25 )
			self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
		end
	end
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
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

function SWEP:GetNPCBulletSpread( proficiency )
    return 4
end

list.Add( "NPCUsableWeapons", { class = "weapon_ez2_ar2", title = "AR2 (EZ2)" } )

if ( SERVER ) then return end
killicon.AddAlias( "weapon_ez2_ar2", "weapon_ar2" )
