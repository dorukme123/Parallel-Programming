module montecarlo
  use iso_fortran_env, only: int32, int64, real32, real64
  use class_area
  implicit none
  include "omp_lib.h"

  abstract interface
    pure function integrand(x, y)
      import real64
      real(real64), intent(in) :: x, y
      real(real64) :: integrand
    end function integrand

    pure function test_point_ex1(x, y, a, b)
      import real64
      real(real64), intent(in) :: x, y, a, b
      logical :: test_point_ex1
    end function test_point_ex1
  end interface

  private
  public :: random_from_interval, montecarlo_square_ex1

  contains
  ! Функция возвращает случайное число из отрезка [a, b]
  function random_from_interval(a, b)
    implicit none
    real(real64), intent(in) :: a, b
    real(real64) :: random_from_interval

    call random_number(random_from_interval)
    random_from_interval = a + (b - a) * random_from_interval

  end function random_from_interval


  ! Функция, вычисляющая двойной интеграл функции sqrt(x, y) методом Монте-Карло
  ! test_func -- проверка на попадание в область
  ! N -- количество итераций метода Монте-Карло
  ! rect -- прямоугольник, описаный вокруг заданной области Ω
  ! threads_num -- количество потоков; если не задан или 0, то
  ! вычисляется с помощью функции omp_get_num_procs()
  function montecarlo_square_ex1(test_func, N, rect, threads_num, a, b)
    implicit none
    procedure(test_point_ex1) :: test_func
    integer(int64), intent(in) :: N
    type(rectangle), intent(in) :: rect
    integer(int64), intent(in), optional :: threads_num

    ! First element is the Area of the chosen area, the second element is the sum of the values of the function.
    real(real64):: montecarlo_square_ex1
    real(real64) :: a, b, freq, rect_square, area

    real(real64) :: x, y, func_values
    ! Количество координат, которые попали в область
    integer(int64) :: M
    integer(int64) :: i
    !! Присвоение M нуля при объявлении не работает при втором вызове функции!
    M = 0
    area = 0.0
    func_values = 0.0

!    if (threads_num == 0) then
!      threads_num = omp_get_num_procs()
!    end if

    !$omp parallel
    !$omp do reduction (+ : M)
    do i=1,N
      x = random_from_interval(rect%x_1, rect%x_2)
      y = random_from_interval(rect%y_1, rect%y_2)

!      write (*, *) "test_func result: ", test_func(x, y, a, b)
      if (test_func(x, y, a, b)) then
        M = M + 1
        func_values = func_values + sqrt(x * y)
      end if

    end do
    !$omp end do
    !$omp end parallel

    freq = dble(M) / dble(N)

    rect_square = abs((rect%x_2 - rect%x_1) * (rect%y_2 - rect%y_1))
    area = freq * rect_square

    montecarlo_square_ex1 = (area / M) * func_values

  end function montecarlo_square_ex1


end module
