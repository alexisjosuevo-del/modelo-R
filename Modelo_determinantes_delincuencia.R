###La delincuencia en México y sus determinantes### 
##Modelo clásico de regresión lineal múltiple##

###Variables###
##Dependiente:
#incidencia:	Tasa de incidencia delictiva por cada cien mil habitantes 

##Independientes:
#efec_tp:	 Porcentaje de personas de 18 años y más que identifica a la policía estatal y considera algo efectivo o muy efectivo el trabajo de la policía estatal
#desempleo:	Tasa de desempleo 

##Modelo de corte transversal por entidad federativa
#32 entidades, n=32
#todas las variables corresponden a 2024

##Cambiar el directorio de trabajo
delitos <- read_csv("G:/Mi unidad/Trabajo UAM/Estadística II/Prácticas cierre regresión simple/modelo_delitos1.csv")

# Ver base de datos
View(delitos)

#Para reconocer cada columna 
#attach permite trabajar con cada variable de forma independiente
attach(delitos)

##Previo a regresión lineal#

#I. Análisis gráfico y estadístico de las variables#
#1. Tasa de incidencia delictiva
#1.1 Gráfica línea 
plot(incidencia, main="Tasa de incidencia delictiva por cada cien mil habitantes")
lines(incidencia, col="blue")
# Usamos 1:length(incidencia) para indicar la posición en el eje X de cada punto
text(
  srt = 45,
  x = 1:length(incidencia), 
  y = incidencia, 
  labels = Entidad, 
  pos = 1,           # Coloca el texto ARRIBA del punto (1=abajo, 2=izquierda, 3=arriba, 4=derecha)
  cex = 0.7,         # Reduce el tamaño de la letra para que no se amontone (1 es el tamaño por defecto)
  col = "darkgray"   # Color del texto de las etiquetas
)

#1.2 diagrama de caja
boxplot(incidencia,
        main = "Diagrama de caja",
        ylab = "Tasa de incidencia delictiva",
        col = "lightblue")
#1.3 Histograma
hist(incidencia)

#1.4 Estadísticos descriptivos 
install.packages("psych")
library(psych)
describe(incidencia)
#kurtosis se compara respecto a cero 

#2. Tasa de desempleo
#2.1 Gráfica línea 
plot(desempleo, main="Tasa de desempleo")
lines(desempleo, col="blue")
# Usamos 1:length(incidencia) para indicar la posición en el eje X de cada punto
text(
  srt = 45,
  x = 1:length(desempleo), 
  y = desempleo, 
  labels = Entidad, 
  pos = 1,           # Coloca el texto ARRIBA del punto (1=abajo, 2=izquierda, 3=arriba, 4=derecha)
  cex = 0.7,         # Reduce el tamaño de la letra para que no se amontone (1 es el tamaño por defecto)
  col = "darkgray"   # Color del texto de las etiquetas
)

#2.2 diagrama de caja
boxplot(desempleo,
        main = "Diagrama de caja",
        ylab = "Tasa de desempleo",
        col = "lightblue")

#2.3 Histograma
hist(desempleo)
#2.4 Estadísticos descriptivos 
describe(desempleo)
#kurtosis se compara respecto a cero 

#3. Porcentaje de percepción de efectividad del trabajo de la policía  
#3.1 Gráfica línea 
plot(efec_tp, main="Porcentaje de percepción efectividad trabajo policía")
lines(efec_tp, col="blue")
# Usamos 1:length(incidencia) para indicar la posición en el eje X de cada punto
text(
  srt = 45,
  x = 1:length(efec_tp), 
  y = efec_tp, 
  labels = Entidad, 
  pos = 1,           # Coloca el texto ARRIBA del punto (1=abajo, 2=izquierda, 3=arriba, 4=derecha)
  cex = 0.7,         # Reduce el tamaño de la letra para que no se amontone (1 es el tamaño por defecto)
  col = "darkgray"   # Color del texto de las etiquetas
)

#3.2 diagrama de caja
boxplot(efec_tp,
        main = "Diagrama de caja",
        ylab = "Porcentaje de percepción efectividad trabajo policía",
        col = "lightblue")

#3.3 Histograma
hist(efec_tp)

#3.4 Estadísticos descriptivos 
describe(efec_tp)
#kurtosis se compara respecto a cero 

#II. Análisis de correlación#
#1. coeficiente de correlación
cor(incidencia,desempleo)
cor(incidencia,efec_tp)

#2. Diagrama de dispersión
plot(x =desempleo, y = incidencia)
plot(x =efec_tp, y = incidencia)

#2.1Diagrama de dispersión con recta de regresión
plot(desempleo, incidencia, 
     main = "Incidencia delictiva= f (tasa de desempleo)",
     xlab = "Tasa de desempleo", 
     ylab = "Incidencia delictiva", 
     pch = 19,         # Tipo de punto (sólido)
     col = "blue")     # Color de los puntos
modelo <- lm(incidencia ~ desempleo)
abline(modelo, col = "red", lwd = 2) # lwd cambia el grosor de la línea

#Diagrama de dispersión con recta de regresión
plot(efec_tp, incidencia,
     main = "Incidencia delictiva= f (Porcentaje de percepción efectividad trabajo policía)",
     xlab = "Porcentaje de percepción efectividad trabajo policía", 
     ylab = "Incidencia delictiva", 
     pch = 19,         # Tipo de punto (sólido)
     col = "blue")     # Color de los puntos
