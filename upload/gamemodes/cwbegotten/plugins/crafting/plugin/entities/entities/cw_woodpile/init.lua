--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.kernel:IncludePrefixed("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

local cwRecipes = cwRecipes;

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_foliage/driftwood_clump_03a.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);
	self.BreakSounds = {"physics/wood/wood_strain2.wav", "physics/wood/wood_strain3.wav", "physics/wood/wood_strain4.wav"};
	
	local physicsObject = self:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		physicsObject:EnableMotion(false);
	end;
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

function ENT:Use(activator, caller)

end;

function ENT:OnTakeDamage(damageInfo)
	local player = damageInfo:GetAttacker();
	
	if IsValid(player) and player:IsPlayer() then
		local activeWeapon = player:GetActiveWeapon();
		
		if (damageInfo:IsDamageType(4) and damageInfo:GetDamage() >= 15) or (activeWeapon and activeWeapon.isHatchet) then
			self:EmitSound(self.BreakSounds[math.random(1, #self.BreakSounds)]);
			
			if !self.woodLeft then
				self.woodLeft = math.random(cwRecipes.minPileItems, 5);
			end
			
			if !self.strikesRequired then
				self.strikesRequired = math.random(10, 20);
			end
			
			if activeWeapon and activeWeapon.isHatchet then
				self.strikesRequired = self.strikesRequired - 2;
			else
				self.strikesRequired = self.strikesRequired - 1;
			end
			
			if cwCharacterNeeds and player.HandleNeed then
				player:HandleNeed("thirst", 0.75);
				player:HandleNeed("sleep", 0.25);
			end
			
			if self.strikesRequired <= 0 then
				local entPos = self:GetPos();
				local itemTable = item.CreateInstance("wood")

				if (itemTable) then
					itemTable:SetCondition(math.random(25, 100), true);
				
					local item = Clockwork.entity:CreateItem(nil, itemTable, Vector(entPos.x, entPos.y, entPos.z + 40));
					
					if IsValid(item) then
						item:Spawn();
						item:EmitSound("physics/wood/wood_plank_break3.wav");
						
						Clockwork.entity:Decay(item, 300);
						item.lifeTime = CurTime() + 300; -- so the item save plugin doesn't save it
					end
				end
				
				if cwBeliefs and player.HandleXP then
					local playerFaction = player:GetFaction();
					
					if playerFaction == "Gatekeeper" then
						player:HandleXP(15);
					else
						player:HandleXP(5);
					end
				end
				
				self.woodLeft = self.woodLeft - 1;
				self.strikesRequired = math.random(5, 10);
			end
			
			if !activeWeapon.isHatchet then
				local weaponItemTable = item.GetByWeapon(activeWeapon);
				
				if weaponItemTable then
					if cwBeliefs then
						if !player:HasBelief("ingenuity_finisher") or weaponItemTable.unrepairable then
							if player:HasBelief("scour_the_rust") then
								weaponItemTable:TakeCondition(0.25);
							else
								weaponItemTable:TakeCondition(0.5);
							end
						end
					else
						weaponItemTable:TakeCondition(0.5);
					end
				end
			end
			
			if self.woodLeft <= 0 then
				Clockwork.chatBox:AddInTargetRadius(player, "it", "The wood pile is reduced to nothing, its resources fully extracted.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
				
				self:Remove();
			end
		end
	end
end

function ENT:OnRemove()
	for category, v in pairs(cwRecipes.Piles) do
		for i, pileTable in ipairs(v) do
			if pileTable.pile == self then
				table.remove(cwRecipes.Piles[category], i);
				
				break;
			end
		end
	end
	
	for category, v in pairs(cwRecipes.pileLocations) do
		for i, location in ipairs(v) do
			if location.occupier == self:EntIndex() then
				cwRecipes.pileLocations[category][i].occupier = nil;
				
				break;
			end
		end
	end
end;