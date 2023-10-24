module test_mod
use iso_fortran_env, only: int32, int64,real32,real64
	 implicit none

abstract interface
pure function f(x)
real, intent(in) :: x 
real :: f
end function f
end interface
	
public :: polinom1, polinom2, map
 contains
 
 elemental real function polinom1(x)
	real,intent(in) :: x
	polinom1 = x*x*x+x*x+x
 end function 

 
 pure real  function polinom2(x)
	implicit none
	real,intent(in) :: x
	polinom2 = x*x*x+x*x+x
 end function 
 

pure function map(pol, A)
 real,dimension(1:),intent(in) :: A
 procedure(f) :: pol
 real,dimension(1:size(A,1)) :: map
 integer(int64):: i
 
	do i=1,size(A,1),1 
	map(i) = pol(A(i))
	end do
end function map
end module test_mod
