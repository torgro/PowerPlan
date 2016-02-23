#Requires -modules PowerPlan -RunAsAdministrator

Describe 'Get information from localhost about power plans' -tag 'taskRunnertest' {
    Context 'List power plans' {
        $builtIn = @('Balanced', 'High performance', 'Power saver')
        ForEach ($plan in $builtIn)
        {
            It "the returned list includes the $plan plan" {
                (Get-Powerplan | ForEach-Object 'ElementName') -contains  $plan | Should Be True
            }
            It "can specifically get the $plan plan" {
                Get-Powerplan -PlanName $plan | ForEach-Object 'ElementName' | Should Be $plan
            }
        }
    }
}