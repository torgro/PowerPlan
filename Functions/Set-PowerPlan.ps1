function Set-PowerPlan
{
<#
.Synopsis
   Sets a Powerplan by name or by value provided from the pipeline
.DESCRIPTION
   This cmdlet invokes the CIM-method Activate in class Win32_PowerPlan. See also Get-PowerPlan cmdlet
.EXAMPLE
   Set-PowerPlan -PlanName high*

   This will set the current powerplan to "High 
.EXAMPLE
   Get-Powerplan -PlanName "Power Saver" | Set-PowerPlan
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
)

    Begin
    {
        $f = $MyInvocation.InvocationName
        Write-Verbose -Message "$f - START"    
    }

    Process
    {   
        Write-Verbose -Message "$f -  ElementName=$PlanName" 
        if ($pscmdlet.ShouldProcess("$PlanName", "Set as active powerplan"))
        {
            $CimObjectPowerPlan = Get-CimInstance -Namespace "root\cimv2\power" -ClassName "win32_PowerPlan" | Where-Object ElementName -eq "$PlanName"
            if($CimObjectPowerPlan)
            {            
                $null = Invoke-CimMethod -InputObject $CimObjectPowerPlan -MethodName Activate -Verbose
            }
        }    
    }

    End
    {
        Write-Verbose -Message "$f - END"
    }

}
