# https://platform.openai.com/account/api-keys
# usage chatgptAPI.ps1 -question "what is the capital of the netherlands?"

param (
    [string]$question
)
    
$RequestBody = @{
    prompt      = $question
    model       = "text-davinci-003"
    temperature = 1
    stop        = "."
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
