#//////////////////////////////////////////////////////////////////
#///////////////// Cvičení 11 - Testování hypotéz /////////////////
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

# Odpovídá Příkladu 3 v prezentaci k Intervalovým odhadům (Cviceni09_skript_Int_odhady.R + poznámky)

# POZOR! V Příkladu 1 byla stanovena hladina významnosti 0,05 - tuto hladinu je nutné používat u všech testů,
# které budou v kontextu Příkladu 1 použity !!!

#* a) ####
data1a = 
  data %>% 
  filter(system %in% c("WIN", "Linux"))

# Odlehlá pozorování a jejich odstranění
boxplot(data1a$odehrane_hod_2018 ~ data1a$system)

outliers = 
  data1a %>% 
  group_by(system) %>% 
  identify_outliers(odehrane_hod_2018)

outliers

data1a =
  data1a %>% 
  mutate(odehrane_hod_2018_out = ifelse(IDhrace %in% outliers$IDhrace, 
                                        NA, 
                                        odehrane_hod_2018))

boxplot(data1a$odehrane_hod_2018_out ~ data1a$system)

# Analýza předpokladů - normalita
ggplot(data1a, 
       aes(x = odehrane_hod_2018_out))+
  geom_histogram(bins = 10)+
  facet_wrap("system", 
             ncol = 1)

ggplot(data1a, 
       aes(sample = odehrane_hod_2018_out))+
  stat_qq()+ 
  stat_qq_line()+
  facet_wrap("system",
             scales = "free")

tapply(data1a$odehrane_hod_2018_out, 
       data1a$system, 
       moments::skewness, na.rm =T)

tapply(data1a$odehrane_hod_2018_out, 
       data1a$system, 
       moments::kurtosis, na.rm =T)-3

tapply(data1a$odehrane_hod_2018_out, 
       data1a$system, 
       shapiro.test)

# Analýza předpokladů -> normalita OK -> shoda rozptylů?

# Empiricky - poměr výběrových rozptylů (větší ku menšímu) < 2 ?
tapply(data1a$odehrane_hod_2018_out, 
       data1a$system, 
       var, na.rm =T)

# Exaktně! Test o shodě rozptylů - F-test
# Touto strukturou se hůře hlídá "co k čemu" se vztahuje - pokud potřebuji i IO, pak rozhodně nedoporučuji
# Pokud potřebuji jen p-hodnotu, tak klidně
var.test(data1a$odehrane_hod_2018_out ~ data1a$system)

# Srovnejte!
var.test(data1a$odehrane_hod_2018_out ~ data1a$system)

var.test(data1a$odehrane_hod_2018_out[data1a$system == "WIN"], 
         data1a$odehrane_hod_2018_out[data1a$system == "Linux"])

var.test(data1a$odehrane_hod_2018_out[data1a$system == "Linux"], 
         data1a$odehrane_hod_2018_out[data1a$system == "WIN"])

# Analýza předpokladů -> normalita OK, shoda rozptylů KO -> Aspinové-Welchův test

# Aspinové-Welchův test (H0: mu_W = mu_L, HA: mu_W !=  mu_L) odpovídá (H0: mu_W - mu_L = 0, HA: mu_W - mu_L != 0)
t.test(data1a$odehrane_hod_2018_out[data1a$system=="WIN"], 
       data1a$odehrane_hod_2018_out[data1a$system=="Linux"], 
       alternative = "two.sided", 
       var.equal = FALSE,     # shoda rozptylů KO
       conf.level = 0.95)

#* b) ####
data1b = 
  data %>% 
  filter(system %in% c("OSX", "Linux"))

# Odlehlá pozorování a jejich odstranění
boxplot(data1b$odehrane_hod_2018 ~ data1b$system)

outliers = 
  data1b %>% 
  group_by(system) %>% 
  identify_outliers(odehrane_hod_2018)

outliers

data1b =
  data1b %>% 
  mutate(odehrane_hod_2018_out = ifelse(IDhrace %in% outliers$IDhrace, 
                                        NA, 
                                        odehrane_hod_2018))

