:: CombinePdfFiles.bat
:: Written by Vincent Kocks
:: v1.0.0
@echo off

:: Static Environment Variables
set JOIN_PDF_SCRIPT_PATH=%~dp0Join-PdfFiles.ps1

set PDF_FILE_ROOT=%~dp0
set PDFTK_PATH=pdftk
set VERBOSE=False


:: Dynamic Environment Variables
set /P PDF_FILE_PREFIX=Please enter the name prefix of the PDF files to join, or leave blank to join all PDF files:
if "%PDF_FILE_PREFIX%" == "" (
    set PDF_PATTERN_ARGUMENT=
    set PDF_OUTPUT_ARGUMENT=
    echo Combining all PDF files...
) else (
    set PDF_PATTERN_ARGUMENT=-InputPattern '%PDF_FILE_PREFIX%*'
    set PDF_OUTPUT_ARGUMENT=-OutFile '%PDF_FILE_PREFIX%.pdf'
    echo Combining PDF files with prefix '%PDF_FILE_PREFIX%'...
)


:: Main Execution
pwsh -ExecutionPolicy Bypass -Command "%JOIN_PDF_SCRIPT_PATH% %PDF_PATTERN_ARGUMENT% -InputDirectory '%PDF_FILE_ROOT%' %PDF_OUTPUT_ARGUMENT% -PdftkPath '%PDFTK_PATH%' -InformationAction 'Continue' -Verbose:$%VERBOSE%"
rem Reminder: ERRORLEVEL 1 covers all positive error numbers
if ERRORLEVEL 1 goto error

echo PDF combining finished successfully.
goto finish

:error
echo PDF combining failed!
goto finish

:finish
pause
