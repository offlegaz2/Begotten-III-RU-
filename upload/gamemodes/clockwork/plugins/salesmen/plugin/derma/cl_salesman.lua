--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local PANEL = {}

-- Called when the panel is initialized.
function PANEL:Init()
	local salesmanName = Clockwork.salesman:GetName()

	self:SetTitle(salesmanName)
	self:SetBackgroundBlur(true)
	self:SetDeleteOnClose(false)

	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		CloseDermaMenus()
		self:Close() self:Remove()

		netstream.Start("SalesmanAdd", {
			showChatBubble = Clockwork.salesman.showChatBubble,
			buyInShipments = Clockwork.salesman.buyInShipments,
			priceScale = Clockwork.salesman.priceScale,
			factions = Clockwork.salesman.factions,
			subfactions = Clockwork.salesman.subfactions,
			physDesc = Clockwork.salesman.physDesc,
			buyRate = Clockwork.salesman.buyRate,
			--classes = Clockwork.salesman.classes,
			stock = Clockwork.salesman.stock,
			model = Clockwork.salesman.model,
			head = Clockwork.salesman.head,
			sells = Clockwork.salesman.sells,
			cash = Clockwork.salesman.cash,
			text = Clockwork.salesman.text,
			buys = Clockwork.salesman.buys,
			name = Clockwork.salesman.name,
			flags = Clockwork.salesman.flags,
			beliefs = Clockwork.salesman.beliefs
		})

		Clockwork.salesman.priceScale = nil
		Clockwork.salesman.factions = nil
		Clockwork.salesman.subfactions = nil
		--Clockwork.salesman.classes = nil
		Clockwork.salesman.physDesc = nil
		Clockwork.salesman.buyRate = nil
		Clockwork.salesman.stock = nil
		Clockwork.salesman.model = nil
		Clockwork.salesman.head = nil
		Clockwork.salesman.sells = nil
		Clockwork.salesman.buys = nil
		Clockwork.salesman.items = nil
		Clockwork.salesman.text = nil
		Clockwork.salesman.cash = nil
		Clockwork.salesman.name = nil
		Clockwork.salesman.flags = nil
		Clockwork.salesman.beliefs = nil

		gui.EnableScreenClicker(false)
	end

	self.sellsPanel = vgui.Create("cwPanelList")
 	self.sellsPanel:SetPadding(2)
 	self.sellsPanel:SetSpacing(3)
 	self.sellsPanel:SizeToContents()
	self.sellsPanel:EnableVerticalScrollbar()

	self.buysPanel = vgui.Create("cwPanelList")
 	self.buysPanel:SetPadding(2)
 	self.buysPanel:SetSpacing(3)
 	self.buysPanel:SizeToContents()
	self.buysPanel:EnableVerticalScrollbar()

	self.itemsPanel = vgui.Create("cwPanelList")
 	self.itemsPanel:SetPadding(2)
 	self.itemsPanel:SetSpacing(3)
 	self.itemsPanel:SizeToContents()
	self.itemsPanel:EnableVerticalScrollbar()

	self.settingsPanel = vgui.Create("cwPanelList")
 	self.settingsPanel:SetPadding(2)
 	self.settingsPanel:SetSpacing(3)
 	self.settingsPanel:SizeToContents()
	self.settingsPanel:EnableVerticalScrollbar()
	self.settingsPanel.Paint = function(sp, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(200, 200, 200))
	end

	self.settingsForm = vgui.Create("cwForm")
	self.settingsForm:SetPadding(4)
	self.settingsForm:SetName("Settings")

	self.settingsPanel:AddItem(self.settingsForm)

	self.showChatBubble = self.settingsForm:CheckBox("Show chat bubble.");
	self.buyInShipments = self.settingsForm:CheckBox("Buy items in shipments.");
	self.priceScale = self.settingsForm:TextEntry("What amount to scale prices by.");
	self.flagsEntry = self.settingsForm:TextEntry("Required flags for access (separate by -).");
	self.beliefsEntry = self.settingsForm:TextEntry("Required beliefs for access (separate by -).");
	self.physDesc = self.settingsForm:TextEntry("The physical description of the salesman.");
	self.buyRate = self.settingsForm:NumSlider("Buy Rate", nil, 1, 100, 0);
	self.stock = self.settingsForm:NumSlider("Default Stock", nil, -1, 100, 0);
	self.model = self.settingsForm:TextEntry("The model of the salesman.");
	self.head = self.settingsForm:TextEntry("The head model of the salesman.");
	self.cash = self.settingsForm:NumSlider("Starting Cash", nil, -1, 1000000, 0);
	
	self.buyRate:SetToolTip("Percentage of price to keep when selling.");
	self.stock:SetToolTip("The default stock of each item (-1 for infinite stock).");
	self.cash:SetToolTip("Starting cash of the salesman (-1 for infinite cash).");

	self.showChatBubble:SetValue(Clockwork.salesman.showChatBubble == true)
	self.buyInShipments:SetValue(Clockwork.salesman.buyInShipments == true)
	self.priceScale:SetValue(Clockwork.salesman.priceScale)
	self.flagsEntry:SetValue(Clockwork.salesman.flags or "")
	self.beliefsEntry:SetValue(Clockwork.salesman.beliefs or "")
	self.physDesc:SetValue(Clockwork.salesman.physDesc)
	self.buyRate:SetValue(Clockwork.salesman.buyRate)
	self.stock:SetValue(Clockwork.salesman.stock)
	self.model:SetValue(Clockwork.salesman.model)
	self.head:SetValue(Clockwork.salesman.head)
	self.cash:SetValue(Clockwork.salesman.cash)

	self.responsesForm = vgui.Create("cwForm")
	self.responsesForm:SetPadding(4)
	self.responsesForm:SetName("Answers")
	self.settingsForm:AddItem(self.responsesForm)

	self.startText = self.responsesForm:TextEntry("When the player starts trading.");
	self.startSound = self.responsesForm:TextEntry("The sound to play for the above phrase.");
	self.startHideName = self.responsesForm:CheckBox("Hide the salesman's name for the above phrase.");
	
	self.noSaleText = self.responsesForm:TextEntry("When the player cannot trade with them.");
	self.noSaleSound = self.responsesForm:TextEntry("The sound to play for the above phrase.");
	self.noSaleHideName = self.responsesForm:CheckBox("Hide the salesman's name for the above phrase.");

	self.noStockText = self.responsesForm:TextEntry("When the salesman does not have an item in stock.");
	self.noStockSound = self.responsesForm:TextEntry("The sound to play for the above phrase.");
	self.noStockHideName = self.responsesForm:CheckBox("Hide the salesman's name for the above phrase.");

	self.needMoreText = self.responsesForm:TextEntry("When the player cannot afford the item.");
	self.needMoreSound = self.responsesForm:TextEntry("The sound to play for the above phrase.");
	self.needMoreHideName = self.responsesForm:CheckBox("Hide the salesman's name for the above phrase.");

	self.cannotAffordText = self.responsesForm:TextEntry("When the salesman cannot afford the item.");
	self.cannotAffordSound = self.responsesForm:TextEntry("The sound to play for the above phrase.");
	self.cannotAffordHideName = self.responsesForm:CheckBox("Hide the salesman's name for the above phrase.")

	self.doneBusinessText = self.responsesForm:TextEntry("When the player is done doing trading.");
	self.doneBusinessSound = self.responsesForm:TextEntry("The sound to play for the above phrase.");
	self.doneBusinessHideName = self.responsesForm:CheckBox("Hide the salesman's name for the above phrase.")

	Clockwork.salesman.text.start = Clockwork.salesman.text.start or {};
	
	self.startText:SetValue(Clockwork.salesman.text.start.text or "How can I help you today?");
	self.startSound:SetValue(Clockwork.salesman.text.start.sound or "");

	self.startHideName:SetValue(Clockwork.salesman.text.start.bHideName == true);

	self.noSaleText:SetValue(Clockwork.salesman.text.noSale.text or "I cannot trade my inventory with you!");
	self.noSaleSound:SetValue(Clockwork.salesman.text.noSale.sound or "");

	self.noSaleHideName:SetValue(Clockwork.salesman.text.noSale.bHideName == true);

	self.noStockText:SetValue(Clockwork.salesman.text.noStock.text or "I do not have that item in stock!");
	self.noStockSound:SetValue(Clockwork.salesman.text.noStock.sound or "");

	self.noStockHideName:SetValue(Clockwork.salesman.text.noStock.bHideName == true);
	
	self.needMoreText:SetValue(Clockwork.salesman.text.needMore.text or "You cannot afford to buy that from me!");
	self.needMoreSound:SetValue(Clockwork.salesman.text.needMore.sound or "");

	self.needMoreHideName:SetValue(Clockwork.salesman.text.needMore.bHideName == true);

	self.cannotAffordText:SetValue(Clockwork.salesman.text.cannotAfford.text or "I cannot afford to buy that item from you!");
	self.cannotAffordSound:SetValue(Clockwork.salesman.text.cannotAfford.sound or "");

	self.cannotAffordHideName:SetValue(Clockwork.salesman.text.cannotAfford.bHideName == true);

	self.doneBusinessText:SetValue(Clockwork.salesman.text.doneBusiness.text or "Thanks for doing business, see you soon!");
	self.doneBusinessSound:SetValue(Clockwork.salesman.text.doneBusiness.sound or "");

	self.doneBusinessHideName:SetValue(Clockwork.salesman.text.doneBusiness.bHideName == true);

	self.factionsForm = vgui.Create("DForm");
	self.factionsForm:SetPadding(4);
	self.factionsForm:SetName("Factions");
	self.settingsForm:AddItem(self.factionsForm);
	self.factionsForm:Help("Leave these unchecked to allow all factions to buy and sell.");
	
	self.subfactionsForm = vgui.Create("DForm");
	self.subfactionsForm:SetPadding(4);
	self.subfactionsForm:SetName("Subfactions");
	self.settingsForm:AddItem(self.subfactionsForm);
	self.subfactionsForm:Help("Leave these unchecked to allow all subfactions to buy and sell.");
	
	--[[self.classesForm = vgui.Create("DForm");
	self.classesForm:SetPadding(4);
	self.classesForm:SetName("Classes");
	self.settingsForm:AddItem(self.classesForm);
	self.classesForm:Help("Leave these unchecked to allow all classes to buy and sell.");]]--

	--self.classBoxes = {}
	self.factionBoxes = {}
	self.subfactionBoxes = {}

	for k, v in SortedPairs(Clockwork.faction:GetStored()) do
		self.factionBoxes[k] = self.factionsForm:CheckBox(v.name)
		self.factionBoxes[k].OnChange = function(checkBox)
			if (checkBox:GetChecked()) then
				Clockwork.salesman.factions[k] = true
			else
				Clockwork.salesman.factions[k] = nil
			end
		end

		if (Clockwork.salesman.factions[k]) then
			self.factionBoxes[k]:SetValue(true)
		end
		
		local subfactions = v.subfactions;
		
		if subfactions then
			for k2, v2 in ipairs(subfactions) do
				self.subfactionBoxes[v2.name] = self.subfactionsForm:CheckBox(v2.name);
				self.subfactionBoxes[v2.name].OnChange = function(checkBox)
					if (checkBox:GetChecked()) then
						Clockwork.salesman.subfactions[v2.name] = true
					else
						Clockwork.salesman.subfactions[v2.name] = nil
					end
				end
				
				if (Clockwork.salesman.subfactions[v2.name]) then
					self.subfactionBoxes[v2.name]:SetValue(true)
				end
			end
		end
	end

	--[[for k, v in SortedPairs(Clockwork.class:GetStored()) do
		self.classBoxes[k] = self.classesForm:CheckBox(v.name)
		self.classBoxes[k].OnChange = function(checkBox)
			if (checkBox:GetChecked()) then
				Clockwork.salesman.classes[k] = true
			else
				Clockwork.salesman.classes[k] = nil
			end
		end

		if (Clockwork.salesman.classes[k]) then
			self.classBoxes[k]:SetValue(true)
		end
	end]]--

	self.propertySheet = vgui.Create("DPropertySheet", self);
		self.propertySheet:SetPadding(4);
		self.propertySheet:AddSheet("Sells", self.sellsPanel, "icon16/box.png", nil, nil, "View items that "..salesmanName.." sells.");
		self.propertySheet:AddSheet("Buys", self.buysPanel, "icon16/add.png", nil, nil, "View items that "..salesmanName.." buys.");
		self.propertySheet:AddSheet("Items", self.itemsPanel, "icon16/application_view_tile.png", nil, nil, "View possible items for trading.");
		self.propertySheet:AddSheet("Settings", self.settingsPanel, "icon16/tick.png", nil, nil, "View possible items for trading.");
	Clockwork.kernel:SetNoticePanel(self);
