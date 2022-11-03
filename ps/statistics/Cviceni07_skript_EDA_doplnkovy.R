#//////////////////////////////////////////////////////////////////////////////////////
##############    Explorační analýza dat - doplňkový skript       #####################
################                 Adéla Vrtková                 ########################
#//////////////////////////////////////////////////////////////////////////////////////

# Zobrazuje-li se vám skript s chybným kódováním, využijte příkaz File / Reopen with Encoding

# Tento skript slouží jako praktický pomocník. Jsou v něm nachystané už "finální"
# podoby nejpoužívanějších grafů a připravené nejčastěji používané procedury.

# Skript není výukový, tzn. nejsou v něm komentáře či doplňující vysvětlení. 
# Předpokládá se, že uživatelé použitým příkazům rozumí
# a umí si je vykopírovat a upravit pro své účely.

# Za následné správné použití je zodpovědný sám uživatel!!!
# Klíčová místa pro úpravu jsou označena poznámkou, nicméně neznamená to, že
# uživatel nesmí zasahovat do jiných míst (na vlastní zodpovědnost).

# Každá část 1-10 funguje zcela samostatně. Před použitím kódů v těchto částech
# je potřeba pouze připravit prostředí, tj. projít část 0. Příprava prostředí

## Obsah skriptu aneb co potřebuji? ##################
# 1. Krabicový graf (jedna kvant. proměnná)
# 2. Vícenásobný krabicový graf (kvant. proměnná tříděná dle kategoriální)
# 3. Histogram (jedna kvant. proměnná)
# 4. Sada histogramů (kvant. proměnná tříděná dle kategoriální)
# 5. QQ-graf (jedna kvant. proměnná)
# 6. Sada QQ-grafů (kvant. proměnná tříděná dle kategoriální)
# 7. Tabulka se sumárními charakteristikami (jedna kvant. proměnná)
# 8. Tabulka se sumárními charakteristikami (kvant. proměnná tříděná dle kategoriální)
# 9. Odstranění odlehlých pozorování (jedna kvant. proměnná)
# 10. Odstranění odlehlých pozorování (kvant. proměnná tříděná dle kategoriální)

#/////////////////////////////////////////////////////////////////////////////////////
## 0. Příprava prostředí ##########

# Aktivace potřebných knihoven, případně doinstalujte pomocí install.packages()
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggpubr)
library(moments)
library(rstatix)

# Import dat
data = read_excel("data_hraci.xlsx")  # Uprav soubor, příp. cestu k souboru

# Překódování kategoriální proměnné, upravit dle vlastní kategoriální proměnné
data$system = factor(data$system, 
                     levels = c("Linux", "OSX", "WIN"), # původní názvy kategorií
                     labels = c("Linux", "OS X", "Windows")) # nové názvy v daném pořadí

#/////////////////////////////////////////////////////////////////////////////////////
# 1. Krabicový graf (jedna kvant. proměnná) ####

ggplot(data, # uprav
       aes(x = "",
           y = odehrane_hod_2018))+  # uprav
  stat_boxplot(geom = "errorbar",
               width = 0.15)+
  geom_boxplot()+
  labs(x = "", y = "Odehraná doba za rok 2018 (hod)")+ # uprav
  theme_classic()+
  theme(axis.ticks.x = element_blank(),
        axis.text = element_text(color = "black", size = 11))

#/////////////////////////////////////////////////////////////////////////////////////
# 2. Vícenásobný krabicový graf (kvant. proměnná tříděná dle kategoriální) ####

ggplot(data, # uprav
       aes(x = system, # uprav
           y = odehrane_hod_2018))+ # uprav
  stat_boxplot(geom = "errorbar",
               width = 0.15)+
  geom_boxplot()+
  labs(x = "", y = "Odehraná doba za rok 2018 (hod)")+ # uprav
  theme_classic()+
  theme(axis.text = element_text(color = "black", size = 11))

#/////////////////////////////////////////////////////////////////////////////////////
# 3. Histogram (jedna kvant. proměnná) ####

ggplot(data, # uprav
       aes(x = odehrane_hod_2018))+ # uprav
  geom_histogram(binwidth = 20, # uprav
                 color = "black",
                 fill = "grey55")+
  labs(x = "Odehraná doba za rok 2018 (hod)", # uprav
       y = "Četnost")+ 
  theme_classic()+
  theme(axis.text = element_text(color = "black", size = 11))

# Alternativa:
ggplot(data, # uprav
       aes(x = odehrane_hod_2018))+ # uprav
  geom_histogram(aes(y = ..density..),
                 binwidth = 20, # uprav
                 color = "black",
                 fill = "grey55")+
  geom_density()+
  labs(x = "Odehraná doba za rok 2018 (hod)", # uprav
       y = "Hustota pravděpodobnosti")+ 
  theme_classic()+
  theme(axis.text = element_text(color = "black", size = 11))

#/////////////////////////////////////////////////////////////////////////////////////
# 4. Sada histogramů (kvant. proměnná tříděná dle kategoriální) ####

ggplot(data, # uprav
       aes(x = odehrane_hod_2018))+ # uprav
  geom_histogram(binwidth = 15, # uprav
                 color = "black",
                 fill = "grey55")+
  labs(x = "Odehraná doba za rok 2018 (hod)", # uprav
       y = "Četnost")+ 
  theme_classic()+
  theme(axis.text = element_text(color = "black", size = 11))+
  facet_wrap("system",  # uprav
             dir = "v")

# Alternativa:
ggplot(data, # uprav
       aes(x = odehrane_hod_2018))+ # uprav
  geom_histogram(aes(y = ..density..),
                 binwidth = 20, # uprav
                 color = "black",
                 fill = "grey55")+
  geom_density()+
  labs(x = "Odehraná doba za rok 2018 (hod)", # uprav
       y = "Hustota pravděpodobnosti")+ 
  theme_classic()+
  theme(axis.text = element_text(color = "black", size = 11))+
  facet_wrap("system",  # uprav
             dir = "v")

