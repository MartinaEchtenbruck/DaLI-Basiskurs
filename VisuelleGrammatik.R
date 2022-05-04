### Benoetigte Pakete installieren und laden
# install.packages("Rtools") # nur einmal ausfuehren
# install.packages("ggplot2") # nur einmal ausfuehren
library(ggplot2)

### URL zu Datensatz definieren
url <- "https://raw.githubusercontent.com/konrad/DaLI_Basismodul_WiSe2021_2022/main/data/Rodenkirchen_processed.csv"

### Daten lesen
dat.dali <- read.csv(url, na.strings = "-", stringsAsFactors = FALSE, quote = "''")

### Daten aufraeumen
dat.dali <- dat.dali[, -c(1:2)] # die ersten beiden Spalten loeschen (Laufenden Zeilennummer + Stationscode)
dat.dali$Datum <- as.POSIXct(dat.dali$Datum, format= "%d.%m.%Y %H:%M", tz=Sys.timezone()) # Datum und Zeit von Text in ein Datum-Zeit Objekt umwandeln
colnames(dat.dali) <- c("Datum", "Feinstaub", "Ozon", "NO2", "Index") # Spaltennamen vergeben

### Einen Ueberblick ueber die Daten verschaffen
str(dat.dali)

### Die Daten plotten...
ggplot(data = dat.dali) # einen Plot definieren

ggplot(data = dat.dali, aes(x = Datum, y = Feinstaub)) # Skalen ergaenzen

ggplot(data = dat.dali, aes(x = Datum, y = NO2)) + geom_point(na.rm = TRUE) # Punkteplot hinzufuegen

ggplot(data = dat.dali, aes(x = Datum, y = NO2)) + geom_line(na.rm = TRUE) # Linienplot hinzufuegen

### Monatliche Daten aggregieren?
dat.dali$Monat <- as.Date(cut(dat.dali$Datum, breaks = "month"))

### ... und die aggregierten Daten plotten
ggplot(data = dat.dali) + aes(x=Monat, y=NO2) + geom_line(na.rm = TRUE) # Das sieht nicht gut aus. Warum?

### ... die aggregierten Daten nochmal plotten

ggplot(data = dat.dali) + aes(x=Monat, y=NO2) + geom_line(na.rm = TRUE) +
  geom_point(na.rm = TRUE, color= "red")

### Wie kann man die Daten sinnvoll aggregieren? Dafuer bietet ggplot sogenannte 'Statistiken'
### Die hier verwendeten Statistiken plotten das arithmetische Mittel (mean) für den Monat

ggplot(data = dat.dali) + aes(x=Monat, y=NO2) +
  stat_summary(fun = "mean", geom = "line", na.rm = TRUE)

ggplot(data = dat.dali) + aes(x=Monat, y=NO2) +
  stat_summary(fun = "mean", geom = "bar", na.rm = TRUE)


### Wie kann man die Skalierung der Y-Achse ändern?

install.packages("scales")
library("scales")
ggplot(data = dat.dali) + aes(x=Monat, y=NO2) +
  stat_summary(fun = "mean", geom = "bar", na.rm = TRUE) +
  scale_y_log10( breaks = scales::trans_breaks("log10", function(x) 10^x), labels = scales::trans_format("log10", scales::math_format(10^.x)))

### Was sind Facetten?
ggplot(data = dat.dali) + aes(x=Monat, y=NO2) +
  stat_summary(fun = "mean", geom = "bar", na.rm = TRUE) +
  facet_grid(cols = vars(Index))

### Und wie kann man die Facetten umsortieren?
ggplot(data = dat.dali) + aes(x=Monat, y=NO2) +
  stat_summary(fun = "mean", geom = "bar", na.rm = TRUE) +
  facet_grid(~forcats::fct_relevel(Index, "schlecht", "mäßig", "gut", "sehr gut"))

### Und jetzt einmal den Ozon-Wert statt den NO2-Wert plotten?
ggplot(data = dat.dali) + aes(x=Monat, y=Ozon) + 
  stat_summary(fun = "mean", geom = "bar", na.rm = TRUE) +
  facet_grid(~forcats::fct_relevel(Index, "schlecht", "mäßig", "gut", "sehr gut"))

### Und wie aendere ich das gesamte Aussehen des Plots?
ggplot(data = dat.dali) + aes(x=Monat, y=NO2) +
  stat_summary(fun = "mean", geom = "bar", na.rm = TRUE) +
  facet_grid(~forcats::fct_relevel(Index, "schlecht", "mäßig", "gut", "sehr gut")) +
  theme_bw()