boxplot(data1b$odehrane_hod_2018_out ~ data1b$system)

# Analýza předpokladů - normalita
ggplot(data1b, 
       aes(x = odehrane_hod_2018_out))+
  geom_histogram(bins = 10)+
  facet_wrap("system", 
             ncol = 1)

ggplot(data1b, 
       aes(sample = odehrane_hod_2018_out))+
  stat_qq()+ 
  stat_qq_line()+
  facet_wrap("system", scales = "free")

tapply(data1b$odehrane_hod_2018_out, 
       data1b$system, 
       moments::skewness, na.rm =T)

tapply(data1b$odehrane_hod_2018_out, 
       data1b$system, 
       moments::kurtosis, na.rm =T)-3

tapply(data1b$odehrane_hod_2018_out, 
       data1b$system, 
       shapiro.test)

# Analýza předpokladů -> normalita OK -> shoda rozptylů?

# Empiricky - poměr výběrových rozptylů (větší ku menšímu) < 2 ?
tapply(data1b$odehrane_hod_2018_out, 
       data1b$system, 
       var, na.rm =T)

# Exaktně! Test o shodě rozptylů - F-test
# Touto strukturou se hůře hlídá "co k čemu" se vztahuje - pokud potřebuji i IO, pak rozhodně nedoporučuji
# Pokud potřebuji jen p-hodnotu, tak klidně
var.test(data1b$odehrane_hod_2018_out ~ data1b$system)
# lépe - kontrolovaně
var.test(data1b$odehrane_hod_2018_out[data1b$system == "OSX"], 
         data1b$odehrane_hod_2018_out[data1b$system == "Linux"])

# Analýza předpokladů -> normalita OK, shoda rozptylů OK -> Dvouvýběrový t-test

# Dvouvýběrový t-test (H0: mu_L = mu_O, HA: mu_L >  mu_O) odpovídá (H0: mu_L - mu_O = 0, HA: mu_L - mu_O > 0)
t.test(data1b$odehrane_hod_2018_out[data1b$system=="Linux"], 
       data1b$odehrane_hod_2018_out[data1b$system=="OSX"], 
       alternative = "greater", 
       var.equal = TRUE,     # shoda rozptylů OK
       conf.level = 0.95)

#* c) ####
data1c = 
  data %>% 
  filter(system %in% c("OSX", "Linux"))

# Odlehlá pozorování
boxplot(data1c$odehrane_hod_2019 ~ data1c$system)

data1c %>% 
  group_by(system) %>% 
  identify_outliers(odehrane_hod_2019)


# Analýza předpokladů - normalita
ggplot(data1c, 
       aes(x = odehrane_hod_2019))+
  geom_histogram(bins = 10)+
  facet_wrap("system", 
             ncol = 1)

ggplot(data1c, 
       aes(sample = odehrane_hod_2019))+
  stat_qq()+ 
  stat_qq_line()+
  facet_wrap("system",
             scales = "free")

tapply(data1c$odehrane_hod_2019, 
       data1c$system, 
       moments::skewness, na.rm =T)

tapply(data1c$odehrane_hod_2019, 
       data1c$system, 
       moments::kurtosis, na.rm =T)-3

tapply(data1c$odehrane_hod_2019, 
       data1c$system, 
       shapiro.test)

# Analýza předpokladů -> normalita KO -> přechod na mediány!

# Kontrola, zda výběry mají stejný tvar rozdělení (histogramy, míry tvaru)
# Nesmí být např. jedno rozdělení výrazně zešikmené doleva a druhé doprava.

# Analýza předpokladů -> normalita KO, stejný tvar OK -> Mannův-Whitneyho test

# Kvůli přehlednosti je zde medián značen jen symbolicky x (aby byl odlišitelný od stř. hodnoty mu)
# Mannův-Whitneyho test (H0: x_L = x_O, HA: x_L >  x_O) odpovídá (H0: x_L - x_O = 0, HA: x_L - x_O > 0)
wilcox.test(data1c$odehrane_hod_2019[data1c$system=="Linux"], 
            data1c$odehrane_hod_2019[data1c$system=="OSX"], 
            alternative = "greater", 
            conf.level = 0.95,
            conf.int = T)

