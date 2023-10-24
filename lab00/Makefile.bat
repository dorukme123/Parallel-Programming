@echo off
chcp 65001

set BINDIR=bin
set TESTDIR=test
set MODDIR=mod

mkdir %BINDIR% > nul
mkdir %MODDIR% > nul

gfortran -Wall ./%TESTDIR%/test_quad.f90 -o ./%BINDIR%/test_quad.exe -J %MODDIR%
gfortran -Wall ./%TESTDIR%/test_sum.f90 -o ./%BINDIR%/test_sum.exe -J %MODDIR%
gfortran -Wall -fopenmp ./%TESTDIR%/test_sum_omp.f90 -o ./%BINDIR%/test_sum_omp.exe -J %MODDIR%

echo Выполняем test_quad.exe
%BINDIR%\test_quad.exe 

echo Выполняем test_sum.exe
%BINDIR%\test_sum.exe

echo Тестируем параллельное суммирование
%BINDIR%\test_sum_omp.exe | python plot.py -f png -d imgs

pause
