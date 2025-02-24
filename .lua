local args1 = {[1] = "RolePlayName", [2] = "CARTOLA 🎩"};
game:GetService("ReplicatedStorage").RE:FindFirstChild(
    "1RPNam1eTex1t"):FireServer(unpack(args1));
local args = {
    [1] = "PickingRPNameColor",
    [2] = Color3.fromRGB(194, 56, 164)
};
game:GetService("ReplicatedStorage").RE:FindFirstChild(
    "1RPNam1eColo1r"):FireServer(unpack(args));
local args4 = {[1] = "RolePlayBio", [2] = "hub"};
game:GetService("ReplicatedStorage").RE:FindFirstChild(
    "1RPNam1eTex1t"):FireServer(unpack(args4));


-- Carregar a Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

-- Adicionar som
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://"  -- Substitua pelo ID do áudio desejado
sound.Parent = game.Workspace  -- Pode ser adicionado a qualquer parte, mas Workspace é um bom local
sound:Play()  -- Tocar o áudio

-- Aguardar um pequeno tempo para garantir que o som inicie
task.wait(0.1)

-- Criar uma janela
local Window = OrionLib:MakeWindow({
    Name = "ALONE",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionConfigs",
    IntroEnabled = true,
    IntroText = "ALONE HUB",
    IntroIcon = "rbxassetid://4483345998",
    Icon = "rbxassetid://4483345998"
})


-- Ajuste da escala para dispositivos móveis
local screenGui = Instance.new("ScreenGui")
local uiScale = Instance.new("UIScale")
uiScale.Parent = screenGui
uiScale.Scale = 0.8  -- Ajuste a escala para 80% da tela, para se adaptar melhor em dispositivos móveis
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Detecção de Toque para Mobile
local UserInputService = game:GetService("UserInputService")

-- Detectando o toque na tela
UserInputService.TouchTap:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    print("Toque detectado na tela!")
    -- Você pode adicionar ações para toque aqui, como abrir a janela ou interagir com algum botão
end)

-- Teste visual de interface para celular
local debugText = Instance.new("TextLabel")
debugText.Text = "Testando a UI no celular..."
debugText.Size = UDim2.new(0, 300, 0, 50)
debugText.Position = UDim2.new(0.5, -150, 0.9, -25)
debugText.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")



