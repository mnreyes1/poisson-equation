# Start of the makefile

poisson.out: poisson.f08
	# Compiling the code
	gfortran -o poisson.out poisson.f08 -L/usr/lib -llapack -L/usr/lib -lblas
	# Executing the output of the code	
	./poisson.out

# To clean directory

clean:
	rm poisson.out

# End of the makefile
