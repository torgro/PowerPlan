#Requires -modules PowerPlan -RunAsAdministrator

Describe 'Get information from localhost about power plans'
{
    Context 'List all power plans'
    {
        It 'list of plan names'
        {
            Get-PowerPlan | ForEach-Object 'ElementName' | Should Include @('Balanced', 'HIgh performance', 'Power saver')
        }
    }
}