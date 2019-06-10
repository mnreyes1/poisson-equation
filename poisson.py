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


# Abre el archivo obtenido de poisson.f08 (solucion al sistema de ecuaciones)
with open('data.dat') as file:
    data = file.readline()
    data = data.split(' ')
    data = [i for i in data if i not in ['', '\n']]
    data = [i.strip().replace('E-00', 'e-') for i in data]
    data = [float(i) for i in data]

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
        value = data[len(data) // 2]
    else:
        value = f(X[i], Y[i], Z[i])
    # Se agrega el valor del potencial a la lista
    P.append(value)


def graficar_3d():
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


def graficar_curvas_nivel():
    # Grafica todas las curvas de nivel del sistema y las compara
    # con los valores esoerados para una distribucion de carga
    # puntual. Para cada curva de nivel posible, se genera un grafico.
    for m in range(n // 2 + 1):
        plot_numerico = []
        plot_esperado = []
        for i in range(n**3):
            # Se usa un margen de error para comparar la coordenada Y
            # con el valor de un multiplo de la separacion de la grilla.
            # Para el valor fijo de X, y un valor fijo de Y ( es decir,
            # variando en la coordenada Z), obtenemos los valores del
            # potencial obtenido numericamente, y el potencial esperado,
            # y los agregamos a una lista.
            if X[i] == 0 and abs(Y[i] - m * h) < (h / 3):
                plot_numerico.append(P[i])
                plot_esperado.append(data[i])

        # Se grafican los resultados. En negro esta el valor esperado
        # y en rojo el obtenido.
        plt.plot(Z[0:n], plot_numerico, color='k')
        plt.plot(Z[0:n], plot_esperado, color='r')
        plt.show()
        plt.close()


if __name__ == '__main__':
    # Interfaz para el usuario
    plot = int(input(
        'Que desea hacer?\n\n1.-Graficar curvas de nivel\n2.-Graficar 3d\n\nRespuesta: '))
    if plot == 1:
        graficar_curvas_nivel()
    elif plot == 2:
        graficar_3d()
    else:
        print('\nOpcion no valida')
