function Get-Powerplan
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
[cmdletbinding()]
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
        if($PlanName)
        {
            Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan | Where-Object ElementName -Like "$PlanName"
        }
        else
        {
            Get-CimInstance -Name root\cimv2\power -Class Win32_PowerPlan
        }
    }

    End
    {
        Write-Verbose -Message "$f - END"
    }
}