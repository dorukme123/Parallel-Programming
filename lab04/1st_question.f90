! Created by ivan on 21.12.2021.
include "lab04-stud/src/class_area.f90"
include "lab04-stud/src/montecarlo.f90"

module support
    use iso_fortran_env
    use omp_lib
    implicit none

    private
    public :: test_point_ex1

    contains
    pure function test_point_ex1(x, y, a, b)
        implicit none
        real(real64), intent(in) :: x, y
        real(real64), intent(in) :: a, b
        logical :: test_point_ex1

        test_point_ex1 = (y > (a - x)) .and. (y < (b - x))
    end function test_point_ex1

end module support


program main
    use iso_fortran_env
    use omp_lib
    use class_area
    use montecarlo
    use support
    implicit none

    real(real64), parameter :: b = 2
    real(real64), parameter :: a = 1
    integer(int64), parameter :: N = 10**6
    type(Rectangle), parameter :: rect = Rectangle(x_1=0, x_2=2, y_1=0, y_2=2)
    real(real64) :: res
    integer(int64) :: threads_num

    integer(int32), parameter :: max_threads_num = 4
    integer :: tn
    real (real64) :: avg_T
    real (real64) :: t1, t2

    do tn=1,max_threads_num

        call omp_set_num_threads(tn)
        t1 = omp_get_wtime()

        !    write (*, *) "Calculating the volume of the figure."

        threads_num = omp_get_num_procs()
        res = montecarlo_square_ex1(test_point_ex1, N, rect, threads_num, a, b)
        ! Умножим на два, так как область у нас отзеркаливается.
        res = res * 2

!        write (*, *) "Result of calculations: ", res
        !    write (*, *) "The true value is: ", 3.1415 / real(12) * (b**3 - a**3)

        t2 = omp_get_wtime()
        avg_T = t2 - t1
        ! tn - number of threads, avg_T - average time
        print '(G0, ",", G0)', tn, avg_T

    end do

end program main