param(
    [string]$module
)
terraform state list|findstr $module| %{$_.replace("`"","\`"")}|%{terraform taint "$_"}