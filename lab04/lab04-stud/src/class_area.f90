module class_area
  use iso_fortran_env
  implicit none

  ! интерфейс функции, для проверки попадания точки в область
  abstract interface
    pure function test_point(x, y)
      import real64
      real(real64), intent(in) :: x, y
      logical :: test_point
    end function test_point
  end interface

  private
  public :: Rectangle, Circle, Ellipse, pi, &
            test_point

  real(real64), parameter :: pi = 3.14159265358979323d0
  
  ! Прямоугольная область
  type, public :: Rectangle
    real(real64) :: x_1
    real(real64) :: x_2
    real(real64) :: y_1
    real(real64) :: y_2
  contains
    procedure :: square => rectangle_square
    procedure :: test_point => rectangle_test_point
  end type Rectangle

  ! Круг, окружность
  type, public :: Circle
    real(real64) :: R
    real(real64) :: x_0 = 0.0
    real(real64) :: y_0 = 0.0
  contains
    procedure :: square => circle_square
    procedure :: test_point => circle_test_point
  end type Circle

  ! Эллипс
  type, public :: Ellipse
    real(real64) :: a
    real(real64) :: b
    real(real64) :: x_0 = 0.0
    real(real64) :: y_0 = 0.0
  contains
    procedure :: square => ellipse_square
    procedure :: test_point => ellipse_test_point
  end type Ellipse

  ! Лемниската Бернулли
  type, public :: Lemniscate
    real(real64) :: a
  contains
    procedure :: square => lemniscate_square
    procedure :: test_point => lemniscate_test_point
  end type Lemniscate

  contains

    ! Вычисление площади прямоугольника
    pure function rectangle_square(this) result(square)
      implicit none
      class(Rectangle), intent(in) :: this
      real(real64) :: square
      square = abs((this%x_2 - this%x_1) * (this%y_2 - this%y_1))
    end function rectangle_square

    ! проверка точки на принадлежность прямоугольной области
    pure function rectangle_test_point(this, x, y)
      implicit none
      class(Rectangle), intent(in) :: this
      real(real64), intent(in) :: x, y
      logical :: rectangle_test_point
      rectangle_test_point = (this%x_1 <= x .and. x <= this%x_2) .and. &
                            &(this%y_1 <= y .and. y <= this%y_2)
    end function rectangle_test_point

    ! Вычисление площади круга
    pure function circle_square(this) result(square)
      implicit none
      class(Circle), intent(in) :: this
      real(real64) :: square
      square = this%R * this%R * pi
    end function circle_square

    ! проверка точки на принадлежность кругу
    pure function circle_test_point(this, x, y)
      implicit none
      class(Circle), intent(in) :: this
      real(real64), intent(in) :: x, y
      logical :: circle_test_point
      circle_test_point = (x - this%x_0)**2 + (y - this%y_0)**2 <= this%R**2
    end function circle_test_point

    ! Вычисление площади эллипса
    pure function ellipse_square(this) result(square)
      implicit none
      class(Ellipse), intent(in) :: this
      real(real64) :: square
      square = this%a * this%b * pi
    end function ellipse_square

    ! проверка точки на принадлежность эллипсу
    pure function ellipse_test_point(this, x, y)
      implicit none
      class(Ellipse), intent(in) :: this
      real(real64), intent(in) :: x, y
      logical :: ellipse_test_point
      ellipse_test_point = ((x - this%x_0) / this%a)**2 + &
                          &((y - this%y_0) / this%b)**2 <= 1
    end function ellipse_test_point

    ! Вычисление площади лемнискаты
    pure function lemniscate_square(this) result(square)
      implicit none
      class(Lemniscate), intent(in) :: this
      real(real64) :: square
      square = 2*this%a
    end function lemniscate_square

    ! проверка точки на принадлежность лемнискаты
    pure function lemniscate_test_point(this, x, y)
      implicit none
      class(Lemniscate), intent(in) :: this
      real(real64), intent(in) :: x, y
      logical :: lemniscate_test_point
      lemniscate_test_point = (x**2 + y**2)**2 - 2*this%a**2*(x**2 - y**2) <= 0
      ! lemniscate_test_point = x**2 - 2*this%a**2*cos(2*y) <= 0
    end function lemniscate_test_point

end module class_area