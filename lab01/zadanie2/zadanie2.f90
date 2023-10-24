program zadanie2
    use iso_fortran_env
    use omp_lib
    implicit none

    integer(int64), parameter :: n = 10000
    integer(int64) :: th
    integer(int64) :: i
    integer(int64) :: sum1, sum2, sum3, sum4

    sum1 = 1
    sum2 = 2
    sum3 = 3
    sum4 = 4

    print *, "before parallelism"


    !$omp parallel private(th) num_threads(4)
    th = omp_get_thread_num()
    do i = th + 1, n, 1
        if (th == 0) then
        sum1 = sum1 + 4
        else if (th == 1) then
        sum2 = sum2 + 4
        else if (th == 2) then
        sum3 = sum3 + 4
        else if (th == 3) then
        sum4 = sum4 + 4
        end if
    end do
    
    !$omp end parallel
    print *, "after parallelism"
    
    write(*,*) 'thread 1', sum1
    write(*,*) 'thread 2', sum2
    write(*,*) 'thread 3', sum3
    write(*,*) 'thread 4', sum4
    

end program zadanie2