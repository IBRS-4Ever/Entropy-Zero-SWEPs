SWEP.Base           = "weapon_base"
SWEP.Category				= "Entropy : Zero"
SWEP.DrawAmmo				= true
SWEP.UseHands = true

SWEP.BounceWeaponIcon	= false
SWEP.DrawWeaponInfoBox	= false

SWEP.Idle = 0
SWEP.IdleTimer = CurTime()
SWEP.FirstDraw = 0
SWEP.FirstDrawAnimation = "firstdraw"
SWEP.FirstDrawing = 0
SWEP.NextFirstDrawTimer = CurTime()

SWEP.IdleToLower = 0
SWEP.IdleToLowerTimer = CurTime() 
SWEP.IdleLower = 0
SWEP.IdleLowerTimer = CurTime()
SWEP.LowerToIdle = 0
SWEP.LowerToIdleTimer = CurTime()

SWEP.CrosshairX		= 0.0
SWEP.CrosshairY		= 0.0

SWEP.TracerName = "Tracer"

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

hook.Add( "EntityEmitSound", "EZ_SWEPS_DO_ALTIFRE",function(data)--we use sound manipulation to make people think soldiers can actually use smg grenades
	local ar2_ball = { [Sound("Weapon_CombineGuard.Special1")] = true }
	local AltFire = ar2_ball[data.OriginalSoundName]
	local Entity = data.Entity
	if AltFire and Entity:GetClass() == "npc_combine_s" then
		if !(weapons.IsBasedOn(Entity:GetActiveWeapon():GetClass(), "weapon_ez2_base")) then return end
		Entity:GetActiveWeapon():NPCShoot_Secondary()
		return false
	end
end)

function SWEP:Equip()
	if self.Owner:GetClass() == "npc_citizen" then
		self.Weapon.Owner:Fire( "DisableWeaponPickup" )
	end
end

function SWEP:NPCShoot_Primary( shootPos, shootDir )

end

function SWEP:BulletPenetrate(attacker, tr, dmginfo, aimvect)
	if !GetConVar("ez_swep_bullet_penetrate"):GetBool() then return end
	if IsValid(attacker) then
		if CLIENT then return end
		local mat = tr.MatType
		if mat == MAT_SAND then return false end
		local dir = tr.Normal * 16
		if mat == MAT_GLASS or mat == MAT_PLASTIC or mat == MAT_WOOD or mat == MAT_FLESH or mat == MAT_ALIENFLESH then
			dir = tr.Normal * 32
		end
		local trace = {start=tr.HitPos + dir,endpos=tr.HitPos,mask=MASK_SHOT}
		trace = util.TraceLine(trace) 
		if trace.StartSolid or trace.Fraction >= 1 or tr.Fraction <= 0 then return false end
		local fDamageMulti = 0.5
		if (mat == MAT_CONCRETE) then
			fDamageMulti = 0.3
		elseif (mat == MAT_WOOD or mat == MAT_PLASTIC or mat == MAT_GLASS) then
			fDamageMulti = 0.8
		end
		local bullet = {Num=1, Src=trace.HitPos, Dir=tr.Normal, Spread=vector_origin, Tracer=1, TracerName=self.TracerName, Force=5, Damage=(dmginfo:GetDamage()*fDamageMulti), HullSize=2, IgnoreEntity = tr.Entity}
		
		timer.Simple(0, function()
		if not IsFirstTimePredicted() then return end
			attacker.FireBullets(attacker, bullet, true)
		end)
		return true
	end
end

function SWEP:Reload()
	if !self.Owner:IsNPC() then
		if self:Clip1() == self.Primary.ClipSize and self.NextFirstDrawTimer < CurTime() and self.FirstDrawing == 0 and GetConVar( "ez_swep_firstdraw_by_reload" ):GetBool() then
			self:PlayAnim( self.FirstDrawAnimation )
			self.NextFirstDrawTimer = CurTime() + self:SequenceDuration()
		end
		if self.Weapon:DefaultReload(ACT_VM_RELOAD) then
			self:EmitSound( self.ReloadSound )
		end
		self.Idle = 0
		self.IdleTimer = CurTime() + self:SequenceDuration()
	
	else
		self.Owner:SetSchedule(SCHED_RELOAD)
		self:EmitSound( self.NPCReloadSound ) 
	end
