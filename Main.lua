-- =====================================================
-- CYGNUSXSTORE - Key System (GitHub Auto-Verify)
-- =====================================================
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")

-- -----------------------------------------------------
-- ตั้งค่าคีย์และลิงก์เชื่อมต่อ
-- -----------------------------------------------------
local UseOnlineKey  = true 
local LocalKey      = "CYGNUS-X-2026" 
local KeyRawURL     = "https://raw.githubusercontent.com/asdqwedfg283/cygnus-keys/refs/heads/main/keys.txt" 
local DiscordInvite = "D5JsKNCKzy"
local DiscordLink   = "https://discord.gg/" .. DiscordInvite
local WebsiteLink   = "https://cygnusx.cu.ma"

-- ฟังก์ชันดึงเข้า Discord ออโต้ (RPC) + คัดลอกลิงก์
local function AutoJoinDiscord()
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    local joined = false

    if req then
        for port = 6463, 6472 do
            local ok = pcall(function()
                req({
                    Url = "http://127.0.0.1:" .. tostring(port) .. "/rpc/v1/invites/" .. DiscordInvite,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json",
                        ["Origin"] = "https://discord.com"
                    },
                    Body = HttpService:JSONEncode({
                        cmd = "INVITE_BROWSER",
                        args = { code = DiscordInvite },
                        nonce = HttpService:GenerateGUID(false)
                    })
                })
            end)
            if ok then joined = true break end
        end
    end

    if setclipboard or toclipboard then
        local copyFunc = setclipboard or toclipboard
        copyFunc(DiscordLink)
    end

    return joined
end

-- ฟังก์ชันตรวจสอบคีย์จาก GitHub Raw
local function VerifyKey(inputKey)
    inputKey = string.gsub(inputKey, "%s+", "") -- ลบช่องว่างออก
    
    if UseOnlineKey then
        local ok, result = pcall(function()
            return game:HttpGet(KeyRawURL)
        end)
        
        if ok and result then
            -- วนลูปเช็คคีย์บรรทัดต่อบรรทัดจากไฟล์บน GitHub
            for line in string.gmatch(result, "[^\r\n]+") do
                local cleanLine = string.gsub(line, "%s+", "")
                if cleanLine ~= "" and cleanLine == inputKey then
                    return true
                end
            end
        end
        return false
    else
        return inputKey == LocalKey
    end
end

-- =====================================================
-- GUI หน้ากรอกคีย์
-- =====================================================
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "CygnusKeySystem"
KeyGui.ResetOnSpawn = false
pcall(function() KeyGui.Parent = game:GetService("CoreGui") end)
if not KeyGui.Parent or not KeyGui.Parent.Name then
    KeyGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
end

local KeyWin = Instance.new("Frame")
KeyWin.Size = UDim2.new(0, 380, 0, 260)
KeyWin.Position = UDim2.new(0.5, -190, 0.5, -130)
KeyWin.BackgroundColor3 = Color3.fromRGB(12, 8, 18)
KeyWin.BorderSizePixel = 0
KeyWin.Active = true
KeyWin.Draggable = true
KeyWin.Parent = KeyGui
local kwCorner = Instance.new("UICorner") kwCorner.CornerRadius = UDim.new(0, 10) kwCorner.Parent = KeyWin

local kwStroke = Instance.new("UIStroke")
kwStroke.Color = Color3.fromRGB(160, 32, 240)
kwStroke.Thickness = 1.5
kwStroke.Transparency = 0.3
kwStroke.Parent = KeyWin

-- Header
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 32)
Title.Position = UDim2.new(0, 0, 0, 6)
Title.BackgroundTransparency = 1
Title.Text = "CYGNUS-X  |  KEY SYSTEM"
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.Parent = KeyWin

-- Website Label Button
local WebBtn = Instance.new("TextButton")
WebBtn.Size = UDim2.new(1, -40, 0, 18)
WebBtn.Position = UDim2.new(0, 20, 0, 36)
WebBtn.BackgroundTransparency = 1
WebBtn.Text = "Website: " .. WebsiteLink
WebBtn.TextColor3 = Color3.fromRGB(160, 32, 240)
WebBtn.TextSize = 11
WebBtn.Font = Enum.Font.SourceSansSemibold
WebBtn.Parent = KeyWin

-- Key Input Box
local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -40, 0, 38)
KeyInput.Position = UDim2.new(0, 20, 0, 62)
KeyInput.BackgroundColor3 = Color3.fromRGB(22, 16, 32)
KeyInput.Text = ""
KeyInput.PlaceholderText = "Paste Key Here..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(90, 80, 110)
KeyInput.TextColor3 = Color3.fromRGB(240, 240, 245)
KeyInput.TextSize = 12
KeyInput.Font = Enum.Font.SourceSansSemibold
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = KeyWin
local kiCorner = Instance.new("UICorner") kiCorner.CornerRadius = UDim.new(0, 6) kiCorner.Parent = KeyInput
local kiStroke = Instance.new("UIStroke")
kiStroke.Color = Color3.fromRGB(55, 30, 85)
kiStroke.Thickness = 1
kiStroke.Parent = KeyInput

-- Status Label
local StatusLbl = Instance.new("TextLabel")
StatusLbl.Size = UDim2.new(1, -40, 0, 18)
StatusLbl.Position = UDim2.new(0, 20, 0, 104)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text = ""
StatusLbl.TextColor3 = Color3.fromRGB(220, 60, 60)
StatusLbl.TextSize = 11
StatusLbl.Font = Enum.Font.SourceSansItalic
StatusLbl.Parent = KeyWin