#/////////////////////////////////////////////////////////////////////////////////////
# 5. QQ-graf (jedna kvant. proměnná) ####

ggplot(data, # uprav
       aes(sample = odehrane_hod_2018))+ # uprav
  stat_qq()+
  stat_qq_line()+
  labs(x = "Teoretické normované kvantily", y = "Výběrové kvantily")+
  theme_classic()+
  theme(axis.text = element_text(color = "black", size = 11))

#/////////////////////////////////////////////////////////////////////////////////////
# 6. Sada QQ-grafů (kvant. proměnná tříděná dle kategoriální) ####

ggplot(data, # uprav
       aes(sample = odehrane_hod_2018))+ # uprav
  stat_qq()+
  stat_qq_line()+
  labs(x = "Teoretické normované kvantily", y = "Výběrové kvantily")+
  theme_classic()+
  theme(axis.text = element_text(color = "black", size = 11))+
  facet_wrap("system", # uprav
             ncol = 3, # uprav
             scales = "free")

#/////////////////////////////////////////////////////////////////////////////////////
# 7. Tabulka se sumárními charakteristikami (jedna kvant. proměnná) ####

# V každém řádku s "odehrane_hod_2018" je nutné upravit název proměnné,
# na.rm = T je preventivní parametr, který přeskočí prázdné buňky,
# hodí se, pokud počítáme charakteristiky pro proměnnou, kde byla odstraněna odlehlá pozorování.
moje_tab = 
  data %>%
    summarise(rozsah = length(na.omit(odehrane_hod_2018)),
              minimum = min(odehrane_hod_2018, na.rm=T),
              Q1 = quantile(odehrane_hod_2018, 0.25, na.rm=T),
              prumer = mean(odehrane_hod_2018, na.rm=T),
              median = median(odehrane_hod_2018, na.rm=T),
              Q3 = quantile(odehrane_hod_2018, 0.75, na.rm=T),
              maximum = max(odehrane_hod_2018, na.rm=T),
              rozptyl = var(odehrane_hod_2018, na.rm=T),
              smerodatna_odchylka = sd(odehrane_hod_2018,na.rm=T),
              variacni_koeficient = (100*(smerodatna_odchylka/abs(prumer))), 
              sikmost = (moments::skewness(odehrane_hod_2018, na.rm=T)),
              stand_spicatost = (moments::kurtosis(odehrane_hod_2018, na.rm=T)-3),
              dolni_mez_hradeb = Q1-1.5*(Q3-Q1),
              horni_mez_hradeb = Q3+1.5*(Q3-Q1))

t(moje_tab) # Vše je potřeba zaokrouhlit dle norem!

#/////////////////////////////////////////////////////////////////////////////////////
# 8. Tabulka se sumárními charakteristikami (kvant. proměnná tříděná dle kategoriální) ####

# V každém řádku s "odehrane_hod_2018" je nutné upravit název proměnné,
# na.rm = T je preventivní parametr, který přeskočí prázdné buňky,
# hodí se, pokud počítáme charakteristiky pro proměnnou, kde byla odstraněna odlehlá pozorování.
moje_tab2=
  data %>%
  group_by(system) %>%  # uprav
  summarise(rozsah = length(na.omit(odehrane_hod_2018)),
            minimum = min(odehrane_hod_2018, na.rm=T),
            Q1 = quantile(odehrane_hod_2018, 0.25, na.rm=T),
            prumer = mean(odehrane_hod_2018, na.rm=T),
            median = median(odehrane_hod_2018, na.rm=T),
            Q3 = quantile(odehrane_hod_2018, 0.75, na.rm=T),
            maximum = max(odehrane_hod_2018, na.rm=T),
            rozptyl = var(odehrane_hod_2018, na.rm=T),
            smerodatna_odchylka = sd(odehrane_hod_2018,na.rm=T),
            variacni_koeficient = (100*(smerodatna_odchylka/abs(prumer))), 
            sikmost = (moments::skewness(odehrane_hod_2018, na.rm=T)),
            stand_spicatost = (moments::kurtosis(odehrane_hod_2018, na.rm=T)-3),
            dolni_mez_hradeb = Q1-1.5*(Q3-Q1),
            horni_mez_hradeb = Q3+1.5*(Q3-Q1))

t(moje_tab2) # Vše je potřeba zaokrouhlit dle norem!

#/////////////////////////////////////////////////////////////////////////////////////
# 9. Odstranění odlehlých pozorování (jedna kvant. proměnná) ####

outliers = 
  data %>% # uprav nazev dat
   identify_outliers(odehrane_hod_2019)  # uprav nazev promenne

data = data %>%  # uprav nazev dat
            mutate(odehrane_hod_2019_out = # uprav nazev nove promenne
                     ifelse(IDhrace %in% outliers$IDhrace,  # uprav IDhrace
                            NA, 
                            odehrane_hod_2019)) # uprav nazev promenne


#/////////////////////////////////////////////////////////////////////////////////////
# 10. Odstranění odlehlých pozorování (kvant. proměnná tříděná dle kategoriální) ####

outliers = 
  data %>% # uprav nazev dat
  group_by(system) %>% # uprav nazev promenne
  identify_outliers(odehrane_hod_2018)  # uprav nazev promenne

data = data %>%  # uprav nazev dat
  mutate(odehrane_hod_2018_out = # uprav nazev nove promenne
           ifelse(IDhrace %in% outliers$IDhrace,  # uprav IDhrace
                  NA, 
                  odehrane_hod_2018)) # uprav nazev promenne

