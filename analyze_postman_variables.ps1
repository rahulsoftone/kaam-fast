$envPath = "d:\kaam_fast\KaamFast.staging.postman_environment (1).json"
$collPath = "d:\kaam_fast\KaamFast.postman_collection (1).json"

$env = Get-Content $envPath -Raw | ConvertFrom-Json
$coll = Get-Content $collPath -Raw | ConvertFrom-Json

Write-Output "=========================================================="
Write-Output "1. ENVIRONMENT ANALYSIS"
Write-Output "=========================================================="
Write-Output "Environment Name: $($env.name)"
Write-Output "Scope: $($env._postman_variable_scope)"
Write-Output "Initial Variables defined in Environment:"
foreach ($v in $env.values) {
    Write-Output "  - Key: '$($v.key)' = '$($v.value)' (Enabled: $($v.enabled), Type: $($v.type))"
}

Write-Output "`n=========================================================="
Write-Output "2. COLLECTION VARIABLES & DYNAMIC VARIABLES"
Write-Output "=========================================================="
if ($coll.variable) {
    Write-Output "Collection Variables defined in root ($($coll.variable.Count)):"
    foreach ($v in $coll.variable) {
        Write-Output "  - '$($v.key)' = '$($v.value)'"
    }
} else {
    Write-Output "No root collection.variable defined."
}

# Scan all requests for {{variable}} references
$usedVariables = [System.Collections.Generic.HashSet[string]]::new()
$setVariables = [System.Collections.Generic.HashSet[string]]::new()
$testScriptsCount = 0
$prerequestScriptsCount = 0

function Traverse-Scripts($items) {
    foreach ($item in $items) {
        if ($item.item) {
            Traverse-Scripts $item.item
        }
        if ($item.event) {
            foreach ($ev in $item.event) {
                $scriptText = $ev.script.exec -join "`n"
                if ($ev.listen -eq "test") {
                    $global:testScriptsCount++
                    # Find pm.collectionVariables.set / pm.environment.set
                    $matches = [regex]::Matches($scriptText, "pm\.(collectionVariables|environment)\.set\(['""]([^'""]+)['""]")
                    foreach ($m in $matches) {
                        $null = $global:setVariables.Add($m.Groups[2].Value)
                    }
                } elseif ($ev.listen -eq "prerequest") {
                    $global:prerequestScriptsCount++
                    $matches = [regex]::Matches($scriptText, "pm\.(collectionVariables|environment)\.set\(['""]([^'""]+)['""]")
                    foreach ($m in $matches) {
                        $null = $global:setVariables.Add($m.Groups[2].Value)
                    }
                }
            }
        }
        # Check URL, Headers, Body for {{var}}
        $itemJson = $item | ConvertTo-Json -Depth 5
        $varMatches = [regex]::Matches($itemJson, "\{\{([a-zA-Z0-9_-]+)\}\}")
        foreach ($vm in $varMatches) {
            $null = $global:usedVariables.Add($vm.Groups[1].Value)
        }
    }
}

Traverse-Scripts $coll.item

Write-Output "`nTotal Test Scripts in Collection: $testScriptsCount"
Write-Output "Total Pre-request Scripts: $prerequestScriptsCount"

Write-Output "`nVariables Dynamically Created/Updated in Tests/Scripts ($($setVariables.Count)):"
foreach ($sv in ($setVariables | Sort-Object)) {
    Write-Output "  -> $sv"
}

Write-Output "`nAll {{variables}} Referenced Across URLs / Headers / Bodies ($($usedVariables.Count)):"
foreach ($uv in ($usedVariables | Sort-Object)) {
    Write-Output "  -> $uv"
}
