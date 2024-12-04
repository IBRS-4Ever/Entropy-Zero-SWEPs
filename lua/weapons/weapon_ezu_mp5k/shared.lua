SWEP.Base           = "weapon_base"
SWEP.Category				= "#EZ_Sweps.Category_EZU" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep..
SWEP.Spawnable				= true --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable			= true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.AdminOnly = false
SWEP.DrawCrosshair			= true		-- Draw the crosshair?
SWEP.DrawCrosshairIS = false --Draw the crosshair in ironsights?
SWEP.PrintName				= "MP5K (EZU)"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 2		-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 20			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter if enabled in the GUI.
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.Weight				= 30			-- This controls how "good" the weapon is for autopickup.
SWEP.UseHands = true
SWEP.ViewModel        = "models/weapons/ezu/c_mp5k.mdl"
SWEP.WorldModel = "models/weapons/ezu/w_mp5k.mdl"

SWEP.Primary.Automatic			= true
SWEP.Primary.ClipSize = 30
SWEP.Primary.Delay = 0.10 
SWEP.Primary.DefaultClip = 200
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Sound = Sound ( "Weapon_MP5K.Single" )
SWEP.Primary.Recoil = 1

SWEP.HoldType = "smg"

SWEP.Idle = 0
SWEP.IdleTimer = CurTime()

SWEP.Secondary.ClipSize = 3
SWEP.Secondary.Delay = 1
SWEP.Secondary.Damage = 0
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

local NextBurst = 0

function SWEP:Reload()
	if self.Weapon:DefaultReload(ACT_VM_RELOAD) then
		self:EmitSound( "Weapon_MP5K.Reload" )
	end
	self.Idle = 0
	self.IdleTimer = CurTime() + self:SequenceDuration()
end

function SWEP:Initialize()
self:SetWeaponHoldType( self.HoldType )
self.Idle = 0
self.IdleTimer = CurTime() + 4
end

function SWEP:DrawWeaponSelection(x,y,wide,tall)
local c=self.TextColor or Color(255,220,0)
draw.SimpleText("f","WeaponIcons",x+wide/2,y+tall*.2,c,TEXT_ALIGN_CENTER)
self:PrintWeaponInfo(x+wide+20,y+tall*.95,alpha)
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )
	self.Idle = 0
	self.IdleTimer = CurTime() + self:SequenceDuration()
end

function SWEP:PrimaryAttack()
    if CurTime() < NextBurst then return end //冷却时间未结束，不射击

    self:EmitSound("Weapon_AR2.Single")
    self:ShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Primary.Spread)
    self.Owner:ViewPunch(Angle(-self.Primary.Recoil, 0, 0))

    //添加后坐力
    local punch = Angle(0,0,0)   
    punch.pitch = math.Rand(-0.2,-0.1) * self.Primary.Recoil 
    self.Owner:ViewPunch(punch)

    self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    //设置计时器值
    NextBurst = CurTime() + 0.1
end

function SWEP:SecondaryAttack()
 	if ( !self:CanPrimaryAttack() ) then return end

	if ( IsFirstTimePredicted() ) then
		local bullet = {}
		bullet.Num = 1
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
			if GetConVar( "ez_swep_no_bullet_spread" ):GetInt() == 0 then
				bullet.Spread = Vector( 0.03, 0.03, 0 )
			else
				bullet.Spread = Vector( 0, 0, 0 )
			end
		bullet.Force = 5
		bullet.Damage = self.Primary.Damage
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
		self.IdleTimer = CurTime() + self:SequenceDuration()
end

function SWEP:Think()
//self.Primary.Damage = GetConVar( "sk_ezu_mp5k_dmg" ):GetInt()
if self.Idle == 0 and self.IdleTimer < CurTime() then
if SERVER then
self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
end
self.Idle = 1
end
end
if ( SERVER ) then return end
killicon.AddFont( "weapon_ezu_mp5k", "WeaponIcons", "f", Color( 255, 80, 0, 255 ) )