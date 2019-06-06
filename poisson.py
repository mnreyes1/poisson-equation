from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import numpy as np

# Se usara que epsilon_0 = 1

# Numero de puntos usados
n = 13
# Largo de la caja
L = 1
# Constante de potencial electrico
k = 1 / (4 * np.pi)
# carga del electron
Q = -1
# Parametro de separacion en la grilla
h = L / (n - 1)


def f(x, y, z):
    # Funcion que define el potencial electrico de una carga puntual
    r = np.sqrt(x**2 + y**2 + z**2)
    return k * Q / r

# Valores de las posiciones de X, Y y Z que usaremos del espacio
X = [(((i // n**2) % n) - n // 2) * h for i in range(n**3)]
Y = [(((i // n) % n) - n // 2) * h for i in range(n**3)]
Z = [((i % n) - n // 2) * h for i in range(n**3)]


# Lista en la que se guardaran los valores del potencial
P = []
for i in range(n**3):
    # En el centro de la caja se pone potencial igual a 0
    # ya que aqui diverge la funcion
    if (X[i], Y[i], Z[i]) == (0, 0, 0):
        value = 0
    else:
        value = f(X[i], Y[i], Z[i])
    # Se agrega el valor del potencial a la lista
    P.append(value)


# Abre el archivo obtenido de poisson.f08 (solucion al sistema de ecuaciones)
with open('data.dat') as f:
    data = f.readline()
    data = data.split(' ')
    data = [i for i in data if i not in ['', '\n']]
    data = [i.strip().replace('E-00', 'e-') for i in data]
    data = [float(i) for i in data]


'''
# Se grafica el potencial, con colores que indican la intensidad de este
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
img = ax.scatter(X, Y, Z, c=P, cmap=plt.hot(), marker='o')
fig.colorbar(img)
plt.show()
plt.close()

# Grafica la solucion obtenida numericamente
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
img = ax.scatter(X, Y, Z, c=data, cmap=plt.hot(), marker='o')
fig.colorbar(img)
plt.show()
plt.close()
'''

plot2_a = []
plot2_b = []

for i in range(n**3):
    if X[i] == 0 and Y[i] == h:
        plot2_a.append(P[i])
        plot2_b.append(data[i])

plt.plot(Z[0:n], plot2_a)
plt.show()
plt.plot(Z[0:n], plot2_b)
plt.show()
