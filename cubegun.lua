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

	-- Создаем кубик, который будет выстреливаться
	local cube = Instance.new("Part")
	cube.Size = Vector3.new(2,2,2)
	cube.Color = Color3.fromRGB(255, 0, 0)
	cube.Material = Enum.Material.Neon
	cube.Position = root.Position + (root.CFrame.LookVector * 5)
	cube.Velocity = root.CFrame.LookVector * 100
	cube.Anchored = false
	cube.CanCollide = true
	cube.Parent = workspace

	-- Удаление кубика через 5 секунд
	game.Debris:AddItem(cube, 5)

	-- Обработчик столкновения с другими игроками
	cube.Touched:Connect(function(hit)
		local hum = hit.Parent:FindFirstChild("Humanoid")
		if hum and hum.Health > 0 and hit.Parent ~= character then
			-- Поставим игрока в режим "платформы" (не может двигаться)
			hum.PlatformStand = true
			wait(0.1)
			hum.PlatformStand = false

			-- Создаём физический эффект падения
			local humanoidRootPart = hit.Parent:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart then
				-- Добавим силу, чтобы "ронять" игрока
				local bodyVelocity = Instance.new("BodyVelocity")
				bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000) -- Высокая сила
				bodyVelocity.Velocity = Vector3.new(0, -50, 0)  -- Падает вниз
				bodyVelocity.Parent = humanoidRootPart

				-- Удаляем BodyVelocity через 1 секунду
				game.Debris:AddItem(bodyVelocity, 1)
			end
		end
	end)
end)

tool.Parent = Backpack
