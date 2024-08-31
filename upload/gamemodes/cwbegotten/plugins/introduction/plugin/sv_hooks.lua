--[[
	Begotten III: Jesus Wept
--]]

intro_enabled = true;

-- Called when a player's data has loaded.
function cwIntroduction:PlayerDataLoaded(player)
	if intro_enabled then
		--[[if (!player:GetData("cwSeenIntro")) then
			netstream.Start(player, "MenuIntro", true);
			player:SetData("cwSeenIntro", true);
		else
			local rand = math.random(2);
			
			if rand == 1 then
				netstream.Start(player, "JesusWeptIntro", true);
			else
				netstream.Start(player, "MenuIntro", true);
			end
		end;]]--
		
		if (!Clockwork.quiz:GetEnabled() or Clockwork.quiz:GetCompleted(player)) then
			--netstream.Start(player, "QuizCompleted", true)
			local rand = math.random(2);
			
			if rand == 1 then
				netstream.Start(player, "JesusWeptIntro", true);
			else
				netstream.Start(player, "MenuIntro", true);
			end
		--else
			--netstream.Start(player, "QuizCompleted", false)
		end
		
		--netstream.Start(player, "JesusWeptIntro", true);
	end
end;

--[[concommand.Add("a", function()
	PrintTable(item.stored)
end);]]--