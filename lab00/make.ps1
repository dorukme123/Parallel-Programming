# Requires -PSEdition Core

$tasks = $args

$BINDIR = 'bin'
$TESTDIR = 'test'
$MODDIR = 'mod'

if ($args.count -eq 0) {
  $tasks = @(
    'quad', 'sum', 'sum_omp'
    )
}
# Set-PSDebug -Trace 0

switch($tasks) {
  'quad' {
    gfortran -Wall $TESTDIR/test_quad.f90 -o $BINDIR/test_quad.exe -J $MODDIR
  }
  'sum' {
    gfortran -fopenmp -Wall $TESTDIR/test_sum.f90 -o $BINDIR/test_sum.exe -J $MODDIR
  }
  'sum_omp' {
    gfortran -fopenmp -Wall $TESTDIR/test_sum_omp.f90 -o $BINDIR/test_sum_omp.exe -J $MODDIR
  }
  'clean' {
    Get-ChildItem -Include ('*.mod', '*.exe') -Recurse | ForEach-Object { Remove-Item -Path $_.FullName -Verbose }
  }
}