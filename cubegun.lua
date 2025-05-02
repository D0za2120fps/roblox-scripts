local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateCubeEvent = ReplicatedStorage:WaitForChild("CreateCube")

CreateCubeEvent.OnServerEvent:Connect(function(player)
    -- Проверяем, если игрок в игре, создаем кубик
    local character = player.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Создаем кубик
    local cube = Instance.new("Part")
    cube.Size = Vector3.new(2, 2, 2)
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