-- Criar uma aba para Scripts
local ScriptTab = Window:MakeTab({
    Name = "Scripts",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Botão para executar o script "Get Sofa"
ScriptTab:AddButton({
    Name = "Get Sofa",
    Callback = function()
        -- Carrega e executa o script do sofá
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://you.whimper.xyz/sources/slowed/3"))()
        end)

        if not success then
            -- Caso ocorra algum erro ao executar o script, exibe uma notificação
            OrionLib:MakeNotification({
                Name = "Erro ao carregar o Script",
                Content = "Falha ao carregar o sofá: " .. err,
                Time = 5
            })
        end
    end
})





-- Criar uma aba para Fling
local FlingTab = Window:MakeTab({
    Name = "Fling",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local originalPosition = nil
local sofaInstance = nil

-- Função para garantir que temos o controle sobre a física
local function setNetworkOwner(part)
    if part and part:IsA("BasePart") then
        local success, err = pcall(function()
            part:SetNetworkOwner(LocalPlayer)
        end)
    end
end

-- Função para aplicar o fling
local function flingTarget(target)
    local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")

    if rootPart and targetRoot then
        setNetworkOwner(rootPart)
        rootPart.AssemblyLinearVelocity = Vector3.zero -- Resetar qualquer movimento
        rootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 5, 0) 
        task.wait(0.1) 
        rootPart.AssemblyLinearVelocity = Vector3.new(100000, 100000, 100000) 
        task.wait(0.2)
        rootPart.AssemblyLinearVelocity = Vector3.zero
    end
end

-- Função para teleportar instantaneamente
local function teleportToTarget(target)
    local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")

    if rootPart and targetRoot then
        if not originalPosition then
            originalPosition = rootPart.CFrame
        end
        -- Forçar a posição e garantir que a física está certa
        rootPart.AssemblyLinearVelocity = Vector3.zero
        rootPart.CFrame = targetRoot.CFrame + Vector3.new(0, 5, 0)
        setNetworkOwner(rootPart)
    end
end

-- Dropdown para selecionar o player
local selectedPlayer
local playerDropdown = FlingTab:AddDropdown({
    Name = "Selecionar Player",
    Default = "",
    Options = {},
    Callback = function(value)
        selectedPlayer = Players:FindFirstChild(value)
    end
})

-- Atualizar lista de jogadores
local function updatePlayers()
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    playerDropdown:Refresh(playerNames, "")
end

Players.PlayerAdded:Connect(updatePlayers)
Players.PlayerRemoving:Connect(updatePlayers)
updatePlayers()

-- Botão para pegar sofá
FlingTab:AddButton({
    Name = "Pegar Sofá",
    Callback = function()
        loadstring(game:HttpGet("https://you.whimper.xyz/sources/slowed/3"))()
    end
})

-- Botão para pegar e colocar o player no sofá
FlingTab:AddButton({
    Name = "Pegar Player e Colocar no Sofá",
    Callback = function()
        if selectedPlayer then
            local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetRoot = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if rootPart and targetRoot then
                teleportToTarget(selectedPlayer)

                local sofa = workspace:FindFirstChild("Sofa")
                if sofa and targetRoot then
                    targetRoot.CFrame = sofa.CFrame * CFrame.new(0, 1, 0)
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = sofa
                    weld.Part1 = targetRoot
                    weld.Parent = sofa
                    sofaInstance = sofa
                end
            end

            task.wait(1)

            selectedPlayer.Character.Humanoid.Seated:Connect(function(seated)
                if seated then
                    flingTarget(selectedPlayer)
                end
            end)
        else
            warn("Nenhum player selecionado!")
        end
    end
})

-- Botão para liberar o player e remover o sofá
FlingTab:AddButton({
    Name = "Liberar Player e Remover Sofá",
    Callback = function()
        if selectedPlayer then
            local targetRoot = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                for _, weld in pairs(targetRoot:GetChildren()) do
                    if weld:IsA("WeldConstraint") then
                        weld:Destroy()
                    end
                end

                targetRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 5, 0)

                if sofaInstance then
                    sofaInstance:Destroy()
                    sofaInstance = nil
                end

                if originalPosition then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = originalPosition
                    originalPosition = nil
                else
                    warn("Posição original não encontrada!")
                end
            end
        end
    end
})




local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

-- Função para desativar efeitos laggy
local function disableLaggyFeatures()
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire")) then
            v.Enabled = false
        end
    end
end

-- Criar uma aba para Orbit
local OrbitTab = Window:MakeTab({
    Name = "Orbit",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local selectedPlayer
local orbiting = false

-- Função para obter os jogadores
local function getPlayers()
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        if (player ~= LocalPlayer) then
            table.insert(playerNames, player.Name)
        end
    end
    return playerNames
end

-- Dropdown para selecionar o jogador
local playerDropdown = OrbitTab:AddDropdown({
    Name = "Select Player",
    Default = "",
    Options = getPlayers(),
    Callback = function(value)
        selectedPlayer = Players:FindFirstChild(value)
    end
})

-- Função para atualizar a lista de jogadores
local function updatePlayerList()
    playerDropdown:Refresh(getPlayers(), "")
end

-- Detectar quando um jogador entra ou sai
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Toggle para iniciar a órbita
OrbitTab:AddToggle({
    Name = "Start Orbit",
    Default = false,
    Callback = function(value)
        orbiting = value
        if (orbiting and selectedPlayer) then
            -- Loop de órbita
            while orbiting do
                local targetPosition = selectedPlayer.Character.HumanoidRootPart.Position
                local orbitPosition = targetPosition +
                    Vector3.new(math.cos(tick() * 20) * 5, 0, math.sin(tick() * 20) * 5)
                
                local tweenInfo = TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                local tween = TweenService:Create(LocalPlayer.Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(orbitPosition)})
                tween:Play()
                tween.Completed:Wait()
            end
        end
    end
})

-- Chamada para desativar os efeitos laggy
disableLaggyFeatures()



local NewTab = Window:MakeTab({
    Name = "Settings - Get",
    Icon = "rbxassetid://4483345998",  -- Ícone opcional
    PremiumOnly = false
})

-- Adicionar uma seção à nova aba
local Section = NewTab:AddSection({Name = "Get Options"})

-- Botão para obter guitarra (Sound)
NewTab:AddButton({
    Name = "Get guitarra (Sound)",
    Callback = function()
        loadstring(game:HttpGet("https://you.whimper.xyz/sources/slowed/1"))()
    end
})


local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Função para visualizar um jogador
local function spectatePlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Camera.CameraSubject = targetPlayer.Character.Humanoid
    end
end

-- Função para parar de visualizar
local function stopSpectating()
    Camera.CameraSubject = LocalPlayer.Character.Humanoid
end

-- Função para atualizar a lista de jogadores no dropdown
local function updatePlayerList(dropdown)
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    -- Usar Refresh apenas quando necessário para evitar atualizações desnecessárias
    if #playerNames > 0 then
        dropdown:Refresh(playerNames, "")
    end
end

-- Função para ativar o Wallhack (tornar as partes do personagem sem colisão)
local function enableWallhack()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

-- Função para desativar o Wallhack (restaurar a colisão das partes)
local function disableWallhack()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Seção de Visualização
local SpectateTab = Window:MakeTab({
    Name = "Visualizar",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Dropdown para selecionar o jogador para visualizar
local selectedPlayer
local playerDropdown = SpectateTab:AddDropdown({
    Name = "Selecionar Jogador",
    Default = "",
    Options = {},
    Callback = function(value)
        selectedPlayer = value
    end
})

-- Botão para atualizar a lista de jogadores no dropdown
SpectateTab:AddButton({
    Name = "Atualizar Lista",
    Callback = function()
        -- Atualizar a lista de jogadores de maneira eficiente
        updatePlayerList(playerDropdown)
    end
})

-- Toggle para ativar ou desativar a visualização
SpectateTab:AddToggle({
    Name = "Visualizar Jogador",
    Default = false,
    Callback = function(value)
        if value and selectedPlayer then
            spectatePlayer(selectedPlayer)
        else
            stopSpectating()
        end
    end
})


-- Criar a aba "Alteração de Nome e Bio"
local NameBioTab = Window:MakeTab({
    Name = "Alteração de Nome e Bio",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
});

-- Seção de "Alteração de Nomes"
local Section1 = NameBioTab:AddSection({
    Name = "Settings - Alteração De Nomes"
});

NameBioTab:AddTextbox({
    Name = "Altera Nome",
    Default = "Coloque o Nome aqui",
    TextDisappear = false,
    Callback = function(value)
        local args = {[1] = "RolePlayName", [2] = value};
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1RPNam1eTex1t"):FireServer(unpack(args));
    end
});

NameBioTab:AddTextbox({
    Name = "Altera Bio Roleplay",
    Default = "Coloque o Nome aqui",
    TextDisappear = false,
    Callback = function(value)
        local args = {[1] = "RolePlayBio", [2] = value};
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1RPNam1eTex1t"):FireServer(unpack(args));
    end
});

-- Seção de "Alteração de Cor Aleatória"
local Section2 = NameBioTab:AddSection({
    Name = "Settings - Random Color"
});

local function getRandomColor()
    return Color3.new(math.random(), math.random(), math.random());
end

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RemoteEvent = ReplicatedStorage.RE:FindFirstChild("1RPNam1eColo1r");

local nameColorRunning = false;
local bioColorRunning = false;

-- Função otimizada para mudar a cor do nome
local function changeNameColor()
    while nameColorRunning do
        local randomColor = getRandomColor();
        local args = {[1] = "PickingRPNameColor", [2] = randomColor};
        RemoteEvent:FireServer(unpack(args));
        task.wait(1);  -- Atraso de 1 segundo para reduzir a sobrecarga
    end
end

-- Função otimizada para mudar a cor da bio
local function changeBioColor()
    while bioColorRunning do
        local randomColor = getRandomColor();
        local args = {[1] = "PickingRPBioColor", [2] = randomColor};
        RemoteEvent:FireServer(unpack(args));
        task.wait(1);  -- Atraso de 1 segundo para reduzir a sobrecarga
    end
end

-- Adicionar Toggle para "Nome colorido"
local nameColorToggle;
nameColorToggle = NameBioTab:AddToggle({
    Name = "Nome colorido",
    Default = false,
    Callback = function(Value)
        if Value then
            if not nameColorRunning then
                nameColorRunning = true;
                changeNameColor();  -- Chama a função diretamente para não criar múltiplos threads
            end
        else
            nameColorRunning = false;
        end
    end
});

-- Adicionar Toggle para "Bio colorida"
local bioColorToggle;
bioColorToggle = NameBioTab:AddToggle({
    Name = "Bio colorida",
    Default = false,
    Callback = function(Value)
        if Value then
            if not bioColorRunning then
                bioColorRunning = true;
                changeBioColor();  -- Chama a função diretamente para não criar múltiplos threads
            end
        else
            bioColorRunning = false;
        end
    end
});

-- Função otimizada para desativar efeitos pesados
local function disableLaggyFeatures()
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire")) then
            v.Enabled = false
        end
    end
end

-- Executa a função de desativação de efeitos pesados quando necessário
disableLaggyFeatures();






-- Criar a aba para Teleporte
local TeleportTab = Window:MakeTab({
    Name = "Teleporte",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Criar uma seção dentro da aba
local Section = TeleportTab:AddSection({Name = "Settings - Teleporte"})

local selectedPlayer = nil
local teleportEnabled = false
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Atualiza a lista de jogadores
local function updatePlayerList()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    return playerNames
end

-- Teleportar para o jogador selecionado
local function teleportToPlayer()
    if selectedPlayer and teleportEnabled then
        local targetPlayer = Players:FindFirstChild(selectedPlayer)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end

-- Dropdown para selecionar jogador
TeleportTab:AddDropdown({
    Name = "Selecionar Jogador",
    Default = "",
    Options = updatePlayerList(),
    Callback = function(value)
        selectedPlayer = value
        if teleportEnabled then
            teleportToPlayer()
        end
    end
})

-- Botão para atualizar a lista de jogadores
TeleportTab:AddButton({
    Name = "Atualizar Lista",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Lista Atualizada",
            Content = "A lista de jogadores foi atualizada",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
        TeleportTab:UpdateDropdown("Selecionar Jogador", updatePlayerList())
    end
})

-- Toggle para ativar/desativar o teleporte contínuo
TeleportTab:AddToggle({
    Name = "Ativa-Desativa Teleporte",
    Default = false,
    Callback = function(value)
        teleportEnabled = value
        if teleportEnabled then
            teleportToPlayer()
        end
    end
})

-- Se o jogador selecionado renascer, teleporta automaticamente se ativado
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if teleportEnabled and (player.Name == selectedPlayer) then
            teleportToPlayer()
        end
    end)
end)

-- Mantém o teleporte ativado enquanto o toggle estiver ligado
game:GetService("RunService").Stepped:Connect(function()
    if teleportEnabled and selectedPlayer then
        teleportToPlayer()
    end
end)

-- Criar a aba para Casas
local HouseTab = Window:MakeTab({
    Name = "Casas",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Criar uma seção dentro da aba
local Section = HouseTab:AddSection({Name = "Gerenciamento de Casas"})

-- Lista de números das casas disponíveis
local houseNumbers = {
    1, 2, 3, 4, 5, 6, 7, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
    22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37
}

local selectedHouseNumber = nil

-- Dropdown para selecionar a casa
HouseTab:AddDropdown({
    Name = "Selecione a Casa",
    Options = houseNumbers,
    Default = 1,
    Callback = function(Value)
        selectedHouseNumber = tonumber(Value)
        print("Casa selecionada:", selectedHouseNumber)
    end
})

-- Botão para dar permissão à casa
HouseTab:AddButton({
    Name = "Dar Permissão",
    Callback = function()
        if selectedHouseNumber then
            local args = {
                [1] = "GivePermissionLoopToServer",
                [2] = game:GetService("Players").LocalPlayer,
                [3] = selectedHouseNumber
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild(
                "1Playe1rTrigge1rEven1t"):FireServer(unpack(args))
            print("Permissão dada para a casa:", selectedHouseNumber)
        else
            print("Nenhuma casa selecionada!")
        end
    end
})

-- Botão para remover banimento da casa
HouseTab:AddButton({
    Name = "Remover Ban",
    Callback = function()
        if selectedHouseNumber then
            local lotNumber = "0o1.L0ts"
            local lot = workspace:FindFirstChild(lotNumber)
            if lot then
                for _, house in pairs(lot:GetChildren()) do
                    if house:FindFirstChild("HousePickedByPlayer") then
                        local bannedBlockName = "BannedBlock" .. selectedHouseNumber
                        local bannedBlock = house.HousePickedByPlayer.HouseModel:FindFirstChild(bannedBlockName)
                        if bannedBlock then
                            bannedBlock:Destroy()
                            print(bannedBlockName .. " deletado com sucesso em " .. house.Name)
                        else
                            print(bannedBlockName .. " não encontrado em " .. house.Name)
                        end
                    end
                end
            else
                print("Lote " .. lotNumber .. " não encontrado.")
            end
        else
            print("Nenhuma casa selecionada!")
        end
    end
})



-- Criar a aba para Modificar Tamanho do Personagem
local HumanTab = Window:MakeTab({
    Name = "Humano",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Criar uma seção dentro da aba
local Section = HumanTab:AddSection({Name = "Configurações - Tamanho"})

-- Botão para diminuir o tamanho do personagem
HumanTab:AddButton({
    Name = "Ficar Pequeno",
    Callback = function()
        local args = {
            [1] = "CharacterSizeDown", -- Corrigi para um nome mais adequado
            [2] = 4
        }
        
        local remoteEvent = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Clothe1s")
        if remoteEvent then
            remoteEvent:FireServer(unpack(args))
        else
            warn("Erro: Evento remoto não encontrado!")
        end
    end
})

-- Botão para restaurar o tamanho normal do personagem
HumanTab:AddButton({
    Name = "Voltar Tamanho Normal",
    Callback = function()
        local args = {
            [1] = "CharacterSizeUp", -- Mantenho o original para voltar ao normal
            [2] = 1 -- 1 para tamanho padrão
        }
        
        local remoteEvent = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Clothe1s")
        if remoteEvent then
            remoteEvent:FireServer(unpack(args))
        else
            warn("Erro: Evento remoto não encontrado!")
        end
    end
})



-- Criar a aba de Utilitários
local utilitiesTab = Window:MakeTab({
    Name = "Utilitários",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Anti Sit
utilitiesTab:AddToggle({
    Name = "Anti Sit",
    Default = false,  -- Desativado por padrão
    Callback = function(value)
        local antiSitConnection
        if value then
            antiSitConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    if LocalPlayer.Character.Humanoid.Sit then
                        LocalPlayer.Character.Humanoid.Sit = false
                    end
                end
            end)
        elseif antiSitConnection then
            antiSitConnection:Disconnect()
        end
    end
})

-- Anti Void
utilitiesTab:AddToggle({
    Name = "Anti Void",
    Default = false,  -- Desativado por padrão
    Callback = function(value)
        local antiVoidConnection
        if value then
            antiVoidConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    if LocalPlayer.Character.HumanoidRootPart.Position.Y < -50 then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
                    end
                end
            end)
        elseif antiVoidConnection then
            antiVoidConnection:Disconnect()
        end
    end
})

-- Auto Rejoin
utilitiesTab:AddToggle({
    Name = "Auto Rejoin",
    Default = false,  -- Desativado por padrão
    Callback = function(value)
        if value then
            local function autoRejoinHandler(child)
                if child.Name == "ErrorPrompt" then
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end
            end
            game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(autoRejoinHandler)
        end
    end
})

-- Anti Lag
utilitiesTab:AddToggle({
    Name = "Anti Lag",
    Default = false,  -- Desativado por padrão
    Callback = function(value)
        if value then
            disableLaggyFeatures()
            local function antiLagHandler(descendant)
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Smoke") or descendant:IsA("Fire") then
                    descendant.Enabled = false
                end
            end
            workspace.DescendantAdded:Connect(antiLagHandler)
        end
    end
})

-- Adicionar uma seção para configurações extras
local Section = utilitiesTab:AddSection({
    Name = "Settings"
})

-- Teleporta para o spawn
utilitiesTab:AddButton({
    Name = "Teleporta Pro Spawn",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        end
    end
})

-- Função para remover objetos que causam lag
local function removeLag()
    local removedCount = 0
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            if not part.Visible or (part.Transparency >= 1) then
                part:Destroy()
                removedCount = removedCount + 1
            end
        end
    end
    for _, light in pairs(workspace:GetDescendants()) do
        if light:IsA("Light") then
            if not light.Parent or not light.Parent.Parent then
                light:Destroy()
                removedCount = removedCount + 1
            end
        end
    end
    for _, texture in pairs(workspace:GetDescendants()) do
        if texture:IsA("Texture") then
            if texture.Parent and not texture.Parent.Visible then
                texture:Destroy()
                removedCount = removedCount + 1
            end
        end
    end
    OrionLib:MakeNotification({
        Name = "Removendo Lag",
        Content = removedCount .. " objetos removidos.",
        Time = 5
    })
end

-- Botão para remover lag
utilitiesTab:AddButton({
    Name = "Remover Lag",
    Callback = function()
        removeLag()
    end
})

-- Função para detectar exploits
local function detectExploits()
    local exploitCount = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player:FindFirstChild("HumanoidRootPart") and player.HumanoidRootPart.Anchored then
            exploitCount = exploitCount + 1
        end
    end
    return exploitCount
end

-- Atualizar contagem de exploits
local function updateExploitCount()
    local exploitCount = detectExploits()
    exploitCountLabel:Set("Exploit Quantos: " .. exploitCount)
end

Players.PlayerAdded:Connect(updateExploitCount)
Players.PlayerRemoving:Connect(updateExploitCount)
updateExploitCount()
