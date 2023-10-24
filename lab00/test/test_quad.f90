include "../src/quadequation.f90"

! Тестирование решений квадратного уравнения
subroutine test(a, b, c)
  use iso_fortran_env, only: int32, int64, real32, real64
  use quadequation
  implicit none
  
  real(real64), intent(in) :: a, b, c
  
  real(real64), dimension(1:2) :: x
  complex(real64), dimension(1:2) :: cx
  logical :: is_real

  is_real = .true.

  call quadroots(a, b, c, x, cx, is_real)

  ! действительные корни
  if (is_real) then
    ! проверяем корни
    print *, "test 01: ", abs(real_p2(a, b, c, x(1))) <= epsilon(1.0d0)
    print *, "test 02: ", abs(real_p2(a, b, c, x(2))) <= epsilon(1.0d0)
    ! теорема Виета
    print *, "test 03: ", abs(x(1) + x(2) + b/a) <= epsilon(1.0d0)
    print *, "test 04: ", abs(x(1) * x(2) - c/a) <= epsilon(1.0d0)
  ! комплексные корни
  else if (.not. is_real) then
    ! проверяем корни
    print *, "test 01: ", abs(complex_p2(a, b, c, cx(1))) <= epsilon(1.0d0)
    print *, "test 02: ", abs(complex_p2(a, b, c, cx(2))) <= epsilon(1.0d0)
    ! теорема Виета
    print *, "test 03: ", abs(cx(1) + cx(2) + b/a) <= epsilon(1.0d0)
    print *, "test 04: ", abs(cx(1) * cx(2) - c/a) <= epsilon(1.0d0)
  end if
end subroutine test

program test_quad
  use iso_fortran_env, only: int32, int64, real32, real64
  implicit none
  real(real64) :: a, b, c

  print *, "Целые коэффициенты"
  a = 1; b = 2; c = 1
  call test(a, b, c)

  print *, "Рациональные коэффициенты"
  a = 1.2; b = 2.5; c = 0.5
  call test(a, b, c)

  print *, "Иррациональные коэффициенты"
  a = 1; b = sqrt(2.0d0); c = 0.5
  call test(a, b, c)

  print *, "Комплексные корни"
  a = 4.0; b = 2.0; c = 1.0
  call test(a, b, c)

  print *, "Большие числа"
  a = 45678907.0; b = 20987654.0; c = 109876.0
  call test(a, b, c)
  
  print *, "Большие отрицательные числа"
  a = -45678907.0; b = 20987654.0; c = -109876.0
  call test(a, b, c)
end program test_quad
