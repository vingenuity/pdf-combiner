# pdf-combiner

## Overview
This is a quick PowerShell & batch script combination I threw together for quickly combining PDF files.

I typically use these scripts in order to combine PDF receipts for better consumption by my beancount accounting setup, but I'm sure y'all can find other uses for it!

## Instructions
1. Clone this repository to your local machine.
2. Copy the PDF files that you would like to combine to the repository directory on your local machine.
3. Double-click `CombinePdfFiles.bat`.
4. Specify the prefix of the PDF files to be combined in the console, or press enter to combine all PDF files in the folder.

The given files should then be combined!
If no prefix was specified, the combined file will be named `output.pdf`. Otherwise, the combined file will be named `<FILE_PREFIX>.pdf`.
