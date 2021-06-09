##########################################################################
# OATH authenticator import for Nexus Hybrid Access Gateway                      
##########################################################################
# version: 0.1
# last updated on: 2021-06-03 by Jonas Markström
# see readme.md for more info.
#
# NOTE: This script takes in the generic Thales authenticator seed file for 3rd
# party use and manipulates it for compliance with Nexus HAG import 
# requirements. In the script, the OTP110 authenticator is used, but the script 
# can be easily modified to support the Thales OTP Display Card and others.
#
# USEFUL RESOURCES: 
# https://powershellmagazine.com/2013/08/19/mastering-everyday-xml-tasks-in-powershell/ 
# https://www.quora.com/How-do-I-create-a-new-element-of-XML-automatically-file-in-PowerShell# 
#
# LIMITATIONS/ KNOWN ISSUES: N/A
#
# ************************************************************************
# DISCLAIMER: This script is provided "as-is" without any warranty of
# any kind, either expressed or implied.
# ************************************************************************
#
##########################################################################

# Clear the screen (because why not):
Clear-Host

##########################################################################
# CHECKS AND BALANCES:

# Inform the user of script actions:
[console]::beep(300, 150); Write-Host "`nPLEASE READ:`n============`nContinuing script execution you will be asked to browse to a source file.`nNOTE: This source file must be a Thales PSKC container with the .XML extension.`nThe script will then modify the source file and prompt you to save it.`n"

# Ask confirmation:
do {
    $ans = Read-Host "Continue!? y/n"
    if ($ans -eq 'N') { return }
}
until($ans -eq 'Y')(Write-Output "`nOK, now browse to your seed file (window may not be in focus)")

##########################################################################
# BROWSE TO SOURCE FILE FUNCTION:

Function Open-File ([string]$initialDirectory) {

    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title = "Open source Nexus seed file:"
    $OpenFileDialog.initialDirectory = $OpenInitialPath
    $OpenFileDialog.filter = "XML (*.xml)| *.xml"
    $OpenFileDialog.FileName = $OpenFileName
    $OpenFileDialog.ShowDialog() | Out-Null
    return $OpenFileDialog.filename
}


# Call the browse function above and store the selected file in a variable:
$results = Open-File 


##########################################################################
# APPEND SEED FILE WITH ELEMENTS/NODES

# A hash table holds the namespace we need to be able to navigate with xPath:
$ns = @{pskc = "urn:ietf:params:xml:ns:keyprov:pskc" }

# load it into an XML object: 
$xml = New-Object -TypeName XML
$xml.Load($results)

# Iterate the XML document using xPath to locate the AlgorithmParameters element:
Foreach ($item in (Select-XML -Xml $xml -XPath /pskc:KeyContainer/pskc:KeyPackage/pskc:Key/pskc:AlgorithmParameters -Namespace $ns)) {
    # Add element/node to AlgorithmParameters parent WITH namespace:
    $newElement = $xml.createElement('pskc:Suite', 'urn:ietf:params:xml:ns:keyprov:pskc')
    # Add the value to the key:
    $newElement.innerText = 'HMAC-SHA1'
    # Create the new node AND restrict it from writing to terminal:
    $item.node.AppendChild($newElement) | Out-null

    # Here is an example of updating an existing value within selected element:
    #$item.node.Lenght = "8"
} 


##########################################################################
# SAVE THE RESULTS:

# Function to prompt the user to save the new CSV file created:
Function Save-File ([string]$initialSaveDirectory) {

    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $SaveFileDialog.Title = "Save generated Nexus HAG seed file as:"
    $SaveFileDialog.initialSaveDirectory = $SaveInitialPath
    $SaveFileDialog.filter = "XML (*.xml)| *.xml"
    $SaveFileDialog.FileName = $SaveFileName
    $SaveFileDialog.ShowDialog() | Out-Null
    $global:selectedFilePath = $SaveFileDialog.filename
    return $SaveFileDialog.filename
}

# Call the function to save the file prompting the user for location:
$SaveMyFile = Save-File
$xml.Save($selectedFilePath)

