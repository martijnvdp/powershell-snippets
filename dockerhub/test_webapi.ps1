$token = ((invoke-webrequest "https://auth.docker.io/token?scope=repository%3Ahashicorp%2Ftfc-agent%3Apull&service=registry.docker.io").Content|ConvertFrom-Json).token
$authorization = "Bearer $token"

$headers = @{'Authorization'=$authorization}
invoke-restmethod -Uri "https://registry.hub.docker.com/v2/hashicorp/tfc-agent/tags/list" -ContentType application/json -Method Get -Headers $headers
Invoke-RestMethod -Uri "https://registry.hub.docker.com/v2/hashicorp/tfc-agent/manifests/latest" -ContentType application/vnd.docker.distribution.manifest.v2+json -Method Get -Headers $headers
