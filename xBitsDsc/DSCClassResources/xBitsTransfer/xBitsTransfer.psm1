[DscResource()]
class xBitsTransfer {
    [DscProperty(Key)]
    [string] $SourceFile

    [DscProperty(Mandatory)]
    [string]$DestinationPath

    [DscProperty(Mandatory=$false)]
    [string]$Checksum

    [DscProperty(NotConfigurable)]
    [string]$DestinationFullName

    [DscProperty(NotConfigurable)]
    [bool]$FileExists

    # Gets the resource's current state.
    [xBitsTransfer] Get() {
        $this.DestinationFullName = $this.GetFileFullName()
        try {
            if (test-path $this.DestinationFullName) {
                $this.FileExists = $true
                #$this.Checksum = $this.Checksum = (Get-FileHash -Path $this.DestinationFullName).Hash
            }
            else {
                $this.FileExists = $false
            }
        }
        catch {
            throw "Unable to query filesystem"
        }
        return $this
    }

    # Sets the desired state of the resource.
    [void] Set() {
        $this.DestinationFullName = $this.GetFileFullName()
        Write-Verbose "File will be downloaded to: $($this.DestinationFullName)"
        try {
            Start-BitsTransfer -Destination $this.DestinationFullName -Source $this.SourceFile
            $this.Checksum = (Get-FileHash -Path $this.DestinationFullName).Hash
        }
        catch {
            throw "Could not download file using BITS."
        }
        try {
            Write-Verbose "Adding alternate data stream for source url"
            Add-Content -Path $this.DestinationFullName -Stream Source -Value $this.SourceFile
        }
        catch {
            Write-Warning "Could not add Alternate Data Stream to File"
        }
    }
    
    # Tests if the resource is in the desired state.
    [bool] Test() {
        $obj = $this.Get()
        if ($obj.FileExists) {
            Write-Verbose "Detected Destination File: $($this.DestinationFullName)"
            if ($this.Checksum) {
                Write-Verbose "Checksum has been specified..Comparing"
                $currentChecksum = (Get-FileHash -Path $this.DestinationFullName).Hash
                if ($currentChecksum -ne $this.Checksum) {
                    Write-Verbose "Checksums do not match"
                    return $false
                }
                else {
                    return $true
                }
            }
            else {
                return $true
            }
        }
        else {
            return $false
        }
    }

    [string]GetFileFullName() {
        if ($this.SourceFile -match "\?") {
            $urlWOQuery = ($this.SourceFile -split "\?")[0]
            $fileName = Split-Path $urlWOQuery -Leaf
            $FileLocationPath = Join-Path -Path $this.DestinationPath -ChildPath $fileName
        }
        else {
            $fileName = Split-Path $this.SourceFile -Leaf
            $FileLocationPath = Join-Path -Path $this.DestinationPath -ChildPath $fileName
        }
        return $FileLocationPath
    }
}