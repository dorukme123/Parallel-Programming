include "../src/summation.f90"

program test_sum
  use iso_fortran_env, only: int32, int64, real32, real64
  use summation
  implicit none

  ! Количество испытаний
  integer(int32), parameter :: iterations_num = 100
  ! Длина массива
  integer(int64) :: array_length
  ! Количество нитей
  ! integer(int32) :: threads_num

  ! Динамический массив для проверки функции
  real(real64), dimension(:), allocatable :: test_array
  real(real64) :: correct_sum
  real(real64) :: test_res
  integer(int64) :: i
  ! Вначале проверяем на корректность вычислений


  ! --------  Тест 1 ---------
  array_length = 10
  allocate(test_array(1:array_length))
  
  ! Массив натуральных чисел от 1 до конца массива
  test_array = [(i, i=1,array_length)]
  correct_sum = 0.5 * (test_array(1) + test_array(array_length)) * array_length
  test_res = iterative_sum(test_array, 1)
  
  print *, test_res == correct_sum
  
  deallocate(test_array)
  ! -----------------
  
  ! --------  Тест 2 ---------
  array_length = 1000
  allocate(test_array(1:array_length))
  
  ! Массив отрицательных целых чисел
  test_array = [(-i, i=1,array_length)]
  correct_sum = 0.5 * (test_array(1) + test_array(array_length)) * array_length
  test_res = iterative_sum(test_array, 1)
  print *, test_res == correct_sum
  
  deallocate(test_array)
  ! -----------------
  
  ! --------  Тест 3 ---------
  array_length = 1000
  allocate(test_array(1:array_length))
  
  ! Наполняем случайными числами
  call random_number(test_array)
  
  correct_sum = sum(test_array)
  test_res = iterative_sum(test_array, 1)
  print *, abs(test_res - correct_sum) <= epsilon(1.0d0)
  
  deallocate(test_array)
  ! -----------------
end program test_sum
