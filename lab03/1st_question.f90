module ex1_func
    use iso_fortran_env
    implicit none

    private
    public :: randomint

    contains

    integer function randomint(n)
        implicit none
        integer, intent(in) :: n
        real :: x
        call random_number(x)
        randomint = ceiling(x * n)
    end function randomint
end module ex1_func



module tests
    use iso_fortran_env
    use ex1_func
    implicit none

    private
    public :: number_six_tests, number_six_tests_parallel

    contains

    function number_six_tests() result(results)
        implicit none
        integer :: n, test_number
        real, dimension(1:10**6) :: results

        test_number = 6
        do n = 1, 10**6
            results(n) = randomint(test_number)
        end do
    end function number_six_tests

    function number_six_tests_parallel() result(results)
        implicit none
        integer :: n, test_number
        real :: results(1:10**6)

        test_number = 6
        !$omp parallel
        !$omp do
        do n = 1, 10**6
            results(n) = randomint(test_number)
        end do
        !$omp end do
        !$omp end parallel
    end function number_six_tests_parallel
end module tests



program main
    use iso_fortran_env
    use tests
    use omp_lib
    implicit none

    double precision :: t1, t2, t3, t4
    integer ::  i
    real, dimension(1:10**6) :: res1, res2

    t1 = omp_get_wtime()
    res1 = number_six_tests()
    t2 = omp_get_wtime()
    write (*, *) "Monte-Carle 10**6 times took sec: ", t2 - t1

    t3 = omp_get_wtime()
    res2 = number_six_tests_parallel()
    t4 = omp_get_wtime()
    write (*, *) "Monte-Carle 10**6 times using parallelization took secs: ", t4 - t3

end program
