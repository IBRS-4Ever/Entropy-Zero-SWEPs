SWEP.Base           = "weapon_base"
SWEP.Category				= "Entropy : Zero" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep..
SWEP.Author				= "Insane Black Rock Shooter" --Author Tooltip
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter if enabled in the GUI.
-- SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
-- SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
-- SWEP.Weight				= 30			-- This controls how "good" the weapon is for autopickup.
SWEP.UseHands = true

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

SWEP.TracerName = "Tracer"

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

function SWEP:BulletPenetrate(attacker, tr, dmginfo, aimvect)
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
		local bullet = {Num=1, Src=trace.HitPos, Dir=tr.Normal, Spread=vector_origin, Tracer=1, TracerName=self.TracerName, Force=5, Damage=(dmginfo:GetDamage()*fDamageMulti), HullSize=2}
		
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
			self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		end
		if self.Weapon:DefaultReload(ACT_VM_RELOAD) then
			self:EmitSound( self.ReloadSound )
		end
		self.Idle = 0
		self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	
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

function SWEP:DrawWeaponSelection(x,y,wide,tall)
	local c=self.TextColor or Color(255,220,0)
		draw.SimpleText( self.SelectIcon ,"WeaponIcons",x+wide/2,y+tall*.2,c,TEXT_ALIGN_CENTER)
		self:PrintWeaponInfo(x+wide+20,y+tall*.95,alpha)
end

function SWEP:Deploy()
	if !self.Owner:IsNPC() then
		if self.FirstDraw != 1 and GetConVar( "ez_swep_firstdraw_animation" ):GetInt() == 1 then
			self:PlayAnim( self.FirstDrawAnimation )
			self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
			self:SetNextSecondaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
			self.FirstDraw = 1
			self.Idle = 0
			self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			self.NextFirstDrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration() + 3
		else
			self:SendWeaponAnim( ACT_VM_DRAW )
			self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )
			self.Idle = 0
			self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
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
			self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			self:Reload()
			return false
		end
		return true
	end
end

function SWEP:Holster( wep )
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
		
		if GetConVar( "ez_swep_lower_on_ally" ):GetBool() then
		function IdleToLowerAnimation()
			if self.IdleToLower == 0 and self.IdleLower == 0 and self.IdleToLowerTimer < CurTime() then
				self:SendWeaponAnim(ACT_VM_IDLE_TO_LOWERED)
				self.IdleToLower = 1
				self.IdleToLowerTimer = CurTime() + 0.5
				self.IdleLower = 1
				self.IdleLowerTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
				print("IdleToLower")
			end
			
			if self.IdleLower == 1 and self.IdleToLower == 1 and self.IdleLowerTimer < CurTime() then
				self:SendWeaponAnim(ACT_VM_IDLE_LOWERED)
				--self.IdleLower = 0
				self.IdleLowerTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
				self.LowerToIdle = 0
				self.LowerToIdleTimer = CurTime() + 1
				print("IdleLower")
			end
		end
		
		function LowerToIdleAnimation()
			if self.LowerToIdle == 0 and self.IdleLower == 1 and self.LowerToIdleTimer < CurTime() then
				self:SendWeaponAnim(ACT_VM_LOWERED_TO_IDLE)
				self.IdleLower = 0
				self.IdleToLower = 0
				self.LowerToIdle = 1
				self.IdleToLowerTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
				print("LowerToIdle")
				self.Idle = 0
				self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			end
		end
			
		-- timer.Create( "CheckFriendly", 0.5, 0, function()
		if CLIENT then return end -- 只在服务端运行此代码
		if not IsValid(self.Owner) or not self.Owner:IsPlayer() then return end  -- 确保武器的拥有者是玩家

		--if self.Owner:ShouldDrawLocalPlayer() then return end -- 确保玩家不是第三人称视角，只有第一人称视角时才可触发

		-- 获取玩家凝视的实体
		local trace = self.Owner:GetEyeTrace()
		if not IsValid(trace.Entity) or not trace.Entity:IsNPC()then return LowerToIdleAnimation() end
		
		local Friendly = IsFriendEntityName(trace.Entity:GetClass())
		if Friendly then
				IdleToLowerAnimation() -- 调用函数
		end
		-- end )
		end
	end
end
