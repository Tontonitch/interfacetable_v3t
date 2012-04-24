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
    if not "%SNMP_VERSION%"=="%SNMP_VERSION%" (
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
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=%AGENT_PORT% --%SNMP_VERSION% --community=%SNMP_COMMUNITY% --start-oid=1.3.6.1.2.1.1.1 --stop-oid=1.3.6.1.2.1.1.7 --output-file=devices/%DEVICE_NAME%_partial.snmprec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=%AGENT_PORT% --%SNMP_VERSION% --community=%SNMP_COMMUNITY% --start-oid=1.3.6.1.2.1.2.2.1 --stop-oid=1.3.6.1.2.1.2.2.2 --output-file=devices/%DEVICE_NAME%_partial.snmprec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=%AGENT_PORT% --%SNMP_VERSION% --community=%SNMP_COMMUNITY% --start-oid=1.3.6.1.2.1.4.20.1.2 --stop-oid=1.3.6.1.2.1.4.20.1.4 --output-file=devices/%DEVICE_NAME%_partial.snmprec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=%AGENT_PORT% --%SNMP_VERSION% --community=%SNMP_COMMUNITY% --start-oid=1.3.6.1.2.1.10.7.2.1.19 --stop-oid=1.3.6.1.2.1.10.7.2.1.20 --output-file=devices/%DEVICE_NAME%_partial.snmprec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=%AGENT_PORT% --%SNMP_VERSION% --community=%SNMP_COMMUNITY% --start-oid=1.3.6.1.4.1.11.2.14.11.5.1.7.1.15.3.1.2 --stop-oid=1.3.6.1.4.1.11.2.14.11.5.1.7.1.15.3.1.3 --output-file=devices/%DEVICE_NAME%_partial.snmprec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=%AGENT_PORT% --%SNMP_VERSION% --community=%SNMP_COMMUNITY% --start-oid=1.3.6.1.2.1.17.1 --stop-oid=1.3.6.1.2.1.17.3 --output-file=devices/%DEVICE_NAME%_partial.snmprec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=%AGENT_PORT% --%SNMP_VERSION% --community=%SNMP_COMMUNITY% --start-oid=1.3.6.1.2.1.31.1.1.1 --stop-oid=1.3.6.1.2.1.31.1.1.2 --output-file=devices/%DEVICE_NAME%_partial.snmprec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=%AGENT_PORT% --%SNMP_VERSION% --community=%SNMP_COMMUNITY% --start-oid=1.3.6.1.2.1.47.1.2.1.1.2 --stop-oid=1.3.6.1.2.1.47.1.2.1.1.3 --output-file=devices/%DEVICE_NAME%_partial.snmprec
echo/|set /p =.

REM Cisco
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=%AGENT_PORT% --%SNMP_VERSION% --community=%SNMP_COMMUNITY% --start-oid=1.3.6.1.4.1.9.5.1.2 --stop-oid=1.3.6.1.4.1.9.5.1.3 --output-file=devices/%DEVICE_NAME%_partial.snmprec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=%AGENT_PORT% --%SNMP_VERSION% --community=%SNMP_COMMUNITY% --start-oid=1.3.6.1.4.1.9.5.1.4.1.1 --stop-oid=1.3.6.1.4.1.9.5.1.4.1.2 --output-file=devices/%DEVICE_NAME%_partial.snmprec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=%AGENT_PORT% --%SNMP_VERSION% --community=%SNMP_COMMUNITY% --start-oid=1.3.6.1.4.1.9.9.68.1.2.2.1 --stop-oid=1.3.6.1.4.1.9.9.68.1.2.2.2 --output-file=devices/%DEVICE_NAME%_partial.snmprec
echo/|set /p =.

REM Hp
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=%AGENT_PORT% --%SNMP_VERSION% --community=%SNMP_COMMUNITY% --start-oid=1.3.6.1.4.1.11.2.14.11.5.1.7.1.15.3.1.2 --stop-oid=1.3.6.1.4.1.11.2.14.11.5.1.7.1.15.3.1.3 --output-file=devices/%DEVICE_NAME%_partial.snmprec
echo/|set /p =.


REM NetScreen
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=%AGENT_PORT% --%SNMP_VERSION% --community=%SNMP_COMMUNITY% --start-oid=1.3.6.1.4.1.3224.8 --stop-oid=1.3.6.1.4.1.3224.10 --output-file=devices/%DEVICE_NAME%_partial.snmprec
echo/|set /p =.
snmprec.exe --quiet --agent-address=%AGENT_ADDRESS% --agent-port=%AGENT_PORT% --%SNMP_VERSION% --community=%SNMP_COMMUNITY% --start-oid=1.3.6.1.4.1.3224.15 --stop-oid=1.3.6.1.4.1.3224.16 --output-file=devices/%DEVICE_NAME%_partial.snmprec

ECHO Done!
GOTO END

:USAGE

ECHO.
ECHO Description: script to take a snmp snapshot of a device, only for the oids needed for interfacetable_v3t simulations.
ECHO.
ECHO Usage:  %~n0.bat ^<agent_address^> ^<agent_port^> ^<snmp_version^> ^<snmp_community^> ^<device_name^>
ECHO.
ECHO Where:  
ECHO         ^<agent_address^>    : the ip address of the target device
ECHO         ^<agent_port^>       : the port number on the target device on 
ECHO                              which the snmp service is listening
ECHO         ^<snmp_version^>     : the snmp version to use. Should be v1 or %SNMP_VERSION%.
ECHO         ^<snmp_community^>   : the snmp community to use
ECHO         ^<device_name^>      : the prefix to use for the generated record file. 
ECHO                              Better to fit to the target device type.
ECHO.

:END