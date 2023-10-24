module quadequation
  use iso_fortran_env, only: int32, int64, real32, real64
  implicit none
  private

! Доступные вовне функции и подпрограммы
  public :: real_p2, complex_p2, quadroots
  
  contains
  ! Вычисление квадратного трехчлена
  pure function real_p2(a, b, c, x)
    implicit none
    real(real64), intent(in) :: a, b, c
    real(real64), intent(in) :: x
    real(real64) :: real_p2
    ! Оптимизируем число операций
    real_p2 = (x + (b/a)) * x + (c/a)
  end function real_p2

  ! Вычисление квадратного трехчлена от комплексных чисел
  pure function complex_p2(a, b, c, x)
    implicit none
    real(real64), intent(in) :: a, b, c
    complex(real64), intent(in) :: x
    real(real64) :: complex_p2
    ! оптимизируем число операций
    complex_p2 = dble((x + (b/a)) * x + (c/a))
  end function complex_p2

  ! Вычисление корней квадратного уравнения
  subroutine quadroots(a, b, c, real_roots, complex_roots, is_real)
    implicit none
    real(real64), intent(in) :: a, b, c
    real(real64), intent(out), dimension(1:2) :: real_roots
    complex(real64), intent(out), dimension(1:2) :: complex_roots
    logical, intent(out) :: is_real

    real(real64) :: p, q
    real(real64) :: D
    
    p = b/a
    q = c/a
    D = p*p - 4.0*q
    is_real = .true.
    if (D > 0) then
      real_roots(1) = 0.5*(-p - sqrt(D))
      reaL_roots(2) = 0.5*(-p + sqrt(D))
    else if (D < 0) then
      is_real = .false.
      complex_roots(1) = 0.5*(-p - sqrt(cmplx(D, kind=8)))
      complex_roots(2) = 0.5*(-p + sqrt(cmplx(D, kind=8)))
    else if (abs(D) < epsilon(1.0d0)) then
      real_roots(1) = -0.5*p
      real_roots(2) = -0.5*p
    end if

  end subroutine quadroots
end module quadequation



