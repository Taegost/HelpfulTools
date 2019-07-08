@Echo Off
REM Use this script to make backups of important folders.  It has 2 stages: 1st
REM stage creates a local backup on the machine, then the 2nd stage mirrors those
REM backups to a remote location

REM 7-Zip is a pre-req to archive the files, you need to make sure it's installed
REM and accessible from the command shell before using.
REM As always, make sure you test that it works before trusting it.

REM Set variables
REM It is best to avoid spaces whenever possible
Set ApplicationName=SampleApplication
Set ServerFolder=D:\%ApplicationName%
Set LocalDrive=E:
Set LocalBackupFolder=\Backups\%ApplicationName%
Set LocalTempFolder=\Temp\%ApplicationName%
Set BackupDestination=\\RemoteFileServer\Backups\%ApplicationName%

REM Uses the date format YYYY-MM-DD (ex. 2019-07-23)
Set BackupDate=%DATE:~10,4%-%DATE:~4,2%-%DATE:~7,2%

Echo Switch to the backup folder

%LocalDrive%
Cd %LocalBackupFolder%

REM This keeps 5 days of backups.  To keep more, just modify this section
REM This may generate errors during the first few runs, but they can be safely
REM ignored as long as you know the folders really don't exist.
Echo In case the the folders already exist, rotate them
RD /Q /S Day5
Ren Day4 Day5
Ren Day3 Day4
Ren Day2 Day3
Ren Latest Day2

MD Latest

REM It's important to copy the files first because if any of them are in use
REM at the time 7-Zip tries to archive them, they will most likely be skipped.
Echo Copying the files to a temporary location
RD /Q /S %LocalDrive%%LocalTempFolder%
XCopy /E /Y %ServerFolder% %LocalDrive%%LocalTempFolder%\

REM In addition to creating the archive, it also creates an archive log, to 
REM aid in troubleshooting
Echo Zipping files
7z a "%LocalDrive%%LocalBackupFolder%\Latest\%ApplicationName%_Backup_%backupdate%.zip" -xr!%ApplicationName%\Archive "%LocalDrive%%LocalTempFolder%" > "%LocalDrive%%LocalBackupFolder%\Latest\Archive.Log"

REM Excludes the \Archive and \Weekly folders in the destination folder so they 
REM aren't overwritten during the mirror operation.  ALso creates a log in the
REM destination folder.
Echo Mirror to the backup folder on the fileserver
Robocopy "%LocalDrive%%LocalBackupFolder%" "%BackupDestination%" /XD "%BackupDestination%\Weekly" "%BackupDestination%\Archive" /MIR /COPY:DT /FFT /LOG:"%BackupDestination%\Robocopy.Log" 