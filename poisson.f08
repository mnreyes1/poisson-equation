subroutine carga_puntual(i, j, k, L, n, rho)
    ! Subrutina que define una densidad de carga puntual 
    ! centrada en el origen. Recibe como parametros la 
    ! posicion (i, j, k) de la grilla, el numero de puntos
    ! n, el largo L de la caja, y retorna rho.
    implicit none
    integer, intent(in) :: n, i, j, k
    double precision, intent(out) :: rho
    double precision :: L
    double precision :: h

    ! h es la distancia dx, dy y dz que representa la separacion
    ! en la grilla.
    h = L / (n - 1)

    ! Si recibe el centro de la grilla le asigna el valor q*h^2,
    ! donde q = 1 es la carga. En caso contrario asigna el valor 0
    ! por lo que estamos representando un delta de Dirac.
    if (i == 3 .and. j == n / 2 .and. k == n / 2) then 
        rho = 1.0d+0 / h ! *h^2/h^3 (h^3 por que densidad es carga/volumen)
    else
        rho = 0.0d+0
    end if
end subroutine carga_puntual

subroutine matrix_generator(A, b, n, tx, ty, tz, L)
    ! Recibe una matriz A de tamaño n^3 x n^3, un vector b de tamaño
    ! n^3, el numero n de puntos, y las temperaturas en las paredes de 
    ! la caja tx, ty y tz, para cada pared.
    implicit none
    integer, intent(in) :: n
    double precision, intent(in) :: tx, ty, tz, L
    double precision, dimension(n**3), intent(out) :: b
    double precision, dimension(n**3, n**3), intent(out) :: A
    integer :: i, j, k
    double precision :: rho, x, y, z

    ! Ciclo que obtiene los valores de la matriz y el vector.
    ! Se recorren los elementos de la diagonal de la matriz y se
    ! construyen las filas una a una.
    do i = 0, n - 1
        do j = 0, n - 1
            do k = 0, n - 1

            ! Para cada fila se obtiene el valor del vector b
            call carga_puntual(i, j, k, L, n, rho)
            b(i * n**2 + j * n + k + 1) = rho
            
            ! Si estamos en una pared x=0 o x=L obtenemos el valor de la matriz
            ! y del vector con las condiciones de borde
            if (i == 0 .or. i == n - 1) then
                A(i * n**2 + j * n + k + 1, i * n**2 + j * n + k + 1) = 1.0d+0
                b(i * n**2 + j * n + k + 1) = tx
            
            ! Si estamos en una pared y=0 o y=L obtenemos el valor de la matriz
            ! y del vector con las condiciones de borde
            else if (j == 0 .or. j == n - 1) then
                A(i * n**2 + j * n + k + 1, i * n**2 + j * n + k + 1) = 1.0d+0
                b(i * n**2 + j * n + k + 1) = ty
            
            ! Si estamos en una pared z=0 o z=L obtenemos el valor de la matriz
            ! y del vector con las condiciones de borde
            else if (k == 0 .or. k == n - 1) then
                A(i * n**2 + j * n + k + 1, i * n**2 + j * n + k + 1) = 1.0d+0
                b(i * n**2 + j * n + k + 1) = tz
            
            ! Si no estamos en las paredes, obtenemos los valores de la matriz
            ! para toda la fila a la vez
            else
                A(i * n**2 + j * n + k + 1, i * n**2 + j * n + k + 1) = -6.0d+0
                A(i * n**2 + j * n + k + 1, i * n**2 + j * n + k + 2) = 1.0d+0
                A(i * n**2 + j * n + k + 1, i * n**2 + j * n + k) = 1.0d+0
                A(i * n**2 + j * n + k + 1, i * n**2 + (j + 1) * n + k + 1) = 1.0d+0
                A(i * n**2 + j * n + k + 1, i * n**2 + (j - 1) * n + k + 1) = 1.0d+0
                A(i * n**2 + j * n + k + 1, (i + 1) * n**2 + j * n + k + 1) = 1.0d+0
                A(i * n**2 + j * n + k + 1, (i - 1) * n**2 + j * n + k + 1) = 1.0d+0
            end if

            x = L * (i - n/2) / (n - 1)
            y = L * (j - n/2) / (n - 1)
            z = L * (k - n/2) / (n - 1)

            if (x**2.0d+0 + y**2.0d+0 < 0.0d+0) then
                print *, i, j, k
                A(i * n**2 + j * n + k + 1, i * n**2 + j * n + k + 1) = 0.0d+0
                A(i * n**2 + j * n + k + 1, i * n**2 + j * n + k + 2) = 0.0d+0
                A(i * n**2 + j * n + k + 1, i * n**2 + j * n + k) = 0.0d+0
                A(i * n**2 + j * n + k + 1, i * n**2 + (j + 1) * n + k + 1) = 0.0d+0
                A(i * n**2 + j * n + k + 1, i * n**2 + (j - 1) * n + k + 1) = 0.0d+0
                A(i * n**2 + j * n + k + 1, (i + 1) * n**2 + j * n + k + 1) = 0.0d+0
                A(i * n**2 + j * n + k + 1, (i - 1) * n**2 + j * n + k + 1) = 0.0d+0
            end if

            end do
        end do
    end do
