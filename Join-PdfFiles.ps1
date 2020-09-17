
<#PSScriptInfo

.VERSION 1.0.0

.GUID 6cd0313e-c0c8-4dae-bac8-f7b88b78bb0e

.AUTHOR "Vincent Kocks"

.COMPANYNAME

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES pdftk

.RELEASENOTES


.PRIVATEDATA

#>

<#

.SYNOPSIS
 Joins multiple PDF files using pdftk server.

.DESCRIPTION
 Joins multiple PDF files using pdftk server.

.PARAMETER InputPattern
 Specifies the wildcard pattern used to locate the PDF files to join.
 The default pattern is '*.pdf'.

.PARAMETER InputDirectory
 Specifies the directory in which the PDF files to join are located.
 The default directory is the current working directory.

.PARAMETER OutFile
 Specifies the path at which the joined PDF should be output.
 The default path is 'output.pdf'.

.PARAMETER PdftkPath
 Specifies the path at which pdftk-server is located.
 The default assumes that pdftk-server is installed in the system's PATH.

.INPUTS
 None. You cannot pipe objects to Join-PdfFiles.ps1.

.OUTPUTS
 None. Join-PdfFiles.ps1 does not generate any output.

.EXAMPLE
 C:\PS> .\Join-PdfFiles.ps1 -InputPattern 'test*.pdf'

.EXAMPLE
 C:\PS> .\Join-PdfFiles.ps1 -InputPattern 'test*.pdf' -InformationAction 'Continue'
 Locating PDF files matching pattern 'test*.pdf' in directory 'C:\Code\pdf-combiner'...
 Found 2 PDF files to combine.
 Combining PDFs into file at 'C:\Code\pdf-combiner\output.pdf'...

.LINK
 pdftk server homepage: https://www.pdflabs.com/tools/pdftk-server/

#>
[CmdletBinding()]
Param(
    [ValidateNotNullOrEmpty()]
    [string]$InputPattern = '*.pdf',

    [ValidateNotNullOrEmpty()]
    [string]$InputDirectory = $(Get-Location),

    [ValidateNotNullOrEmpty()]
    [string]$OutFile = $(Get-Location | Join-Path -ChildPath 'output.pdf'),

    [ValidateNotNullOrEmpty()]
    [string]$PdftkPath = 'pdftk'
)

if ((Get-Command $PdftkPath -ErrorAction 'SilentlyContinue') -eq $null)
{ 
   Write-Error "Unable to find pdftk executable at '$PdftkPath'!"
   exit 1
}

Write-Information "Locating PDF files matching pattern '$InputPattern' in directory '$InputDirectory'..."
$FilePaths = Get-ChildItem -Path:$InputDirectory -Filter:$InputPattern

$fileCount = $FilePaths.Count
if($fileCount -le 0) {
    Write-Error "Unable to find any files matching pattern '$InputPattern'!"
    exit 2
}
elseif($fileCount -eq 1) {
    Write-Warning "Only one file matching pattern '$InputPattern' was found! No joining is needed."
}
else {
    Write-Information "Found $fileCount PDF files to combine."
    Write-Verbose 'Found PDF files:'
    $FilePaths | Select-Object -ExpandProperty 'Name' | Write-Verbose

    Write-Information "Combining PDFs into file at '$OutFile'..."
    $PdftkArguments = $FilePaths + @('cat', 'output', $OutFile)
    & $PdftkPath $PdftkArguments

    if($LASTEXITCODE -ne 0) {
        Write-Error "An error occurred in pdftk!"
        exit 3
    }
}
