# compare helm chart versions from manfests with latest on repo
$rootPath = "$PSScriptRoot/.."
$csv_out_file = "$PSScriptRoot/../charts.csv"

$helm_repos = $(helm repo list -o json | convertfrom-json)
helm repo update

if ($IsWindows) {
    $delimiter = "\"
}

$charts = $(Get-ChildItem -File -Include Chart.yaml -Recurse $rootPath | Select-Object FullName).FullName
foreach ($chart in $charts) {
    $current_charts += $(Get-Content $chart | ConvertFrom-Yaml).dependencies
}

foreach ($chart in $($current_charts | Select-Object name, repository, version | Sort-Object name -Unique)) {
    if (!($helm_repos.name -eq "$($chart.name)")) {
        helm repo add $chart.name $chart.repository
        helm repo update
        $helm_repos = $(helm repo list -o json | convertfrom-json)
    }
   
    $(helm search repo "$($chart.name)/$($chart.name)" -o json | ConvertFrom-Json) | Select-Object `
    @{Name = 'Name'; Expression = { $_.Name } }, `
    @{Name = 'Description'; Expression = { $_.Description } }, `
    @{Name = 'current_chart_version'; Expression = { $chart.version } }, `
    @{Name = 'latest_chart_version'; Expression = { $_.version } } | Export-Csv -Append $csv_out_file
}