end

-- A function to rebuild a panel.
function PANEL:RebuildPanel(panelList, typeName, inventory)
	panelList:Clear(true)
	panelList.typeName = typeName
	panelList.inventory = inventory

	local categories = {}
	local items = {}

	for k, v in SortedPairs(panelList.inventory) do
		local itemTable = item.FindByID(k)

		if (itemTable) then
			local category = itemTable.category

			if (category) then
				items[category] = items[category] or {}
				items[category][#items[category] + 1] = {k, v}
			end
		end
	end

	for k, v in SortedPairs(items) do
		categories[#categories + 1] = {
			category = k,
			items = v
		}
	end

	if (table.Count(categories) > 0) then
		for k, v in SortedPairs(categories) do
			local collapsibleCategory = Clockwork.kernel:CreateCustomCategoryPanel(v.category, panelList)
				collapsibleCategory:SetCookieName("Salesman"..typeName..v.category)
			panelList:AddItem(collapsibleCategory)

			local categoryList = vgui.Create("DPanelList", collapsibleCategory)
				categoryList:EnableHorizontal(true)
				categoryList:SetAutoSize(true)
				categoryList:SetPadding(4)
				categoryList:SetSpacing(4)
			collapsibleCategory:SetContents(categoryList)

			table.sort(v.items, function(a, b)
				local itemTableA = item.FindByID(a[1])
				local itemTableB = item.FindByID(b[1])

				return itemTableA.cost < itemTableB.cost
			end)

			for k2, v2 in SortedPairs(v.items) do
				CURRENT_ITEM_DATA = {
					itemTable = item.FindByID(v2[1]),
					typeName = typeName
				}

				categoryList:AddItem(
					vgui.Create("cwSalesmanItem", categoryList)
				)
			end
		end
	end
end

-- A function to rebuild the panel.
function PANEL:Rebuild()
	self:RebuildPanel(self.sellsPanel, "Sells",
		Clockwork.salesman:GetSells()
	)

	self:RebuildPanel(self.buysPanel, "Buys",
		Clockwork.salesman:GetBuys()
	)

	self:RebuildPanel(self.itemsPanel, "Items",
		Clockwork.salesman:GetItems()
	)
end

-- Called each frame.
function PANEL:Think()
	self:SetSize(ScrW() * 0.5, ScrH() * 0.75)
	self:SetPos((ScrW() / 2) - (self:GetWide() / 2), (ScrH() / 2) - (self:GetTall() / 2))

	Clockwork.salesman.text.doneBusiness = {
		text = self.doneBusinessText:GetValue(),
		bHideName = (self.doneBusinessHideName:GetChecked() == true),
		sound = self.doneBusinessSound:GetValue()
	}
	Clockwork.salesman.text.cannotAfford = {
		text = self.cannotAffordText:GetValue(),
		bHideName = (self.cannotAffordHideName:GetChecked() == true),
		sound = self.cannotAffordSound:GetValue()
	}
	Clockwork.salesman.text.needMore = {
		text = self.needMoreText:GetValue(),
		bHideName = (self.needMoreHideName:GetChecked() == true),
		sound = self.needMoreSound:GetValue()
	}
	Clockwork.salesman.text.noStock = {
		text = self.noStockText:GetValue(),
		bHideName = (self.noStockHideName:GetChecked() == true),
		sound = self.noStockSound:GetValue()
	}
	Clockwork.salesman.text.noSale = {
		text = self.noSaleText:GetValue(),
		bHideName = (self.noSaleHideName:GetChecked() == true),
		sound = self.noSaleSound:GetValue()
	}
	Clockwork.salesman.text.start = {
		text = self.startText:GetValue(),
		bHideName = (self.startHideName:GetChecked() == true),
		sound = self.startSound:GetValue()
	}
	Clockwork.salesman.showChatBubble = (self.showChatBubble:GetChecked() == true)
	Clockwork.salesman.buyInShipments = (self.buyInShipments:GetChecked() == true)
	Clockwork.salesman.physDesc = self.physDesc:GetValue()
	Clockwork.salesman.buyRate = self.buyRate:GetValue()
	Clockwork.salesman.stock = self.stock:GetValue()
	Clockwork.salesman.model = self.model:GetValue()
	Clockwork.salesman.head = self.head:GetValue()
	Clockwork.salesman.cash = self.cash:GetValue()

	local priceScale = self.priceScale:GetValue()
	Clockwork.salesman.priceScale = tonumber(priceScale) or 1

	Clockwork.salesman.flags = self.flagsEntry:GetValue() or ""
	Clockwork.salesman.beliefs = self.beliefsEntry:GetValue() or ""
end

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	DFrame.PerformLayout(self)

	if (self.propertySheet) then
		self.propertySheet:StretchToParent(4, 28, 4, 4)
	end
end

vgui.Register("cwSalesman", PANEL, "DFrame")

local PANEL = {}

-- Called when the panel is initialized.
function PANEL:Init()
	local itemData = self:GetParent().itemData or CURRENT_ITEM_DATA
	self.itemTable = itemData.itemTable
	self.typeName = itemData.typeName
	
	local model, skin = item.GetIconInfo(self.itemTable)
	
	self:SetSize(64, 64);
	
	if self.itemTable.iconoverride then
		self.spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("DImageButton", self));
		self.spawnIcon:SetImage(self.itemTable.iconoverride);
		self.spawnIcon:SetSize(64, 64);
		self.spawnIcon.isSpawnIcon = false;
		
		function self.spawnIcon.DoRightClick(spawnIcon)
			if (itemData.OnPress) then
				itemData.OnPress();
				return;
			end;
			
			Clockwork.kernel:HandleItemSpawnIconRightClick(self.itemTable, spawnIcon);
		end;
	else
		self.spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwSpawnIcon", self));
		self.spawnIcon:SetModel(model, skin);
		self.spawnIcon:SetSize(64, 64);
		self.spawnIcon.isSpawnIcon = true;
	end
	
	self.spawnIcon:SetItemTable(self.itemTable);

	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		if (self.typeName == "Items") then
			if (config.Get("cash_enabled"):Get()) then
				local cashName = Clockwork.option:GetKey("name_cash");

				Clockwork.kernel:AddMenuFromData(nil, {
					["Buys"] = function()
						Derma_StringRequest(cashName, "How much do you want the item to be bought for?", "", function(text)
							Clockwork.salesman.buys[self.itemTable.uniqueID] = tonumber(text) or true;
							Clockwork.salesman:GetPanel():Rebuild();
						end);
					end,
					["Sells"] = function()
						Derma_StringRequest(cashName, "How much do you want the item to sell for?", "", function(text)
							Clockwork.salesman.sells[self.itemTable.uniqueID] = tonumber(text) or true;
							Clockwork.salesman:GetPanel():Rebuild();
						end);
					end,
					["Both"] = function()
						Derma_StringRequest(cashName, "How much do you want the item to sell for?", "", function(sellPrice)
							Derma_StringRequest(cashName, "How much do you want the item to be bought for?", "", function(buyPrice)
								Clockwork.salesman.sells[self.itemTable.uniqueID] = tonumber(sellPrice) or true;
								Clockwork.salesman.buys[self.itemTable.uniqueID] = tonumber(buyPrice) or true;
								Clockwork.salesman:GetPanel():Rebuild();
							end);
						end);
					end
				});
			else
				Clockwork.kernel:AddMenuFromData(nil, {
					["Buys"] = function()
						Clockwork.salesman.buys[self.itemTable.uniqueID] = true;
						Clockwork.salesman:GetPanel():Rebuild();
					end,
					["Sells"] = function()
						Clockwork.salesman.sells[self.itemTable.uniqueID] = true;
						Clockwork.salesman:GetPanel():Rebuild();
					end,
					["Both"] = function()
						Clockwork.salesman.sells[self.itemTable.uniqueID] = true;
						Clockwork.salesman.buys[self.itemTable.uniqueID] = true;
						Clockwork.salesman:GetPanel():Rebuild();
					end
				});
			end;
		elseif (self.typeName == "Sells") then
			Clockwork.salesman.sells[self.itemTable.uniqueID] = nil
			Clockwork.salesman:GetPanel():Rebuild()
		elseif (self.typeName == "Buys") then
			Clockwork.salesman.buys[self.itemTable.uniqueID] = nil
			Clockwork.salesman:GetPanel():Rebuild()
		end
	end

	self.spawnIcon:SetModel(model, skin)
	--self.spawnIcon:SetTooltip("")
	self.spawnIcon:SetSize(64, 64)
