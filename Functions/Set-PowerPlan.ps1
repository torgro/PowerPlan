function Set-PowerPlan
{
<#
.Synopsis
   Sets a Powerplan by name or by value provided from the pipeline
.DESCRIPTION
   This cmdlet invokes the CIM-method Activate in class Win32_PowerPlan. See also Get-PowerPlan cmdlet
.EXAMPLE
   Set-PowerPlan -PlanName high*

   This will set the current powerplan to High for the current computer
.EXAMPLE
   Get-Powerplan -PlanName "Power Saver" | Set-PowerPlan

   Will set the powerplan to "Power Saver" for current computer
.EXAMPLE
   Get-Powerplan -PlanName "Power Saver" -ComputerName "Server1","Server2" | Set-PowerPlan

   This will set the current powerpla to "Power Saver" for the computers Server1 and Server2
.EXAMPLE
   Set-PowerPlan -PlanName "Power Saver" -ComputerName "Server1","Server2"

   This will set the current powerpla to "Power Saver" for the computers Server1 and Server2
.NOTES
   Powerplan and performance
.COMPONENT
   Powerplan
.ROLE
   Powerplan
.FUNCTIONALITY
   This cmdlet invokes CIM-methods in the class Win32_PowerPlan
#>
[cmdletbinding(
    SupportsShouldProcess=$true,
    ConfirmImpact='Medium'
)]
Param(
    [Parameter(
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true, 
        ValueFromRemainingArguments=$false
    )]
    [Alias("ElementName")]
    [string]$PlanName = "*"
    ,    
    [Parameter(
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true, 
        ValueFromRemainingArguments=$false
    )]
    [Alias("PSComputerName")]
    [string[]]$ComputerName
)

    Begin
    {
        $f = $MyInvocation.InvocationName
        Write-Verbose -Message "$f - START"
        $GetCimInstance = @{
            Namespace = "root\cimv2\power"
            ClassName = "Win32_PowerPlan"
        }

        if($ComputerName)
        {
            $GetCimInstance.Add("ComputerName",$ComputerName)
        }

        $InvokeCimMethod = @{
            MethodName = "Activate"
        }

        if($WhatIfPreference)
        {
            $InvokeCimMethod.Add("WhatIf",$true)
        }
    }

    Process
    {   
        Write-Verbose -Message "$f -  ElementName=$PlanName"
        $CimObjectPowerPlan = Get-CimInstance @GetCimInstance | Where-Object ElementName -like "$PlanName"

        foreach($Instance in $CimObjectPowerPlan)
        {
            $null = Invoke-CimMethod -InputObject $Instance @InvokeCimMethod
        }
        if(-not $CimObjectPowerPlan)
        {
            Write-Warning -Message "Unable to find powerplan $PlanName"
        }   
    }

    End
    {
        Write-Verbose -Message "$f - END"
    }

}
