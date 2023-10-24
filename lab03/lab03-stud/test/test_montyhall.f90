include "../src/random.f90"


program test_montyhall
  use iso_fortran_env
  use random
  implicit none
  include "omp_lib.h"

  integer(int64) :: i
  integer(int64), parameter :: number_of_turns = 10**6
  integer(int64) :: victories
  real(real64) :: win_rate_with_alt, win_rate_without_alt

  ! Игрок всегда меняет выбор
  victories = 0
  do i = 1,number_of_turns,1
    victories = victories + monty(.true.)
  end do

  win_rate_with_alt = dble(victories) / dble(number_of_turns)

  ! Игрок не меняет выбора
  victories = 0 
  do i = 1,number_of_turns,1
    victories = victories + monty(.false.)
  end do

  win_rate_without_alt = dble(victories) / dble(number_of_turns)

  print "(1(G0))", "# 1: количество испытаний", &
                &  "# 2: частота выигрыша при смене выбора", &
                &  "# 3: частота выигрыша без смены выбора"
  print "(*(G0,:','))", number_of_turns, win_rate_with_alt, win_rate_without_alt

end program test_montyhall