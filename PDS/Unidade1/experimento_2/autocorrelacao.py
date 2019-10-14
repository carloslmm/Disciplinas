import numpy as np
import math as mt
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import axes3d, Axes3D
tau = 100
n = 100  #Criando a variável referente ao número de amostras do sinal amostrado
l = 5000 #Criando a variável referente aos blocos
x_n = np.random.randn(1,n*l) #Criando o sinal contendo o ruído branco 

aux = 0
r_xx = [] # Criando a lista para guardar as matrizes de autocorrelação

x_n_amostrado = [] # Criando uma lista para o sinal que será amostrado

aux2 = np.array([])# Auxiliar para guardar os n valores dos l blocos

# Amostrando o sinal contendo o ruído branco, dividindo ele em l blocos
for i in range(l):
	for j in range(n):
		aux2 = np.append(aux2, x_n[0][aux])
		aux = aux + 1
	x_n_amostrado.append(aux2)
	aux2 = np.array([])

corr = np.array([]) #Variável responsável pela multiplicação da autocorrelação
#Fazendo a operação de autocorrelação	
for i in range(l):
	r_xx.append([])
	for j in range(tau):
		r_xx[i].append([])
		for z in range(n):
			if ((z+j) <= (tau-1)):
				corr = np.append(corr, x_n_amostrado[i][z]*x_n_amostrado[i][z+j]) #Salvando a multiplicação na array corr
			else:
				corr = np.append(corr, 0) #Caso houver o deslocamento do sinal, terá uma amostra a menos para multiplicar, por isso utilizou-se 
			 
		r_xx[i][j].append(corr)
		corr = np.array([])

avg_x_n_amostrado = [] #Criando um vetor para armazenar a média das matrizes da autocorrelacao
mat_avg_x_n = np.array([])
avg_value = 0
#Calculando os valores médios das matrizes da autocorrelação 		
for i in range(tau):
	avg_x_n_amostrado.append(np.array([]))
	for j in range(n):
		for z in range(l):
			avg_value = avg_value + r_xx[z][i][0][j]
		avg_x_n_amostrado[i] = np.append(avg_x_n_amostrado[i], avg_value/l) 
		avg_value = 0 					
	

x_plot = np.arange(1,tau+1,1) #Valores referentes ao eixo x do plot
y_plot = np.arange(1,n+1,1) # Vetor com os valores referentes ao eixo y do plot
avg_x_n_amostrado = np.array(avg_x_n_amostrado) #Transformando a lista  em um array
shape = (n,tau) #Descrevendo o shape da matriz de autocorrelação
avg_x_n_amostrado.reshape(shape)#Descrevendo o shape da matriz

#Plot da superfície 
X,Y = np.meshgrid(x_plot,y_plot)
Z = avg_x_n_amostrado
fig = plt.figure(figsize=(12,6))
ax = Axes3D(fig)

cset = ax.plot_surface(X,Y,Z)
ax.set_xlabel('Deslocamento(tau)', fontsize = 15)
ax.set_ylabel('$N$', fontsize = 15)
ax.set_zlabel('$R_{xx}$', fontsize = 15)
plt.show()

