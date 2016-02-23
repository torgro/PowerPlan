#Requires -modules PowerPlan -RunAsAdministrator

Describe 'Get information from localhost about power plans' -tag 'taskRunnertest' {
    Context 'List power plans' {
        $plans = Get-PowerPlan
        $builtIn = @('Balanced', 'High performance', 'Power saver')
        ForEach ($plan in $builtIn)
        {
            It "includes the $plan plan" {
                ($plans | ForEach-Object 'ElementName') -contains  $plan | Should Be True
            }
        }
    }
}