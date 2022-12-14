#######################################################################################
########################## Intervalov? odhady #########################################
############### Martina Litschmannov?, Veronika Kub??kov? #############################
#######################################################################################

################## P?iklad 1. (??rovky) ###############################################
#######################################################################################

# Odhadujeme st?.hodnotu a sm?r.odchylku ?ivotnosti ??rovek
# Sou??st? zad?n? je informace o normalit? dat

n = 16  		# rozsah souboru 
x.bar = 3000 	# hodin.... pr?m?r (bodov? odhad st?edn? hodnoty)
s = 20 	# hodin.... v?b?rov? sm?rodatn? odchylka (bodov? odhad sm. odchylky)
alpha = 0.1 # hladina v?znamnosti (spolehlivost 1-alpha = 0.9)

## Oboustrann? intervalov? odhad st?edn? hodnoty

x.bar-qt(1-alpha/2,n-1)*s/sqrt(n)   # doln? mez IO
x.bar+qt(1-alpha/2,n-1)*s/sqrt(n)   # horn? mez IO


## Oboustrann? intervalov? odhad sm?rodatn? odchylky

sqrt( ((n-1)*s^2) / qchisq(1-alpha/2,n-1) )    # doln? mez IO
sqrt( ((n-1)*s^2) / qchisq(alpha/2,n-1) )      # horn? mez IO

#Pozn?mky:
# n = 16, tj. sm?r. odchylku zaokrouhl?me na 2 platn? cifry (v na?em p??pad? na jednotky)
# intervalov? odhady st?edn? hodnoty i sm?r. odchylky zaokrouhlujeme na stejn? ??d jako sm?r. odchylku
# doln? mez IO zaokrouhlujeme dol?
# horn? mez IO zaokrouhlujeme nahoru

################## P?iklad 2. (Hloubka mo?e) ##########################################
#######################################################################################

# Ur?ujeme odhad pot?ebn?ho rozsahu v?b?ru (po?tu pot?ebnych m??en?)

# P?edpokl?d?me normalitu dat, se zn?m?m rozpylem (dle zad?n?)

sigma = 20 # metr? .... zn?m? sm?rodatn? odchylka
alpha = 0.05 # hladina v?znamnosti (spolehlivost 1-alpha = 0.95)
delta = 10 # metr? ... p??pustn? chyba m??en? 

# Odhad rozsahu v?b?ru
(qnorm(1-alpha/2,0,1)*sigma/delta)^2 


################## P?iklad 3. (Cholesterol 1) #########################################
#######################################################################################

# Odhadujeme st?edn? hladinu cholesterolu v s?ru 

# P?edpokl?d?me normalitu dat (dle zad?n?)

n = 25  		# rozsah souboru 
x.bar = 6.3 	# mmol/l .... pr?m?r (bodov? odhad st?edn? hodnoty)
s = 1.3 	# mmol/l .... v?b?rov? sm?rodatn? odchylka (bodov? odhad sm. odchylky)
alpha = 0.05 # hladina v?znamnosti (spolehlivost 1-alpha = 0.95)

## Oboustrann? intervalov? odhad st?edn? hodnoty

x.bar-qt(1-alpha/2,n-1)*s/sqrt(n)   # doln? mez IO
x.bar+qt(1-alpha/2,n-1)*s/sqrt(n)   # horn? mez IO


################## P?iklad 4. (Cholesterol 2) #########################################
#######################################################################################

# Odhadujeme pod?l mu?? s vy??? hladinou cholesterolu v cel? populaci, 
# tj. pravd?podobnost,?e n?hodn? vybran? mu? bude m?t vy??? hladinu cholesterolu

n = 200  	# rozsah souboru 
x = 120 	# po?et "?sp?ch?"
p = x/n 	# relativn? ?etnost (bodov? odhad pravd?podobnosti)
p
alpha = 0.05 # hladina v?znamnosti (spolehlivost 1-alpha = 0.95)

