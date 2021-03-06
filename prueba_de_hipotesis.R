#TRABAJO PRUEBA DE HIPOTESIS EN R STUDIO 

# Una hip?tesis es una declaraci?n relativa a una poblaci?n
#En el an?lisis estad?stico se establece una afirmaci?n, una hip?tesis, 
#se recogen datos que posteriormente se utilizan para probar la aserci?n. 
#Entonces, una hip?tesis estad?stica es una afirmaci?n relativa a un par?metro 
#de la poblaci?n sujeta a verificaci?n.

#PRUEBA DE HIP?TESIS: es un procedimiento basado en evidencia de la muestra y 
#la teor?a de la probabilidad para determinar si la hip?tesis es una 
#afirmaci?n razonable.

#Pasos para probar una hip?tesis.
#1: Se establece la hip?tesis nula (H0) y la hip?tesis alternativa (H1)
#2: Se selecciona un nivel de significancia
#3: Se selecciona el estad?stico de prueba
#4: Se formula la regla de decisi?n
#5: Se toma una decisi?n

#  PRUEBA DE HIP?TESIS ACERCA DEL VALOR DE UNA PROPORCI?N 

#Ejemplo 

#El departamento de quejas de McFarland Insurance Company informa que el 
#costo medio paratramitar una queja es de $60. Una comparaci?n en la 
#industria demostr? que esta cantidad es mayor que en las dem?s compa??as 
#de seguros, as? que la compa??a tom? medidas para reducir gastos. 
#Para evaluar el efecto de las medidas de reducci?n de gastos, el supervisor del
#departamento de quejas seleccion? una muestra aleatoria de 26 quejas atendidas 
#el mes pasado.
#Los datos son: 45, 49, 62, 40, 43, 61, 48, 53, 67, 63, 78, 64,
#48, 54, 51, 56, 63, 69, 58, 51, 58, 59, 56, 57, 38, 76.

#Paso 1: Se establecen las hip?tesis nula y alternativa. 
#La hip?tesis nula consiste en que la media poblacional es de por lo menos $60. 
#La hip?tesis alternativa consiste en que la media poblacional es menor a $60.

#Paso 2: Se selecciona un nivel de significancia. El nivel de significancia es 0.01.

#Los pasos 3, 4 y 5 se realizaran con la ayude de R Studio de la siguiente forma: 

