# Benoetigte Pakete laden
# install.packages("Rtools") # nur einmal ausfuehren
# install.packages("ggplot") # nur einmal ausfuehren
# install.packages("ggrepel") # nur einmal ausfuehren

### Benoetigte Bibliotheken laden
library(ggplot2) # Bibliothek um Plots mit R zu generieren
library(ggrepel)

### Definiere Links zu den Datensaetzen
urlCities <- "https://raw.githubusercontent.com/andrewheiss/fancy-minard/master/input/minard/cities.txt"
urlTroops <- "https://raw.githubusercontent.com/andrewheiss/fancy-minard/master/input/minard/troops.txt"
urlTemps <- "https://raw.githubusercontent.com/andrewheiss/fancy-minard/master/input/minard/temps.txt"

### Datensaetze einlesen
cities <- read.table(urlCities, header = TRUE, stringsAsFactors = FALSE)
troops <- read.table(urlTroops, header = TRUE, stringsAsFactors = FALSE)
temps <- read.table(urlTemps, header = TRUE, stringsAsFactors = FALSE)


### Erster Plot mit geom_path
ggplot(troops) + aes(x = long, y = lat, group=group) + geom_path()
# oder
ggplot() + geom_path(data = troops, aes(x = long, y = lat, group=group))
# solange sich alle Geometrien auf dieselben Daten und Aestethics beziehen
# ist die Wahl der Programmierung hier egal. Sobald der Plot komplizierter wird
# und verschiedene Datensaetze und/oder verschiedene Aestethics verwendet werden
# ist es sinnvoller die zweite Formulierung zu verwenden.


### Farben abhaengig von Marschrichtung
ggplot(troops) + aes(x = long, y = lat, group=group) + geom_path() + 
  aes(color=direction)
# oder
ggplot() + geom_path(data = troops, aes(x = long, y = lat, group=group, color=direction))

### Repraesentation Truppenstaerke
ggplot(troops) + aes(x = long, y = lat, group=group) + geom_path() + 
  aes(color=direction, size= survivors) + scale_size(range=c(0.5, 15))
# oder
ggplot() + 
  geom_path(data = troops, aes(x = long, y = lat, group=group, color=direction, size=survivors)) + 
  scale_size(range=c(0.5, 15))

### Repraesentation TruppenstaerkeAnpassung an Original-Farbschema
ggplot(troops) + aes(x = long, y = lat, group=group) + geom_path() + 
  aes(color=direction, size= survivors) + scale_size(range=c(0.5, 15)) +
  scale_colour_manual(values = c("#e6ccab", "#000000"))
# oder
ggplot() + 
  geom_path(data = troops, aes(x = long, y = lat, group=group, color=direction, size=survivors)) + 
  scale_size(range=c(0.5, 15)) +
  scale_colour_manual(values = c("#e6ccab", "#000000"))

### Achsen und Legende
ggplot(troops) + aes(x = long, y = lat, group=group) + geom_path() + 
  aes(color=direction, size= survivors) + scale_size(range=c(0.5, 15)) +
  scale_colour_manual(values = c("#e6ccab", "#000000")) +
  theme(axis.title = element_blank(), axis.ticks = element_blank(),
        axis.text = element_blank(), legend.position = "none")
# oder
ggplot() + 
  geom_path(data = troops, aes(x = long, y = lat, group=group, color=direction, size=survivors)) + 
  scale_size(range=c(0.5, 15)) +
  scale_colour_manual(values = c("#e6ccab", "#000000")) +
  theme(axis.title = element_blank(), axis.ticks = element_blank(),
        axis.text = element_blank(), legend.position = "none")


### Darstellung der Städte (Punkte)
ggplot(troops) + aes(x = long, y = lat, group=group) + geom_path() + 
  aes(color=direction, size= survivors) + scale_size(range=c(0.5, 15)) +
  scale_colour_manual(values = c("#e6ccab", "#000000")) +
  theme(axis.title = element_blank(), axis.ticks = element_blank(),
        axis.text = element_blank(), legend.position = "none") + 
  geom_point(data=cities, aes(x=long, y=lat, size=3, stroke=3, group="none"), color="red")
# oder
ggplot() + 
  geom_path(data = troops, aes(x = long, y = lat, group=group, color=direction, size=survivors)) + 
  scale_size(range=c(0.5, 15)) +
  scale_colour_manual(values = c("#e6ccab", "#000000")) +
  theme(axis.title = element_blank(), axis.ticks = element_blank(),
        axis.text = element_blank(), legend.position = "none") +
  geom_point(data=cities, aes(x=long, y=lat), color="red")
# Hier kommt geom_point hinzu, das sich auf die Städtedaten und nicht auf die
# Truppendaten bezieht. Wenn Datensatz oder Aestethics allgemein gesetzt wurden, 
# dann müssen die gesetzten Werte im Zweifelsfall ueberschrieben werden 
# (hier bspw. size und group). 
# In der zweiten Formulierung, wo Daten und Aesthetics der Geometrie zugeordnet
# wurden, ist das nicht noetig.
# Im Folgenden wird daher die zweite Formulierung verwendet.



### Darstellung der Städte
ggplot() + 
  geom_path(data = troops, aes(x = long, y = lat, group=group, color=direction, size=survivors)) + 
  scale_size(range=c(0.5, 15)) +
  scale_colour_manual(values = c("#e6ccab", "#000000")) +
  theme(axis.title = element_blank(), axis.ticks = element_blank(),
        axis.text = element_blank(), legend.position = "none") +
  geom_point(data=cities, aes(x=long, y=lat), color="red") + 
  geom_text_repel(data=cities, aes(x=long, y=lat,label=city), color="red")