	do
		local Antis = tbl15.Invincibility:AddLeftGroupbox("Antis", "brick-wall-shield")

		Antis:AddToggle("AntiGrab", {
			Text = "Anti Grab",
			Default = false,
			Tooltip = "The most default anti-grab",
			Callback = function(antiGrab)
				tbl8.AntiGrab = antiGrab
				tbl12.AntiGrab()
			end,
		})

		Antis:AddToggle("GucciAntiGrab", {
			Text = "[GUCCI] Anti Grab",
			Default = false,
			Tooltip = "Can't be touched.",
			Callback = function(arg)
				tbl12.SetGucciAntiGrab(arg)
			end,
		}):AddKeyPicker("GucciK", {
			Text = "[GUCCI] Anti Grab",
			Default = nil,
			Mode = "Toggle",
			NoUI = false,
			SyncToggleState = true,
		})

		Antis:AddToggle("AntiBlobman", {
			Text = "Anti Blobman",
			Default = false,
			Tooltip = "People can't grab you using Blobman",
			Callback = function(arg)
				tbl12.SetRuntimeToggle("AntiBlobman", arg)
			end,
		})

		Antis:AddToggle("AntiInputLag", {
			Text = "Anti Network Ownership",
			Default = false,
			Tooltip = "Anti Blob-kill, etc.",
			Callback = function(arg)
				tbl12.SetRuntimeToggle("AntiInputLag", arg)
			end,
		}):AddKeyPicker("AntiNetK", {
			Text = "Anti Network Ownership",
			Default = nil,
			Mode = "Toggle",
			NoUI = false,
			SyncToggleState = true,
		})

		Antis:AddToggle("AntiExplosion", {
			Text = "Anti Explosion",
			Default = false,
			Tooltip = "Makes you not able to be exploded",
			Callback = function(antiExplosion)
				tbl8.AntiExplosion = antiExplosion
			end,
		})

		Antis:AddToggle("AntiBurn", {
			Text = "Anti Burn",
			Default = false,
			Tooltip = "Makes you not able to be burnt",
			Callback = function(antiBurn)
				tbl8.AntiBurn = antiBurn
			end,
		})

		Antis:AddToggle("AntiVoid", {
			Text = "Anti Void",
			Default = false,
			Tooltip = "Teleports you up if you go far down into the void",
			Callback = function(arg)
				tbl12.SetRuntimeToggle("AntiVoid", arg)
			end,
		})

		Antis:AddToggle("AntiKick", {
			Text = "Anti Kick",
			Default = false,
			Tooltip = "Default shuriken anti-kick",
			Callback = function(arg)
				tbl12.SetRuntimeToggle("AntiKick", arg)
				tbl12.WakeRuntimeGate("PCLDTracking")
			end,
		})

		Antis:AddToggle("AntiKick2", {
			Text = "[Break PCLD] Anti Kick",
			Default = false,
			Tooltip = "Unable to get kicked at all",
			Callback = function(arg)
				tbl12.SetRuntimeToggle("AntiKick2", arg)
			end,
		})

		Antis:AddToggle("AntiSticky", {
			Text = "Anti Sticky",
			Default = false,
			Tooltip = "Protects your character from sticky toys",
			Callback = function(antiSticky)
				tbl8.AntiSticky = antiSticky

				task.spawn(function()
					while tbl8.AntiSticky and task.wait(0.1) do
						local v20 = tbl12.Char()

						if v20 then
							for _, v21 in pairs(v20:QueryDescendants("BasePart")) do
								for _, v22 in pairs(v21:GetConnectedParts()) do
									if not (v22.Name ~= "StickyPart" or v22:IsDescendantOf(v17) or v22:IsDescendantOf(workspace.PlotItems) and not localPlayer.InOwnedPlot.Value) then
										for _, child in pairs(v22:GetChildren()) do
											if child:IsA("TouchInterest") then
												child:Destroy()
											end
										end

										local parent2 = v22.Parent

										if parent2 then
											local v23 = tbl12.FindNicePart(parent2)

											if v23 then
												tbl12.Grab(v23)
											end
										end
									end
								end
							end
						end
					end
				end)
			end,
		})

		Antis:AddToggle("AntiSnowball", {
			Text = "Anti Snowball",
			Default = false,
			Tooltip = "Prevents you from getting snowballed",
			Callback = function(arg)
				tbl12.SetRuntimeToggle("AntiSnowball", arg)

				if not arg then
					local v20 = tbl12.Char()
					if not v20 then
						return
					end
					tbl12.ToggleCollisions(v20, true)
				end
			end,
		})

		Antis:AddToggle("AntiBanana", {
			Text = "Anti Banana",
			Default = false,
			Tooltip = "Bananas won't touch you",
			Callback = function(arg)
				tbl12.SetRuntimeToggle("AntiBanana", arg)
			end,
		})

		Antis:AddToggle("AntiPaint", {
			Text = "Anti Paint",
			Default = false,
			Tooltip = "You won't get painted",
			Callback = function(antiPaint)
				tbl8.AntiPaint = antiPaint

				task.spawn(function()
					local tbl16 = {}

					local function fn21(descendant)
						if descendant:IsA("BasePart") and descendant.Name == "PaintPlayerPart" then
							descendant.CanTouch = not antiPaint

							if antiPaint then
								tbl16[descendant] = descendant:GetPropertyChangedSignal("CanTouch"):Connect(function()
									if not tbl8.AntiPaint then
										return
									end
									descendant.CanTouch = false
								end)
							end
						end
					end

					for _, v20 in pairs(workspace:QueryDescendants("BasePart#PaintPlayerPart")) do
						fn21(v20)
					end

					if antiPaint then
						local connection = workspace.DescendantAdded:Connect(fn21)

						repeat
							task.wait()
						until not tbl8.AntiPaint

						connection:Disconnect()

						for _, v20 in pairs(tbl16) do
							v20:Disconnect()
						end
					end
				end)
			end,
		})

		Antis:AddToggle("AntiPoison", {
			Text = "Anti Poison",
			Default = false,
			Tooltip = "Poison parts won't kill you",
			Callback = function(arg)
				local hole = map:FindFirstChild("Hole")
				local poisonBigHole = hole and hole:FindFirstChild("PoisonBigHole")
				hole = hole and hole:FindFirstChild("PoisonSmallHole")

				for _, v20 in pairs({ poisonBigHole, hole }) do
					if v20 then
						local poisonHurtPart = v20:FindFirstChild("PoisonHurtPart")
						local paintPlayerPart = v20:FindFirstChild("PaintPlayerPart")

						if poisonHurtPart then
							poisonHurtPart.CanTouch = not arg
						end

						if paintPlayerPart then
							paintPlayerPart.CanTouch = not arg
						end
					end
				end
			end,
		})

		Antis:AddToggle("AntiLag", {
			Text = "Anti Lag",
			Default = false,
			Tooltip = "Anti Line-Lag & Sticky-Lag",
			Callback = function(arg)
				local enabled = not arg
				if enabled and tbl7.LookFigures.Enabled then
					toggles.AntiLag:SetValue(true)
					return
				end
				localPlayer.PlayerScripts.CharacterAndBeamMove.Enabled = enabled
				localPlayer.PlayerScripts.StickyPartsTouchDetection.Enabled = enabled
				tbl12.SetAntiShurikenLag(arg)

				if arg then
					task.delay(1.5, function()
						if flag11 or not toggles.AntiLag.Value then
							return
						end

						for _, v20 in pairs(tbl7.PlayerList) do
							local v21 = tbl12.Char(v20)

							if v21 then
								for _, child in pairs(v21:GetChildren()) do
									if child.Name == "GrabParts" then
										child:Destroy()
									end
								end
							end
						end
					end)
				end
			end,
		}):AddKeyPicker("AntiLagK", { Text = "Anti Lag", Default = nil, Mode = "Toggle", NoUI = false, SyncToggleState = true })

		Antis:AddToggle("AutoAntiLag", {
			Text = "Auto Anti Lag",
			Default = true,
			Tooltip = "Enables anti-lag for you if too low fps",
			Callback = function(autoAntiLag)
				tbl8.AutoAntiLag = autoAntiLag
			end,
		})

		Antis:AddToggle("AntiInvis", {
			Text = "Anti Invis",
			Default = false,
			Tooltip = "Makes any invisible players visible",
			Callback = function()
				task.spawn(function()
					while toggles.AntiInvis and toggles.AntiInvis.Value do
						for _, v20 in tbl7.PlayerList, nil, nil do
							if v20 ~= localPlayer then
								local v21, v22, v23 = tbl12.Char(v20)

								if v22 then
									v22.Massless = false
								end

								if v23 and v23.Sit and v23.SeatPart then
									local seatPart = v23.SeatPart
									local seatWeld = seatPart:FindFirstChild("SeatWeld")

									if seatPart.Parent and seatWeld and not seatWeld.Enabled then
										seatWeld.Enabled = true
									end
								end
							end
						end

						task.wait(0.1)
					end
				end)
			end,
		})

		Antis:AddToggle("AutoReset", {
			Text = "Auto Reset",
			Default = true,
			Tooltip = "Checks for kick frame and resets when needed",
			Callback = function(autoReset)
				tbl8.AutoReset = autoReset
			end,
		})

		Antis:AddToggle("LoopTP", {
			Text = "Loop TP",
			Default = false,
			Tooltip = "Teleports you infinitely so you're unable to be grabbed",
			Callback = function(loopTP)
				tbl8.LoopTP = loopTP

				task.spawn(function()
					local v20
					v20, v20 = tbl12.Char()
					local cFrame2

					if v20 then
						cFrame2 = v20.CFrame
					else
						cFrame2 = CFrame.new(0, -5, 0)
					end

					while tbl8.LoopTP and fn20(0.04) do
						local v21 = tbl12.Char()

						if v21 then
							local random = math.random
							local cframe = CFrame.new(math.random(-1000, 1000), -7.35, random(-1000, 1000))
							tbl12.PivotTo(v21, cframe)
						end
					end

					local v21 = tbl12.Char()

					if v21 then
						tbl12.PivotTo(v21, cFrame2)
					end
				end)
			end,
		})
	end

	do
		local Miscellaneous = tbl15.Invincibility:AddRightGroupbox("Miscellaneous", "bolt")

		Miscellaneous:AddToggle("DisblVoid", {
			Text = "Disable Void",
			Default = true,
			Tooltip = "Makes you not get killed in void",
			DisabledTooltip = "This function is currently being managed by another function.",
			Callback = function(destroyVoid)
				tbl8.DestroyVoid = destroyVoid

				if destroyVoid then
					workspace.FallenPartsDestroyHeight = (0/0)
				else
					workspace.FallenPartsDestroyHeight = -100
				end
			end,
		})

		Miscellaneous:AddToggle("WaterWalk", {
			Text = "Water Walk",
			Default = false,
			Tooltip = "Walk on water",
			Callback = function(arg)
				for _, child in pairs(alwaysHereTweenedObjects.Ocean.Object.ObjectModel:GetChildren()) do
					local tbl16 = tbl7.WaterPartStates[child]

					if arg and not tbl16 then
						tbl16 = { child.CanCollide, child.Transparency }
						tbl7.WaterPartStates[child] = tbl16
					end

					if arg then
						child.CanCollide = true

						if child.Transparency ~= 1 and tbl16[2] ~= 1 then
							child.Transparency = 0.5
						end
					elseif tbl16 then
						child.CanCollide = tbl16[1]
						local transparency

						if toggles.CustomWaterT and toggles.CustomWaterT.Value then
							transparency = 1
						else
							transparency = tbl16[2]
						end

						child.Transparency = transparency

						if not (toggles.CustomWaterT and toggles.CustomWaterT.Value) then
							tbl7.WaterPartStates[child] = nil
						end
					end
				end
			end,
		})

		Miscellaneous:AddToggle("DeleteBarriers", {
			Text = "Noclip Barrier",
			Default = false,
			Callback = function(arg)
				local plots = workspace:FindFirstChild("Plots")
				if not plots then
					return
				end

				for _, child in ipairs(plots:GetChildren()) do
					local barrier = child:FindFirstChild("Barrier")

					if barrier then
						for _, child2 in ipairs(barrier:GetChildren()) do
							if child2:IsA("BasePart") and child2.Name == "PlotBarrier" then
								child2.CanCollide = not arg
							end
						end
					end
				end
			end,
		})

		Miscellaneous:AddToggle("OtherInvCollisions", {
			Text = "Anti-Fling [Objects Noclip]",
			Default = false,
			Callback = function(arg)
				if arg then
					task.spawn(function()
						while task.wait(0.1) and toggles.OtherInvCollisions.Value and not flag11 do
							for _, v20 in tbl12.Char():QueryDescendants("BasePart") do
								PhysicsService:SetPartCollisionGroup(v20, "PlotPlayers")
							end
						end

						for _, v20 in tbl12.Char():QueryDescendants("BasePart") do
							local v21 = PhysicsService
							local setPartCollisionGroup = v21.SetPartCollisionGroup
							local str5

							if not localPlayer.InOwnedPlot.Value then
								str5 = "Players"
							else
								str5 = "PlotPlayers"
							end

							setPartCollisionGroup(v21, v20, str5)
						end
					end)
				end
			end,
		})

		local LastGrabbedLabel = Miscellaneous:AddLabel("LastGrabbedLabel", { Text = "Last person who grabbed you: nobody", DoesWrap = true })

		tbl12.UpdateLastGrabbedLabel = function()
			LastGrabbedLabel:SetVisible(tbl9.WhoGrabbed ~= nil)

			if tbl9.WhoGrabbed then
				LastGrabbedLabel:SetText("Last person who grabbed you: " .. tbl9.WhoGrabbed)
			end
		end
	end

	tbl12.UpdateLastGrabbedLabel()

	do
		local v20 = tbl15.Invincibility:AddLeftGroupbox("Counter-attack", "airplay")

		v20:AddDropdown("CADropdown", {
			Values = { "Grab", "Kill", "Void", "Delete Limbs", "Fling", "Teleport to Spawn", "Anchor" },
			Default = "Kill",
			Multi = false,
			Text = "Consequences",
			Tooltip = "What will you do when someone touches you and you have Counter-attack on",
			Callback = function(counterMethod)
				tbl9.CounterMethod = counterMethod
			end,
		})

		v20:AddToggle("CAToggle", {
			Text = "Counter Attack",
			Default = false,
			Tooltip = "People who touch you will have the selected consequences",
			Callback = function(counterAttack)
				tbl8.CounterAttack = counterAttack
			end,
		})

		local v21 = v20:AddDependencyBox()
		v21:SetupDependencies({ { options.CADropdown, "Delete Limbs" } })
		v21:AddDivider("Delete Limb Settings")

		v21:AddDropdown("deleteLimbsCounterBoxDropdown", {
			Values = { "Legs", "Arms", "All" },
			Default = 3,
			Multi = false,
			Searchable = true,
			Text = "Limbs to delete",
			Tooltip = "What limbs will you delete",
			Callback = function(targetedLimbCA)
				tbl9.TargetedLimbCA = targetedLimbCA
			end,
		})
	end

	do
		local Config = tbl15.Invincibility:AddRightGroupbox("Config", "settings")

		Config:AddSlider("AntiLagSens", {
			Text = "Auto Anti-Lag Sensitivity",
			Default = 3,
			Min = 1,
			Max = 20,
			Suffix = " FPS",
			Callback = function(antiLagSens)
				tbl9.AntiLagSens = antiLagSens
			end,
		})

		Config:AddDivider("Auto Reset")

		Config:AddToggle("AutoLeave", {
			Text = "Auto Leave",
			Default = true,
			Tooltip = "Leaves after four detected kick flags instead of continuing to reset",
			Callback = function(autoLeave)
				tbl8.AutoLeave = autoLeave
			end,
		})

		Config:AddDivider("Anti-Grabs")

		Config:AddDropdown("AGTDropdown", {
			Values = { "Normal", "No Ragdoll", "Anti-Kill", "Escapes Anything, but buggy" },
			Default = 1,
			Multi = false,
			Text = "Anti-Grab Type",
			Tooltip = "Type of default Anti-Grab",
			Callback = function(agType)
				tbl9.AGType = agType
			end,
		})

		Config:AddDropdown("GTDropdown", {
			Values = { "Blobman", "Tractor [Invisible]", "Train [Invisible]", "Sleigh [Invisible]" },
			Default = 1,
			Multi = false,
			Text = "GUCCI Type",
			Tooltip = "What vehicle will you sit on during Gucci Anti Grab",
			Callback = function(arg)
				if arg == "Blobman" then
					tbl9.GucciType = "CreatureBlobman"
				elseif arg == "Tractor [Invisible]" then
					tbl9.GucciType = "TractorGreen"
				elseif arg == "Train [Invisible]" then
					tbl9.GucciType = "Train"
				elseif arg == "Sleigh [Invisible]" then
					tbl9.GucciType = "SantaSleigh"
				end
			end,
		})

		Config:AddDivider("Anti Net-Owner")

		Config:AddDropdown("AITDropdown", {
			Values = {
				"FoodHamburger",
				"InstrumentDrumBongos",
				"InstrumentBrassTrumpet",
				"InstrumentBrassBugle",
				"InstrumentVoiceMicrophone",
				"InstrumentWoodwindOcarina",
				"InstrumentGuitarUkulele",
				"InstrumentGuitarLyre",
				"InstrumentGuitarBanjo",
				"InstrumentGuitarAcoustic",
				"CupMugBrown",
				"CupMugWhite",
				"FoodBanana",
				"FoodBread",
				"FoodBroccoli",
				"FoodCakePink",
				"FoodCoconut",
				"FoodDippyEgg",
				"FoodDonut",
				"FoodFrenchFries",
				"FoodHotdog",
				"FoodMayonnaise",
				"FoodMeatStick",
				"FoodMushroomPoison",
				"FoodPizzaCheese",
				"FoodPizzaPepperoni",
				"FoodSodaCan",
				"PoopPile",
				"PoopPileSparkle",
			},
			Default = 1,
			Multi = false,
			Text = "Type",
			Tooltip = "What interactable item will you use when doing anti-Net Owner",
			Callback = function(antiInputType)
				tbl9.AntiInputType = antiInputType
			end,
		})

		Config:AddSlider("AntiInpLagDel", {
			Text = "Grab & Drop Delay",
			Default = 0.05,
			Min = 0,
			Max = 0.3,
			Suffix = " sec",
			Rounding = 2,
			Callback = function(inputLgDelay)
				tbl9.InputLgDelay = inputLgDelay
			end,
		})

		Config:AddLabel("Below 0.05 can cause high ping")

		Config:AddSlider("ItemTransAK", {
			Text = "Item Transparency",
			Default = tbl9.AILTransparency,
			Min = 0,
			Max = 1,
			Rounding = 2,
			Callback = function(ailTransparency)
				tbl9.AILTransparency = ailTransparency
			end,
		})

		Config:AddDivider("Anti-Kick")
		local antiKickSettings = tbl7.AntiKickSettings

		local AntiKickHL = Config:AddToggle("AntiKickHL", {
			Text = "Highlight",
			Default = antiKickSettings.Highlight,
			Tooltip = "Highlights the shuriken",
			Callback = function(highlight)
				antiKickSettings.Highlight = highlight
			end,
		})

		AntiKickHL:AddColorPicker("AKFill", {
			Default = antiKickSettings.HighlightFill,
			Title = "Fill Color",
			Callback = function(highlightFill)
				antiKickSettings.HighlightFill = highlightFill
			end,
		})

		AntiKickHL:AddColorPicker("AKOutline", {
			Default = antiKickSettings.HighlightOutl,
			Title = "Outline Color",
			Callback = function(highlightOutl)
				antiKickSettings.HighlightOutl = highlightOutl
			end,
		})

		tbl12.AddRainbowToggle(Config, "RGBAKFill", "RGB Fill", "AKFill")
		tbl12.AddRainbowToggle(Config, "RGBAKOutline", "RGB Outline", "AKOutline")

		Config:AddSlider("FillTransAK", {
			Text = "Fill Transparency",
			Default = antiKickSettings.HighlightFT,
			Min = 0,
			Max = 1,
			Rounding = 2,
			Callback = function(highlightFT)
				antiKickSettings.HighlightFT = highlightFT
			end,
		})
