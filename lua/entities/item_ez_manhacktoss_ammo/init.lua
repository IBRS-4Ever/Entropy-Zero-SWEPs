AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel( "models/manhack.mdl" ) 
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )
	
	local phys = self:GetPhysicsObject()

	if phys and phys:IsValid() then
		phys:Wake()
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.1)
end

function ENT:Think()

	for k, target in pairs ( ents.FindInSphere( self.Entity:GetPos(), 45 ) ) do
		   if target:IsValid() and target:IsPlayer() then

		   target:GiveAmmo(self.Amount, self.AmmoType)
		   self:Remove()
						
	    end
    end	
end