end

function SWEP:PlayAnim(a,c,t)
	local vm=self.Owner:GetViewModel()
	if a then
		local n=vm:LookupSequence(a)
		vm:ResetSequence(n)
		vm:ResetSequenceInfo()
		vm:SendViewModelMatchingSequence(n)
	end
	if !c then c=1 end
		vm:SetPlaybackRate(c)
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	
	if !self.Owner:IsNPC() then
		self.Idle = 0
		self.IdleTimer = CurTime() + 4
	end
end



function SWEP:Deploy()
	if !self.Owner:IsNPC() then
		if self.FirstDraw != 1 and GetConVar( "ez_swep_firstdraw_animation" ):GetInt() == 1 then
			self:PlayAnim( self.FirstDrawAnimation )
			self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )
			self:SetNextSecondaryFire( CurTime() + self:SequenceDuration() )
			self.FirstDraw = 1
			self.Idle = 0
			self.IdleTimer = CurTime() + self:SequenceDuration()
			self.NextFirstDrawTimer = CurTime() + self:SequenceDuration() + 3
		else
			self:SendWeaponAnim( ACT_VM_DRAW )
			self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )
			self.Idle = 0
			self.IdleTimer = CurTime() + self:SequenceDuration()
		end
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

function SWEP:CanPrimaryAttack()
	if !self.Owner:IsNPC() then
		if self:Clip1() < 1 then
			self:EmitSound("Weapon_Pistol.Empty")
			self:SendWeaponAnim( ACT_VM_DRYFIRE )
			self:GetOwner():SetAnimation(PLAYER_ATTACK1)
			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) -- 等待动画播放完毕
			self.Idle = 0
			self.IdleTimer = CurTime() + self:SequenceDuration()
			self:Reload()
			return false
		end
		return true
	end
end

function SWEP:Holster( wep )
	self:SetIsReloading( false )
	return true
end

function SWEP:Think()
	if !self.Owner:IsNPC() then
		self.ViewModelFOV = GetConVar( "ez_swep_fov" ):GetInt()
		if self.Idle == 0 and self.IdleTimer < CurTime() then
			if SERVER then
				self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
			end
			self.Idle = 1
		end
		
		if CLIENT then
			if GetConVar( "ez_swep_lower_on_ally" ):GetBool() then
				function IdleToLowerAnimation()
					if self.IdleToLower == 0 and self.IdleLower == 0 and self.IdleToLowerTimer < CurTime() then
						self:SendWeaponAnim(ACT_VM_IDLE_TO_LOWERED)
						self.IdleToLower = 1
						self.IdleToLowerTimer = CurTime() + 0.5
						self.IdleLower = 1
						self.IdleLowerTimer = CurTime() + self:SequenceDuration()
					end
					
					if self.IdleLower == 1 and self.IdleToLower == 1 and self.IdleLowerTimer < CurTime() then
						self:SendWeaponAnim(ACT_VM_IDLE_LOWERED)
						self.IdleLowerTimer = CurTime() + self:SequenceDuration()
						self.LowerToIdle = 0
						self.LowerToIdleTimer = CurTime() + 1
					end
				end
				
				function LowerToIdleAnimation()
					if self.LowerToIdle == 0 and self.IdleLower == 1 and self.LowerToIdleTimer < CurTime() then
						self:SendWeaponAnim(ACT_VM_LOWERED_TO_IDLE)
						self.IdleLower = 0
						self.IdleToLower = 0
						self.LowerToIdle = 1
						self.IdleToLowerTimer = CurTime() + self:SequenceDuration()
						self.Idle = 0
						self.IdleTimer = CurTime() + self:SequenceDuration()
					end
				end
					
				if not IsValid(self.Owner) or not self.Owner:IsPlayer() then return end  -- 确保武器的拥有者是玩家

				local trace = self.Owner:GetEyeTrace()
				if not IsValid(trace.Entity) or not trace.Entity:IsNPC()then return LowerToIdleAnimation() end
				
				local Friendly = IsFriendEntityName(trace.Entity:GetClass())
				if Friendly then
					IdleToLowerAnimation() -- 调用函数
				end
			end
		end
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
		draw.SimpleText( self.SelectIcon, 'EZ2HUD', x + wide / 2, y + tall * 0.1 + 30, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end
end