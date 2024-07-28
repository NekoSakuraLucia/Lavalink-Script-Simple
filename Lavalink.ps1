 function Write-Rainbow {
    param (
        [string]$Text
    )

    $colors = [System.Enum]::GetValues([System.ConsoleColor])
    $index = 0
    foreach ($char in $Text.ToCharArray()) {
        $color = $colors[$index % $colors.Count]
        Write-Host -NoNewline $char -ForegroundColor $color
        $index++
    }
    Write-Host ""
}

# Function to ping Checking Lavalink server // ฟังก์ชั่นการ ping ตรวจสอบเซิร์ฟเวอร์ Lavalink
function Ping-LavalinkServer {
    param(
        [string]$Version
    )

    $Url = "https://github.com/lavalink-devs/Lavalink/releases/tag/$Version"
    $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -Method Head

    if ($response.StatusCode -eq 200) {
  Write-Rainbow ("Checking Lavalink ${Version}: is successfully.")
    } else {
        Write-Host ("Checking Lavalink ${Version}: is not success") -ForegroundColor Rainbow
        exit 1
    }
}

# Function to download Lavalink release from GitHub // ฟังก์ชั่นดาวน์โหลด Lavalink release จาก GitHub
function Download-Lavalink {
    param(
        [string]$Version
    )

    $DownloadUrl = "https://github.com/lavalink-devs/Lavalink/releases/download/$Version/Lavalink.jar"
    $OutputFile = "Lavalink-$Version.jar"

    Write-Host "Downloading Lavalink version $($Version)..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $OutputFile

    if ($?) {
        Write-Host "Lavalink version $($Version) downloaded successfully." -ForegroundColor Green
        
        # Run Lavalink automatically after download // เรียกใช้ Lavalink โดยอัตโนมัติหลังจากดาวน์โหลด
        Write-Host "Running Lavalink version $($Version)..." -ForegroundColor Cyan
        Start-Process java -ArgumentList "-Xmx512M", "-jar", $OutputFile -Wait
    } else {
        Write-Host "Failed to download Lavalink version $($Version)." -ForegroundColor Red
        exit 1
    }
}

# Main script logic // ตรรกะสคริปต์หลัก
Write-Host "Welcome to Lavalink installer script!" -ForegroundColor Yellow

# Ping all versions of Lavalink first // ปิง Lavalink ทุกเวอร์ชันก่อน
$Versions = @(
    "4.0.7",
    "4.0.6",
    "4.0.5",
    "4.0.4",
    "4.0.3",
    "3.7.12",
    "3.7.11"
)

foreach ($Version in $Versions) {
    Ping-LavalinkServer $Version
}

# Prompt user to select Lavalink version
Write-Host "Choose Lavalink version to install:" -ForegroundColor Yellow
Write-Host "1. 4.0.7" -ForegroundColor Green
Write-Host "2. 4.0.6" -ForegroundColor Green
Write-Host "3. 4.0.5" -ForegroundColor Green
Write-Host "4. 4.0.4" -ForegroundColor Green
Write-Host "5. 4.0.3" -ForegroundColor Green
Write-Host "6. 3.7.12" -ForegroundColor Green
Write-Host "7. 3.7.11" -ForegroundColor Green
$Choice = Read-Host "Enter your choice (1-7)"

switch ($Choice) {
    "1" {
        Download-Lavalink "4.0.7"
    }
    "2" {
        Download-Lavalink "4.0.6"
    }
    "3" {
        Download-Lavalink "4.0.5"
    }
    "4" {
        Download-Lavalink "4.0.4"
    }
    "5" {
        Download-Lavalink "4.0.3"
    }
    "6" {
        Download-Lavalink "3.7.12"
    }
    "7" {
        Download-Lavalink "3.7.11"
    }
    default {
        Write-Host "Invalid choice. Please enter a number from 1 to 7." -ForegroundColor Red
        exit 1
    }
}

exit 0
