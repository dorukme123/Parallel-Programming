program zadanie2
    use iso_fortran_env
    use omp_lib
    implicit none

    integer(int64), parameter :: n = 1000
    integer(int32), parameter :: th_num = 4

    integer(int64) :: th
    real(real64) :: S(0:th_num-1)
    integer(int64) :: i

    integer(int64) :: first, final

    print *, "before parallelism"

    S = 0

    !$omp parallel private(th, first, final) shared(S) num_threads(th_num)

    th = omp_get_thread_num()
    first = 1+n+th
    final = n*(th+1)

    do i = first,final,1
        S(th) = sin(dble(i)) + cos(dble(i)) + exp(-dble(i))
    end do

    !$omp end parallel
    print *, "after parallelism"
    print "('S = ', 4(G0, 1x))", S
    print "('sum(S) = ', G0)", sum(S)

end program zadanie2