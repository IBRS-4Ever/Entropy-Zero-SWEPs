resource.AddWorkshop( 2195733665 )

local ReplacementClass = {
	["npc_citizen"] = true,
	["npc_combine_s"] = true,
	["npc_metropolice"] = true
}

hook.Add("OnEntityCreated", "ReplaceNPCWeapons", function(entity)
	if CLIENT then return end
    -- 检查生成的实体是否为NPC
    if entity:IsNPC() and ReplacementClass[entity:GetClass()] and GetConVar("ez_swep_replacement"):GetBool() then
		local weapons = {}
		timer.Simple(0, function()
			if !entity:IsValid() then return end
			if !entity:GetActiveWeapon():IsValid() then return end
			local NPCWeapon = entity:GetActiveWeapon():GetClass() or nil
			if NPCWeapon == "weapon_smg1" then
				weapons = { "weapon_ez2_mp5k", "weapon_ez2_mp5k", "weapon_ez2_smg1" }
			elseif NPCWeapon == "weapon_ar2" then
				weapons = { "weapon_ez2_ar2", "weapon_ez2_ar2", "weapon_ez2_ar2_proto" }
			elseif NPCWeapon == "weapon_shotgun" then
				weapons = { "weapon_ez2_shotgun" }
			elseif NPCWeapon == "weapon_pistol" then
				weapons = { "weapon_ez2_pistol", "weapon_ez2_pistol", "weapon_ez2_357" }
			end
			
			if next(weapons) ~= nil then
				local selectedweapon = weapons[math.random(1,#weapons)]
				entity:Give(selectedweapon)
				entity:SelectWeapon(selectedweapon)
			end
		end)
    end
end)

function SendAnim(ply, animation, c)
	local vm=ply:GetViewModel()
	if animation then
		local n=vm:LookupSequence(animation)
		vm:ResetSequence(n)
		vm:ResetSequenceInfo()
		vm:SendViewModelMatchingSequence(n)
	end
	if !c then c=1 end
	vm:SetPlaybackRate(c)
end

local lastCommandTime = 0
local commandCount = 0

concommand.Add( "ez_swep_send_squad", function( ply )
	local currentTime = CurTime()
	-- 检查距离上次指令执行的时间是否小于等于0.5秒
    if currentTime - lastCommandTime <= 0.5 then
        commandCount = commandCount + 1
    else
        commandCount = 1
    end
    
    lastCommandTime = currentTime
	
	if !ply:GetActiveWeapon():IsValid() then return end
	local Weapon = ply:GetActiveWeapon():GetClass()
	if weapons.IsBasedOn(Weapon, "weapon_ez2_base") and (Weapon != "weapon_ez2_pistol_madcop" or Weapon != "weapon_ez2_shotgun_madcop") then
		if commandCount >= 2 then
            SendAnim(ply, "recall") -- 播放 recall 动画
			RunConsoleCommand( "impulse", 50 )
			RunConsoleCommand( "impulse", 50 )
        else
            SendAnim(ply, "send") -- 播放 send 动画
			RunConsoleCommand( "impulse", 50 )
        end
	end
end )
