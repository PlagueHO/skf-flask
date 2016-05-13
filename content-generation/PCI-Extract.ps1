cls
#configure as needed
$outPut = "C:\temp\dumpFolder\"
$txtPath = "C:\Users\si553909.LDSTATDV\Documents\Security documents\PCI_DSS_v3-2.txt"
$checklistPath = "C:\GitRepositories\skf-flask\skf\markdown\checklists"

$checkListName ="PCIDSS32"
$increment = 0
$kb = 0
$entryAdded = @()

#Get current increment
$found = Get-ChildItem $checklistPath | select Name -Last 1 | Out-String | % {$_ -match '\d+'}

if($found) 
{
    $increment =[convert]::ToInt16($matches[0])
}


$content = (Get-Content $txtPath |Out-String)
$results = [Regex]::Matches($content, '(?msi)^(?<identifier>(\d{1,3}\.{0,1}){1,3}\.\d{1,2}\s)(.*?)(?=^(\d{1,3}\.){1,4}|Requirement\s\d{1,2})|(?<Requirement>(?m-si)Requirement\s\d{1,2}:.+)')

$results | %{               
                if ($_.Groups["Requirement"].value)
                {
                    $kb = 0                    
                }
                else
                {            
                    $kb = "1"
                }                               
               

                if(-not $entryAdded.Contains($_.Groups["identifier"].value) )
                {                   
                    $filename = "$increment--$checkListName--$kb--.md" 
                    $_.value | Out-File -FilePath $outPut$filename -Encoding ascii -Force              
                   
                
                    if($kb -ne 0)
                    {
                        $entryAdded+=($_.Groups["identifier"].value)                        
                    }

                    $increment++
                }                
            }

