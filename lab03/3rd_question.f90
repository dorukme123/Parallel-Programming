include 'lab03-stud/src/random.f90'
module suppl
    use iso_fortran_env
    use omp_lib
    use random
    implicit none

    contains

    ! Source: https://www.mjr19.org.uk/IT/sorts/sorts.f90
    recursive subroutine quicksort(array)
        integer, intent(inout)::array(:)
        real :: temp,pivot
        integer :: i,j,last,left,right

        last=size(array)

        if (last.lt.50) then ! use insertion sort on small arrays
            do i=2,last
                temp=array(i)
                do j=i-1,1,-1
                    if (array(j).le.temp) exit
                    array(j+1)=array(j)
                enddo
                array(j+1)=temp
            enddo
            return
        endif
        ! find median of three pivot
        ! and place sentinels at first and last elements
        temp=array(last/2)
        array(last/2)=array(2)
        if (temp.gt.array(last)) then
            array(2)=array(last)
            array(last)=temp
        else
            array(2)=temp
        endif
        if (array(1).gt.array(last)) then
            temp=array(1)
            array(1)=array(last)
            array(last)=temp
        endif
        if (array(1).gt.array(2)) then
            temp=array(1)
            array(1)=array(2)
            array(2)=temp
        endif
        pivot=array(2)

        left=3
        right=last-1
        do
            do while(array(left).lt.pivot)
                left=left+1
            enddo
            do while(array(right).gt.pivot)
                right=right-1
            enddo
            if (left.ge.right) exit
            temp=array(left)
            array(left)=array(right)
            array(right)=temp
            left=left+1
            right=right-1
        enddo
        if (left.eq.right) left=left+1
        call quicksort(array(1:left-1))
        call quicksort(array(left:))

    end subroutine quicksort

    function birth(stud_number) result(res)
        integer, intent(in) :: stud_number
        integer, dimension(1:stud_number) :: births
        integer :: i, j
        logical :: res

        res = .false.

        !$omp parallel
        !$omp do
        do i=1, stud_number
            births(i) = randomint(365)
        end do
        !$omp end do
        !$omp end parallel

!        !a$omp parallel
!        !a$omp do
!        do i=1, stud_number
!            do j=1, stud_number
!                if (births(i) == births(j)) then
!                    res = .true.
!                    exit
!                end if
!            end do
!        end do
!        !a$omp end do
!        !a$omp end parallel

        call quicksort(births)

        !write (*, *) "Sorted array: ", births

        do i=2, stud_number
            if (births(i) == births(i-1)) then
                res = .true.
                exit
            end if
        end do


    end function birth
end module suppl

program ex3
    use iso_fortran_env
    use omp_lib
    use suppl

    integer :: start, end, positive
    real, allocatable :: frequency(:)
    integer i, j
    logical :: tmp_res

    write (*, *) "This is the Birthday Problem simulation program."
    write (*, *)
    write (*, *) "Having a number of students n, we want to estimate the probability that at least 2 of them have the &
            day and the month of the birth. "
    write (*, *) "This program will estimate the probabilities of matching the births in range &
        [start, end]"
    write (*, *) "We will use Monte-Carlo method to estimate the probability..."
    write (*, *)
    write (*, *) "Now please, enter the `start` and the `end` integers correspondingly: "
    write (*, *)

    read (*, *) start, end
    write (*, *) "The start is: ", start, "The end is: ", end

    allocate(frequency(start:end))
    write (*, *) "Array successfully allocated. Proceeding to the calculation..."

    call omp_set_num_threads(4)

    do i=start,end
        if ( i == ceiling( real(start-end) / 4.0) ) then
            write (*, *) "25% done..."
        else if ( i == ceiling(real(start-end) / 2.0) ) then
            write (*, *) "50% done..."
        else if ( i == (ceiling(real(start-end) / 4.0) + ceiling(real(start-end) / 2.0) ) ) then
            write (*, *) "75% done..."
        end if
        positive = 0
        !$omp parallel
        !$omp do reduction(+ : positive)
        do j=1,10**6
            if (birth(i)) then
                positive = positive + 1
            end if
        end do
        !$omp end do
        !$omp end parallel
        frequency(i) = real(positive) / real(10**6)
    end do

    write (*, *) "Calculation is successful. Data will be saved to the file frequency.txt"

    open(5, file="../lab03/frequency.txt", action="write")
    write(5, "(G0)"), frequency
    close(5, status="keep")

    write (*, *) "Successfully written to the file. Exiting the program..."

end program ex3