# Ov??en? p?edpoklad?
n > 9/(p*(1-p))
# D?le p?edpokl?d?me  n < 0.05*N, tj. ?e N > n/0.05 (N > 20n), 
# tj. ?e dan? populace (mlad?ch mu??) m? rozsah alespo? 20*200 = 4000 mu??, 
# co? je asi vcelku re?ln? p?edpoklad :-)

## Oboustrann? Clopper?v - Pearson?v (exaktn?) intervalov? odhad parametru binomick?ho rozd?len?
binom.test(x,n,alternative="two.sided",conf.level=0.95)

## Wald?v (asymptotick?) odhad (z-statistika) - aproximace norm?ln?m rozd?len?m dle CLV
p-qnorm(1-alpha/2)*sqrt( (p*(1-p)) / n )   # doln? mez IO
p+qnorm(1-alpha/2)*sqrt( (p*(1-p)) / n )       # horn? mez IO

## V?po?et 11 nej?ast?ji pou??van?ch interval? spolehlivosti parametru bin. rozd?len?
## pomoc? bal??ku binom

install.packages("binom")
library(binom)
binom.confint(x,n)#Wald?v odhad (asymptotic), Clopper?v - Pearson?v odhad (exact)

################## P?iklad 5. (Hemoglobin) ############################################
#######################################################################################

## Odhadujeme st?edn? hodnotu a sm?rodatnou odchylku hemoglobinu v s?ru

## Na?ten? dat z xlsx souboru (pomoci bal??ku readxl)
library(readxl)
## adresu v n?sleduj?c?m p??kazu je nutno upravit dle vlastn?ho nastaven?
hem = read_excel("C:/Users/lit40/OneDrive - VSB-TUO/Vyuka/PASTA/DATA/aktualni/intervalove_odhady.xlsx",
                  sheet = "Hemoglobin")
colnames(hem)="hodnoty"

## Explora?n? anal?za
boxplot(hem$hodnoty)
# Data neobsahuj? odlehl? pozorov?n?.
length(hem$hodnoty)
sd(hem$hodnoty)
summary(hem$hodnoty)

# Ov??en? normality
qqnorm(hem$hodnoty)
qqline(hem$hodnoty)
hist(hem$hodnoty)

library(moments)
skewness(hem$hodnoty)
moments::kurtosis(hem$hodnoty)-3
# ?ikmost i ?pi?atost odpov?d? norm. rozd?len?. Pro kone?n? rozhodnut? o normalit? dat pou?ijeme
# test normality.

# Zn?me-li testov?n? hypot?z, ov???me p?edpoklad normality Shapirov?m . Wilkov?m testem.
shapiro.test(hem$hodnoty)
# Na hl. v?znamnosti 0.05 nelze p?edpoklad normality zam?tnout (p-hodnota=0.522, Shapir?v-Wilk?v test).

# 95% oboustrann? intervalov? odhad st?edn? hodnoty
t.test(hem$hodnoty,alternative = "two.sided",conf.level=0.95)

## 95% oboustrann? intervalov? odhad sm?rodatn? odchylky
library(EnvStats)
varTest(hem$hodnoty,conf.level = 0.95) #95% intervalov? odhad rozptylu

# Jak z?skat 95% intervalov? odhad sm?rodatn? odchylky?
var_hem = varTest(hem$hodnoty,conf.level = 0.95) # v?sledek f-ce varTest ulo??me do pomecn? prom?nn?
names(var_hem) # zjist?me, kde najdeme informaci o intervalov?m odhadu rozptylu
sqrt(var_hem$conf.int) # vyu?ijeme toho, ?e sm. odchylka je odmocninou z rozptylu


################## P?iklad 6. (Hemoglobin - odhad rozsahu v?b?ru) #####################
#######################################################################################

# Ur?ujeme odhad pot?ebn?ho rozsahu v?b?ru (po?tu novorozenc?, kter? mus?me testovat)

