--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

-- Called when the local player's animation is updated.
function cwAnimatedLegs:UpdateAnimation(player, velocity, maxSeqGroundSpeed)
	if (Clockwork.Client == player) then
		if (IsValid(self.LegsEntity)) then
			self:LegsThink(maxSeqGroundSpeed)
		else
			self:CreateLegs()
		end
	end
end

-- Called when the screenspace effects are rendered.
function cwAnimatedLegs:RenderScreenspaceEffects()
	cam.Start3D(EyePos(), EyeAngles())
		if (self:ShouldDrawLegs()) then
			self.RenderPos = Clockwork.Client:GetPos()

			if (!Clockwork.Client:InVehicle()) then
				self.BiasAngles = Clockwork.Client:EyeAngles()
				self.RenderAngle = Angle(0, self.BiasAngles.y, 0)
				self.RadAngle = math.rad(self.BiasAngles.y)
				self.ForwardOffset = -18 + (1 - (math.Clamp(self.BiasAngles.p - 45, 0, 45) / 45) * 7)
				self.RenderPos.x = self.RenderPos.x + math.cos(self.RadAngle) * self.ForwardOffset
				self.RenderPos.y = self.RenderPos.y + math.sin(self.RadAngle) * self.ForwardOffset

				if (Clockwork.Client:GetGroundEntity() == NULL) then
					self.RenderPos.z = self.RenderPos.z + 8

					if (Clockwork.Client:KeyDown(IN_DUCK)) then
						self.RenderPos.z = self.RenderPos.z - 28
					end
				end
			else
				self.RenderAngle = Clockwork.Client:GetVehicle():GetAngles()
				self.RenderAngle:RotateAroundAxis(self.RenderAngle:Up(), 90)
			end

			self.RenderColor = Clockwork.Client:GetColor(true)

			render.EnableClipping(true)
			render.PushCustomClipPlane(self.ClipVector, self.ClipVector:Dot(EyePos()))
			render.SetColorModulation(self.RenderColor.r / 255, self.RenderColor.g / 255, self.RenderColor.b / 255)
			render.SetBlend(self.RenderColor.a / 255)

			self.LegsEntity:SetRenderOrigin(self.RenderPos)
			self.LegsEntity:SetRenderAngles(self.RenderAngle)
			self.LegsEntity:SetupBones()
			self.LegsEntity:DrawModel()
			self.LegsEntity:SetRenderOrigin()
			self.LegsEntity:SetRenderAngles()

			render.SetBlend(1)
			render.SetColorModulation(1, 1, 1)

			hook.Run("PostDrawAnimatedLegs", self.LegsEntity, self.RenderPos, self.RenderAngle)

			render.PopCustomClipPlane()
			render.EnableClipping(false)
		end
	cam.End3D()
end