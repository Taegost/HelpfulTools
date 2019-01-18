@Echo Off
REM *************************************************************
REM * Clear_TFS_Cache.bat					*
REM * 								*
REM *   This script clears out the TFS cache of the user	*
REM * profile that is currently signed in			*
REM *								*
REM * Usage:							*
REM * 							    	*
REM * 1) Close out of Visual Studio and any tools (Sidekicks)  	*
REM * 2) Run this script					*
REM *   						    	*
REM *************************************************************

Echo Please ensure that you have closed Visual Studio and all tools (Such as VS Sidekicks, TFS Power Tools, etc)
pause

Echo Clearing TFS cache
Del "C:\Users\%USERNAME%\AppData\Local\Microsoft\Team Foundation\2.0\Cache\*.*" /S /F /Q
RMDIR "C:\Users\%USERNAME%\AppData\Local\Microsoft\Team Foundation\2.0\Cache" /S /Q

Del "C:\Users\%USERNAME%\AppData\Local\Microsoft\Team Foundation\3.0\Cache\*.*" /S /F /Q
RMDIR "C:\Users\%USERNAME%\AppData\Local\Microsoft\Team Foundation\3.0\Cache" /S /Q

Del "C:\Users\%USERNAME%\AppData\Local\Microsoft\Team Foundation\4.0\Cache\*.*" /S /F /Q
RMDIR "C:\Users\%USERNAME%\AppData\Local\Microsoft\Team Foundation\4.0\Cache" /S /Q

Del "C:\Users\%USERNAME%\AppData\Local\Microsoft\Team Foundation\5.0\Cache\*.*" /S /F /Q
RMDIR "C:\Users\%USERNAME%\AppData\Local\Microsoft\Team Foundation\5.0\Cache" /S /Q


Echo Clearing VS cache
Del "C:\Users\%USERNAME%\AppData\Local\Microsoft\VisualStudio\10.0\ComponentModelCache" /S /F /Q
RMDIR "C:\Users\%USERNAME%\AppData\Local\Microsoft\VisualStudio\10.0\ComponentModelCache" /S /Q

Del "C:\Users\%USERNAME%\AppData\Local\Microsoft\VisualStudio\11.0\ComponentModelCache" /S /F /Q
RMDIR "C:\Users\%USERNAME%\AppData\Local\Microsoft\VisualStudio\11.0\ComponentModelCache" /S /Q

Del "C:\Users\%USERNAME%\AppData\Local\Microsoft\VisualStudio\12.0\ComponentModelCache" /S /F /Q
RMDIR "C:\Users\%USERNAME%\AppData\Local\Microsoft\VisualStudio\12.0\ComponentModelCache" /S /Q

Del "C:\Users\%USERNAME%\AppData\Local\Microsoft\VisualStudio\13.0\ComponentModelCache" /S /F /Q
RMDIR "C:\Users\%USERNAME%\AppData\Local\Microsoft\VisualStudio\13.0\ComponentModelCache" /S /Q

Del "C:\Users\%USERNAME%\AppData\Local\Microsoft\VisualStudio\14.0\ComponentModelCache" /S /F /Q
RMDIR "C:\Users\%USERNAME%\AppData\Local\Microsoft\VisualStudio\14.0\ComponentModelCache" /S /Q
