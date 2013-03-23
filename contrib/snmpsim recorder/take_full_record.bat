@ECHO off

if "%1" == "/h" goto USAGE
SET AGENT_ADDRESS=%1
SET AGENT_PORT=%2
SET SNMP_VERSION=%3
SET SNMP_COMMUNITY=%4
SET DEVICE_NAME=%5

REM Argument check
if "%AGENT_ADDRESS%" == "" (
    ECHO Invalid agent address.
    GOTO USAGE
)
if "%AGENT_PORT%" == "" (
    ECHO Invalid agent port.
    GOTO USAGE
)
if not "%SNMP_VERSION%"=="v1" (
    if not "%SNMP_VERSION%"=="v2c" (
        ECHO Invalid snmp version.
        GOTO USAGE
    )
)
if "%SNMP_COMMUNITY%" == "" (
    ECHO Invalid snmp community.
    GOTO USAGE
)
if "%DEVICE_NAME%" == "" (
    ECHO Invalid device name.
    GOTO USAGE
)

REM Main
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=%AGENT_PORT% --%SNMP_VERSION% --community=%SNMP_COMMUNITY% --start-oid=1.3.6.1 --stop-oid=1.3.6.2 --output-file=devices/%DEVICE_NAME%_full.snmprec
ECHO Done!
GOTO END

:USAGE

ECHO.
ECHO Description: script to take a snmp snapshot of a device, for all the 1.3.6.1 tree.
ECHO.
ECHO Usage:  %~n0.bat ^<agent_address^> ^<agent_port^> ^<snmp_version^> ^<snmp_community^> ^<device_name^>
ECHO.
ECHO Where:  
ECHO         ^<agent_address^>    : the ip address of the target device
ECHO         ^<agent_port^>       : the port number on the target device on 
ECHO                              which the snmp service is listening
ECHO         ^<snmp_version^>     : the snmp version to use. Should be v1 or v2c.
ECHO         ^<snmp_community^>   : the snmp community to use
ECHO         ^<device_name^>      : the prefix to use for the generated record file. 
ECHO                              Better to fit to the target device type.
ECHO.

:END