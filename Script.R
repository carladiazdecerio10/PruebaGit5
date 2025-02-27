#Pasos seguidos para generar el archivo renv.lock de este script

#1) install.packages("renv")

#2)library(renv)

#3) renv::init()

#4) Instalar los paquetes correspondientes con renv:
#renv::install("maptools@1.1-8") 
#renv::install("ggplot2@3.4.4") 
#renv::install("dplyr@1.0.7")
#renv::install("readxl@1.3.1")




#Script

#Si quieres restaurar este proyecto antes de ejecutar este script ejecuta:
#renv::restore() en la línea de comandos


#Cargar las librerías necesarias 
library(maptools)
library(ggplot2)
library(dplyr)
library(readxl)

#Crear carpeta para almacenar los resultados
dir.create("output", showWarnings = FALSE)

#Leer los datos
bee_data <- read.table("data/WBees.txt", header = TRUE, sep = "\t")
women_data <- read_excel("data/women.xlsx")

# Hacer operaciones sencillas
bee_summary <- bee_data %>%
  group_by(Hive) %>%
  summarise(Avg_CellSize = mean(CellSize, na.rm = TRUE))

women_summary <- women_data %>%
  summarise(across(where(is.numeric), mean, na.rm = TRUE))

# Generar gráfico y guardarlo en la carpeta output
ggplot(bee_data, aes(x = CellSize)) +
  geom_histogram(binwidth = 0.01, fill = "blue", alpha = 0.7) +
  ggtitle("Distribución de CellSize en WBees")
ggsave("output/bee_histogram.png")


write.csv(bee_summary, "output/bee_summary.csv", row.names = FALSE)
write.csv(women_summary, "output/women_summary.csv", row.names = FALSE)

# Congelar el entorno
renv::snapshot()

# Para restaurar el proyecto en otro equipo, ejecutar: 
# renv::restore()