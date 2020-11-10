#Crear una variable threshold

a = 0.85

#CASOS

casos <- read.delim("~/Desktop/MN4/Resultados/Tablas/casos_events.psi", header = TRUE, sep = "\t", row.names = 1)
head(casos)
dim(casos)

casos_up = as.data.frame(rowSums(casos > a, na.rm = TRUE)) #Contar cuantas muestras están por encima de 0.85 en cada evento
casos_down = as.data.frame(rowSums(casos < a, na.rm = TRUE)) #Contar cuantas muestras están por debajo de 0.85 en cada evento
casos_nan = as.data.frame(rowSums(casos == "NaN")) #Contar cuantos nan y na hay por cada evento

psitable <- cbind(casos_up, casos_down, casos_nan) #Guardar los datos en una nueva tabla 
psi <- cbind(casos_up, casos_down)

#CONTROLES

controles <- read.delim("~/Desktop/MN4/Resultados/Tablas/controles_events.psi", header = TRUE, sep = "\t", row.names = 1)
head(controles)
dim(controles)

controles_up = as.data.frame(rowSums(controles > a, na.rm = TRUE)) #Contar cuantas muestras están por encima de 0.85 en cada evento
controles_down = as.data.frame(rowSums(controles < a, na.rm = TRUE)) #Contar cuantas muestras están por debajo de 0.85 en cada evento
controles_nan = as.data.frame(rowSums(controles == "NaN")) #Contar cuantos nan y na hay por cada evento

psitable  <- cbind(psitable, controles_up, controles_down, controles_nan) #Guardar las tres nuevas columnas en la tabla de los casos
psi <- cbind(psi, controles_up, controles_down)

colnames(psitable) <- c("casos_up", "casos_down", "casos=nan", "controles_up", "controles_down", "controles=nan") #Cambiar los nombres a las columnas
colnames(psi) <- c("casos>0.85", "casos<0.85", "controles>0.85", "controles<0.85")

#Calcular el p-valor para cada fila sin tener en cuenta los "NaN"

i <- NULL; p.value <- NULL
for(i in 1:dim(psi)[1]) 
{
  fila1 = psi[i, c(1,3)]
  fila2 = psi[i, c(2,4)]
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

  #Visualizar los pvalores menor que 0.05

dpsi <- psitable[psitable$pval.adjust < 0.05, ] #Guardar los eventos significativos en una variable 
View(dpsi) #Visualizar la tabla con solo los eventos significativos 

#Guardar la tabla en un fichero

write.table(psitable, file = "~/Desktop/MN4/Resultados/casos_vs_controles_vs_na.txt", sep = "\t", col.names = TRUE, row.names = TRUE)
write.table(psi, file = "~/Desktop/MN4/Resultados/casos_vs_controles.txt", sep = "\t", col.names = TRUE, row.names = TRUE)
