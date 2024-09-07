SWEP.Base           = "weapon_ez2_base"
SWEP.Category				= "Entropy : Zero 2" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep..
SWEP.Spawnable				= true --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable			= true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.AdminOnly = false
if language then
	SWEP.PrintName				= language.GetPhrase( "ez_swep.prototype.ar2" ) -- "Prototype AR2 (EZ2)"		-- Weapon name (Shown on HUD)
end
SWEP.Slot				= 2			-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 20			-- Position in the slot
SWEP.ViewModel        = "models/weapons/ez2/c_ar2_proto.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"

SWEP.Primary.Automatic			= true
SWEP.Primary.ClipSize = 90
SWEP.Primary.Delay = 0.1
SWEP.Primary.DefaultClip = 180
SWEP.Primary.Ammo = "ar2"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 1.95
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "AR2AltFire"

SWEP.HoldType = "ar2"
SWEP.ReloadSound = ""
SWEP.NPCReloadSound = "Weapon_AR2.Reload"

SWEP.TracerName = "AR2Tracer"

SWEP.SelectIcon = "l"

function SWEP:PrimaryAttack()
	
	if !self.Owner:IsNPC() then
		if ( !self:CanPrimaryAttack() ) then return end
		if ( IsFirstTimePredicted() ) then
			self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			local bullet = {}
			bullet.Num = GetConVar( "ez2_swep_proto_ar2_num" ):GetInt()
			bullet.Src = self.Owner:GetShootPos()
			bullet.Dir = (self.Owner:EyeAngles()+self.Owner:GetViewPunchAngles()):Forward() 
					
			if GetConVar( "ez_swep_no_bullet_spread" ):GetInt() == 0 then
				bullet.Spread = Vector( 0.05, 0.05, 0 )
			else
				bullet.Spread = Vector( 0, 0, 0 )
			end
					
			bullet.Force = 5
			bullet.Damage = GetConVar("ez2_swep_proto_ar2_plr_dmg"):GetInt()
			bullet.TracerName = self.TracerName
			bullet.Callback	= function(a,b,c)
				self:BulletPenetrate(a,b,c)
			end
			self.Owner:FireBullets( bullet )
				
			if GetConVar( "ez_swep_no_recoil" ):GetInt() == 0 then
				self.Owner:ViewPunch(Angle( -2, math.Rand( -2, 2 ),0))
			end
			
			self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
				
			if GetConVar( "ez_swep_infinite_ammo" ):GetInt() == 0 then
				self:TakePrimaryAmmo( 1 )
			else
				self:TakePrimaryAmmo( 0 )
			end
					
			self:EmitSound("Weapon_EZ2_AR2_Proto.Single")
			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
			self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
		end
			
		self.Idle = 0
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		
	else
		if ( !self:NPCCanPrimaryAttack() ) then return end
		local bullet = {}
		bullet.Num = GetConVar( "ez2_swep_proto_ar2_num" ):GetInt()
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector( 0.05, 0.05, 0 )
		bullet.Force = 5
		bullet.Damage = GetConVar("ez2_swep_proto_ar2_npc_dmg"):GetInt()
		bullet.TracerName = self.TracerName
		bullet.Callback	= function(a,b,c)
			self:BulletPenetrate(a,b,c)
		end
		self.Owner:FireBullets( bullet )
		
		self:EmitSound("Weapon_EZ2_AR2_Proto.Single")
		self:TakePrimaryAmmo( 1 )
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	end
end

function SWEP:SecondaryAttack()
	if ( IsFirstTimePredicted() ) then
		if self.Owner:GetAmmoCount( self.Secondary.Ammo ) > 0 or GetConVar( "ez_swep_infinite_ammo" ):GetInt() == 1 then
			self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			self:EmitSound("Weapon_EZ2_AR2_Proto.Special1")
			--self:PlayAnim( "shake" )
			self:SendWeaponAnim( ACT_VM_FIDGET )
				if SERVER then
					timer.Simple(0.65,function()
						local cballspawner = ents.Create( "point_combine_ball_launcher" )
							cballspawner:SetAngles( self.Owner:EyeAngles())
							cballspawner:SetPos( self.Owner:GetShootPos() + self.Owner:GetAimVector()*14)
							cballspawner:SetKeyValue( "minspeed",2200 )
							cballspawner:SetKeyValue( "maxspeed", 2200 )
							cballspawner:SetKeyValue( "ballradius", "5" )
							cballspawner:SetKeyValue( "ballcount", "1" )
							cballspawner:SetKeyValue( "maxballbounces", "9999" )
							cballspawner:SetKeyValue( "launchconenoise", 2 )
							cballspawner:Spawn()
							cballspawner:Activate()
							cballspawner:Fire( "LaunchBall" )
							cballspawner:Fire( "LaunchBall" )
							cballspawner:Fire( "LaunchBall" )
							cballspawner:Fire("kill","",0)
								if GetConVar( "ez_swep_no_recoil" ):GetInt() == 0 then
									self.Owner:ViewPunch(Angle( -10,0,0 ))
								end
								if GetConVar( "ez_swep_infinite_ammo" ):GetInt() == 0 then
									self:TakeSecondaryAmmo( 1 )
								else
									self:TakeSecondaryAmmo( 0 )
								end
							self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
							self.Owner:SetAnimation( PLAYER_ATTACK1 )
							self:EmitSound("Weapon_EZ2_AR2_Proto.AltFire_Single")
							--print("Firing Energy Ball")
					end)
				end
			timer.Simple(0.67,function()
				if IsValid(self) and IsValid(self.Owner) then
					for k,v in pairs(ents.FindInSphere(self.Owner:GetShootPos(),20)) do
						if IsValid(v) and string.find(v:GetClass(),"prop_combine_ball") and !IsValid(v:SetOwner()) and SERVER then
							v:SetOwner(self.Owner)
							v:GetPhysicsObject():AddGameFlag( FVPHYSICS_WAS_THROWN )
							v:Fire("explode","",GetConVar( "ez2_swep_proto_ar2_ball_explode_time" ):GetInt())
							--print("Timer Hit")
						end
					end
				end
			end)
			self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
			self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
			self.Idle = 0
			self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		else 
			self:EmitSound("Weapon_IRifle.Empty")
			self:SetNextPrimaryFire( CurTime() + 0.25 )
			self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
			self.Idle = 0
			self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
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
    return 12, 24, 0.1
end

function SWEP:GetNPCBulletSpread( proficiency )
    return 4
end

-- function SWEP:GetCapabilities()

	-- return bit.bor( CAP_WEAPON_RANGE_ATTACK1, CAP_INNATE_RANGE_ATTACK1 )

-- end

list.Add( "NPCUsableWeapons", { class = "weapon_ez2_ar2_proto", title = "Prototype AR2 (EZ2)" } )

if ( SERVER ) then return end
killicon.AddAlias( "weapon_ez2_ar2_proto", "weapon_ar2" )
