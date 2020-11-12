#####################################ANALIZAR DATOS DE SUPPA EN CASOS Y CONTROLES####################################################

#Crear una variable threshold
a = 0.95

#CASOS

casos <- read.delim("~/Desktop/MN4/Resultados/Resultados/casos_events.psi", header = TRUE, sep = "\t")
head(casos)
dim(casos)

casos_up = as.data.frame(rowSums(casos > a, na.rm = TRUE)) #Contar cuantas muestras están por encima de 0.85 en cada evento
casos_down = as.data.frame(rowSums(casos < a, na.rm = TRUE)) #Contar cuantas muestras están por debajo de 0.85 en cada evento
casos_nan = as.data.frame(rowSums(casos == "NaN")) #Contar cuantos nan y na hay por cada evento

psitable <- cbind(casos$Event_ID, casos_up, casos_down, casos_nan) #Guardar los datos en una nueva tabla 
psi <- cbind(casos_up, casos_down)

#CONTROLES

controles <- read.delim("~/Desktop/MN4/Resultados/Resultados/controles_events.psi", header = TRUE, sep = "\t")
head(controles)
dim(controles)

controles_up = as.data.frame(rowSums(controles > a, na.rm = TRUE)) #Contar cuantas muestras están por encima de 0.85 en cada evento
controles_down = as.data.frame(rowSums(controles < a, na.rm = TRUE)) #Contar cuantas muestras están por debajo de 0.85 en cada evento
controles_nan = as.data.frame(rowSums(controles == "NaN")) #Contar cuantos nan y na hay por cada evento

psitable  <- cbind(psitable, controles_up, controles_down, controles_nan) #Guardar las tres nuevas columnas en la tabla de los casos
psi <- cbind(psi, controles_up, controles_down)

colnames(psitable) <- c("Event_ID", "casos_up", "casos_down", "casos=nan", "controles_up", "controles_down", "controles=nan") #Cambiar los nombres a las columnas
colnames(psi) <- c("casos>0.85", "casos<0.85", "controles>0.85", "controles<0.85")

#Calcular el p-valor para cada fila sin tener en cuenta los "NaN"

i <- NULL; p.value <- NULL
for(i in 1:dim(psitable)[1]) 
{
  fila1 = psitable[i, c(2,5)]
  fila2 = psitable[i, c(3,6)]
  names(fila1) <- c("casos", "controles")
  names(fila2) <- c("casos", "controles")
  ha = rbind(fila1, fila2)
  r = fisher.test(ha)$p.value
  p.value <- c(p.value, r)
}
p.value

psitable <- cbind(psitable, p.value) #Guardar el vector p.value de cada evento como una columna nueva del dataframe psitable
psi <- cbind(psi, p.value) #Guardar el vector p.value de cada evento como una columna nueva del dataframe psi

#Ajustar el pvalor

psitable$pval.adjust <- p.adjust(psitable$p.value, method="BH")

#Visualizar la tabla

View(psitable)
View(psi)

#Visualizar los pvalores ajustados menor que 0.05

d <- psitable[psitable$pval.adjust < 0.05, ] #Guardar los eventos significativos con un threshold de 0.95 en una variable 
View(d) #Visualizar la tabla con solo los eventos significativos 
dpsi_0.99 <- psitable[psitable$pval.adjust < 0.05, ] #Threshold de 0.99
View(dpsi_0.99)

#Crear una columna con el evento

psitable$d <- sub(".*;", "", psitable$Event_ID) #; psitable$gene <- sub(";.*", "", psitable$Event_ID) En este caso si queremos crear una columna con los id de los genes
psitable$event <- sub(":.*", "", psitable$d) #Creamos una columna con solo el evento  
psitable <- psitable[, -10] #eliminamos la columna "d" y así solo nos quedamos con la del evento
psitable <- psitable[ , c(1,10,2,3,4,5,6,7,8,9)] #Ordenamos las columnas para que el evento está en la segunda columna

#Guardar la tabla en un fichero

write.table(psitable, file = "~/Desktop/MN4/Resultados/Resultados/casos_vs_controles_vs_na_0.95.txt", sep = "\t", col.names = TRUE, row.names = TRUE)
write.table(psi, file = "~/Desktop/MN4/Resultados/casos_vs_controles.txt", sep = "\t", col.names = TRUE, row.names = TRUE)

###########################HIPERGEOMETRÍA##############################################

m <- NULL #Variable para todo el número de casos con un PSI mayor del threshold
n <- NULL #Variable para todo el número de controles con un PSI mayor del threshold
e <- NULL 
ev_names = c("SE", "MX", "A5", "A3", "RI", "AF", "AL") #Concatenamos todas los eventos en una variable para utilizarlo en los bucles

m <- colSums(psitable[, 3, drop = FALSE]) #Guardamos en una variable todo los casos con el PSI mayor del treshold de nuestra tabla
n <- colSums(psitable[, 6, drop = FALSE]) #Lo mismo pero con los controles

#En un bucle obtenemos la suma de todos los casos con el PSI mayor del threshold para cada evento
for (e in ev_names){
  q <- colSums(psitable[psitable$event==e, 3, drop = FALSE]) #Guardamos en la variable q la suma de los casos con el PSI mayor del threshold para cada evento 
  name1 = paste("q", e, sep = "") #En una variable le asignamos a cada evento el nombre "q" por evento: "SE"..., obteniendo "qSE"..
  assign(name1, q) #Le asignamos a cada evento ("qSE"...) el valor de "q", es decir, de la suma de los casos...
}

#En un bucle obtenemos la suma numérica de cada columna de los casos y controles por encima y debajo del threshold para cada evento
for (e in ev_names){
  k <- as.data.frame(colSums(psitable[psitable$event==e, c(3, 4, 6, 7), drop = FALSE]))
  k <- colSums(k[, 1, drop = FALSE]) #Guardamos en la variable k la suma total de las 4 columnas para cada evento 
  name2 = paste("k", e, sep = "") #En una variable le asignammos a cada evento el nombre "k" por evento: "SE"..., obteniendo "kSE", "kMX"...
  assign(name2, k) #Le asignamos a cada evento ("kSE"...) el valor de su "k", es decir, de la suma total de las 4 columnas por cada evento...
}

#Crear una tabla (data frame) para el método phyper con todas las variables 
phy <- data.frame(
  "event" = c("SE", "MX", "A5", "A3", "RI", "AF", "AL"), 
  "m" = rep(m, 7), 
  "n" = rep(n, 7),
  "k" = c(kSE, kMX, kA5, kA3, kRI, kAF, kAL),
  "q" = c(qSE, qMX, qA5, qA3, qRI, qAF, qAL)
)

rownames(phy) <- NULL #Le quitamos el índice de las filas

View(phy) #Visualizar la tabla phy

#Realizar el test de phyper para cada evento en un bucle 
o <- NULL; pval <- NULL

for (o in 1:dim(phy)[1]) {
  k = phy[o, 4]
  q = phy[o, 5]
  t <-  phyper(q, m, n, k, lower.tail = FALSE, log.p = FALSE)
  pval <- c(pval, t)
}

phy <- cbind(phy, pval) #Añadir el resultado del test en la tabla 
View(phy)