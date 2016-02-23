#Requires -modules PowerPlan -RunAsAdministrator

Describe 'Get information from localhost about power plans' -tag 'taskRunnertest' {
    $builtIn = @('Balanced', 'High performance', 'Power saver')
    $plans = Get-Powerplan
    Context 'List power plans' {
        ForEach ($plan in $builtIn)
        {
            It "the returned list includes the $plan plan" {
                $plans.ElementName -contains  $plan | Should Be True
            }
            It "can specifically get the $plan plan" {
                (Get-Powerplan -PlanName $plan).ElementName | Should Be $plan
            }
        }
        It 'uses the -ComputerName parameter correctly against localhost' {
            $ComputerName = 'localhost'
            $results = Get-Powerplan -ComputerName $ComputerName
            $results.count -gt 0 | Should Be True
            # would be better to count errors
        }
        It 'returns the expected properties of a plan' {
            $properties = Get-Powerplan | Get-Member -MemberType Property
            $properties.Name | Should Be @('Caption', 'Description', 'ElementName', 'InstanceID', 'IsActive', 'PSComputerName')
        }
    }
    Context 'Set a Powerplan active' {
        $currentPlan = $plans | Where-Object {$_.IsActive -eq $true}
        ForEach ($plan in $builtIn)
        {
            It "sets $plan as active" {
                Set-PowerPlan $plan
                $active = Get-PowerPlan | Where-Object {$_.IsActive -eq $true}
                $active.ElementName | Should Be $plan
            }
        }
        It 'uses the -ComputerName parameter correctly against localhost' {
            $ComputerName = 'localhost'
            Set-Powerplan -ComputerName $ComputerName -PlanName 'Balanced'
            $active = Get-PowerPlan | Where-Object {$_.IsActive -eq $true}
            $active.ElementName | Should Be 'Balanced'
            # would be better to count errors
        }
        Set-PowerPlan $currentPlan.ElementName
    }
}