# Construyendo una funci?n en R para realizar la prueba de hip?tesis. 
Prueba.prop <- function(x, n, po, H1="Distinto", alfa=0.01) 
{ 
  op <- options(); 
  options(digits=2) 
  pe=x/n #calcula la proporci?n muestral 
  SE <- sqrt((po * (1-po))/n) # calcula la varianza de la proporci?n muestral 
  Zo <- (pe-po)/SE #calcula el estad?stico de prueba 
  # Si lower.tail = TRUE (por defecto), P[X <= x], en otro caso P[X > x] 
  if (H1 == "Menor" || H1 == "Mayor") 
  { 
    Z <- qnorm(alfa, mean=0, sd=1, lower.tail = FALSE, log.p = FALSE) 
    #calcula los valores cr?ticos de la distribuci?n N(0;1) en el caso de una prueba unilateral 
    valores <- rbind(Prop_Estimada=pe, Prop_Hipotetica=po, Z_critico=Z,Estadistico= Zo) 
  } 
  else 
  { 
    Z <- qnorm(alfa/2, mean=0, sd=1, lower.tail = FALSE, log.p = FALSE) 
    #calcula los valores cr?ticos de la distribuci?nN(0;1) en el caso de una prueba bilateral 
    valores <- rbind(Prop_Estimada=pe, Prop_Hipotetica =po, Z_critico_menor=-Z, 
                     Z_critico_mayor =Z, Zo) 
  } # esto es para encontrar los valores cr?ticos 
  if (H1 == "Menor") 
  { 
    if (Zo < -Z) decision <- paste("Como Estadistico <", round(-Z,3), ", entonces rechazamos Ho") 
    else decision <- paste("Como Estadistico>=", round(-Z,3), ", entonces aceptamos Ho") 
  } 
  if (H1 == "Mayor") 
  { 
    if (Zo > Z) decision <- paste("Como Estadistico >", round(Z,3), ", entonces rechazamos Ho") 
    else decision <- paste("Como Estadistico <=", round(Z,3), ", entonces aceptamos Ho") 
  } 
  if (H1 == "Distinto") 
  { 
    if (Zo < -Z) decision <- paste("Como Estadistico <", round(-Z,3), ", entonces rechazamos Ho") 
    if (Zo > Z) decision <- paste("Como Estadistico >", round(Z,3), ", entonces rechazamos Ho") 
    else decision <- paste("Como Estadistico pertenece a [", round(-Z,3), ",", round(Z,3), "], 
                           entonces aceptamos Ho") 
  } # esto para llevar a cabo los contraste de hip?tesis 
  print(valores) 
  print(decision) 
  options(op) # restablece todas las opciones iniciales 
  } 

Prueba.prop(26, 50, 0.01, H1="Menor", alfa=0.05)
Datos = c(45, 49, 62, 40, 43, 61, 48, 53, 67, 63, 78, 64, 48, 54, 51, 56, 63, 
          69, 58, 51, 58, 59, 56, 57, 38, 76)

#Los resultados nos dicen que se acepta la Hipotesis nula 




#  PRUEBA DE HIP?TESIS SOBRE UNA MEDIA
#  CUANDO LA VARIANZA ES DESCONOCIDA

#En el caso de que la varianza poblacional sea desconocida R permite realizar 
#contraste sobre la media poblacional. 
#La funci?n que se debe utilizar es t.test(), los par?metros a considerar para 
#su utilizaci?n son los siguientes. 
# . X corresponde al vector de observaciones. 
# . En alternative se especifica el tipode contraste (similar a prop.test()). 
# . Conf.level se especifica el nivel de significancia utilizado para realizar el contraste.

#Ejemplo

#La longitud media de una peque?a barra de contrapeso es de 43 mil?metros. 
#Al supervisor de producci?n le preocupa que hayan cambiado los ajustes de 
#la m?quina de producci?n de barras. Solicita una investigaci?n al departamento 
#de ingenier?a, que selecciona una muestra aleatoria de 12 barras y las mide. 
#Los resultados aparecen en seguida, expresados en mil?metros.
#42 39 42 45 43 40 39 41 40 42 43 42

#?Es razonable concluir que cambi? la longitud media de las barras? Utilice el 
#nivel de significancia 0.0?

#Hipotesis nula: longitud igual a 43 milimetros.
#Hipotesis alternativa: longitud distinta a 43 milimetros.

#Una soluci?n con utilizar es t.test() es:
Datos = c(42, 39, 42, 45, 43, 40, 39, 41, 40, 42, 43, 42) 
t.test(Datos,mu=43,alternative="greater")

#La hip?tesis nula que afirma que la media poblacional es de 43 mil?metros se 
#rechaza porque el valor calculado de t de 	2.913 se encuentra en el ?rea a la 
#izquierda de 	2.718. Se acepta la hip?tesis alternativa y se concluye que la media 
#poblacional no es de 43 mil?metros.
#La m?quina est? fuera de control y necesita algunos ajustes.


#PRUEBAS SOBRE DOS MUESTRAS INDEPENDIENTES

#Ejemplo 
#El gerente de producci?n de Bellevue Steel, fabricante de sillas de ruedas, 
#desea comparar el n?mero de sillas de ruedas defectuosas producidas en el turno 
#matutino con el del turno vespertino, Con un nivel de significancia de 0.05. 
#Una muestra de la producci?n de 6 turnos matutinos y 8 vespertinos revel? el 
#n?mero de defectos siguiente.Matutino 5,8,7,6,9,7 Y Vespertino 8,10,7,11,9,12,14,9.

#Hipotesis nula: la cantidad de sillas defectuas es igual.
#Hipotesis alternativa: la cantidad de sillas defectuosas es diferente.

Matutino<- c(5, 8, 7, 6, 9, 7) 
Vespertino<- c(8, 10, 7, 11, 9, 12, 14, 9) 

t.test(Vespertino, Matutino, var.equal=TRUE, mu=0)

#Se concluye entonces que existe diferencia significativa en la cantidad de producto
#defectuoso entre ambos grupos, pues el p valor de la prueba resulta ser muy peque?o.
# Adem?s Se rechaza H0 porque 2.837 es menor que el valorcr?tico.
# Se concluye que El n?mero medio de defectos no es el mismo en los dos turnos.


#PRUEBAS SOBRE DOS MUESTRAS PAREADAS 

#dise?o pareado lo que se busca es dar una mayor validez a las inferencias 
#obtenidas, controlando o eliminando la influencia de variables extra?as cuyo 
#efecto ya es conocido o sospechado, y no se desea que intervenga en el estudio 
#actual pudiendo enmascarar el efecto del tratamiento o de la variable de inter?s.

# Ejemplo

#Nickel Savings and Loan desea comparar las dos compa??as que contrata para
#valuar las casas. Nickel Savings seleccion? una muestra de 10 propiedades y 
#programa los aval?os de las dos empresas. Los resultados, en miles de d?lares, 
#son:
#Casa:1, 2, 3, 4, 5, 6, 7, 8, 9, 10
#Schadek:235, 210, 231, 242, 205, 230, 231, 210, 225, 249
#Bowyer:228, 205, 219, 240, 198, 223, 227, 215, 222, 245

#HO:las diferencias en la muestra entre los aval?os provienen de una poblacion 
#con una media de 0
#Ha: las diferencias en la muestra entre los aval?os no provienen de una poblacion 
#con una media de 0

Schadek<-c(235, 210, 231, 242, 205, 230, 231, 210, 225, 249)
Bowyer<-c(228, 205, 219, 240, 198, 223, 227, 215, 222, 245)

#realizando la prueba t 
t.test(Schadek, Bowyer, paired=TRUE, mu=0)

#El valor calculado de t es 3.305, y el valor p de dos colas, 0.009. 
#Como el valor p es menor que 0.05, se rechaza la hipotesis de que la media de 
#la distribucion de las diferencias entre los aval?os es cero.