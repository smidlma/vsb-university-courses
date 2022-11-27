#######################################################################################
########################## Intervalové odhady #########################################
############### Martina Litschmannová, Veronika Kubíèková #############################
#######################################################################################

################## Pøiklad 1. (Žárovky) ###############################################
#######################################################################################

# Odhadujeme stø.hodnotu a smìr.odchylku životnosti žárovek
# Souèástí zadání je informace o normalitì dat

n = 16  		# rozsah souboru 
x.bar = 3000 	# hodin.... prùmìr (bodový odhad støední hodnoty)
s = 20 	# hodin.... výbìrová smìrodatná odchylka (bodový odhad sm. odchylky)
alpha = 0.1 # hladina významnosti (spolehlivost 1-alpha = 0.9)

## Oboustranný intervalový odhad støední hodnoty

x.bar-qt(1-alpha/2,n-1)*s/sqrt(n)   # dolní mez IO
x.bar+qt(1-alpha/2,n-1)*s/sqrt(n)   # horní mez IO


## Oboustranný intervalový odhad smìrodatné odchylky

sqrt( ((n-1)*s^2) / qchisq(1-alpha/2,n-1) )    # dolní mez IO
sqrt( ((n-1)*s^2) / qchisq(alpha/2,n-1) )      # horní mez IO

#Poznámky:
# n = 16, tj. smìr. odchylku zaokrouhlíme na 2 platné cifry (v našem pøípadì na jednotky)
# intervalové odhady støední hodnoty i smìr. odchylky zaokrouhlujeme na stejný øád jako smìr. odchylku
# dolní mez IO zaokrouhlujeme dolù
# horní mez IO zaokrouhlujeme nahoru

################## Pøiklad 2. (Hloubka moøe) ##########################################
#######################################################################################

# Urèujeme odhad potøebného rozsahu výbìru (poètu potøebnych mìøení)

# Pøedpokládáme normalitu dat, se známým rozpylem (dle zadání)

sigma = 20 # metrù .... známá smìrodatná odchylka
alpha = 0.05 # hladina významnosti (spolehlivost 1-alpha = 0.95)
delta = 10 # metrù ... pøípustná chyba mìøení 

# Odhad rozsahu výbìru
(qnorm(1-alpha/2,0,1)*sigma/delta)^2 


################## Pøiklad 3. (Cholesterol 1) #########################################
#######################################################################################

# Odhadujeme støední hladinu cholesterolu v séru 

# Pøedpokládáme normalitu dat (dle zadání)

n = 25  		# rozsah souboru 
x.bar = 6.3 	# mmol/l .... prùmìr (bodový odhad støední hodnoty)
s = 1.3 	# mmol/l .... výbìrová smìrodatná odchylka (bodový odhad sm. odchylky)
alpha = 0.05 # hladina významnosti (spolehlivost 1-alpha = 0.95)

## Oboustranný intervalový odhad støední hodnoty

x.bar-qt(1-alpha/2,n-1)*s/sqrt(n)   # dolní mez IO
x.bar+qt(1-alpha/2,n-1)*s/sqrt(n)   # horní mez IO


################## Pøiklad 4. (Cholesterol 2) #########################################
#######################################################################################

# Odhadujeme podíl mužù s vyšší hladinou cholesterolu v celé populaci, 
# tj. pravdìpodobnost,že náhodnì vybraný muž bude mít vyšší hladinu cholesterolu

n = 200  	# rozsah souboru 
x = 120 	# poèet "úspìchù"
p = x/n 	# relativní èetnost (bodový odhad pravdìpodobnosti)
p
alpha = 0.05 # hladina významnosti (spolehlivost 1-alpha = 0.95)

# Ovìøení pøedpokladù
n > 9/(p*(1-p))
# Dále pøedpokládáme  n < 0.05*N, tj. že N > n/0.05 (N > 20n), 
# tj. že daná populace (mladých mužù) má rozsah alespoò 20*200 = 4000 mužù, 
# což je asi vcelku reálný pøedpoklad :-)

## Oboustranný Clopperùv - Pearsonùv (exaktní) intervalový odhad parametru binomického rozdìlení
binom.test(x,n,alternative="two.sided",conf.level=0.95)

## Waldùv (asymptotický) odhad (z-statistika) - aproximace normálním rozdìlením dle CLV
p-qnorm(1-alpha/2)*sqrt( (p*(1-p)) / n )   # dolní mez IO
p+qnorm(1-alpha/2)*sqrt( (p*(1-p)) / n )       # horní mez IO

## Výpoèet 11 nejèastìji používaných intervalù spolehlivosti parametru bin. rozdìlení
## pomocí balíèku binom

install.packages("binom")
library(binom)
binom.confint(x,n)#Waldùv odhad (asymptotic), Clopperùv - Pearsonùv odhad (exact)

################## Pøiklad 5. (Hemoglobin) ############################################
#######################################################################################

## Odhadujeme støední hodnotu a smìrodatnou odchylku hemoglobinu v séru

## Naètení dat z xlsx souboru (pomoci balíèku readxl)
library(readxl)
## adresu v následujícím pøíkazu je nutno upravit dle vlastního nastavení
hem = read_excel("C:/Users/lit40/OneDrive - VSB-TUO/Vyuka/PASTA/DATA/aktualni/intervalove_odhady.xlsx",
                  sheet = "Hemoglobin")
colnames(hem)="hodnoty"

