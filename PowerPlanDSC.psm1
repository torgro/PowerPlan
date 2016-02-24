<#
   Manages the power plan selection for a computer.
#>

[DscResource()]
class powerPlan
{
    <#
       This property is the name of an available power plan.
    #>
    [DscProperty(Key)]
    [string]$Name

    <#
        Sets the specified power plan as active.
    #>
    [void] Set()
    {
        Set-PowerPlan $Name
    }

    <#
        Tests if the machine is using the specified power plan.
    #>
    [bool] Test()
    {
        if ((Get-PowerPlan -Active).ElementName = $Name)
        {
            return $true
        }
        else
        {
            return $false
        }
    }

    <#
        Returns an instance of this class to identify the active plan.
    #>
    [powerPlan] Get()
    {
        $this.Name = (Get-PowerPlan -Active).ElementName
        return $this
    }
}