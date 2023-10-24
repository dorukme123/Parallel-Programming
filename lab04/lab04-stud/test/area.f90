include "../src/class_area.f90"
include "../src/montecarlo.f90"

program test_area
  use iso_fortran_env
  use class_area
  use montecarlo
  implicit none

  integer(int64), parameter :: N = 10**7
  real(real64), parameter :: R = 1

  type(Rectangle), parameter :: rect = Rectangle(x_1=-R, x_2=+R+R/2.0, y_1=-R, y_2=+R)
  type(Circle), parameter :: C1 = Circle(R=R)
  type(Circle), parameter :: C2 = Circle(R=R, x_0=R/2.0)
  type(Circle), parameter :: C3 = Circle(R=0.5*R, x_0=R/4.0)
  type(Ellipse), parameter :: E = Ellipse(a=2*R, b=R)
  type(Lemniscate), parameter :: L = Lemniscate(a=R)
  
  real(real64) :: x, y
  integer(int64) :: i
  
  do i = 1,N,1
    x = random_from_interval(rect%x_1, rect%x_2)
    y = random_from_interval(rect%y_1, rect%y_2)

    if (C1%test_point(x, y) .and. C2%test_point(x, y) &
        & .and. .not. C3%test_point(x, y)) then
      print "(G0, ',', G0)", x, y
    end if
  end do

end program test_area