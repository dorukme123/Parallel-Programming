include 'lab03-stud/src/random.f90'
module games
    use iso_fortran_env
    use omp_lib
    use random
    implicit none

    contains

    function tokens_game(x, y, z) result(counter)
        implicit none
        integer, intent(in) :: x, y, z
        integer :: counter, toss
        integer, dimension(3) :: players

        players(1) = x
        players(2) = y
        players(3) = z
        counter = 0

        do while ( (players(1) /= 0) .and. (players(2) /= 0) .and. (players(3) /= 0) )
            players(1) = players(1) - 1
            players(2) = players(2) - 1
            players(3) = players(3) - 1

            toss = randomint(3)
            players(toss) = players(toss) + 3

            counter = counter + 1
        end do
    end function tokens_game
end module games


program main
    use iso_fortran_env
    use omp_lib
    use games
    implicit none

    integer x, y, z, cycles, tmp_res, i
    integer, allocatable :: rounds(:)
    real res

    write (*, *) "Задача о жетонах. Имеем 3 игрока, бросают кости &
            за более подробным условием обратитесь к заданию "
    write (*, *) "Исходом на вывод подается среднее число раундов для &
            прекращения игры"
    write(*, *)
    write(*, *) "Введите следующие параметры: x, y, z, cycles. x, y, z - &
            Изначальное количество жетонов у игроков 1, 2, 3 соотвественно &
            Cycles - желаемое количество повторений, например, 10**6..."
    write(*, *)
    read (*, *) x, y, z, cycles
    write (*, *) "Read success. Processing..."

    allocate(rounds(1:cycles))

    !$omp parallel
        !$omp do
        !reduction (+ : rounds)
        do i=1, cycles
            tmp_res = tokens_game(x, y, z)
            rounds(i) = tmp_res
        end do
        !$omp end do
    !$omp end parallel

    res = real(sum(rounds)) / real(size(rounds))

    deallocate(rounds)

    write(*, *) "Обработка произошла успешно."
    write(*, *) "Среднее количество раундов до конца игры: ", floor(res)
    write(*, *) "Должно быть значение: ", (x * y * z) / (x + y + z - 2)

end program main