end subroutine matrix_generator


subroutine LinearEquations(n, b, tx, ty, tz, L)
    ! Subrutina que resuelve un sistema de n^3 x n^3
    ! dadas 3 condiciones de borde (tx, ty, tz). Se
    ! utiliza una subrutina de Lapack (DGESV) para resolver
    ! el sistema. La solucion se guarda en el vector b.
    implicit none
    integer, intent(in) :: n
    double precision, intent(in) :: tx, ty, tz, L
    double precision, dimension(n**3), intent(inout) :: b
    double precision, dimension(n**3, n**3) :: A
    integer :: i, j, k, info
    integer :: pivot(n**3)

    ! Se rellena de ceros la matriz y el vector
    do i = 1, n**3
        b(i) = 0.0d+0
        do j = 1, n**3
            A(i, j) = 0.0d+0
        end do
    end do

    ! Se llama a la subrutina para generar la matriz
    call matrix_generator(A, b, n, tx, ty, tz, L)
    !print '("Matrix A"/(125F3.0))', ((A(i,j), i = 1, 125), j = 1, 125) 
    ! Se llama a la subrutina que resuelve el sistema
    call DGESV(n**3, 1, A, n**3, pivot, b, n**3, info)

end subroutine LinearEquations


subroutine potencial_esperado(x, L)
    ! Funcion que define el potencial esperando para una carga puntual
    double precision, intent(in) :: L
    double precision, intent(out) :: x
    real(8),  parameter :: PI_8  = 4 * atan (1.0_8)

    r = (1.0d+0 * (L/2)**2)**(0.5d+0)
    ! Valor del potencial
    x = -1.0d+0 / (r * 4.0d+0 * PI_8)

end subroutine potencial_esperado


program MAIN
    ! Programa principal. Recibe el numero de puntos que se usaran
    ! (n), las condiciones de borde de las paredes (tx, ty, tz),
    ! el largo de la caja que se usa para las condiciones de borde (L)
    ! un vector en el que se guardara la solución al sistema
    ! de ecuaciones (b), y dos variables que miden el tiempo
    ! de ejecucion (start, finish).
    implicit none
    ! Se establece el numero de puntos que se usará en la subdivision 
    ! del espacio
    integer, parameter :: n = 13
    double precision :: tx, ty, tz, L, potencial
    double precision, dimension(n**3) :: b
    real :: start, finish

    ! Se asignan los valores de las condiciones de borde usando como referencia
    ! el potencial que se obtendria de una carga puntual a distancia L/2
    L = 1.0d+0
    call potencial_esperado(potencial, L)
    tx = 0.0d+0
    ty = 0.0d+0
    tz = 0.0d+0

    ! Abre un archivo en el cual se guardara la solucion al problema
    open(1, file='data.dat')
    ! Se guarda el tiempo inicial
    call cpu_time(start)
    ! Resuelve el sistema de ecuaciones
    call LinearEquations(n, b, tx, ty, tz, L)
    ! Se guarda el tiempo final
    call cpu_time(finish)
    ! Se imprime en pantalla el numero de puntos usados, y el tiempo
    ! que se tardo en resolver el problema
    print '("n = ",i3)', n
    print '("Time = ",f6.3," seconds.")', finish - start
    ! Se guardan los resultados en un archivo
    write(1, *) b
    close(1)
end program MAIN