function Set-PowerPlan
{
<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
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
