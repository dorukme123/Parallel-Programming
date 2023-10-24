include "../src/summation.f90"

program test_sum
  use iso_fortran_env, only: int32, int64, real32, real64
  use summation
  implicit none
  include "omp_lib.h"

  ! Количество испытаний
  integer(int32), parameter :: iterations_num = 1000
  ! Максимальное количество нитей
  integer(int32), parameter :: max_threads_num = 8
  ! Длина массива
  integer(int64) :: array_length
  ! Количество нитей
  integer(int32) :: threads_num
  ! Для замера времени
  real(real64) :: t1, t2
  real(real64), dimension(iterations_num) :: T

  ! Динамический массив для проверки функции
  real(real64), dimension(:), allocatable :: test_array
  real(real64) :: test_res
  integer(int64) :: i

  ! Создаем большой массив для тестирования производительности
  array_length = 1000 * 1000
  allocate(test_array(1:array_length))

  call random_number(test_array)

  do threads_num = 1,max_threads_num,1
    do i = 1,iterations_num,1
      t1 = omp_get_wtime()
      test_res = iterative_sum(test_array, threads_num)
      t2 = omp_get_wtime()
      T(i) = t2 - t1
    end do
    print '(i2,",",G0)', threads_num, sum(T) / dble(iterations_num)
  end do

  deallocate(test_array)
end program test_sum