# Uvědomme si, že výše uvedené také odpovídá:
# Mannův-Whitneyho test (H0: x_O = x_L, HA: x_O <  x_L) odpovídá (H0: x_O - x_L = 0, HA: x_O - x_L < 0)
wilcox.test(data1c$odehrane_hod_2019[data1c$system=="OSX"], 
            data1c$odehrane_hod_2019[data1c$system=="Linux"], 
            alternative = "less", 
            conf.level = 0.95,
            conf.int = T)

tapply(data1c$odehrane_hod_2019, data1c$system, quantile, 0.5)
326.5 - 315

# POZOR! V interpretaci musíme respektovat to, že jsme museli přejít na mediány!

#//////////////////////////////////////////////////////////////////
# Vsuvka ######
# Mohli jste si všimnout, že spoustu charakteristik opakovaně potřebujeme během analýzy.
# Jedná se o - šikmost, špičatost, případně rozptyly, směrodatné odchylky, rozsahy a dále průměry nebo mediány,
# test normality...
# Zatím jsme je počítali postupně tak, jak jsme je potřebovali.
# Pokud ale uživatel už ví, co dělá, tak si může výpočet všeho potřebného nachystat do jedné tabulky, ze které
# si potřebné informace už bude jen vybírat (ne vždy potřebujeme všechno !!!).

data %>% 
  group_by(system) %>% 
  summarise(rozsah = length(na.omit(odehrane_hod_2018)),
            sikmost = moments::skewness(odehrane_hod_2018, na.rm = T),
            spicatost = moments::kurtosis(odehrane_hod_2018, na.rm = T)-3, 
            rozptyl = var(odehrane_hod_2018, na.rm = T),
            sm_odch = sd(odehrane_hod_2018, na.rm = T),
            prumer = mean(odehrane_hod_2018, na.rm = T),
            median = quantile(odehrane_hod_2018, 0.5, na.rm = T),
            Shapiruv_Wilkuv_phodnota = shapiro.test(odehrane_hod_2018)$p.value)

# Tuto tabulku samozřejmě do práce takto nevkládáme, ale držíme se toho, kdy jaké charakteristiky
# potřebujeme, podle toho je v práci uvádíme.
# Např. pokud rozsah a sm. odchylku potřebujeme jen kvůli zaokrouhlení, pak je do práce neuvedeme, ale
# během řešení je potřebujeme... Pokud pracujeme s mediány, pak je bezpředmětné uvádět někde průměry...
# Hold musíte vědět, co děláte :), abyste si ve správnou chvíli vyzobali ty správné údaje...

#//////////////////////////////////////////////////////////////////
# Příklad 2 #####

# Vyfiltrování těch záznamů, potřebných k tomuto příkladu a vytvoření nové proměnné
data2 = 
  data %>% 
  filter(system %in% c("Linux", "WIN")) %>% 
  mutate(rozdil = odehrane_hod_2019 - odehrane_hod_2018)

# POZOR! V Příkladu 2 byla stanovena hladina významnosti 0,05 - tuto hladinu je nutné používat u všech testů,
# které budou v kontextu Příkladu 2 použity !!!

#* a) ####
boxplot(data2$rozdil ~ data2$system)

#* b) ####
# Odlehlá pozorování a příprava podkladů
outliers = 
  data2 %>% 
  group_by(system) %>% 
  identify_outliers(rozdil)

outliers

data2 =
  data2 %>% 
  mutate(rozdil_out = ifelse(IDhrace %in% outliers$IDhrace, 
                             NA, 
                             rozdil))

boxplot(data2$rozdil_out ~ data2$system)

