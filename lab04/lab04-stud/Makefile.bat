@echo off
chcp 65001

set BINDIR=bin
set TESTDIR=test
set MODDIR=mod

mkdir %BINDIR% > nul
mkdir %MODDIR% > nul

REM gfortran -fopenmp -Wall ./%TESTDIR%/montecarlo_square.f90 -o ./%BINDIR%/montecarlo_square.exe -J %MODDIR%

gfortran -fopenmp -Wall ./%TESTDIR%/area.f90 -o ./%BINDIR%/area.exe -J %MODDIR%

REM echo Выполняем test_montecarlo_square.exe
REM %BINDIR%\test_montecarlo_square.exe 


echo Выполняем area.exe
%BINDIR%\area.exe | python plot_area.py

pause
