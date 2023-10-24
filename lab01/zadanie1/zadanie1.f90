program freeze1
    use iso_fortran_env
    use omp_lib
    ! include "omp_lib.h"
    implicit none
    integer, parameter :: N = 100
    real(8) :: s_time, e_time
    integer :: i
    real(8) :: comp
    integer, dimension(N) :: timing_results
    integer :: unit_num
    open(unit=unit_num, file='Timing_results.txt', status='replace')

    timing_results = 0

    do i = 1, N
        s_time = omp_get_wtime()

        do while (omp_get_wtime() - s_time < 1.0)
        comp = sin(1.0) * cos(1.0) 
        end do

        e_time = omp_get_wtime()

        timing_results(i) = int((e_time - s_time) * 1000.0)

        write(unit_num, '(I6)') timing_results(i)
    end do

    close(unit_num)

end program freeze1