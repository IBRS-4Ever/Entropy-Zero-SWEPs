AddCSLuaFile()
list.Set("ContentCategoryIcons", "#EZ_Sweps.Category_EZ2", "icon16/ez2.png")

local BaseClass = baseclass.Get( "weapon_base" )
SWEP.Base           = "weapon_base"

SWEP.Category				= "#EZ_Sweps.Category_EZ2"
SWEP.UseHands = true

SWEP.BounceWeaponIcon	= false
SWEP.DrawWeaponInfoBox	= false

SWEP.Primary.Ammo			= ""
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true

SWEP.Secondary.Ammo			= ""
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true

SWEP.CrosshairX		= 0.0
SWEP.CrosshairY		= 0.0
SWEP.HoldType		= "normal"

SWEP.ReadyTimings	= {}
SWEP.ReloadTime		= -1

SWEP.FirstDrawAnimation = "firstdraw"

SWEP.PenetrationPower = 1
SWEP.PenetrationPowerMultiplier = 1

SWEP.TracerName = "Tracer"
SWEP.WepSelectIcon = false

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:OnReloaded()
	self:Initialize()
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Float",	"NextIdleTime" )
	self:NetworkVar( "Float",	"FireDuration" ) -- time spent holding primary trigger
	self:NetworkVar( "Int",		"ShotsFired" ) -- consecutive shot counter
	self:NetworkVar( "Bool",	"IsReloading")
	self:NetworkVar( "Float",	"ReloadTime" )
	self:NetworkVar( "Bool",	"FirstTimePickup")

	if SERVER then
		self:SetShotsFired(0)
		self:SetIsReloading(false)
	end
end

function SWEP:Equip()
	if self.Owner:GetClass() == "npc_citizen" then
		self.Owner:Fire( "DisableWeaponPickup" )
	end
	if self.Owner:IsPlayer() then
		self:SetFirstTimePickup(true)
	end
end

function SWEP:PlayActivity(act, blocker)
	local SequenceIndex = self.Owner:GetViewModel():LookupSequence(act)
	if SequenceIndex != -1 then
		self.Owner:GetViewModel():ResetSequence(SequenceIndex)
		self.Owner:GetViewModel():ResetSequenceInfo()
		self.Owner:GetViewModel():SendViewModelMatchingSequence(SequenceIndex)
	else
		self:SendWeaponAnim(act)
	end

	local delay = self.Owner:GetViewModel():SequenceDuration()
	self:SetNextIdleTime(CurTime() + delay)
	if blocker or false then
		if self.ReadyTimings[act] and self.ReadyTimings[act] ~= -1 then
			delay = self.ReadyTimings[act]
		end
		self:SetNextPrimaryFire(CurTime() + delay)
		self:SetNextSecondaryFire(CurTime() + delay)
	end
end

function SWEP:Holster( wep )
	self:SetIsReloading( false )
	return true
end

function SWEP:CanReload()
	if self:GetIsReloading() then return false end
	if self:Clip1() >= self:GetMaxClip1() then return false end
	if self:GetNextPrimaryFire() > CurTime() then return false end
	if self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()) <= 0 then return false end

	return true
end

function SWEP:Reload()
	if self.Owner:IsNPC() then
		self.Owner:SetSchedule(SCHED_RELOAD)
		self:EmitSound( self.NPCReloadSound ) 
	else
		if self:CanReload() then
			self:BeginReload()
		else
			if !GetConVar("ez_swep_firstdraw_by_reload"):GetBool() then return end
			if not self:GetIsReloading() and self:GetActivity() == ACT_VM_IDLE then
				if timer.TimeLeft( "EZ2SWEP_FirstDrawTimer" ) == nil then
					self:PlayActivity(self.FirstDrawAnimation)
					timer.Create( "EZ2SWEP_FirstDrawTimer", self.Owner:GetViewModel():SequenceDuration(), 1, function() end )
				end
			end
		end
	end
end

function SWEP:BeginReload()
	self:PlayActivity(ACT_VM_RELOAD, true)
	self:EmitSound(self.ReloadSound)
	self:GetOwner():SetAnimation( PLAYER_RELOAD )
	self:SetIsReloading(true)

	local delay = self:SequenceDuration()
	if self.ReloadTime != -1 then delay = self.ReloadTime end
	self:SetReloadTime(CurTime() + delay)
end

function SWEP:FinishReload()
	local num = self:GetMaxClip1() - self:Clip1()
	num = math.min(num, self:Ammo1())

	self:SetClip1( self:Clip1() + num )
	self:GetOwner():RemoveAmmo(num, self:GetPrimaryAmmoType())
	self:SetIsReloading(false)
