#//////////////////////////////////////////////////////////////////
#///////////////// Cvičení 9 - Intervalové odhady /////////////////
#//////  R-skript k Doplňujícím příkladům k online cvičení  ///////
#/////////////////      Mgr. Adéla Vrtková        /////////////////
#//////////////////////////////////////////////////////////////////

# Tento skript obsahuje pouze R-příkazy !!!
# Veškeré korektní zápisy a doprovodné komentáře jsou k dispozici v Poznámkách.

# R-příkazy nejsou samy o sobě uznatelným řešením! 
# Slouží případně pouze jako doplněk !!!

#//////////////////////////////////////////////////////////////////
# Příprava prostředí #####

library(readxl)
library(dplyr)
library(ggplot2)
library(moments)
library(rstatix)

data = read_excel("data_hraci.xlsx")

# V každém příkladu si data uložíme do samostatné proměnné (data1, data2, data3, atd.)
# a budeme je upravovat na míru daného zadání. Do datasetu data zasahovat nebudeme, 
# tam zůstanou původní importovaná data.

# Příklady jsou vymyšleny tak, aby pokryly téměř všechny dílčí problémy, se kterými je možno se setkat.
# V praxi se samozřejmě na jedné datové sadě řeší pouze některé z nich v závislosti na cíli výzkumu.

#//////////////////////////////////////////////////////////////////
# Příklad 1 #####

# Vyfiltrování těch záznamů, potřebných k tomuto příkladu - pouze záznamy o hráčích s Linux.
data1 = data %>% 
  filter(system == "Linux")

#* a) ####
# Odlehlá pozorování a analýza předpokladů (normalita)
boxplot(data1$odehrane_hod_2018) # krabicový graf

data1 %>% 
  identify_outliers(odehrane_hod_2018)  # identifikace odl. pozorování

hist(data1$odehrane_hod_2018)  # histogram

qqnorm(data1$odehrane_hod_2018)  # QQ-graf
qqline(data1$odehrane_hod_2018)

moments::skewness(data1$odehrane_hod_2018)   # šikmost 
moments::kurtosis(data1$odehrane_hod_2018)-3 # standardizovaná špičatost

# Rozsah výběru a sm. odchylka kvůli zaokrouhlení
length(na.omit(data1$odehrane_hod_2018))
sd(data1$odehrane_hod_2018)

# Bodový a 90% oboustranný intervalový odhad střední hodnoty (normalita OK)
mean(data1$odehrane_hod_2018)
t.test(data1$odehrane_hod_2018, alternative = "two.sided", conf.level = 0.9)

#* b) ####
# Odlehlá pozorování a analýza předpokladů - viz a)
# Rozsah výběru a sm. odchylka kvůli zaokrouhlení - viz a)

# Bodový a 90% levostranný intervalový odhad střední hodnoty (normalita OK)
mean(data1$odehrane_hod_2018)
t.test(data1$odehrane_hod_2018, alternative = "greater", conf.level = 0.9)

#* c) ####
# Odlehlá pozorování a analýza předpokladů - viz a)
# Rozsah výběru a sm. odchylka kvůli zaokrouhlení - viz a)

# Bodový a 90% pravostranný intervalový odhad střední hodnoty (normalita OK)
mean(data1$odehrane_hod_2018)
t.test(data1$odehrane_hod_2018, alternative = "less", conf.level = 0.9)

#* d) ####
# Odlehlá pozorování a analýza předpokladů - viz a)

# Bodový a 90% oboustranný intervalový odhad směrodatné odchylky (normalita OK)
sd(data1$odehrane_hod_2018)

library(EnvStats)
Int_odhad = varTest(data1$odehrane_hod_2018, alternative = "two.sided", conf.level = 0.9)

# Odmocnění pro získání int. odhadu sm. odchylky (funkce dá int. odhad rozptylu)
sqrt(Int_odhad$conf.int)

#* e) ####
# Definování dichotomické proměnné
data1$hodiny_dich_2018 = ifelse(data1$odehrane_hod_2018>280, "Ano", "Ne")

# Získání potřebných četností
table(data1$hodiny_dich_2018)
n = 42+16
x = 42
p = x/n

# Ověření předpokladů
n > 9/(p*(1-p))