end

-- Called each frame.
function PANEL:Think()
	local function DisplayCallback(displayInfo)
		local priceScale = 1
		local amount = 0

		if (Clockwork.salesman:BuyInShipments()) then
			amount = self.itemTable.batch
		else
			amount = 1
		end

		if (self.typeName == "Sells") then
			priceScale = Clockwork.salesman:GetPriceScale()
		elseif (self.typeName == "Buys") then
			priceScale = Clockwork.salesman:GetBuyRate() / 100
		end

		if (config.Get("cash_enabled"):Get()) then
			if (self.itemTable.cost != 0) then
				displayInfo.weight = Clockwork.kernel:FormatCash(
					(self.itemTable.cost * priceScale) * math.max(amount, 1)
				)
			else
				displayInfo.weight = "Free"
			end

			local overrideCash = Clockwork.salesman.sells[self.itemTable.uniqueID]

			if (self.typeName == "Buys") then
				overrideCash = Clockwork.salesman.buys[self.itemTable.uniqueID]
			end

			if (type(overrideCash) == "number") then
				displayInfo.weight = Clockwork.kernel:FormatCash(overrideCash * math.max(amount, 1))
			end
		end

		if (amount > 1) then
			displayInfo.name = amount.." x "..self.itemTable.name
		else
			displayInfo.name = self.itemTable.name
		end

		if (self.typeName == "Sells" and Clockwork.salesman.stock != -1) then
			displayInfo.itemTitle = "["..Clockwork.salesman.stock.."] ["..displayInfo.name..", "..displayInfo.weight.."]"
		end
	end
	
	if Clockwork.salesman.sells then
		local overrideCash = Clockwork.salesman.sells[self.itemTable.uniqueID];
		
		if self.typeName == "Buys" then
			overrideCash = Clockwork.salesman.buys[self.itemTable.uniqueID];
		end
		
		if overrideCash and (type(overrideCash) == "number") and overrideCash > 0 then
			if !IsValid(self.spawnIcon.cost) then
				self.spawnIcon.cost = vgui.Create("DLabel", self.spawnIcon);
			end
			
			self.spawnIcon.cost:SetText("₵"..overrideCash);
			self.spawnIcon.cost:SetFont("Decay_FormText");
			
			if self.typeName == "Sells" then
				if overrideCash > Clockwork.player:GetCash() then
					self.spawnIcon.cost:SetTextColor(Color(200, 0, 0));
				else
					self.spawnIcon.cost:SetTextColor(Color(0, 200, 0));
				end
			elseif self.typeName == "Buys" then
				if overrideCash > Clockwork.salesman:GetCash() then
					self.spawnIcon.cost:SetTextColor(Color(200, 0, 0));
				else
					self.spawnIcon.cost:SetTextColor(Color(0, 200, 0));
				end
			end
			
			self.spawnIcon.cost:SizeToContents();
			self.spawnIcon.cost:SetPos(4, 46);
		elseif self.spawnIcon and self.spawnIcon.cost then
			self.spawnIcon.cost:Remove();
		end
	end

	--[[self.spawnIcon:SetMarkupToolTip(
		item.GetMarkupToolTip(self.itemTable, true, DisplayCallback)
	)
	self.spawnIcon:SetColor(self.itemTable.color)]]--
end

vgui.Register("cwSalesmanItem", PANEL, "DPanel")