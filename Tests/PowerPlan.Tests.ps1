#Requires -modules PowerPlan -RunAsAdministrator

Describe 'Discovers and and sets power plan' {
    
    $plans = Get-Powerplan
    
    Context 'List power plans' {
        ForEach ($plan in $plans)
        {
            $plan = $plan.ElementName

            It "the returned list includes the $plan plan" {
                $plans.ElementName -contains  $plan | Should Be True
            }
            It "can specifically get the $plan plan" {
                (Get-Powerplan -PlanName $plan).ElementName | Should Be $plan
            }
        }
        It 'uses the -ComputerName parameter correctly against localhost' {
            $ComputerName = 'localhost'
            $results = Get-Powerplan -ComputerName $ComputerName | ForEach-Object ElementName
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

        Mock -ModuleName PowerPlan -CommandName Invoke-CimMethod -MockWith {}

        ForEach ($plan in $plans)
        {
            $plan = $plan.ElementName

            It "handles the plan $plan without error" {
                {Set-PowerPlan $plan} | Should Not Throw
            }
            It "calls the correct mocks" {
                Assert-MockCalled -ModuleName PowerPlan -CommandName Invoke-CimMethod -Times 1
            }
        }
        It 'uses the -ComputerName parameter correctly against localhost' {
            $ComputerName = 'localhost'
            {Set-Powerplan -ComputerName $ComputerName -PlanName 'Balanced'} | Should Not Throw
        }
        It "calls the correct mocks" {
            Assert-MockCalled -ModuleName PowerPlan -CommandName Invoke-CimMethod -Times 1
        }
    }

    Context 'Set-PowerPlan implements -WhatIf' {

        Mock -ModuleName PowerPlan -CommandName Invoke-CimMethod -MockWith {}

        It "handles -whatif without error" {
            {Set-PowerPlan 'Balanced' -whatif} | Should Not Throw
        }
        It "does not call the mock" {
            Assert-MockCalled -ModuleName PowerPlan -CommandName Invoke-CimMethod -Times 0
        }
    }
}