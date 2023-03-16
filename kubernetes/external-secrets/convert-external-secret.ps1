function convert-external-secret {
    <#
.SYNOPSIS
This script is used to convert the old tpe external secret to the new one.

.DESCRIPTION
This script is used to convert the old tpe external secret to the new one.
After the files need to be autoformated this can be done by using the format files plugin in vscode
and using: "format files from glob" function and a matching pattern like this: **/*tpe-dev-sqiish*/externalsecret.yaml

.PARAMETER File
The external secret yaml file to convert

.EXAMPLE
Get-ChildItem -Filter externalsecret.yaml -Recurse | Where-Object {$_.DirectoryName -like "*tpe-dev-sqiish*"}|ForEach-Object { convert-external-secret -file $_.FullName }

This command will convert all the externalsecret.yaml files in folders containing tpe-dev-sqiish
#>
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$file
    )

    $resultYaml = [ordered]@{
        apiVersion = "external-secrets.io/v1beta1"
        kind       = "ExternalSecret"
        metadata   = @{
            name = $null
        }
        spec       = [ordered]@{
            data            = @(
                [ordered]@{
                    secretKey = $null
                    remoteRef = @{
                        key      = $null
                        property = $null
                    }
                }
            )
            secretStoreRef  = [ordered]@{
                kind = "ClusterSecretStore"
                name = "tpe"
            }
            refreshInterval = "5m"
        }
    }
    
    $yaml = Get-Content $file | ConvertFrom-Yaml
    $resultYaml.metadata.name = $yaml.metadata.name

    $resultYaml.spec.data = $yaml.spec.data | ForEach-Object {
        $result = [ordered]@{
            secretKey = $_.name
            remoteRef = @{
                key      = $_.key -replace '.*secret:', ''
                property = $_.property
            }
        }
        $result
    }
    $resultYaml | ConvertTo-Yaml -OutFile $file -Force
    # linux line endings
    (Get-Content $file -raw) -replace "`r`n", "`n" | Set-Content $file -NoNewline -Force
}
