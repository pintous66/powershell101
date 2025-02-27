# ler ficheiro config.json
$config = Get-Content -Raw -Path "config.json" | ConvertFrom-Json


# Variáveis de configuração
$emailUser = $config.smtpUser
$password = $config.smtpPassword
$smtpServer = $config.smtpServer
$smtpPort = $config.smtpPort



# Caminhos dos ficheiros
$inputFile = $config.inputFile
$logFile = $config.logFile


# Verificar se o ficheiro JSON existe, se não, terminar o script
if (!(Test-Path -Path $inputFile)) {
    Write-Host "Ficheiro input.json não encontrado!" -ForegroundColor Red
    exit 1
}

# Ler e processar o ficheiro JSON, sendo que é um array de objetos ( array de emails )
$emails = Get-Content -Raw -Path $inputFile | ConvertFrom-Json

# Verificar se o ficheiro JSON está vazio, se sim, terminar o script
if ($emails.Count -eq 0) {
    Write-Host "Não há emails para enviar!" -ForegroundColor Red
    exit 1
}


# Iterar sobre cada email
foreach ($email in $emails) {
    $to = $email.to
    $subject = $email.subject
    $body = $email.body

    # Enviar email
    try {
       
        $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential ($emailUser, $securePassword)

        
        # Enviar email com o Send-MailMessage (comando nativo do PowerShell) mais info em https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/send-mailmessage?view=powershell-7.1
        Send-MailMessage -SmtpServer $smtpServer -Port $smtpPort -UseSsl `
            -Credential $credential -From $emailUser -To $to -Subject $subject -Body $body
        
          
        # Registar envio no log
        $logEntry = "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")] Email enviado para $to | Assunto: $subject"
        Add-Content -Path $logFile -Value $logEntry
        
        Write-Host "Email enviado com sucesso para $to!" -ForegroundColor Green
    } catch {
        Write-Host "Erro ao enviar email: $_" -ForegroundColor Red
        exit 1
    }
}

# limpar input.json
Clear-Content -Path $inputFile


