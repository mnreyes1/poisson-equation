subroutine carga_puntual(i, j, k, n, rho) 
	implicit none
	integer, intent(in) :: n, i, j, k
	double precision, intent(out) :: rho
	double precision :: x, y, z
	double precision :: L = 1.0d+0

	x = (i * L) / n
	y = (j * L) / n
	z = (k * L) / n

	if (i == (n + 1) / 2 .and. j == (n + 1) / 2 .and. k == (n + 1) / 2) then 
		rho = 7.0d+0

	else
		rho = 0.0d+0

	end if


end subroutine carga_puntual

subroutine matrix_generator(A, b, n, tx, ty, tz)
! receive a matrix A and a vector b and dimension n of
! the problem and return matrix and vector of the system
	implicit none
	integer, intent(in) :: n
    double precision, intent(in) :: tx, ty, tz
    double precision, dimension(n**3), intent(out) :: b
    double precision, dimension(n**3, n**3), intent(out) :: A
    integer :: i, j, k
    double precision :: rho

    do i = 0, n - 1
    	do j = 0, n - 1
    		do k = 0, n - 1

    		call carga_puntual(i, j, k, n, rho)

    		b(i * n**2 + j * n + k + 1) = rho

    		if (i == 0 .or. i == n - 1) then
    			A(i * n**2 + j * n + k + 1, i * n**2 + j * n + k + 1) = 1.0d+0
                b(i * n**2 + j * n + k + 1) = tx
            else if (j == 0 .or. j == n - 1) then
    			A(i * n**2 + j * n + k + 1, i * n**2 + j * n + k + 1) = 1.0d+0
                b(i * n**2 + j * n + k + 1) = ty
            else if (k == 0 .or. k == n - 1) then
    			A(i * n**2 + j * n + k + 1, i * n**2 + j * n + k + 1) = 1.0d+0
                b(i * n**2 + j * n + k + 1) = tz
            else
            	A(i * n**2 + j * n + k + 1, i * n**2 + j * n + k + 1) = -6.0d+0
                A(i * n**2 + j * n + k + 1, i * n**2 + j * n + k + 2) = 1.0d+0
                A(i * n**2 + j * n + k + 1, i * n**2 + j * n + k) = 1.0d+0
                A(i * n**2 + j * n + k + 1, i * n**2 + (j + 1) * n + k + 1) = 1.0d+0
                A(i * n**2 + j * n + k + 1, i * n**2 + (j - 1) * n + k + 1) = 1.0d+0
                A(i * n**2 + j * n + k + 1, (i + 1) * n**2 + j * n + k + 1) = 1.0d+0
                A(i * n**2 + j * n + k + 1, (i - 1) * n**2 + j * n + k + 1) = 1.0d+0


    		end if

    		end do
    	end do
    end do
end subroutine matrix_generator

subroutine LinearEquations(n, b, tx, ty, tz)

  implicit none

  
	integer, intent(in) :: n
    double precision, intent(in) :: tx, ty, tz
    double precision, dimension(n**3), intent(inout) :: b
    double precision, dimension(n**3, n**3) :: A
    integer :: i, j, k, info
    integer :: pivot(n**3)

    do i = 1, n**3

    b(i) = 0.0d+0

    do j = 1, n**3

    A(i, j) = 0.0d+0

    end do
    end do

    call matrix_generator(A, b, n, tx, ty, tz)


    !do i = 1, n**3 !to print matrix
    !do j = 1, n**3
    !WRITE(*,'(5f4.1)', advance='no') A(i,j)
    !end do
    !write(*,*) ' '
    !end do

    call DGESV(n**3, 1, A, n**3, pivot, b, n**3, info)

    !do i = 1, n**3 !to print vector
    !print *, b(i)
    !end do

end subroutine LinearEquations

program main
implicit none
	integer, parameter :: n = 5
	double precision :: tx, ty, tz
	double precision, dimension(n**3) :: b
	real :: start, finish

	tx = 0.0d+0
	ty = 0.0d+0
	tz = 0.0d+0

	open(1, file='data.dat')

	call cpu_time(start)
	call LinearEquations(n, b, tx, ty, tz)
	call cpu_time(finish)
    print '("n = ",i3)', n
    print '("Time = ",f6.3," seconds.")', finish - start

    print *, b

    write(1, *) finish - start


	close(1)

end program main