include 'lab03-stud/src/random.f90'
program ex2
    use iso_fortran_env
    use omp_lib
    use random

    implicit none

    logical :: res1(1:10**6), res2(1:10**6)
    real :: avg_prob1, avg_prob2
    integer :: i

    ! Моделируем, когда нет смены двери.
    logical :: change = .false.

    ! Ускорим вычисления с помощью OpenMP
    !$omp parallel
    !$omp do
    do i=1,10**6
        res1(i) = monty(change)
    end do
    !$omp end do
    !$omp end parallel

    ! write (*, *) "count(res1) is: ", real(count(res1)) / real(10**6)
    avg_prob1 = real(count(res1)) / real(10**6)
    write (*, *) "Monte Carlo prob. without change: ", avg_prob1
    write (*, *) "",

    ! Теперь пускай смена будет положительной
    change = .true.

    ! Ускорим вычисления с помощью OpenMP
    !$omp parallel
    !$omp do
    do i=1,10**6
        res2(i) = monty(change)
    end do
    !$omp end do
    !$omp end parallel

    ! Посчитаем вероятность
    avg_prob2 = real(count(res2)) / real(10**6)
    write (*, *), "Monte Carlo prob. with change.", avg_prob2
end program ex2