end

function SWEP:TakePrimaryAmmo(amount)
	if GetConVar( "ez_swep_infinite_ammo" ):GetBool() then return true end
	if self:Clip1() < 0 then
		if ( self:Ammo1() < amount ) then return false end
		self:GetOwner():RemoveAmmo( amount, self:GetPrimaryAmmoType() )
		return true
	end
	if self:Clip1() < amount then return false end
	self:SetClip1( self:Clip1() - amount )
	return true
end

function SWEP:TakeSecondaryAmmo(amount)
	if GetConVar( "ez_swep_infinite_ammo" ):GetBool() then return true end
	if self:Clip2() < 0 then
		if ( self:Ammo2() < amount ) then return false end
		self:GetOwner():RemoveAmmo( amount, self:GetSecondaryAmmoType() )
		return true
	end
	if self:Clip2() < amount then return false end
	self:SetClip2( self:Clip2() - amount )
	return true
end

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end

function SWEP:SpreadedVector(vec, spread)
	local owner = self:GetOwner()
	local x, y
	local i = 0
	while i < 10 do -- give up after 10 iterations just incase we somehow get stuck.......
		x, y = util.SharedRandom("x", -1.0, 1.0, i), util.SharedRandom("y", -1.0, 1.0, i)
		if x*x + y*y < 1 then
			break
		end
		i = i + 1
	end
	local aimdir, right, up = owner:GetAimVector(), owner:GetRight(), owner:GetUp()

	aimdir = aimdir + x * right * spread + y * up * spread
	return aimdir
end

function SWEP:ShootBullet(spread, damage, count)
	local owner = self:GetOwner()

	local vec = owner:GetAimVector()
	local src = owner:GetShootPos()
	local num = count or 1
	if GetConVar("ez_swep_no_bullet_spread"):GetBool() then spread = Vector(0,0,0) end
	-- use built-in spread here because the shotgun feels even worse when calling FireBullets multiple times instead of using Num
	if num > 1 or owner:IsNPC() then
		owner:FireBullets({
							Src = src,
							Dir = vec,
							Damage = damage,
							Num = num,
							Spread = spread * (math.pi / 4), -- compensate for square-shaped spread
							AmmoType = self.Primary.Ammo,
							TracerName = self.TracerName or nil,
							Callback = function(a,b,c) self:BulletPenetrate(a,b,c) end,
						})
	else
		local spreaded = self:SpreadedVector(vec, spread, i)
		owner:FireBullets({
							Src = src,
							Dir = spreaded,
							Damage = damage,
							AmmoType = self.Primary.Ammo,
							TracerName = self.TracerName or nil,
							Callback = function(a,b,c) self:BulletPenetrate(a,b,c) end,
						})
	end
end

function SWEP:Think()
	if game.SinglePlayer() and CLIENT then self.ViewModelFOV = GetConVar("ez_swep_fov"):GetInt() return end
	if self.Owner:IsNPC() then return end

	local owner = self:GetOwner()
	local cmd = owner:GetCurrentCommand()

	if not self:GetIsReloading() and self:Clip1() == 0 and self:CanReload() then
		self:Reload()
	end

	if cmd:KeyDown(IN_ATTACK) and not self:GetIsReloading() then
		self:SetFireDuration(self:GetFireDuration() + FrameTime())
	elseif CurTime() > self:GetNextPrimaryFire() then
		self:SetFireDuration(0)
		self:SetShotsFired(0)
	end

	if self:GetIsReloading() and self:GetReloadTime() <= CurTime() then
		self:FinishReload()
	end

	self:Idle()
end

function SWEP:Idle()
	if self:GetNextIdleTime() <= CurTime() then
		self:PlayActivity(ACT_VM_IDLE)
	end
end

function SWEP:LowerWeapon()
	if !GetConVar("ez_swep_lower_on_ally"):GetBool() then return end
	if !IsFirstTimePredicted() then return end
end

function SWEP:GetPrimaryAttackActivity()
	if self:GetShotsFired() < 2 then
		return ACT_VM_PRIMARYATTACK end
	if self:GetShotsFired() < 3 then
		return ACT_VM_RECOIL1 end
	if self:GetShotsFired() < 4 then
		return ACT_VM_RECOIL2 end

	return ACT_VM_RECOIL3
end

function SWEP:GetBulletSpread()
	return self.BulletSpread
end

function SWEP:GetFireRate()
	return self.FireRate
end

function SWEP:ApplyViewKick(angle) 
	if GetConVar( "ez_swep_no_recoil" ):GetBool() then return end
	self.Owner:ViewPunch( angle or Angle( 0, 0, 0 ) )