-- Submit Button
local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(1, -40, 0, 36)
SubmitBtn.Position = UDim2.new(0, 20, 0, 128)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(160, 32, 240)
SubmitBtn.Text = "Check Key"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.TextSize = 12
SubmitBtn.Font = Enum.Font.SourceSansBold
SubmitBtn.BorderSizePixel = 0
SubmitBtn.Parent = KeyWin
local sbCorner = Instance.new("UICorner") sbCorner.CornerRadius = UDim.new(0, 6) sbCorner.Parent = SubmitBtn

-- Discord Join Button
local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0.5, -25, 0, 36)
DiscordBtn.Position = UDim2.new(0, 20, 0, 172)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordBtn.Text = "      Join Discord"
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.TextSize = 12
DiscordBtn.Font = Enum.Font.SourceSansBold
DiscordBtn.BorderSizePixel = 0
DiscordBtn.Parent = KeyWin
local dbCorner = Instance.new("UICorner") dbCorner.CornerRadius = UDim.new(0, 6) dbCorner.Parent = DiscordBtn

local DiscordIcon = Instance.new("ImageLabel")
DiscordIcon.Size = UDim2.new(0, 20, 0, 20)
DiscordIcon.Position = UDim2.new(0, 10, 0.5, -10)
DiscordIcon.BackgroundTransparency = 1
DiscordIcon.Image = "rbxassetid://10709791437"
DiscordIcon.Parent = DiscordBtn

task.spawn(function()
    local imgUrl = "https://cdn.prod.website-files.com/6257adef93867e50d84d30e2/636e0a6a49cf127bf92de1e2_icon_clyde_blurple_RGB.png"
    local fileName = "discord_logo_icon.png"
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if req and writefile and getcustomasset then
        if not isfile or not isfile(fileName) then
            pcall(function()
                local res = req({Url = imgUrl, Method = "GET"})
                if res and res.Body then writefile(fileName, res.Body) end
            end)
        end
        if isfile and isfile(fileName) then
            pcall(function() DiscordIcon.Image = getcustomasset(fileName) end)
        end
    end
end)

-- Get Key / Website Button
local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(0.5, -25, 0, 36)
GetKeyBtn.Position = UDim2.new(0.5, 5, 0, 172)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(28, 20, 38)
GetKeyBtn.Text = "Get Key (Web)"
GetKeyBtn.TextColor3 = Color3.fromRGB(150, 140, 170)
GetKeyBtn.TextSize = 12
GetKeyBtn.Font = Enum.Font.SourceSansBold
GetKeyBtn.BorderSizePixel = 0
GetKeyBtn.Parent = KeyWin
local gbCorner = Instance.new("UICorner") gbCorner.CornerRadius = UDim.new(0, 6) gbCorner.Parent = GetKeyBtn

-- =====================================================
-- Event Listeners
-- =====================================================
DiscordBtn.MouseButton1Click:Connect(function()
    StatusLbl.Text = "... Opening Discord ..."
    StatusLbl.TextColor3 = Color3.fromRGB(200, 180, 50)
    
    local joined = AutoJoinDiscord()
    if joined then
        StatusLbl.Text = "v  Discord invite sent / Copied link!"
        StatusLbl.TextColor3 = Color3.fromRGB(60, 200, 80)
    else
        StatusLbl.Text = "v  Link copied to clipboard!"
        StatusLbl.TextColor3 = Color3.fromRGB(60, 200, 80)
    end
end)

local function copyWebLink()
    if setclipboard or toclipboard then
        (setclipboard or toclipboard)(WebsiteLink)
        StatusLbl.Text = "v  Website link copied!"
        StatusLbl.TextColor3 = Color3.fromRGB(60, 200, 80)
    end
end

GetKeyBtn.MouseButton1Click:Connect(copyWebLink)
WebBtn.MouseButton1Click:Connect(copyWebLink)

SubmitBtn.MouseButton1Click:Connect(function()
    local userKey = KeyInput.Text
    if userKey == "" then
        StatusLbl.Text = "X  Please enter a key!"
        StatusLbl.TextColor3 = Color3.fromRGB(220, 60, 60)
        return
    end

    StatusLbl.Text = "... Verifying ..."
    StatusLbl.TextColor3 = Color3.fromRGB(200, 180, 50)
    task.wait(0.2)

    if VerifyKey(userKey) then
        StatusLbl.Text = "v  Key Correct! Loading..."
        StatusLbl.TextColor3 = Color3.fromRGB(60, 200, 80)
        task.wait(0.5)
        
        KeyGui:Destroy()
        if typeof(LoadMainScript) == "function" then
            LoadMainScript()
        end
    else
        StatusLbl.Text = "X  Invalid Key! Try again."
        StatusLbl.TextColor3 = Color3.fromRGB(220, 60, 60)
    end
end)

-- =====================================================
-- สคลิปต์หลักที่จะรันหลังจากใส่คีย์ถูกต้อง
-- =====================================================
function LoadMainScript()
    print("CYGNUS-X Loaded Successfully!")
    
    -- [[ วางโค้ด UI หลักของคุณทั้งหมดไว้ตรงนี้ ]]
    
end
