SWEP.Base           = "weapon_ez2_base"
DEFINE_BASECLASS("weapon_ez2_base")

SWEP.Category				= "#EZ_Sweps.Category_EZ"
SWEP.SubCategory				= "#EZ_Sweps.Category_EZ"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.AdminOnly = false
SWEP.PrintName				= "#ez_swep.manhack_toss"
SWEP.Slot				= 5
SWEP.SlotPos				= 20
SWEP.ViewModel        = "models/weapons/ez/c_manhackcontrol.mdl"
SWEP.WorldModel = "models/weapons/ez/w_manhackcontrol.mdl"

if CLIENT then
	SWEP.WepSelectIcon	= surface.GetTextureID("hud/ez_manhack.vmt")
end

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	self:NetworkVar( "Bool",	"IsDeploying" )
	self:NetworkVar( "Float",	"DeployTime" )
end

SWEP.Primary.Automatic			= true
SWEP.Primary.ClipSize = -1
SWEP.Primary.Delay = 1.5
SWEP.Primary.DefaultClip = 3
SWEP.Primary.Ammo = "manhack"

SWEP.HoldType = "grenade"
SWEP.FirstDrawAnimation = false

SWEP.SelectIcon = "f"

function SWEP:Initialize()
	game.AddAmmoType( { name = "manhack" } )
end

function SWEP:PrimaryAttack()
	if !self:TakePrimaryAmmo(1) then return end
	if SERVER then
		local Manhack = ents.Create("npc_manhack")
		Manhack:SetOwner(self.Owner)
		Manhack:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector()*50 )
		Manhack:SetAngles(self.Owner:EyeAngles())
		Manhack:SetSpawnFlags( bit.bor( Manhack:GetSpawnFlags(), 2097152 ) )
		Manhack:Spawn()
		Manhack:Activate()
		Manhack:SetVelocity(self.Owner:GetAimVector()*1000 + Vector(0,0,80))
		Manhack:SetHealth(200)
		Manhack:SetSequence( "deploy" )
		Manhack.IsCustomEZ2Manhack = true
		
		self:SendWeaponAnim( ACT_VM_THROW )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )	
	end
	
	self:SetIsDeploying(true)
	self:SetNextIdleTime(9999999999)
	self:SetDeployTime(CurTime() + self:SequenceDuration())
	self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
	self:SetLastShootTime()
end

function SWEP:CustomThink()
	if self:GetDeployTime() < CurTime() and self:GetIsDeploying() then
		if self:Ammo1() > 0 then
			self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
			self:SetNextIdleTime(CurTime() + self:SequenceDuration())
			self:SetIsDeploying(false)
			self:SetIsReloading(true)
		end
	end
	if self:GetIsReloading() then
		self:PlayActivity(ACT_VM_DRAW)
		self:SetNextIdleTime(CurTime() + self:SequenceDuration())
		self:SetIsReloading(false)
	end
end

if SERVER then
    hook.Add("EntityTakeDamage", "EZ2_CustomManhackDamage", function(target, dmginfo)
        local inflictor = dmginfo:GetInflictor()
        if IsValid(inflictor) and inflictor:GetClass() == "npc_manhack" and inflictor.IsCustomEZ2Manhack then
            dmginfo:SetDamage(20)
        end
    end)
end