end

function SWEP:DoMachineGunKick(maxVerticalKickAngle, fireDurationTime, slideLimitTime)
	local owner = self:GetOwner()
	local vecScratch = Angle()

	local duration
	if ( fireDurationTime > slideLimitTime ) then
		duration = slideLimitTime
	else
		duration = fireDurationTime
	end

	local kickPerc = duration / slideLimitTime

	owner:ViewPunchReset(10)

	vecScratch.x = -( 0.2 + ( maxVerticalKickAngle * kickPerc ) )
	vecScratch.y = -( 0.2 + ( maxVerticalKickAngle * kickPerc ) ) / 3
	vecScratch.z =    0.1 + ( maxVerticalKickAngle * kickPerc ) / 8

	if util.SharedRandom("DoMachineGunKickX", -1, 1) >= 0 then
		vecScratch.y = -vecScratch.y
	end
	if util.SharedRandom("DoMachineGunKickY", -1, 1) >= 0 then
		vecScratch.x = -vecScratch.x
	end

	local punchangle = vecScratch + owner:GetViewPunchAngles()

	vecScratch.x = math.Clamp(vecScratch.x, punchangle.x - 24, punchangle.x + 24 )
	vecScratch.y = math.Clamp(vecScratch.y, punchangle.y - 3, punchangle.y + 3 )
	vecScratch.z = math.Clamp(vecScratch.z, punchangle.z - 1, punchangle.z + 1 )

	vecScratch = punchangle - owner:GetViewPunchAngles()

	owner:ViewPunch(vecScratch * 0.5)
end

hook.Add( "EntityEmitSound", "EZ_SWEPS_DO_ALTIFRE",function(data)--we use sound manipulation to make people think soldiers can actually use smg grenades
	local ar2_ball = { [Sound("Weapon_CombineGuard.Special1")] = true }
	local AltFire = ar2_ball[data.OriginalSoundName]
	local Entity = data.Entity
	if AltFire and Entity:GetClass() == "npc_combine_s" then
		Entity:GetActiveWeapon():NPCShoot_Secondary()
		return false
	end
end)

function SWEP:NPCShoot_Primary() end
function SWEP:NPCShoot_Secondary() end

local PenetrationMaterials = {
	[MAT_DEFAULT] = 1,
	[MAT_VENT] = 0.4, --Since most is aluminum and stuff
	[MAT_METAL] = 0.6, --Since most is aluminum and stuff
	[MAT_WOOD] = 0.2,
	[MAT_PLASTIC] = 0.23,
	[MAT_FLESH] = 0.48,
	[MAT_CONCRETE] = 0.87,
	[MAT_GLASS] = 0.16,
	[MAT_SAND] = 1,
	[MAT_SLOSH] = 1,
	[MAT_DIRT] = 0.95, --This is plaster, not dirt, in most cases.
	[MAT_FOLIAGE] = 0.9
}

function SWEP:BulletPenetrate(attacker, trace, dmginfo)
	if !GetConVar("ez_swep_bullet_penetrate"):GetBool() then return end
	if IsValid(attacker) then
		if CLIENT then return end
		
		local penetrated = {}
		local mult = (PenetrationMaterials[trace.MatType] or 1) * self.PenetrationPowerMultiplier
		local newdir = (trace.HitPos - trace.StartPos):GetNormalized()
		local desired_length = math.Clamp(self.PenetrationPower / mult, 0, math.Clamp(self.PenetrationPowerMultiplier * 100, 1000, 8000))
		local penetrationoffset = newdir * desired_length
		local pentrace = {
			start = trace.HitPos,
			endpos = trace.HitPos + penetrationoffset,
			mask = MASK_SHOT,
			filter = penetrated
		}
	
		local isent = IsValid(trace.Entity)
		local startpos, decalstartpos
	
		if isent then
			table.insert(penetrated, trace.Entity)
		else
			pentrace.start:Add(trace.Normal)
			pentrace.start:Add(trace.Normal)
			pentrace.collisiongroup = COLLISION_GROUP_WORLD
			pentrace.filter = NULL
		end
		
		local bullet = {
			Num = 1, 
			Src = pentrace.endpos, 
			Dir = trace.Normal, 
			Spread = vector_origin, 
			Tracer = 1, 
			TracerName = self.TracerName, 
			Force = 5, 
			Damage = (dmginfo:GetDamage()*mult), 
			HullSize = 2, 
			IgnoreEntity = trace.Entity
		}

		timer.Simple(0, function()
		if not IsFirstTimePredicted() then return end
			attacker.FireBullets(attacker, bullet, true)
		end)
		return true
	end
