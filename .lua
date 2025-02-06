-- Carregar a Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

-- Adicionar som
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://6879335951"  -- Substitua pelo ID do áudio desejado
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




-- Criar uma aba invisível
local InvisibleTab = Window:MakeTab({
    Name = "‎invisivel", -- Nome totalmente invisível (caractere especial invisível)
    Icon = "rbxassetid://4483345998", -- Remove o ícone para ser completamente invisível
    PremiumOnly = false
})

-- Criar um botão invisível dentro da aba invisível
InvisibleTab:AddButton({
    Name = "‎invisivel", -- Nome totalmente invisível
    Callback = function()
        local evento = game:GetService("ReplicatedStorage"):FindFirstChild("RE")
        if evento and evento:FindFirstChild("1Clothe1s") then
            evento["1Clothe1s"]:FireServer("CharacterSizeDown", 1)
        else
            warn("❌ ERRO: Evento '1Clothe1s' não encontrado!")
        end
    end
})


-- Criar uma aba chamada "Anti Ban House"
local AntiBanTab = Window:MakeTab({
    Name = "Anti Ban House",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Função para remover os banimentos de todas as casas no Brookhaven
local function AntiBanHouseAll()
    local lots = workspace:FindFirstChild("001_Lots")

    if not lots then
        warn("❌ ERRO: A pasta '001_Lots' não foi encontrada!")
        return
    end

    print("✅ Pasta '001_Lots' encontrada! Iniciando a remoção dos banimentos...")

    local casasModificadas = 0

    -- Iterar pelas casas dentro de "001_Lots"
    for _, house in ipairs(lots:GetChildren()) do
        local housePicked = house:FindFirstChild("HousePickedByPlayer")
        local houseModel = housePicked and housePicked:FindFirstChild("HouseModel")

        if houseModel then
            local removidos = 0

            -- Remover BannedBlock e PropBlocker
            for _, obj in ipairs(houseModel:GetChildren()) do
                if obj.Name:match("BannedBlock") then
                    local propBlocker = obj:FindFirstChild("PropBlocker21")
                    if propBlocker then propBlocker:Destroy() end
                    obj:Destroy()
                    removidos += 1
                end
            end

            if removidos > 0 then
                casasModificadas += 1
                print("✅ Banimentos removidos da casa:", house.Name)
            end
        end
    end

    if casasModificadas > 0 then
        print("✅ Banimentos removidos de", casasModificadas, "casas.")
    else
        warn("⚠️ Nenhuma casa foi alterada. Verifique se os nomes dos objetos estão corretos!")
    end
end

-- Botão para ativar a função
AntiBanTab:AddButton({
    Name = "Remover Banimento de Todas as Casas",
    Callback = AntiBanHouseAll
})


-- Criar uma aba chamada "Trollar Jogador"
local TrollarTab = Window:MakeTab({
    Name = "Trollar Jogador",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Variáveis globais
local jogadorSelecionado
local playerOriginalPosition -- Posição original do jogador local
local dropdown -- Armazena o dropdown para atualização dinâmica

-- Função para obter a lista de jogadores (exceto o local)
local function AtualizarListaJogadores()
    local jogadores = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(jogadores, player.Name)
        end
    end
    return jogadores
end

-- Função para teleportar o jogador local até o alvo e puxá-lo para o sofá
local function TeleportarParaJogadorEPuxar()
    local localPlayer = game.Players.LocalPlayer
    local localCharacter = localPlayer.Character
    local jogador = jogadorSelecionado and game.Players:FindFirstChild(jogadorSelecionado)

    if not localCharacter or not localCharacter:FindFirstChild("HumanoidRootPart") then
        warn("❌ Seu personagem não está carregado corretamente.")
        return
    end

    if not jogador or not jogador.Character or not jogador.Character:FindFirstChild("HumanoidRootPart") then
        warn("❌ O jogador selecionado não foi encontrado ou seu personagem não está carregado.")
        return
    end

    local jogadorCharacter = jogador.Character
    local sofaLocal = workspace["001_Lots"].DontDelete -- Local do sofá

    -- Salvar a posição original do jogador local
    playerOriginalPosition = localCharacter.HumanoidRootPart.CFrame

    -- Posição original do jogador alvo
    local posicaoOriginalJogador = jogadorCharacter.HumanoidRootPart.CFrame

    -- Teleportar o jogador local até o jogador alvo
    localCharacter:SetPrimaryPartCFrame(jogadorCharacter.HumanoidRootPart.CFrame)
    task.wait(0.3) -- Pequeno delay para estabilidade

    -- Teleportar o jogador alvo para o sofá
    jogadorCharacter:SetPrimaryPartCFrame(sofaLocal.CFrame)
    task.wait(0.5)

    -- Restaurar a posição original do jogador alvo
    jogadorCharacter:SetPrimaryPartCFrame(posicaoOriginalJogador)
    print(jogador.Name .. " voltou para sua posição original!")

    -- Restaurar a posição original do jogador local
    task.wait(0.5)
    localCharacter:SetPrimaryPartCFrame(playerOriginalPosition)
    print("✅ Você voltou para sua posição original!")
end

-- Criar dropdown para selecionar jogador
dropdown = TrollarTab:AddDropdown({
    Name = "Escolher Jogador",
    Options = AtualizarListaJogadores(),
    Default = nil,
    Callback = function(Selecionado)
        jogadorSelecionado = Selecionado
        print("🎯 Jogador selecionado: " .. jogadorSelecionado)
    end
})

-- Atualizar dropdown quando jogadores entram ou saem
game.Players.PlayerAdded:Connect(function()
    dropdown:Refresh(AtualizarListaJogadores(), true)
end)

game.Players.PlayerRemoving:Connect(function()
    dropdown:Refresh(AtualizarListaJogadores(), true)
end)

-- Adicionar botão para ativar a funcionalidade
TrollarTab:AddButton({
    Name = "Puxar Jogador para o Sofá",
    Callback = TeleportarParaJogadorEPuxar
})



-- Criar uma aba chamada "Puxar Carro"
local CarrosTab = Window:MakeTab({
    Name = "Puxar Carro",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Variáveis
local player = game.Players.LocalPlayer
local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local carroSelecionado
local UserInputService = game:GetService("UserInputService")

-- Resetar variáveis ao morrer ou resetar personagem
player.CharacterAdded:Connect(function(char)
    humanoidRootPart = char:WaitForChild("HumanoidRootPart", 5)
    carroSelecionado = nil
    print("🔄 Reset: Personagem recriado, variáveis limpas.")
end)

-- Função para listar carros disponíveis
local function ListarCarros()
    local carros = {}
    for _, carro in ipairs(workspace.Vehicles:GetChildren()) do
        if carro:IsA("Model") then
            local humanoid = carro:FindFirstChildOfClass("Humanoid")
            local velocidade = carro.PrimaryPart and carro.PrimaryPart.Velocity.Magnitude or 0
            if not humanoid and velocidade < 1 then
                table.insert(carros, carro.Name)
            end
        end
    end
    return carros
end

-- Criar Dropdown para selecionar carro
local DropdownCarros = CarrosTab:AddDropdown({
    Name = "Escolher Carro",
    Options = ListarCarros(),
    Default = "Nenhum",
    Callback = function(Selecionado)
        carroSelecionado = workspace.Vehicles:FindFirstChild(Selecionado)
        if carroSelecionado then
            print("🚗 Carro selecionado:", carroSelecionado.Name)
        else
            warn("❌ Carro não encontrado!")
        end
    end
})

-- Atualizar lista de carros sempre que houver mudanças
local function AtualizarLista()
    DropdownCarros:Refresh(ListarCarros(), true)
    print("🔄 Lista de carros atualizada!")
end
workspace.Vehicles.ChildAdded:Connect(AtualizarLista)
workspace.Vehicles.ChildRemoved:Connect(AtualizarLista)

-- Criar botão para atualizar lista manualmente
CarrosTab:AddButton({
    Name = "Atualizar Lista de Carros",
    Callback = AtualizarLista
})

-- Função para encontrar a peça principal do carro
local function GetCarPrimaryPart(carro)
    if carro.PrimaryPart then return carro.PrimaryPart end
    for _, part in ipairs(carro:GetChildren()) do
        if part:IsA("BasePart") then
            return part
        end
    end
    return nil
end

-- Função para puxar um único carro
local function PuxarCarro()
    if not (carroSelecionado and humanoidRootPart) then
        warn("❌ Nenhum carro selecionado ou jogador não encontrado!")
        return
    end

    local carroRoot = GetCarPrimaryPart(carroSelecionado)
    if not carroRoot then
        warn("❌ O carro não tem uma peça principal válida.")
        return
    end

    local velocidade = carroRoot.Velocity.Magnitude
    if velocidade > 1 then
        warn("❌ O carro está em movimento!")
        return
    end

    carroRoot.Anchored = false
    carroSelecionado:SetPrimaryPartCFrame(humanoidRootPart.CFrame + Vector3.new(0, 3, 0))
    
    print("✅ Carro puxado:", carroSelecionado.Name)

    -- Se houver assento, tenta colocar o jogador automaticamente
    local assento = carroSelecionado:FindFirstChildOfClass("VehicleSeat")
    if assento and player.Character and player.Character:FindFirstChild("Humanoid") then
        assento:Sit(player.Character.Humanoid)
        print("✅ Jogador entrou no carro:", carroSelecionado.Name)
    else
        warn("❌ O carro não tem assento ou o jogador não pode entrar.")
    end
end

-- Botão para puxar um único carro
CarrosTab:AddButton({
    Name = "Puxar Carro",
    Callback = PuxarCarro
})

-- Função para puxar TODOS os carros do jogo
local function PuxarTodosCarros()
    if not humanoidRootPart then
        warn("❌ Jogador não encontrado!")
        return
    end

    local carrosPuxados = 0
    for _, carro in ipairs(workspace.Vehicles:GetChildren()) do
        if carro:IsA("Model") then
            local humanoid = carro:FindFirstChildOfClass("Humanoid")
            local carroRoot = GetCarPrimaryPart(carro)
            local velocidade = carroRoot and carroRoot.Velocity.Magnitude or 0

            if not humanoid and carroRoot and velocidade < 1 then
                carroRoot.Anchored = false
                carro:SetPrimaryPartCFrame(humanoidRootPart.CFrame + Vector3.new(math.random(-5, 5), 3, math.random(-5, 5)))

                print("✅ Carro puxado:", carro.Name)
                carrosPuxados = carrosPuxados + 1
            else
                warn("❌ O carro", carro.Name, "está ocupado ou em movimento!")
            end
        end
    end

    if carrosPuxados > 0 then
        print("🚗 Todos os carros disponíveis foram puxados!")
    else
        warn("❌ Nenhum carro disponível para puxar!")
    end
end

-- Botão para puxar TODOS os carros
CarrosTab:AddButton({
    Name = "Puxar TODOS os Carros",
    Callback = PuxarTodosCarros
})

-- Adicionando suporte a toque na tela para ativar a ação no mobile
UserInputService.TouchTap:Connect(function(_, gameProcessed)
    if not gameProcessed then
        PuxarCarro()
    end
end)



-- Criar a aba "Puxar Carro para Jogador"
local CarrosTab = Window:MakeTab({
    Name = "Puxar Carro para Jogador",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Variáveis
local player = game.Players.LocalPlayer
local jogadorSelecionado
local UserInputService = game:GetService("UserInputService")

-- Função para listar jogadores no servidor (exclui o próprio player)
local function ListarJogadores()
    local jogadores = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= player then
            table.insert(jogadores, p.Name)
        end
    end
    return jogadores
end

-- Criar Dropdown para selecionar jogador
local DropdownJogadores = CarrosTab:AddDropdown({
    Name = "Escolher Jogador",
    Options = ListarJogadores(),
    Default = "Nenhum",
    Callback = function(Selecionado)
        jogadorSelecionado = game.Players:FindFirstChild(Selecionado)
        if jogadorSelecionado then
            print("🎯 Jogador selecionado:", jogadorSelecionado.Name)
        else
            warn("❌ Jogador não encontrado!")
        end
    end
})

-- Atualiza a lista de jogadores dinamicamente
game.Players.PlayerAdded:Connect(function() DropdownJogadores:Refresh(ListarJogadores(), true) end)
game.Players.PlayerRemoving:Connect(function() DropdownJogadores:Refresh(ListarJogadores(), true) end)

-- Função para encontrar a peça principal do carro
local function GetCarPrimaryPart(carro)
    if carro.PrimaryPart then
        return carro.PrimaryPart
    end
    for _, part in ipairs(carro:GetChildren()) do
        if part:IsA("BasePart") then
            return part
        end
    end
    return nil
end

-- Função para puxar os carros para o jogador
local function PuxarCarrosParaJogador()
    if not jogadorSelecionado then
        warn("❌ Nenhum jogador selecionado!")
        return
    end

    local char = jogadorSelecionado.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if not root then
        warn("❌ O jogador não tem um personagem válido no jogo!")
        return
    end

    local carrosPuxados = 0
    for _, carro in ipairs(workspace.Vehicles:GetChildren()) do
        if carro:IsA("Model") then
            local carroRoot = GetCarPrimaryPart(carro)
            local velocidade = carroRoot and carroRoot.Velocity.Magnitude or 0

            if carroRoot and velocidade < 1 then
                -- Mover o carro para perto do jogador
                carro:SetPrimaryPartCFrame(root.CFrame + Vector3.new(math.random(-5, 5), 3, math.random(-5, 5)))
                carro.PrimaryPart.Anchored = false

                -- Se houver assento, tenta colocar o jogador dentro do carro
                local assento = carro:FindFirstChildOfClass("VehicleSeat")
                if assento then
                    assento.CFrame = root.CFrame
                end

                print("✅ Carro puxado:", carro.Name)
                carrosPuxados = carrosPuxados + 1
            else
                warn("❌ O carro", carro.Name, "está ocupado ou em movimento!")
            end
        end
    end

    if carrosPuxados > 0 then
        print("🚗 Todos os carros disponíveis foram puxados para", jogadorSelecionado.Name, "!")
    else
        warn("❌ Nenhum carro disponível para puxar!")
    end
end

-- Criar botão para puxar carros
CarrosTab:AddButton({
    Name = "Puxar Carros",
    Callback = PuxarCarrosParaJogador
})

-- Adicionando suporte a toque na tela para ativar a ação no mobile
UserInputService.TouchTap:Connect(function(_, gameProcessed)
    if not gameProcessed then
        PuxarCarrosParaJogador()
    end
end)



-- Criar a aba de Teleporte para jogadores
local TpTab = Window:MakeTab({
    Name = "Teleportar Jogadores",
    Icon = "rbxassetid://4483345998", 
    PremiumOnly = false
})

-- Variáveis
local jogadoresOnline = {}
local DropdownJogadores
local UserInputService = game:GetService("UserInputService")

-- Ajuste de escala para mobile
local screenGui = Instance.new("ScreenGui")
local uiScale = Instance.new("UIScale")
uiScale.Scale = 0.85  -- Ajuste para melhor visualização em mobile
uiScale.Parent = screenGui
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Função para atualizar a lista de jogadores
local function AtualizarListaJogadores()
    jogadoresOnline = {}

    for _, player in ipairs(game.Players:GetPlayers()) do
        table.insert(jogadoresOnline, player.Name)
    end

    if DropdownJogadores then
        DropdownJogadores:Refresh(jogadoresOnline)
    end
end

-- Função de teleporte
local function TeleportarParaJogador(jogadorNome)
    local jogador = game.Players:FindFirstChild(jogadorNome)
    if jogador and jogador.Character and jogador.Character:FindFirstChild("HumanoidRootPart") then
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            localPlayer.Character.HumanoidRootPart.CFrame = jogador.Character.HumanoidRootPart.CFrame
            print("✅ Teleportado para:", jogadorNome)
        end
    else
        warn("❌ Jogador não encontrado ou personagem não carregado!")
    end
end

-- Criar Dropdown
DropdownJogadores = TpTab:AddDropdown({
    Name = "Escolha um Jogador",
    Options = jogadoresOnline,
    Default = "Nenhum",
    Callback = function(jogadorSelecionado)
        TeleportarParaJogador(jogadorSelecionado)
    end
})

-- Botão para Teleporte
TpTab:AddButton({
    Name = "Teleportar para Jogador Selecionado",
    Callback = function()
        local selecionado = DropdownJogadores:GetSelected()
        if selecionado then
            TeleportarParaJogador(selecionado)
        else
            warn("❌ Nenhum jogador selecionado!")
        end
    end
})

-- Adicionando suporte a toque na tela para ativar o teleporte
UserInputService.TouchTap:Connect(function(_, gameProcessed)
    if not gameProcessed then
        local selecionado = DropdownJogadores:GetSelected()
        if selecionado then
            TeleportarParaJogador(selecionado)
        end
    end
end)

-- Atualizar lista de jogadores quando alguém entra ou sai
game.Players.PlayerAdded:Connect(AtualizarListaJogadores)
game.Players.PlayerRemoving:Connect(AtualizarListaJogadores)

-- Inicializar lista de jogadores
AtualizarListaJogadores()


