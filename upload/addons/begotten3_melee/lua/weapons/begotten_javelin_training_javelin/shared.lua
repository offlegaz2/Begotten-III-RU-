SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Javelin

SWEP.PrintName = "Training Javelin"
SWEP.Category = "(Begotten) Javelin"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_javelin"

SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false

SWEP.IronSights = false;
SWEP.CanParry = false;

--Sounds
SWEP.SoundMaterial = "Wooden" -- Metal, Wooden, MetalPierce, Punch, Default
SWEP.AttackSoundTable = "BluntMetalSpearAttackSoundTable" 

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/

SWEP.AttackTable = "TrainingJavelinAttackTable"

SWEP.Primary.Round = ("begotten_javelin_training_javelin_thrown");

SWEP.ConditionLoss = 2;
SWEP.isJavelin = true;

function SWEP:Hitscan()
	return false;
end

function SWEP:AttackAnimination()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self.Owner:GetViewModel():SetPlaybackRate(0.75)
end

function SWEP:CanSecondaryAttack()
	return false;
end

function SWEP:SecondaryAttack()
	return false;
end

function SWEP:HandlePrimaryAttack()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)
	
	--Attack animation
	self:TriggerAnim(self.Owner, "a_javelin_throw");
	
	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
    self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK );
	self.Owner:GetViewModel():SetPlaybackRate(0.8)	
	--self.Weapon:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])])
	--self.Weapon:EmitSound(Sound("Weapon_Knife.Slash"))
	self.Owner:ViewPunch(attacktable["punchstrength"])
	
	self.Weapon:SetNextPrimaryFire(CurTime() + 1000);
	
	timer.Create("javelin_timer_"..self.Owner:EntIndex(), 0.5, 1, function()
		if IsValid(self) and IsValid(self.Owner) and self.Owner:GetActiveWeapon() and self.Owner:GetActiveWeapon().PrintName == "Training Javelin" then
			self:FireJavelin();
		end
	end);
end

function SWEP:FireJavelin()
	if !IsValid(self.Owner) then
		return;
	end

	pos = self.Owner:GetShootPos()
	
	if SERVER then
		local javelin = ents.Create(self.Primary.Round)
		if !javelin:IsValid() then return false end
		
		javelin:SetModel("models/begotten/weapons/training_spear.mdl");
		javelin:SetAngles(self.Owner:GetAimVector():Angle() + Angle(90, 0, 0))
		javelin:SetPos(pos)
		javelin:SetOwner(self.Owner)
		javelin:Spawn()
		javelin.AttackTable = GetTable(self.AttackTable);
		javelin.Owner = self.Owner
		javelin:Activate()
		
		local phys = javelin:GetPhysicsObject()
		
		if self.Owner.GetCharmEquipped and self.Owner:GetCharmEquipped("hurlers_talisman") then
			phys:SetVelocity(self.Owner:GetAimVector() * 1600);
		else
			phys:SetVelocity(self.Owner:GetAimVector() * 1250);
		end
	end
	
	if SERVER and self.Owner:IsPlayer() then
		local anglo = Angle(-10, -5, 0);
		
		self.Owner:ViewPunch(anglo)
		
		local itemTable = Clockwork.item:GetByWeapon(self);
		
		if itemTable then
			if self.Owner.opponent then
				--Clockwork.kernel:ForceUnequipItem(self.Owner, itemTable.uniqueID, itemTable.itemID);
				
				if (itemTable and itemTable.OnPlayerUnequipped and itemTable.HasPlayerEquipped) then
					if (itemTable:HasPlayerEquipped(self.Owner)) then
						itemTable:OnPlayerUnequipped(self.Owner)
						--[[self.Owner:RebuildInventory()
						self.Owner:SetWeaponRaised(false)]]--
					end
				end
				
				if self.Owner.StripWeapon then
					self.Owner:StripWeapon("begotten_javelin_training_javelin");
				end
			else
				self.Owner:TakeItem(itemTable);
			end
		end
	end
end

function SWEP:OnDeploy()
	self.Owner:ViewPunch(Angle(0,1,0))
    self.Weapon:EmitSound("draw/skyrim_bow_draw.mp3")
	
	if timer.Exists("javelin_timer_"..self.Owner:EntIndex()) then
		timer.Remove("javelin_timer_"..self.Owner:EntIndex());
	end
end

function SWEP:TriggerAnim2(target, anim, beginorend)
	return;
end

/*---------------------------------------------------------
	Bone Mods
---------------------------------------------------------*/

SWEP.ViewModelBoneMods = {
	["v_weapon.Knife_Handle"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(14.444, 0, 0) },
	["ValveBiped.Bip01_Spine4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -12.789), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-0.556, 0, 2.407), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-2.3, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0.925), angle = Angle(-56.667, 0, 0) }
}

SWEP.VElements = {
	["v_training_javelin"] = { type = "Model", model = "models/begotten/weapons/training_spear.mdl", bone = "v_weapon.Knife_Handle", rel = "", pos = Vector(0, 0, 2), angle = Angle(12, 0, 0), size = Vector(0.899, 0.899, 0.899), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_training_javelin"] = { type = "Model", model = "models/begotten/weapons/training_spear.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1.5, -32), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}