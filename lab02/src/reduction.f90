module reduction
  use iso_fortran_env, only: int32, int64, real32, real64
  use omp_lib
  implicit none
  private
! Доступные вовне функции и подпрограммы
  public :: omp_sum, omp_max, omp_min
  public :: omp_reduction
  
  abstract interface
    function omp_reduction(A, ths_num)
      double precision, dimension(1:), intent(in) :: A
      integer, intent(in) :: ths_num
      double precision :: omp_reduction
    end function omp_reduction
  end interface
  
  contains
  function omp_sum(A, ths_num) result(S)
    implicit none
    real(real64), dimension(1:), intent(in) :: A
    integer(int32), intent(in) :: ths_num
    real(real64) :: S
    ! Здесь должен быть ваш код
    integer(int32):: i
      S=0.0
    !$omp parallel do shared(A) reduction(+ : S) num_threads(ths_num)
      do i=1, size(A,1),1
        S=S+A(i)
      end do
    !$omp end parallel do
  end function omp_sum

  function omp_max(A, ths_num) result(M)
    implicit none
    real(real64), dimension(1:), intent(in) :: A
    integer(int32), intent(in) :: ths_num
    real(real64) :: M
    ! Здесь должен быть ваш код
    integer(int32)::i
      M=A(1)
    !$omp parallel do shared(A) reduction(max : M) num_threads(ths_num)
      do i=1, size(A,1),1
        if (M>A(i)) then 
          M=A(i)
        end if
      end do
    !$omp end parallel do
  end function omp_max
  
  function omp_min(A, ths_num) result(M)
    implicit none
    real(real64), dimension(1:), intent(in) :: A
    integer(int32), intent(in) :: ths_num
    real(real64) :: M
    ! Здесь должен быть ваш код
    integer(int32)::i
      M=A(1)
    !$omp parallel do shared(A) reduction(min : M) num_threads(ths_num) 
      do i=1, size(A,1),1
        if (M<A(i)) then 
          M=A(i)
        end if
      end do
    !$omp end parallel do
  end function omp_min
end module reduction