# Bodový a 90% oboustranný intervalový odhad pravděpodobnosti
p
binom.test(x, n, alternative = "two.sided", conf.level = 0.9)

#//////////////////////////////////////////////////////////////////
# Příklad 2 #####

# Vyfiltrování těch záznamů, potřebných k tomuto příkladu - potřebujeme vše.
data2 = data

# Odlehlá pozorování a jejich odstranění
boxplot(data2$odehrane_hod_2019 ~ data2$system)

outliers = 
  data2 %>% 
  group_by(system) %>% 
  identify_outliers(odehrane_hod_2019)

outliers

data2 =
  data2 %>% 
  mutate(odehrane_hod_2019_out = ifelse(IDhrace %in% outliers$IDhrace, 
                                        NA, 
                                        odehrane_hod_2019))

# Analýza předpokladů (normalita pro každý OS)
boxplot(data2$odehrane_hod_2019_out ~ data2$system)

# sada histogramů
ggplot(data2, 
       aes(x = odehrane_hod_2019_out))+
  geom_histogram(bins = 10)+
  facet_wrap("system", dir = "v")

# sada QQ-grafů
ggplot(data2, 
       aes(sample = odehrane_hod_2019_out))+
  stat_qq()+ 
  stat_qq_line()+
  facet_wrap("system", scales = "free")

# Šikmost, špičatost 
# + rozsahy výběrů a sm. odchylky kvůli zaokrouhlení pro každý OS
data2 %>% 
  group_by(system) %>% 
  summarise(sikmost = moments::skewness(odehrane_hod_2019_out, na.rm = T),
            spicatost = moments::kurtosis(odehrane_hod_2019_out, na.rm = T)-3,
            rozsahy = length(na.omit(odehrane_hod_2019_out)),
            sm_odch = sd(odehrane_hod_2019_out, na.rm = T), median = quantile(odehrane_hod_2019_out, 0.5, na.rm =T))

# U některých operačních systémů empirické posouzení normality naznačuje její porušení (OSX, Windows).
# Nelze tedy všude přistoupit k určení int. odhadu střední hodnoty. 
# Budeme tedy pokračovat int. odhady mediánů (symetrie dat - skupiny - není narušena - šikmost, krabicové grafy, histogramy).
# Z důvodu konzistence a srovnatelnosti tedy určíme bodové a int. odhady mediánu pro všechny op. systémy,
# tzn. i pro ty (Linux), kde předpoklad normality je považován za splněný.

# Bodový a 95% oboustranný intervalový odhad mediánu pro každý operační systém (1x normalita OK, 2x normalita KO)
tapply(data2$odehrane_hod_2019_out, 
       data2$system, 
       quantile, 
       probs = 0.5, 
       na.rm =T)

tapply(data2$odehrane_hod_2019_out, 
       data2$system, 
       wilcox.test, 
       alternative = "two.sided", 
       conf.level = 0.95, 
       conf.int = TRUE)

# wilcox.test(data2$odehrane_hod_2019_out[data2$system=="Linux"], alternative = "two.sided", conf.level = 0.95, conf.int = TRUE)

#//////////////////////////////////////////////////////////////////
# Příklad 3 #####

#* a) ####
data3a = 
  data %>% 
  filter (system %in% c("WIN", "Linux"))

# Odlehlá pozorování a jejich odstranění
boxplot(data3a$odehrane_hod_2018 ~ data3a$system)

outliers = 
  data3a %>% 
  group_by(system) %>% 
  identify_outliers(odehrane_hod_2018)

outliers

data3a =
  data3a %>% 
  mutate(odehrane_hod_2018_out = ifelse(IDhrace %in% outliers$IDhrace, 
                                        NA, 
                                        odehrane_hod_2018))

# Analýza předpokladů - normalita + shoda rozptylů !!!
boxplot(data3a$odehrane_hod_2018_out ~ data3a$system)

ggplot(data3a, 
       aes(x = odehrane_hod_2018_out))+
  geom_histogram(bins = 10)+
  facet_wrap("system")

ggplot(data3a, 
       aes(sample = odehrane_hod_2018_out))+
  stat_qq()+ 
  stat_qq_line()+
  facet_wrap("system", scales = "free")

