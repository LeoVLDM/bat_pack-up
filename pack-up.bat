@echo off
rem === Начало скрипта ===

rem --- О версии ---
rem Версия:	1.0
rem Автор:	LeoVLDM
rem GitHub:	https://github.com/LeoVLDM/bat_pack-up.git
rem Лицензия:	Свободное использование, распростраренение, модификация. Всё "как есть", на свой страх и риск :)
rem Описание:	Архивирование папки с проверкой и последующим копированием на другой диск/папку/комп с ведением логов.
rem ----------------

rem === Начало параметрам ===

rem --Файл архива
set af=%1

rem --Папка бэкапов
set backup="\\COMP_Backup\D$\Backup"

rem --Путь к WinRAR
set winrar="C:\Program Files\WinRAR\winrar.exe"

rem --Параметры архивирования
set par=-k -s -r -m5 -df -rr -ibck -ep1 -ilog%~dp0\winrar.log -inul
rem -k	Заблокировать архив 
rem -s	Создать непрерывный архив 
rem -r	Включить в обработку вложенные папки 
rem -m5	Метод сжатия - максимальный
rem -df	Удалить файлы после архивации 
rem -rr	Добавить данные для восстановления 
rem -ibck	Запустить WinRAR как фоновый процесс в области уведомлений (системном лотке) 
rem -ep1	Исключить базовую папку из имён 
rem -ilog	Записывать протокол ошибок в файл 
rem -inul	Не показывать сообщения об ошибках 

rem === Конец параметрам ===


rem === Начало программы ===

rem Параметр обязателен
if "%af%"=="" goto :starterror

rem Записывать всё в лог-файл вместо вывода на экран
set OUTPUT=%~n0.log
if "%STDOUT_REDIRECTED%" == "" (
    set STDOUT_REDIRECTED=yes
    cmd.exe /c %0 %* >>%OUTPUT%
    exit /b %ERRORLEVEL%
)

rem для обновляющейся переменной dt в :times
setlocal enabledelayedexpansion

call :times
echo %dt%	=== Начало программы ===

rem --- Архивирование ---
call :times
echo %dt%		Начато архивирование ...
%winrar% a %par% %af% %af%
set e=%ERRORLEVEL%
if "%e%" neq "0" goto :error_arch
call :times
echo %dt%			архивирование закончено.

rem --- Тестирование ---
call :times
echo %dt%		Начато тестирование архива ...
%winrar% t -ibck -inul %1.rar
set e=%ERRORLEVEL%
if "%e%" neq "0" goto :error_arch
call :times
echo %dt%			тест архива закончен. Ошибок нет.

rem --- Бэкап ---
call :times
echo %dt%		Начат бэкап файла архива ...
mkdir %backup%
copy /B /V /Y /Z %af%.rar %backup% > nul
set e=%ERRORLEVEL%
if "%e%" neq "0" goto :error_backup
call :times
echo %dt%			закончен бэкап файла архива.
goto :end

exit 0
rem === Конец программы ===



rem === Начало функциям ===

rem --- Обновление времени ---
:times
set dt=!date! !time!
exit /b

rem --- Ошибки архиватора ---
:error_arch
call :times
if "%e%" == "1" echo %dt%		Ошибка: Предупреждение. Некритические ошибки.
if "%e%" == "2" echo %dt%		Ошибка: Критическая ошибка.
if "%e%" == "3" echo %dt%		Ошибка: Неверная контрольная сумма. Данные повреждены.
if "%e%" == "4" echo %dt%		Ошибка: Попытка изменить заблокированный архив.
if "%e%" == "5" echo %dt%		Ошибка: Ошибка записи на диск.
if "%e%" == "6" echo %dt%		Ошибка: Ошибка открытия файла.
if "%e%" == "7" echo %dt%		Ошибка: Неверный параметр в командной строке.
if "%e%" == "8" echo %dt%		Ошибка: Недостаточно памяти для выполнения операции.
if "%e%" == "9" echo %dt%		Ошибка: Ошибка при создании файла.
if "%e%" == "10" echo %dt%		Ошибка: Нет параметров и файлов, удовлетворяющих указанной маске.
if "%e%" == "11" echo %dt%		Ошибка: Неверный пароль.
if "%e%" == "255" echo %dt%		Ошибка: Операция прервана пользователем.
goto :end

rem --- Ошибка копирования ---
:error_backup
call :times
echo %dt%		Ошибка: %e%. Бэкап не осуществлён. Архив не скопирован в папку бэкапа.
goto :end

rem --- Ошибка отсутствующего параметра ---
:starterror
echo Нужно указать имя существующей папки для архивирования
echo %~nx0 папка_для_архивирования

rem --- Вывод о конце программы ---
:end
echo %dt%	=== Конец программы ===
exit %e%

rem === Конец функциям ===

rem === Конец скрипта ===