# P?edpokl?d?me normalitu dat, bez tohoto p?edpokladu je p??klad ne?e?iteln?

sigma = sqrt(46) # g/l .... zn?m? sm?rodatn? odchylka
alpha = 0.05 # hladina v?znamnosti (spolehlivost 1-alpha = 0.95)
delta = 1 # g/l ... p??pustn? chyba m??en? 

# Odhad rozsahu v?b?ru
(qnorm(1-alpha/2)*sigma/delta)^2 

################## P?iklad 7. (Po?kozen? tk?n? slinivky b?i?n?) #######################
#######################################################################################

# Odhadujeme st?edn? po?kozen? tk?n? pro pro dv? skupiny pacient? (podle zp?sobu ochlazov?n? tk?n?)
# a rozd?l st?edn?ch po?kozen? tk?n? pro tyto dv? skupiny pacient?

## Na?ten? dat z xlsx souboru (pomoci bal??ku readxl)
library(readxl)
## adresu v n?sleduj?c?m p??kazu je nutno upravit dle vlastn?ho nastaven?
slinivka = read_excel("C:/Users/lit40/OneDrive - VSB-TUO/Vyuka/PASTA/DATA/aktualni/intervalove_odhady.xlsx",
                 sheet = "Slinivka")   
colnames(slinivka) = c("sk1","sk2")

## P?evod dat do standardn?ho datov?ho form?tu
library(tidyr)
slinivka.s = pivot_longer(slinivka,
                          cols = 1:2,
                          values_to = "hodnoty",
                          names_to = "skupina")

slinivka.s = na.omit(slinivka.s)

## Explora?n? anal?za
boxplot(slinivka.s$hodnoty~slinivka.s$skupina)
# Data neobsahuj? odlehl? pozorov?n?.

library(dplyr)
slinivka.s %>% 
  group_by(skupina) %>% 
  summarise(n = length(na.omit(hodnoty)),
            sm.odch. = sd(hodnoty),
            prumer = mean(hodnoty),
            median = median(hodnoty))



# Ov??en? normality
qqnorm(slinivka$sk1)
qqline(slinivka$sk1)

hist(slinivka$sk1)
# zva?te, pop?. si vyzkou?ejte, jak zhotovit graf p??mo pomoci datov? matice slinivka.s

qqnorm(slinivka$sk2)
qqline(slinivka$sk2)

hist(slinivka$sk2)

library(moments)
tapply(slinivka.s$hodnoty,slinivka.s$skupina,skewness,na.rm=TRUE)
tapply(slinivka.s$hodnoty,slinivka.s$skupina,moments::kurtosis,na.rm=TRUE)-3

# ?ikmost i ?pi?atost odpov?d? norm. rozd?len?. Pro kone?n? rozhodnut? o normalit? dat pou?ijeme
# test normality.

# Zn?me-li testov?n? hypot?z, ov???me p?edpoklad normality Shapirov?m - Wilkov?m testem.
library(dlookr)
slinivka.s %>% 
  group_by(skupina) %>% 
  normality(hodnoty)

# Na hl. v?znamnosti 0.05 nelze p?edpoklad normality zam?tnout (p-hodnota1=0.839, p-hodnota2=0.137,
# Shapir?v-Wilk?v test).

# 95% oboustrann? intervalov? odhady st?edn?ch po?kozen? tk?n? pro jednotliv? skupiny
t.test(slinivka$sk1,conf.level=0.95)
t.test(slinivka$sk2,conf.level=0.95)

# 95% oboustrann? intervalov? odhad rozd?lu st?edn?ch po?kozen? tk?n? dan?ch skupin pacient?
t.test(slinivka.s$hodnoty~slinivka.s$skupina,conf.level=0.95,var.equal = F) # Pozor na nutnost kontrolovat jak je rozd?l definov?n!
# nebo
t.test(slinivka$sk1,slinivka$sk2,var.equal = F,conf.level=0.95)
