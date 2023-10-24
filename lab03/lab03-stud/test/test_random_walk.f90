include "../src/random.f90"
include "../src/stats.f90"

program test_random_walk
  use random
  use stats
  use iso_fortran_env
  implicit none
  include "omp_lib.h"

  ! количество испытаний методом Монте-Карло
  integer(int64), parameter :: number_of_turns = 10**7
  ! Минимальная сумма/точка для завершения игры
  integer, parameter :: min_sum = 0
  ! Максимальная сумма/точка для завершения игры
  integer, parameter :: max_sum = 100
  ! Стартовая позиция
  integer, parameter :: start_sum = 90
  ! Вероятность удачи
  real, parameter :: p = 0.45
  ! вероятность неудачи
  real, parameter :: q = 1 - p
  ! Среднее и выборочная дисперсия
  real(int64) :: avg, var, m2
  ! Номер потока
  ! integer :: th
  ! Отдельный счетчик для каждого потока
  ! integer(int64) :: th_i
  ! Оптимально количество потоков
  ! integer :: optimal_threads_num

  ! количество раундов для одной игры, всего и счетчик
  integer(int64) :: rounds, all_rounds, i
  ! среднее количество раундов
  real(real64) :: avg_rounds
  ! успешно или нет
  logical(1) :: win
  ! число успехов
  integer(int64) :: wins_count
  ! частота побед
  real(real64) :: winrate


  wins_count = 0

  avg = 0
  var = 0
  m2 = 0

  rounds = 0
  all_rounds = 0


  do i = 1,number_of_turns,1
    call random_walk_1d(min_sum, max_sum, start_sum, p, rounds, win)
    all_rounds = all_rounds + rounds
    if (win) wins_count = wins_count + 1

    !call online_average(i, dble(rounds), avg)
    call online_variance(i, dble(rounds), avg, m2, var)
    
    if (mod(i, number_of_turns/10) == 0) write(*, "(G0)", advance="no") "*"
  end do

  print *, ""

  winrate = dble(wins_count) / dble(number_of_turns)

  print "('Частота выигрыша: ', G0)", winrate
  print "(G0)", "Средняя продолжительность игры"
  print "('Эмпирическая: ', G0, '±', G0)", avg, sqrt(var / dble(number_of_turns))

  avg_rounds = random_walk_avg_rounds(p, start_sum, max_sum)
  print "('Теоретическая: ', G0)", avg_rounds
  
  print "('Разница между ними: ', G0)", abs(avg - avg_rounds)
end program test_random_walk