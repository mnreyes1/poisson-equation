all:
	# Compiling the code
	gfortran -o poisson.out poisson.f08 -L/usr/lib -llapack -L/usr/lib -lblas
	
	# Executing the output of the code	
	./poisson.out
	
	# Executing the program that plot
	python3 poisson.py

plot: poisson.out data.dat
	# Executing the program that plot
	python3 poisson.py

compile:
	# Compiling the code
	gfortran -o poisson.out poisson.f08 -L/usr/lib -llapack -L/usr/lib -lblas

	# Executing the output of the code	
	./poisson.out

# To clean directory
clean:
	rm poisson.out data.dat
