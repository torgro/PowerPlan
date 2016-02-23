# PowerPlan Module

This module allows you to get and set Power settings from PowerShell.

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
