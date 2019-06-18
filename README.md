# Poisson Equation
Solving the Poisson equation with different charge densities

Default branch that solves the system for a cubic box with zero voltage boundary conditions, 
and a punctual charge density (an electron in the middle of the box).

The charge of electron is assumed as e = -1. The lenght of the box is 1. The boundary conditions are that the box has potential equal to zero.

The program is efficient while n is less than 17.

## Usage

To execute all code, use command

	make

To only compile and execute fortran code use command

	make compile

To only see plots use

	make plot

To clean directory use

	make clean

## Installing Lapack
(Reference: https://coral.ise.lehigh.edu/jild13/2016/07/27/install-lapack-and-blas-on-linux-based-systems/)

First, you have to install BLAS before LAPACK, because LAPACK needs it. Download the packages from the following websites.

   - BLAS, see http://www.netlib.org/blas/
   - LAPACK, see http://www.netlib.org/lapack/

Switch to the BLAS folder and execute

    make

to compile all fortran files. After that, execute

    mv blas_UNIX.a libblas.a

to rename the created library. Probably, you have to change "UNIX" for "LINUX" (look in the BLAS folder for a file with a similar name). After creating the library called “libblas.a”, copy that file to your library folder by executing the following command

    sudo cp libblas.a /usr/local/lib/

The above directory can be replaced by any library path in your systems.

Now we have installed the BLAS package. Then switch to the LAPACK directory and adjust the file “make.inc” if necessary (in the lapack directory will be a make.inc.example file. You can change the name to make.inc). After setting all parameters correctly, type the command

    make

Now, you created a library e.g. called “lapack_MACOS.a”. Copy that file to your library folder by executing

    sudo cp liblapack.a /usr/local/lib/

Congratulation, you’ve installed BLAS and LAPACK on your systems!

Note: when using C++, do not forget to point out your search directory for header files with option “-I”, and add your library path with “-L” for libraries with “-l” if the search paths for the header files and libraries are not included.

