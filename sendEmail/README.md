# Micro Serviço para enviar emails~
Este repositório foi criado com o propósito de fazer um micro serviço que permita enviar emails através da leitura de um ficheiro .json (input.json) com o seguinte formato:

```json
{
    "subject": "Assunto do email",
    "body": "Corpo do email",
    "to": "Email do destinatário"
}
```

# Como usar
Para usar este micro serviço basta executar o script `sendEmail.ps1` e este vai ler o ficheiro `input.json` e enviar o email com os dados presentes no ficheiro. No fundo basta preencher o ficheiro `input.json` com os dados do email que se pretende enviar e executar o script `sendEmail.ps1`. Para configurar onde estão estes ficheiros e as credencias para o envio do email basta alterar as variáveis no ficheiro `config.json`.

# Como funciona internamente

O script `sendEmail.ps1` lê o ficheiro `input.json` e envia um email com os dados presentes no ficheiro. Para enviar o email é necessário configurar as credenciais do email de envio no ficheiro `sendEmail.ps1` nas variáveis `$email` e `$password`.
Este quando lê o input.json de seguida limpa o ficheiro para que não haja problemas com futuros envios de email, sempre que envia um email coloca uma entrada no ficheiro `log.txt` com a data e hora do envio.

# Requisitos


# Possíveis melhorias
- [X] Adicionar a possibilidade de enviar emails para vários destinatários (send-email-v2)
- [X] Adicionar a possibilidade de enviar emails com anexos (send-email-v2)
- [X] Adicionar a possibilidade de enviar emails com formatação HTML (send-email-v2)
- [ ] Adicionar espera ativa para o envio de emails ( ou seja nao ter de chamar sempre o script para enviar um email)

