# PowerPlan Module

Allows you to retrieve the list of available power plans and select the active
plans from PowerShell.

This module includes both PowerShell functions and a Desired State Configuration
resource.  Pester unit tests are provided in the .\Tests folder and an example
configuration script is provided in the .\Examples folder.

**Examples**

    # List available plans
    Get-Powerplan
    
    # List active plan
    Get-Powerplan | ? IsActive -eq $true
    
    # List available plans on remote computer
    Get-Powerplan -Computername RemoteMachine
    
    # Set active plan
    Set-Powerplan Balanced
    
    # Set active plan with space in the name
    Set-Powerplan -Planname 'High performance'
    
    # Set active plan on remote computer
    Set-Powerplan -Planname Balanced -Computername RemoteMachine
    
    # Create a new configuration that contains the PowerPlan resource
    Configuration PowerSettings
    {
        Import-DscResource -ModuleName PowerPlan

        PowerPlan HighPerformance
        {
            Name = 'High performance'
        }            
    }

    # temp

**Release Notes**

v2.0.0.0
* Modifications to add Pester tests and DSC resources

v1.0.3.0
* Original module release by Tore Grøneng