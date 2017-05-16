@echo off
rem === ��砫� �ਯ� ===

rem --- � ���ᨨ ---
rem �����:	1.0
rem ����:	LeoVLDM
rem GitHub:	https://github.com/LeoVLDM/bat_pack-up.git
rem ��業���:	��������� �ᯮ�짮�����, ������७����, ����䨪���. ��� "��� ����", �� ᢮� ���� � �� :)
rem ���ᠭ��:	��娢�஢���� ����� � �஢�મ� � ��᫥���騬 ����஢����� �� ��㣮� ���/�����/���� � �������� �����.
rem ----------------

rem === ��砫� ��ࠬ��ࠬ ===

rem --���� ��娢�
set af=%1

rem --����� �����
set backup="\\COMP_Backup\D$\Backup"

rem --���� � WinRAR
set winrar="C:\Program Files\WinRAR\winrar.exe"

rem --��ࠬ���� ��娢�஢����
set par=-k -s -r -m5 -df -rr -ibck -ep1 -ilog%~dp0\winrar.log -inul
rem -k	�������஢��� ��娢 
rem -s	������� �����뢭� ��娢 
rem -r	������� � ��ࠡ��� �������� ����� 
rem -m5	��⮤ ᦠ�� - ���ᨬ����
rem -df	������� 䠩�� ��᫥ ��娢�樨 
rem -rr	�������� ����� ��� ����⠭������� 
rem -ibck	�������� WinRAR ��� 䮭��� ����� � ������ 㢥�������� (��⥬��� ��⪥) 
rem -ep1	�᪫���� ������� ����� �� ��� 
rem -ilog	�����뢠�� ��⮪�� �訡�� � 䠩� 
rem -inul	�� �����뢠�� ᮮ�饭�� �� �訡��� 

rem === ����� ��ࠬ��ࠬ ===


rem === ��砫� �ணࠬ�� ===

rem ��ࠬ��� ��易⥫��
if "%af%"=="" goto :starterror

rem �����뢠�� ��� � ���-䠩� ����� �뢮�� �� �࠭
set OUTPUT=%~n0.log
if "%STDOUT_REDIRECTED%" == "" (
    set STDOUT_REDIRECTED=yes
    cmd.exe /c %0 %* >>%OUTPUT%
    exit /b %ERRORLEVEL%
)

rem ��� ��������饩�� ��६����� dt � :times
setlocal enabledelayedexpansion

call :times
echo %dt%	=== ��砫� �ணࠬ�� ===

rem --- ��娢�஢���� ---
call :times
echo %dt%		���� ��娢�஢���� ...
%winrar% a %par% %af% %af%
set e=%ERRORLEVEL%
if "%e%" neq "0" goto :error_arch
call :times
echo %dt%			��娢�஢���� �����祭�.

rem --- ����஢���� ---
call :times
echo %dt%		���� ���஢���� ��娢� ...
%winrar% t -ibck -inul %1.rar
set e=%ERRORLEVEL%
if "%e%" neq "0" goto :error_arch
call :times
echo %dt%			��� ��娢� �����祭. �訡�� ���.

rem --- ��� ---
call :times
echo %dt%		���� ��� 䠩�� ��娢� ...
mkdir %backup%
copy /B /V /Y /Z %af%.rar %backup% > nul
set e=%ERRORLEVEL%
if "%e%" neq "0" goto :error_backup
call :times
echo %dt%			�����祭 ��� 䠩�� ��娢�.
goto :end

exit 0
rem === ����� �ணࠬ�� ===



rem === ��砫� �㭪�� ===

rem --- ���������� �६��� ---
:times
set dt=!date! !time!
exit /b

rem --- �訡�� ��娢��� ---
:error_arch
call :times
if "%e%" == "1" echo %dt%		�訡��: �।�०�����. ������᪨� �訡��.
if "%e%" == "2" echo %dt%		�訡��: ����᪠� �訡��.
if "%e%" == "3" echo %dt%		�訡��: ����ୠ� ����஫쭠� �㬬�. ����� ���०����.
if "%e%" == "4" echo %dt%		�訡��: ����⪠ �������� �������஢���� ��娢.
if "%e%" == "5" echo %dt%		�訡��: �訡�� ����� �� ���.
if "%e%" == "6" echo %dt%		�訡��: �訡�� ������ 䠩��.
if "%e%" == "7" echo %dt%		�訡��: ������ ��ࠬ��� � ��������� ��ப�.
if "%e%" == "8" echo %dt%		�訡��: �������筮 ����� ��� �믮������ ����樨.
if "%e%" == "9" echo %dt%		�訡��: �訡�� �� ᮧ����� 䠩��.
if "%e%" == "10" echo %dt%		�訡��: ��� ��ࠬ��஢ � 䠩���, 㤮���⢮����� 㪠������ ��᪥.
if "%e%" == "11" echo %dt%		�訡��: ������ ��஫�.
if "%e%" == "255" echo %dt%		�訡��: ������ ��ࢠ�� ���짮��⥫��.
goto :end

rem --- �訡�� ����஢���� ---
:error_backup
call :times
echo %dt%		�訡��: %e%. ��� �� �����⢫�. ��娢 �� ᪮��஢�� � ����� ����.
goto :end

rem --- �訡�� ���������饣� ��ࠬ��� ---
:starterror
echo �㦭� 㪠���� ��� �������饩 ����� ��� ��娢�஢����
echo %~nx0 �����_���_��娢�஢����

rem --- �뢮� � ���� �ணࠬ�� ---
:end
echo %dt%	=== ����� �ணࠬ�� ===
exit %e%

rem === ����� �㭪�� ===

rem === ����� �ਯ� ===
