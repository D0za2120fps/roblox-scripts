local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")

-- Создание инструмента (оружия)
local tool = Instance.new("Tool")
tool.Name = "Cube Gun"
tool.RequiresHandle = true

-- Создание "пистолетной" ручки
local handle = Instance.new("Part")
handle.Size = Vector3.new(1,1,2)
handle.Name = "Handle"
handle.Color = Color3.fromRGB(50, 100, 255)
handle.Anchored = false
handle.CanCollide = false
handle.Parent = tool

-- Логика выстрела
tool.Activated:Connect(function()
	local character = LocalPlayer.Character
	if not character then return end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local cube = Instance.new("Part")
	cube.Size = Vector3.new(2,2,2)
	cube.Color = Color3.fromRGB(255, 0, 0)
	cube.Material = Enum.Material.Neon
	cube.Position = root.Position + (root.CFrame.LookVector * 5)
	cube.Velocity = root.CFrame.LookVector * 100
	cube.Anchored = false
	cube.CanCollide = true
	cube.Parent = workspace

	game.Debris:AddItem(cube, 5)

	-- Сбивает других игроков
	cube.Touched:Connect(function(hit)
		local hum = hit.Parent:FindFirstChild("Humanoid")
		if hum and hum.Health > 0 and hit.Parent ~= character then
			hum.PlatformStand = true
			wait(1)
			hum.PlatformStand = false
		end
	end)
end)

tool.Parent = Backpack
