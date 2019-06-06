# Start of the makefile

poisson.out: poisson.f08
	# Compiling the code
	gfortran -o poisson.out poisson.f08 -L/usr/lib -llapack -L/usr/lib -lblas
	# Executing the output of the code	
	./poisson.out
	# Executing the program that plot
	python3 poisson.py
	# Deleting unnecessary files
	rm poisson.out data.dat

# To clean directory
clean:
	rm poisson.out data.dat
# End of the makefile
