function AWSGenerateRDSToken {
    param(
        [string]$IAMAssumeRole,
        [string]$AWSSTSEndpoint,
        [string]$Username,
        [string]$RDSHostName,
        [string]$Region,
        [string]$AWSClientProfile,
        [string]$SessionName)
    try {
        $cred = ((aws sts assume-role --role-arn $IAMAssumeRole --role-session-name $SessionName --endpoint $STSEndpoint --profile $AWSClientProfile) | convertfrom-json).credentials
        $env:AWS_ACCESS_KEY_ID = $cred.AccessKeyId
        $env:AWS_SECRET_ACCESS_KEY = $cred.SecretAccessKey
        $env:AWS_SESSION_TOKEN = $cred.SessionToken
        $TOKEN = (aws rds generate-db-auth-token --hostname $RDSHostName --port 3306 --region $region --username $UserName)
    }
    catch {
        $_.exception
        $ErrorText = "Script error authenticating:<br> $_.exception<br><br>"
    }
    return $TOKEN
}