include 'lab03-stud/src/random.f90'
module player
    use iso_fortran_env
    use omp_lib
    use random
    implicit none

    private
    public :: ruin_player

    contains
    ! multiplier - степень, в которую нужно возвести 10, чтобы при умножении 10^^multiplier на prob,
    !                               получилось целое число.
    ! cycles - количество повторений
    function ruin_player(prob, multiplier, n, total) result(res)
        implicit none
        real, intent(in) :: prob
        integer, intent(in) :: n, total, multiplier
        integer :: tmp, i, copy_n, counter, range
        integer :: outcome
        integer, dimension(1:2) :: res

!        omp_set_num_threads(4)

        range = prob * (10 ** multiplier)
!        write (*, *) "range is:", range

        copy_n = n
        counter = 0

        do while ( (copy_n /= 0) .and. (copy_n /= total) )
            tmp = randomint(10**multiplier)
!            write (*, *) "randomint is: ", tmp
            if (tmp <= range) then
                copy_n = copy_n - 1
            else
                copy_n = copy_n + 1
            end if
            counter = counter + 1
        end do

        if (copy_n == 0) then
            outcome = 0
        else if (copy_n == total) then
            outcome = 1
        end if

        res(1) = outcome
        res(2) = counter

    end function ruin_player

end module player


program main
    use iso_fortran_env
    use player
    implicit none

    real :: prob
    integer :: mult, n, total, i
    integer, dimension(1:10**5) :: rounds, outcome
    logical, dimension(1:10**5) :: bool_outcome

    real :: expect, win_prob
    ! expectation, win_prob
    real, dimension(1:2) :: res, tmp_res

    write (*, *) "Задача о разорении игрока. Имеем общее количество рублей N, &
            и количество рублей у первого игрока n, ", &
            "и вероятность выйгрыша p. Реализация программы также &
            просит ввести параметр multiplicator - степень, в которую &
            нужно возвести 10, чтобы при умножении 10^^multiplier &
            на prob, получилось целое число."
    write (*, *) "Исходом на вывод подается вероятность выйгрыша &
            первого игрока, а также среднее число раундов для &
            прекращения игры"
    write(*, *)
    write(*, *) "Введите следующие параметры: probability, multiplier, &
            n, N. "
    write(*, *)
    read (*, *) prob, mult, n, total
    write (*, *) "Read success. Processing..."


    !$omp parallel
        !$omp do reduction (+ : rounds, outcome)
        do i=1, 10**5
            tmp_res = ruin_player(prob, mult, n, total)
!            write (*,*) "Simulating of one iteration is done"
            rounds(i) = tmp_res(2)
            outcome(i) = tmp_res(1)
        end do
        !$omp end do
    !$omp end parallel

!    write (*, *), rounds(:100)
!    write (*, *), "Now outcome", outcome(:100)

    do i=1, size(outcome)
        if (outcome(i) == 0) then
            bool_outcome(i) = .false.
        else if (outcome(i) == 1) then
            bool_outcome(i) = .true.
        end if
    end do

    expect = sum(rounds) / size(rounds)
    win_prob = real(count(bool_outcome)) / real(size(outcome))

    res(1) = expect
    res(2) = win_prob

    write(*, *) "Обработка произошла успешно."
    write(*, *) "Вероятность выигрыша при заданных параметрах: ", res(2)
    write(*, *) "Среднее количество раундов до конца игры: ", res(1)

end program main