modelo <- lm(incidencia ~ efec_tp)
abline(modelo, col = "red", lwd = 2) # lwd cambia el grosor de la línea

#III. Regresión lineal
mod_lin_delito<- lm(incidencia ~ desempleo+efec_tp)
summary(mod_lin_delito)

#Iv. Generar y analizar graficamente los residuos
res_lin <- resid(mod_lin_delito)

#inspeccción gráfica de los residuos
# Gráfica línea 
plot(res_lin, main="Residuos")
lines(res_lin, col="blue")
# Usamos 1:length(incidencia) para indicar la posición en el eje X de cada punto
text(
  srt = 45,
  x = 1:length(res_lin), 
  y = res_lin, 
  labels = Entidad, 
  pos = 1,           # Coloca el texto ARRIBA del punto (1=abajo, 2=izquierda, 3=arriba, 4=derecha)
  cex = 0.7,         # Reduce el tamaño de la letra para que no se amontone (1 es el tamaño por defecto)
  col = "darkgray"   # Color del texto de las etiquetas
)

#diagrama de caja
boxplot(res_lin,
        main = "Diagrama de caja",
        ylab = "Residuos",
        col = "lightblue")

#Histograma
hist(res_lin)

#V. Realizar comparación "y" vs "y-estimada"
#generar "y estimada"
y_estimada <- fitted(mod_lin_delito)
#graficar "y-observada" / "y-estimada"
plot(incidencia,
     type = "l",
     col = "blue",
     lwd = 2,
     ylim = range(c(incidencia, y_estimada)),
     xlab = "Observaciones",
     ylab = "Incidencia delictiva",
     main = "Valores observados y estimados")
lines(y_estimada,
      col = "red",
      lwd = 2)
legend("topright",
       legend = c("Observada", "Estimada"),
       col = c("blue", "red"),
       lwd = 2)

####VI. PRUEBAS DE HIPÓTESIS####
#nota:los valores críticos se señalan como referente aunque 
#en el trabajo final solo se concluirá con p-value 

#Prueba t para pruebas de significancia individual
##VALOR CRÍTICO t, alfa=0,05/2, n=32, k=3, gl=n-k=29
qt(0.05/2, 29)

##VALOR CRÍTICO Prueba F, alfa=0.05, k-1=2, n-k=29
qf(0.05, 2, 29, lower.tail=F)

#######NORMALIDAD##########
#Detección gráfica#
#gráficos de la distribución de los residuos
qqnorm(res_lin)
qqline(res_lin) 
plot(density(res_lin))

###Prueba de Jarque Bera###
#Usar libreria tseries
#Instalar:
install.packages("tseries")
#Activar:
library(tseries) 

y<-rnorm(res_lin)
jarque.bera.test(res_lin)

##VALOR CRÍTICO chi cuadrada, alfa=0,05, 2 gl.
qchisq(0.95,2)

###Prueba Shapiro Wilk###
shapiro.test(res_lin)

###Prueba Anderson Darling###
# usar libreria nortest
install.packages("nortest")
#Activar:
library(nortest)  
ad.test(res_lin)

#####HOMOSCEDASTICIDAD######
#Detección gráfica#
res2=res_lin^2
plot(x=desempleo, y = res2)
plot(x=efec_tp, y = res2)
cor(res2, desempleo)
cor(res2, efec_tp)

#usar paqueteria lm test
install.packages("lmtest")
#activar
library(lmtest)

####Breusch and Pagan### 
mod_breusch <- lm(res_lin ~ desempleo+efec_tp)
summary(mod_breusch)
bptest(mod_breusch)

####White datos cruzados ### 
bptest(mod_breusch, varformula = ~ desempleo+ I(desempleo^2)+efec_tp+I(efec_tp^2)+I(desempleo*efec_tp), data=delitos)

##VALOR CRÍTICO, alfa=0,05, gl=k-1=6-1
qchisq(0.95,5)

#####NO AUTOCORRELACIÓN######
library(lmtest)

#Durbin Watson
dwtest(formula = mod_lin_delito)

#####MULTICOLINEALIDAD######
#Correlación variables independientes
cor(desempleo,efec_tp)

#Prueba VIF (Variance Inflation Factor)
#Se revisa VIF= 1/(1-R2) y se intepreta:
#1 (sin multicolinealidad)
#1 a 5 baja multicolinealidad
#5 a 10 moderada multicolinealidad
#10 o más multicolinealidad alta 

#Se puede calcular automáticamente el VIF
#usar libreria car
install.packages("car")
#activar
library(car)
vif(mod_lin_delito)


#Prueba de Farrar-Glauber
# 1. Instalar y activar librerias psych y mctest
install.packages("psych")
library(psych)
install.packages("mctest")
library(mctest)

# 1. Agrupar solo las variables predictoras (X) en un dataframe o matriz
datos_X <- data.frame(desempleo,efec_tp)

# 2. Calcular la matriz de correlación de las variables independientes
r_ind <- cor(datos_X)

# 3. Obtener el número de observaciones/filas (n) de la muestra
n <- nrow(datos_X)

# 4. Ejecutar la prueba de Farrar-Glauber / Bartlett 
prueba_fg <- cortest.bartlett(r_ind, n = n)

# 5. Ver los resultados
print(prueba_fg)

