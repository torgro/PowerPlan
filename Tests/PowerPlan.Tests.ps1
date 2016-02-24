#Requires -modules PowerPlan -RunAsAdministrator

Describe 'Get information from localhost about power plans' -tag 'taskRunnertest' {
    try {
        
        BeforeAll
        {
            $restorePlan = Get-CimInstance -Namespace 'root\cimv2\power' -ClassName 'Win32_PowerPlan' -Filter 'IsActive=True'
        }
        
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
            }
            It 'returns the expected properties of a plan' {
                $properties = Get-Powerplan | Get-Member -MemberType Property
                $properties.Name | Should Be @('Caption', 'Description', 'ElementName', 'InstanceID', 'IsActive', 'PSComputerName')
            }
            It 'returns the expected plan using the -Active parameter' {
                $active = Get-CimInstance -Namespace 'root\cimv2\power' -ClassName 'Win32_PowerPlan' -Filter 'IsActive=True'
                (Get-Powerplan -Active).InstanceID | Should Be $active.InstanceID
            }
        }
        
        Context 'Set a Powerplan active' {
            ForEach ($plan in $builtIn)
            {
                It "sets $plan as active" {
                    Set-PowerPlan $plan
                    $active = Get-CimInstance -Namespace 'root\cimv2\power' -ClassName 'Win32_PowerPlan' -Filter 'IsActive=True'
                    $active.ElementName | Should Be $plan
                }
            }
            It 'uses the -ComputerName parameter correctly against localhost' {
                $ComputerName = 'localhost'
                Set-Powerplan -ComputerName $ComputerName -PlanName 'Balanced'
                $active = Get-CimInstance -Namespace 'root\cimv2\power' -ClassName 'Win32_PowerPlan' -Filter 'IsActive=True'
                $active.ElementName | Should Be 'Balanced'
            }
        }
    }
    finally {
        AfterAll
        {
            $inputObject = Get-CimInstance -Namespace 'root\cimv2\power' -ClassName 'Win32_PowerPlan' | Where-Object {$_.ElementName -eq $restorePlan.ElementName}
            $null = Invoke-CimMethod -InputObject $inputObject -MethodName Activate
        }
    }
}