podklady = 
  data2 %>% 
  group_by(system) %>% 
  summarise(rozsah = length(na.omit(rozdil_out)),
            sikmost = moments::skewness(rozdil_out, na.rm = T),
            spicatost = moments::kurtosis(rozdil_out, na.rm = T)-3, 
            rozptyl = var(rozdil_out, na.rm = T),
            sm_odch = sd(rozdil_out, na.rm = T),
            prumer = mean(rozdil_out, na.rm = T),
            median = quantile(rozdil_out, 0.5, na.rm = T),
            Shapiruv_Wilkuv_phodnota = shapiro.test(rozdil_out)$p.value)

# Analýza předpokladů (normalita pro každý OS)
ggplot(data2, 
       aes(x = rozdil_out))+
  geom_histogram(bins = 10)+
  facet_wrap("system", 
             ncol = 1)

ggplot(data2, 
       aes(sample = rozdil_out))+
  stat_qq()+ 
  stat_qq_line()+
  facet_wrap("system",
             scales = "free")

# Šikmost, špičatost, Shapirův-Wilkův test - viz podklady

# Analýza předpokladů -> normalita OK -> shoda rozptylů?
# Empiricky - poměr výběrových rozptylů (větší ku menšímu) < 2 ? - viz podklady

# Exaktně! Test o shodě rozptylů - F-test
# Touto strukturou se hůře hlídá "co k čemu" se vztahuje - pokud potřebuji i IO, pak rozhodně nedoporučuji
# Pokud potřebuji jen p-hodnotu, tak klidně
var.test(data2$rozdil_out~data2$system)
# lépe - kontrolovaně
var.test(data2$rozdil_out[data2$system == "WIN"], 
         data2$rozdil_out[data2$system == "Linux"])

# Analýza předpokladů -> normalita OK, shoda rozptylů OK -> Dvouvýběrový t-test

# Jelikož nemáme specifickou teorii, kterou bychom chtěli testovat,
# volíme oboustrannou alternativu. Pokud bychom takovou teorii dopředu měli, je možné
# volit i odpovídající jednostrannou alternativu (analytik si volbu alternativy musí obhájit).

# Dvouvýběrový t-test (H0: mu_W - mu_L = 0, HA: mu_W - mu_L != 0)
t.test(data2$rozdil_out[data2$system == "WIN"], 
       data2$rozdil_out[data2$system == "Linux"],
       alternative = "two.sided", 
       var.equal = TRUE, 
       conf.level = 0.95)

# Ještě bodový odhad rozdílu středních hodnot -> rozdíl výběrových průměrů - viz podklady
# a rozsahy a výběrové sm. odchylky kvůli zaokrouhlení - viz podklady

# Teď už vše jen sepsat a okomentovat.

#//////////////////////////////////////////////////////////////////
# Příklad 3 #####

# Odpovídá Příkladu 4b v prezentaci k Intervalovým odhadům (Cviceni09_skript_Int_odhady.R)

data3 = 
  data %>% 
  filter(system %in% c("WIN", "Linux"))

# Definování dichotomické proměnné
data3$hodiny_dich_2018 = ifelse(data3$odehrane_hod_2018>280, "Ano", "Ne")

# Získání potřebných četností
table(data3$system, data3$hodiny_dich_2018)
# Linux
n_L = 42+16
x_L = 42
p_L = x_L/n_L

# Windows
n_W = 132+70
x_W = 132
p_W = x_W/n_W

# Ověření předpokladů
n_L > 9/(p_L*(1-p_L))
n_W > 9/(p_W*(1-p_W))

# Test shody parametrů dvou binomických rozdělení
# (H0: pi_W = pi_L, HA: pi_W > pi_L) odpovídá (H0: pi_W - pi_L = 0, HA: pi_W - pi_L > 0)
prop.test(c(x_W, x_L), 
          c(n_W,n_L), 
          alternative = "greater", 
          conf.level = 0.85)

# Uvědomme si, že výše uvedené také odpovídá:
# (H0: pi_L = pi_W, HA: pi_L < pi_W) odpovídá (H0: pi_L - pi_W = 0, HA: pi_L - pi_W < 0)
prop.test(c(x_L, x_W), 
          c(n_L,n_W), 
          alternative = "less", 
          conf.level = 0.85)