# Šikmost, špičatost, rozptyly (empirické pravidlo pro posouzení shody rozptylů)
# + rozsahy výběrů a sm. odchylky kvůli zaokrouhlení pro každý OS
data3a %>% 
  group_by(system) %>% 
  summarise(sikmost = moments::skewness(odehrane_hod_2018_out, na.rm = T),
            spicatost = moments::kurtosis(odehrane_hod_2018_out, na.rm = T)-3,
            rozptyl = var(odehrane_hod_2018_out, na.rm = T),
            rozsahy = length(na.omit(odehrane_hod_2018_out)),
            sm_odch = sd(odehrane_hod_2018_out, na.rm = T))

# Bodový a 95% oboustranný intervalový odhad rozdílu středních hodnot (normalita OK, shoda rozptylů KO)
tapply(data3a$odehrane_hod_2018_out, 
       data3a$system, 
       mean, 
       na.rm =T)

mean(data3a$odehrane_hod_2018_out[data3a$system=="WIN"], na.rm = T) - mean(data3a$odehrane_hod_2018_out[data3a$system=="Linux"], na.rm = T)

t.test(data3a$odehrane_hod_2018_out[data3a$system=="WIN"], 
       data3a$odehrane_hod_2018_out[data3a$system=="Linux"], 
       alternative = "two.sided", 
       var.equal = FALSE,     # shoda rozptylů KO
       conf.level = 0.95)


#* b) ####
data3b = 
  data %>% 
  filter(system %in% c("OSX", "Linux"))

# Odlehlá pozorování a jejich odstranění
boxplot(data3b$odehrane_hod_2018 ~ data3b$system)

outliers = 
  data3b %>% 
  group_by(system) %>% 
  identify_outliers(odehrane_hod_2018)

outliers

data3b =
  data3b %>% 
  mutate(odehrane_hod_2018_out = ifelse(IDhrace %in% outliers$IDhrace, 
                                        NA, 
                                        odehrane_hod_2018))

boxplot(data3b$odehrane_hod_2018_out ~ data3b$system)

# Analýza předpokladů - normalita + shoda rozptylů !!!
ggplot(data3b,
       aes(x = odehrane_hod_2018_out))+
  geom_histogram(bins = 10)+
  facet_wrap("system")

ggplot(data3b, 
       aes(sample = odehrane_hod_2018_out))+
  stat_qq()+ 
  stat_qq_line()+
  facet_wrap("system", scales = "free")

# Šikmost, špičatost, rozptyly (empirické pravidlo pro posouzení shody rozptylů), 
# + rozsahy výběrů a sm. odchylky kvůli zaokrouhlení pro každý OS
data3b %>% 
  group_by(system) %>% 
  summarise(sikmost = moments::skewness(odehrane_hod_2018_out, na.rm = T),
            spicatost = moments::kurtosis(odehrane_hod_2018_out, na.rm = T)-3,
            rozptyl = var(odehrane_hod_2018_out, na.rm = T),
            rozsahy = length(na.omit(odehrane_hod_2018_out)),
            sm_odch = sd(odehrane_hod_2018_out, na.rm = T))

# Bodový a 95% levostranný intervalový odhad rozdílu středních hodnot (normalita OK, shoda rozptylů OK)
tapply(data3b$odehrane_hod_2018_out, data3b$system, mean, na.rm =T)
mean(data3b$odehrane_hod_2018_out[data3b$system=="Linux"], na.rm = T) - mean(data3b$odehrane_hod_2018_out[data3b$system=="OSX"], na.rm = T)

t.test(data3b$odehrane_hod_2018_out[data3b$system=="Linux"], 
       data3b$odehrane_hod_2018_out[data3b$system=="OSX"], 
       alternative = "greater", 
       var.equal = TRUE,     # shoda rozptylů OK
       conf.level = 0.95)


#* c) ####
data3c = 
  data %>% 
  filter(system %in% c("OSX", "Linux"))

# Odlehlá pozorování
boxplot(data3c$odehrane_hod_2019 ~ data3c$system)

data3c %>% 
  group_by(system) %>% 
  identify_outliers(odehrane_hod_2019)

# Analýza předpokladů - normalita + shoda rozptylů !!!
ggplot(data3c, 
       aes(x = odehrane_hod_2019))+
  geom_histogram(bins = 10)+
  facet_wrap("system")

ggplot(data3c, aes(sample = odehrane_hod_2019))+
  stat_qq()+ 
  stat_qq_line()+
  facet_wrap("system", scales = "free")

