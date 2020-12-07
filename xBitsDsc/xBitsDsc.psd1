@{
#RootModule = 'MultisiteCluster.psm1'
DscResourcesToExport = @('xBitsTransfer')

# Version number of this module.
ModuleVersion = '0.0.1'

# ID used to uniquely identify this module
GUID = '901141bd-799f-4f1f-adcc-9ebf56488b2c'

# Author of this module
Author = 'Cornelius Schuchardt'

# Module Description
Description = 'PowerShell DSC Resources to download Files via BITS'

# Company or vendor of this module
CompanyName = 'Bright Skies GmbH'

NestedModules = @('.\DSCClassResources\xBitsTransfer\xBitsTransfer.psd1')

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''
}