end

function SWEP:ApplyViewPunch(angle)
	if !self.Owner:IsPlayer() then return end
	if GetConVar( "ez_swep_no_recoil" ):GetBool() then return end
	self.Owner:ViewPunch( angle or Angle( 0, 0, 0 ) )
end

function SWEP:LaunchEnergyBall(speed,radius,lifetime,angle)
	if SERVER then
		if IsValid(self) and IsValid(self.Owner) then
			local ball = ents.Create( "prop_combine_ball" )
			ball:SetAngles( self.Owner:GetAngles() )
			ball:SetPos( self.Owner:GetShootPos() )
			ball:Spawn()
			ball:Activate()
			ball:SetOwner(self.Owner)
			ball:Fire("explode","", lifetime or 4)
			ball:SetSaveValue( "m_flRadius", radius or 10 )
			ball:SetSaveValue( "m_bLaunched", true )
			ball:SetSaveValue( "m_bEmit", true )
			ball:SetSaveValue( "m_bForward", true )
			ball:SetSaveValue( "m_nLastThinkTick", -1 )
			ball:SetSaveValue( "m_nMaxBounces", 9999 )
			ball:SetSaveValue( "m_nState", 3 )
			local phys = ball:GetPhysicsObject()
			phys:SetVelocity( ( self.Owner:GetAimVector():Angle() + (angle or Angle( 0,0,0 )) ):Forward() * ( speed or 1500 )  )
			if self.Owner:IsPlayer() then phys:AddGameFlag( bit.bor( FVPHYSICS_DMG_DISSOLVE, FVPHYSICS_HEAVY_OBJECT ) ) end // Player
			if self.Owner:IsNPC() then phys:AddGameFlag( FVPHYSICS_NO_NPC_IMPACT_DMG ) end									// NPC
			phys:SetMass( 150 )
			phys:SetInertia( Vector( 500, 500, 500 ) )
			self:EmitSound("Weapon_EZ2_AR2_Proto.AltFire_Single")

			if self.Owner:IsPlayer() then
				self:PlayActivity( ACT_VM_SECONDARYATTACK, true )
				self.Owner:SetAnimation( PLAYER_ATTACK1 )
			end
		end
	end
end

function SWEP:Deploy()
	if self.Owner:IsNPC() then return end
	self:PlayActivity(ACT_VM_DRAW, true, 0.8)
	
	if self.SetFireDuration and self.SetShotsFired then
		self:SetFireDuration(0)
		self:SetShotsFired(0)
	end

	if self:GetFirstTimePickup() and SERVER and GetConVar("ez_swep_firstdraw_animation"):GetBool() then
		self:PlayActivity(self.FirstDrawAnimation)
		self:SetFirstTimePickup(false)
	end
	return true
end

function SWEP:NPCCanPrimaryAttack()
	if self.Owner:IsNPC() then
		if ( self.Weapon:Clip1() <= 0 ) then
			self:SetNextPrimaryFire( CurTime() + 0.2 )
			self:Reload()
			return false
		end
		return true
	end
end

function SWEP:GetNPCBulletSpread( proficiency )
    return 1
end

if CLIENT then
	surface.CreateFont( "EZ2HUD", {
		font = "ez2_hud",
		size = 128
	} )

	surface.CreateFont( "EZ2HUD_Kill_ICON", {
		font = "ez2_hud",
		size = 80
	} )

	local crosshairs = Material("hud/ez2_crosshairs.vmt")
	function SWEP:DoDrawCrosshair(x, y)
		if x == 0 and y == 0 then return false end
		surface.SetDrawColor(Color(255,255,255))
		surface.SetMaterial(crosshairs)
		surface.DrawTexturedRectUV( x-32, y-32, 64, 64, self.CrosshairX, self.CrosshairY, self.CrosshairX+0.25, self.CrosshairY+0.25)
		return true
	end

	function SWEP:DrawWeaponSelection(x,y,wide,tall)
		if !self.WepSelectIcon or GetConVar("ez_swep_icon_use_font"):GetBool() then
			draw.SimpleText( self.SelectIcon, 'EZ2HUD', x + wide / 2, y + 50, color_white, TEXT_ALIGN_CENTER )
		else
			surface.SetDrawColor( color_white, alpha )
			surface.SetTexture( self.WepSelectIcon )

			y = y + 10
			x = x + 10
			wide = wide - 20
			tall = tall - 20

			surface.DrawTexturedRect( x, y, wide, wide * 0.5 )
		end
	end
end