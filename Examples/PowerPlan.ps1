Configuration PowerSettings
{
    Import-DscResource -ModuleName PowerPlan

    PowerPlan HighPerformance
    {
        Name = 'High performance'
    }
}

PowerSettings -outputpath C:\DSC\PowerPlan