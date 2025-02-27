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
    $to = $email.to -join ","
    $subject = $email.subject
    $body = $email.body
    $attachments = $email.attachments
    $isHtml = $email.isHtml

    # Converter password para SecureString
    try {
        $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential ($emailUser, $securePassword)

        # Definir parâmetros do email

        # se $to forem um array de emails entao mandar para todos
        #"to": ["rodrigomnp1104@gmail.com", "rodrigomnpinto@gmail.com"],

        foreach($t in $to.Split(",")) {
           
            $mailParams = @{
                SmtpServer = $smtpServer
                Port = $smtpPort
                UseSsl = $true
                Credential = $credential
                From = $emailUser
                To = $t
                Subject = $subject
                Body = $body
                BodyAsHtml = $isHtml
            }

            # Adicionar anexos se existirem
            if ($attachments) {
                $mailParams["Attachments"] = $attachments
            }

            # Enviar email
            Send-MailMessage @mailParams

            # Registar envio no log
            $logEntry = "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")] Email enviado para $t | Assunto: $subject"
            Add-Content -Path $logFile -Value $logEntry

            Write-Host "Email enviado com sucesso para $t!" -ForegroundColor Green
        }
       
    } catch {
        Write-Host "Erro ao enviar email: $_" -ForegroundColor Red
        exit 1
    }
}

# limpar input.json
Clear-Content -Path $inputFile
