# https://platform.openai.com/account/api-keys
# usage:
# set API env key
# $env:CHATGPT_API_KEY="YOUR_OPENAI_API_KEY"
# chatgptAPI.ps1 -question "what is the capital of the netherlands?"

param (
    [string]$question
)
    
$RequestBody = @{
    prompt = $question
    model  = "text-davinci-003"
    max_tokens = 2000
}

$Header = @{ Authorization = "Bearer $($env:CHATGPT_API_KEY) " }
$RequestBody = $RequestBody | ConvertTo-Json

$RestMethodParameter = @{
    Method      = 'Post'
    Uri         = 'https://api.openai.com/v1/completions'
    body        = $RequestBody
    Headers     = $Header
    ContentType = 'application/json'
}

return (Invoke-RestMethod @RestMethodParameter).choices.text
