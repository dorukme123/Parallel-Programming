module summation
  use iso_fortran_env, only: int32, int64, real32, real64
  implicit none
  private
  public :: iterative_sum
  contains

  function iterative_sum(array, threads_num) result(res)
    implicit none
    real(real64), dimension(1:), intent(in) :: array
    integer(int32), intent(in) :: threads_num
    real(real64) :: res
    integer(int32) :: length, i

    length = size(array, 1)
    res = 0.0
    !$omp parallel shared(array) num_threads(threads_num)
    !$omp do reduction(+ : res)
      do i = 1,length,1
        res = res + array(i)
      end do
    !$omp end do
    !$omp end parallel
  end function iterative_sum

end module summation