## Exploraèní analýza
boxplot(hem$hodnoty)
# Data neobsahují odlehlá pozorování.
length(hem$hodnoty)
sd(hem$hodnoty)
summary(hem$hodnoty)

# Ovìøení normality
qqnorm(hem$hodnoty)
qqline(hem$hodnoty)
hist(hem$hodnoty)

library(moments)
skewness(hem$hodnoty)
moments::kurtosis(hem$hodnoty)-3
# Šikmost i špièatost odpovídá norm. rozdìlení. Pro koneèné rozhodnutí o normalitì dat použijeme
# test normality.

# Známe-li testování hypotéz, ovìøíme pøedpoklad normality Shapirovým . Wilkovým testem.
shapiro.test(hem$hodnoty)
# Na hl. významnosti 0.05 nelze pøedpoklad normality zamítnout (p-hodnota=0.522, Shapirùv-Wilkùv test).

# 95% oboustranný intervalový odhad støední hodnoty
t.test(hem$hodnoty,alternative = "two.sided",conf.level=0.95)

## 95% oboustranný intervalový odhad smìrodatné odchylky
library(EnvStats)
varTest(hem$hodnoty,conf.level = 0.95) #95% intervalový odhad rozptylu

# Jak získat 95% intervalový odhad smìrodatné odchylky?
var_hem = varTest(hem$hodnoty,conf.level = 0.95) # výsledek f-ce varTest uložíme do pomecné promìnné
names(var_hem) # zjistíme, kde najdeme informaci o intervalovém odhadu rozptylu
sqrt(var_hem$conf.int) # využijeme toho, že sm. odchylka je odmocninou z rozptylu


################## Pøiklad 6. (Hemoglobin - odhad rozsahu výbìru) #####################
#######################################################################################

# Urèujeme odhad potøebného rozsahu výbìru (poètu novorozencù, které musíme testovat)

# Pøedpokládáme normalitu dat, bez tohoto pøedpokladu je pøíklad neøešitelný

sigma = sqrt(46) # g/l .... známá smìrodatná odchylka
alpha = 0.05 # hladina významnosti (spolehlivost 1-alpha = 0.95)
delta = 1 # g/l ... pøípustná chyba mìøení 

# Odhad rozsahu výbìru
(qnorm(1-alpha/2)*sigma/delta)^2 

################## Pøiklad 7. (Poškození tkánì slinivky bøišní) #######################
#######################################################################################

# Odhadujeme støední poškození tkánì pro pro dvì skupiny pacientù (podle zpùsobu ochlazování tkánì)
# a rozdíl støedních poškození tkánì pro tyto dvì skupiny pacientù

## Naètení dat z xlsx souboru (pomoci balíèku readxl)
library(readxl)
## adresu v následujícím pøíkazu je nutno upravit dle vlastního nastavení
slinivka = read_excel("C:/Users/lit40/OneDrive - VSB-TUO/Vyuka/PASTA/DATA/aktualni/intervalove_odhady.xlsx",
                 sheet = "Slinivka")   
colnames(slinivka) = c("sk1","sk2")

## Pøevod dat do standardního datového formátu
library(tidyr)
slinivka.s = pivot_longer(slinivka,
                          cols = 1:2,
                          values_to = "hodnoty",
                          names_to = "skupina")

slinivka.s = na.omit(slinivka.s)

## Exploraèní analýza
boxplot(slinivka.s$hodnoty~slinivka.s$skupina)
# Data neobsahují odlehlá pozorování.

library(dplyr)
slinivka.s %>% 
  group_by(skupina) %>% 
  summarise(n = length(na.omit(hodnoty)),
            sm.odch. = sd(hodnoty),
            prumer = mean(hodnoty),
            median = median(hodnoty))



# Ovìøení normality
qqnorm(slinivka$sk1)
qqline(slinivka$sk1)

hist(slinivka$sk1)
# zvažte, popø. si vyzkoušejte, jak zhotovit graf pøímo pomoci datové matice slinivka.s

qqnorm(slinivka$sk2)
qqline(slinivka$sk2)

hist(slinivka$sk2)

library(moments)
tapply(slinivka.s$hodnoty,slinivka.s$skupina,skewness,na.rm=TRUE)
tapply(slinivka.s$hodnoty,slinivka.s$skupina,moments::kurtosis,na.rm=TRUE)-3

# Šikmost i špièatost odpovídá norm. rozdìlení. Pro koneèné rozhodnutí o normalitì dat použijeme
# test normality.

# Známe-li testování hypotéz, ovìøíme pøedpoklad normality Shapirovým - Wilkovým testem.
library(dlookr)
slinivka.s %>% 
  group_by(skupina) %>% 
  normality(hodnoty)

# Na hl. významnosti 0.05 nelze pøedpoklad normality zamítnout (p-hodnota1=0.839, p-hodnota2=0.137,
# Shapirùv-Wilkùv test).

# 95% oboustranné intervalové odhady støedních poškození tkánì pro jednotlivé skupiny
t.test(slinivka$sk1,conf.level=0.95)
t.test(slinivka$sk2,conf.level=0.95)

# 95% oboustranný intervalový odhad rozdílu støedních poškození tkánì daných skupin pacientù
t.test(slinivka.s$hodnoty~slinivka.s$skupina,conf.level=0.95,var.equal = F) # Pozor na nutnost kontrolovat jak je rozdíl definován!
# nebo
t.test(slinivka$sk1,slinivka$sk2,var.equal = F,conf.level=0.95)
