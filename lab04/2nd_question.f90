! Created by ivan on 21.12.2021.
include "lab04-stud/src/class_area.f90"
include "lab04-stud/src/montecarlo.f90"

module support

end module support

program test_area
    use iso_fortran_env
    use class_area
    use montecarlo
    use omp_lib
    implicit none

    integer(int64), parameter :: N = 10**7
    real(real64), parameter :: R = 1

    type(Rectangle), parameter :: rect = Rectangle(x_1=-R, x_2=+R+R/2.0, y_1=-R, y_2=+R)
    type(Circle), parameter :: C1 = Circle(R=R)
    type(Circle), parameter :: C2 = Circle(R=R, x_0=R/2.0)
    type(Circle), parameter :: C3 = Circle(R=0.5*R, x_0=R/4.0)
    type(Ellipse), parameter :: E = Ellipse(a=2*R, b=R)
    type(Lemniscate), parameter :: L = Lemniscate(a=R)

    real(real64) :: x, y, freq, area, rect_square
    integer(int64) :: i, M, tn
    integer(int32), parameter :: max_threads_num = 4
    real (real64) :: avg_T
    real (real64) :: t1, t2

    do tn = 1,max_threads_num

        call omp_set_num_threads(tn)

        t1 = omp_get_wtime()

        M = 0

        !$omp parallel
        !$omp do reduction (+ : M)
        do i = 1,N,1
            x = random_from_interval(rect%x_1, rect%x_2)
            y = random_from_interval(rect%y_1, rect%y_2)

            if (C1%test_point(x, y) .and. C2%test_point(x, y) &
                    & .and. C3%test_point(x, y)) then
                M = M + 1
                !            func_values = func_values +
                !           print "(G0, ',', G0)", x, y
            end if
        end do
        !$omp end do
        !$omp end parallel

        freq = real(M) / real(N)

        rect_square = abs((rect%x_2 - rect%x_1) * (rect%y_2 - rect%y_1))
        area = freq * rect_square

        !    write (*, *) "Calculated value: ", area
        !    write (*, *) "True values: ", dble(1) / dble(2) * (3.1415 - sqrt(3.0)) * R**2

        t2 = omp_get_wtime()
        avg_T = t2 - t1
        ! tn - number of threads, avg_T - average time
        print '(G0, ",", G0)', tn, avg_T
        ! call sleep(1)
    end do


end program test_area