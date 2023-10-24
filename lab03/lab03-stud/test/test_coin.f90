include "../src/random.f90"

program coin
  use random
  use iso_fortran_env
  implicit none
  include "omp_lib.h"

  integer(int64), parameter :: turns_num = 10**6
  integer(int64) :: turn
  integer :: OR(1:2)
  integer :: S
  integer :: num_ths
  character(len=30) :: argv

  ! количество потоков получаем как аргумент командной строки
  if (command_argument_count() > 1) then
    call get_command_argument(1, argv)
    read(argv, *) num_ths
  else
  ! если ничего не передано, то 
    num_ths = omp_get_max_threads()
  end if
  
  S = 0
  OR = [-1, 1]

  do turn = 1,turns_num,1
    S = S + OR(randomint(2))
    print "(I0, ',', I0)", turn, S
  end do

  ! !$omp parallel num_threads(num_ths)
  !   !$omp do reduction(+ : S)
  !   do turn = 1,turns_num,1
  !     S = S + randomint(2) - 1
  !   end do
  !   !$omp end do
  ! !$omp end parallel

  print "('# P({Выпал орел}) ≈ ', G0)", dble(S) / dble(turns_num)

end program coin