# Šikmost, špičatost, rozptyl (empirické pravidlo pro posouzení shody rozptylů)
# + rozsahy výběrů a sm. odchylky kvůli zaokrouhlení pro každý OS
data3c %>% 
  group_by(system) %>% 
  summarise(sikmost = moments::skewness(odehrane_hod_2019, na.rm = T),
            spicatost = moments::kurtosis(odehrane_hod_2019, na.rm = T)-3,
            rozptyl = var(odehrane_hod_2019, na.rm = T),
            rozsahy = length(na.omit(odehrane_hod_2019)),
            sm_odch = sd(odehrane_hod_2019, na.rm = T))

# Normalita KO -> Shodu rozptylů neřešíme -> zkontrolujeme stejný tvar (šikmost, krabicový graf, histogram)

# Bodový a 95% pravostranný intervalový odhad rozdílu mediánů (normalita KO, symetrie OK)
tapply(data3c$odehrane_hod_2019,
       data3c$system, 
       quantile, 
       0.5)

quantile(data3c$odehrane_hod_2019[data3c$system=="OSX"], 0.5) - quantile(data3c$odehrane_hod_2019[data3c$system=="Linux"], 0.5)

wilcox.test(data3c$odehrane_hod_2019[data3c$system=="OSX"], 
            data3c$odehrane_hod_2019[data3c$system=="Linux"], 
            alternative = "less", 
            conf.level = 0.95,
            conf.int = T)

#//////////////////////////////////////////////////////////////////
# Příklad 4 #####

#* a) ####
data4a = 
  data %>% 
  filter(system %in% c("WIN", "Linux"))

# Odlehlá pozorování a jejich odstranění
boxplot(data4a$odehrane_hod_2018 ~ data4a$system)

outliers = 
  data4a %>% 
  group_by(system) %>% 
  identify_outliers(odehrane_hod_2018)

outliers

data4a =
  data4a %>% 
  mutate(odehrane_hod_2018_out = ifelse(IDhrace %in% outliers$IDhrace, 
                                        NA, 
                                        odehrane_hod_2018))

# Analýza předpokladů - normalita
boxplot(data4a$odehrane_hod_2018_out ~ data4a$system)

ggplot(data4a, 
       aes(x = odehrane_hod_2018_out))+
  geom_histogram(bins = 10)+
  facet_wrap("system")

ggplot(data4a, 
       aes(sample = odehrane_hod_2018_out))+
  stat_qq()+ 
  stat_qq_line()+
  facet_wrap("system", scales = "free")

data4a %>% 
  group_by(system) %>% 
  summarise(sikmost = moments::skewness(odehrane_hod_2018_out, na.rm = T),
            spicatost = moments::kurtosis(odehrane_hod_2018_out, na.rm = T)-3,
            rozptyl = var(odehrane_hod_2018_out, na.rm = T))

# Bodový a 85% oboustranný intervalový odhad poměru rozptylů (normalita OK)
var(data4a$odehrane_hod_2018_out[data4a$system=="WIN"], na.rm = T)/var(data4a$odehrane_hod_2018_out[data4a$system=="Linux"], na.rm = T)

var.test(data4a$odehrane_hod_2018_out[data4a$system=="WIN"], 
         data4a$odehrane_hod_2018_out[data4a$system=="Linux"], 
         alternative = "two.sided",
         conf.level = 0.85)

#* b) ####

# Filtrování záznamů a vytvoření dichotomické proměnné
data4b = 
  data %>% 
  filter(system %in% c("WIN", "Linux")) %>% 
  mutate(hodiny_dich_2018 = ifelse(odehrane_hod_2018>280, "Ano", "Ne"))

# Získání potřebných četností
table(data4b$system, data4b$hodiny_dich_2018)

# Linux
n1 = 42+16
x1 = 42
p1 = x1/n1

# Windows
n2 = 132+70
x2 = 132
p2 = x2/n2

# Ověření předpokladů
n1 > 9/(p1*(1-p1))
n2 > 9/(p2*(1-p2))

# Bodový a 85% pravostranný intervalový odhad rozdílu pravděpodobností (obě nerovnosti OK)
p1-p2
prop.test(c(x1, x2), c(n1,n2), alternative = "less", conf.level = 0.85)
