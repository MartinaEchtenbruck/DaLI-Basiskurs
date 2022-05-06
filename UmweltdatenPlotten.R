# install.packages("ggplot2") # nur bei Bedarf den Befehl ohne führende Raute markieren und mit STRG+Enter ausfuehren
library(ggplot2)

### Integrierte Daten herunterladen
url <- "https://raw.githubusercontent.com/MartinaEchtenbruck/DaLI-Basiskurs/main/UmweltUndLuftdaten.txt" # Hier sind die Daten hinterlegt
dali.data <- read.csv(file = url, sep = ";", na.strings = "-") # Dieser Befehl liest den Datensatz als Tabelle ein

### Einen schnellen Blick auf die Daten werfen
head(dali.data) # Dieser Befehl zeigt die ersten Zeilen der eingelesenen Tabelle
str(dali.data) # Dieser Befehl zeigt eine Uebersicht aller Spalten mit ihren Werten und dem Format indem diese hinterlegt sind
# Hier werden alle Spalten mit "chr" angezeigt. "chr" steht fuer character und bedeutet, dass die Datums- und die Zahlenspalten nicht als solche erkannt wurden

### Daten aufbereiten
dali.data <- dali.data[,-2] # 2. Spalte loeschen - Datum ist redundant abgespeichert
dali.data$Datum.Uhrzeit <- as.POSIXct(x = dali.data$Datum.Uhrzeit, format="%d.%m.%Y %H:%M", tz="UTC") # Den Datum.Uhrzeit Eintrag als Zeitobjekt hinterlegen

### Die numerischen Spalten sind als Text hinterlegt - diese in Zahlen umwandeln
# dafuer muss zunaechst der Punkt durch ein Komma als Dezimaltrennzeichen ersetzt werden
# und dann der Text in ein numeric umgewandelt werden. 
# Dafuer definieren wir eine Funktion, die dann auf die Spalten angewendet werden kann.
changeToNumeric <- function(x){return(as.numeric(str_replace(string = x, pattern = ",", replacement = ".")))}

### Zahlenspalten umwandeln
dali.data[,c(3,4,5,7:16)] <- apply(dali.data[,c(3,4,5,7:16)], MARGIN = 2, changeToNumeric)

### Erneit einen Blick auf die Daten werfen
head(dali.data) 
str(dali.data)
summary(dali.data) # dieser Befehl zeigt erste Statistiken aller vorliegenden Werte

###############################################################################
### Plot erzeugen #############################################################
###############################################################################

ggplot() +
  geom_line(data=dali.data, aes(x=Datum.Uhrzeit, y=Feinstaub, group=Stationscode, color=Stationscode))
