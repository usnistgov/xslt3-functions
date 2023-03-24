# XSLT / XProc Directory Manifest

Writes descriptions of your folder's XSLT and XProc contents, dynamically.

Run the XProc providing the path to the subdirectory you want and it writes out a report.

Output ports are defined for HTML and Markdown formats - save either one or both.

Invocation scripts:

`make-manifest-here.sh` Bash shell script produces manifest.md in the current (working) directory, using Maven to call XML Calabash - requires Maven

`make-x3f-manifest.bat` Windows Powershell script does likewise

`produce-manifest.sh` calls XML Calabash directly (work in progress) - does not require Maven, only XML Calabash on Java
