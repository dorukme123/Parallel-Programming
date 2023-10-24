include "map.f90"
program test_map
use iso_fortran_env, only: int32, int64,real32,real64
use test_mod
implicit none
real, dimension(6) :: A

A = [10.1,2.4,2.9,4.5,5.6,6.9]
print *, polinom1(A)

print *, map(polinom2,A)

end program test_map