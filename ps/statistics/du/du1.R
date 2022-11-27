library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggpubr)
library(moments)
library(rstatix)
library(lawstat)

# Import dat
data = read_excel("data_du1.xlsx")  # Uprav soubor, příp. cestu k souboru


# 8. Tabulka se sumárními charakteristikami (kvant. proměnná tříděná dle kategoriální) ####

# V každém řádku s "odehrane_hod_2018" je nutné upravit název proměnné,
# na.rm = T je preventivní parametr, který přeskočí prázdné buňky,
# hodí se, pokud počítáme charakteristiky pro proměnnou, kde byla odstraněna odlehlá pozorování.
moje_tab2=
  data %>%
  group_by(manufacturer) %>%  # uprav
  summarise(rozsah = length(na.omit(decrease)),
            minimum = min(decrease, na.rm=T),
            Q1 = quantile(decrease, 0.25, na.rm=T),
            prumer = mean(decrease, na.rm=T),
            median = median(decrease, na.rm=T),
            Q3 = quantile(decrease, 0.75, na.rm=T),
            maximum = max(decrease, na.rm=T),
            rozptyl = var(decrease, na.rm=T),
            smerodatna_odchylka = sd(decrease,na.rm=T),
            variacni_koeficient = (100*(smerodatna_odchylka/abs(prumer))), 
            sikmost = (moments::skewness(decrease, na.rm=T)),
            stand_spicatost = (moments::kurtosis(decrease, na.rm=T)-3),
            dolni_mez_hradeb = Q1-1.5*(Q3-Q1),
            horni_mez_hradeb = Q3+1.5*(Q3-Q1))

t(moje_tab2) # Vše je potřeba zaokrouhlit dle norem!


# 2. Vícenásobný krabicový graf (kvant. proměnná tříděná dle kategoriální) ####

ggplot(data, # uprav
       aes(x = manufacturer, # uprav
           y = decrease))+ # uprav
  stat_boxplot(geom = "errorbar",
               width = 0.15)+
  geom_boxplot()+
  labs(x = "", y = "Pokles světelného toku (lm)")+ # uprav
  theme_classic(base_size = 16)+
  theme(axis.text = element_text(color = "black", size = 16))


outliers = 
  data %>% # uprav nazev dat
  group_by(manufacturer) %>% # uprav nazev promenne
  identify_outliers(decrease)  # uprav nazev promenne

data = data %>%  # uprav nazev dat
  mutate(pokles_out = # uprav nazev nove promenne
           ifelse(ID %in% outliers$ID,  # uprav IDhrace
                  NA, 
                  decrease)) # uprav nazev promenne


# 2. Vícenásobný krabicový graf (kvant. proměnná tříděná dle kategoriální) ####

ggplot(data, # uprav
       aes(x = manufacturer, # uprav
           y = pokles_out))+ # uprav
  stat_boxplot(geom = "errorbar",
               width = 0.15)+
  geom_boxplot()+
  labs(x = "", y = "Pokles světelného toku (lm)")+ # uprav
  theme_classic(base_size = 16)+
  theme(axis.text = element_text(color = "black", size = 16))


moje_tab2=
  data %>%
  group_by(manufacturer) %>%  # uprav
  summarise(rozsah = length(na.omit(pokles_out)),
            minimum = min(pokles_out, na.rm=T),
            Q1 = quantile(pokles_out, 0.25, na.rm=T),
            prumer = mean(pokles_out, na.rm=T),
            median = median(pokles_out, na.rm=T),
            Q3 = quantile(pokles_out, 0.75, na.rm=T),
            maximum = max(pokles_out, na.rm=T),
            rozptyl = var(pokles_out, na.rm=T),
            smerodatna_odchylka = sd(pokles_out,na.rm=T),
            variacni_koeficient = (100*(smerodatna_odchylka/abs(prumer))), 
            sikmost = (moments::skewness(pokles_out, na.rm=T)),
            stand_spicatost = (moments::kurtosis(pokles_out, na.rm=T)-3),
            dolni_mez_hradeb = Q1-1.5*(Q3-Q1),
            horni_mez_hradeb = Q3+1.5*(Q3-Q1))

t(moje_tab2) # Vše je potřeba zaokrouhlit dle norem!


# 6. Sada QQ-grafů (kvant. proměnná tříděná dle kategoriální) ####

ggplot(data, # uprav
       aes(sample = pokles_out))+ # uprav
  stat_qq()+
  stat_qq_line()+
  labs(x = "Teoretické normované kvantily", y = "Výběrové kvantily")+
  theme_classic(base_size = 16)+
  theme(axis.text = element_text(color = "black", size = 16))+
  facet_wrap("manufacturer", # uprav
             ncol = 3, # uprav
             scales = "free")

# 4. Sada histogramů (kvant. proměnná tříděná dle kategoriální) ####

ggplot(data, # uprav
       aes(x = pokles_out))+ # uprav
  geom_histogram(binwidth = 0.8, # uprav
                 color = "black",
                 fill = "grey55")+
  labs(x = "Pokles světelného toku (lm)", # uprav
       y = "Četnost")+ 
  theme_classic(base_size = 16)+
  theme(axis.text = element_text(color = "black", size = 16))+
  facet_wrap("manufacturer",  # uprav
             dir = "v")

options(OutDec = ",")

0.609375 - 2 * 2.932669
0.609375 + 2 * 2.932669

1.255556 - 2 * 3.862091
1.255556 + 2 * 3.862091

348.6 - 2 *10.3


data %>% 
  group_by(manufacturer) %>% 
  summarise(rozsah = length(na.omit(pokles_out)),
            sikmost = moments::skewness(pokles_out, na.rm = T),
            spicatost = moments::kurtosis(pokles_out, na.rm = T)-3, 
            rozptyl = var(pokles_out, na.rm = T),
            sm_odch = sd(pokles_out, na.rm = T),
            prumer = mean(pokles_out, na.rm = T),
            median = quantile(pokles_out, 0.5, na.rm = T),
            Shapiruv_Wilkuv_phodnota = shapiro.test(pokles_out)$p.value,
            Symetrie_phodnota = symmetry.test(pokles_out, boot = FALSE)$p.value,
            )

data1 = data %>% 
  filter(manufacturer == "Amber")


data2 = data %>% 
  filter(manufacturer == "Bright")
#symmetry.test(data1$pokles_out, boot = FALSE)

#Amber test
#wilcox.test(data1$pokles_out, mu = 0.4, alternative = "two.sided", conf.level = 0.95, conf.int = TRUE)
#Bright test
#wilcox.test(data2$pokles_out, mu = 0.8, alternative = "two.sided", conf.level = 0.95, conf.int = TRUE)

tapply(data$pokles_out, data$manufacturer, wilcox.test, mu = 0, alternative = "greater", conf.level = 0.95, conf.int = T)

quantile(data2$pokles_out, 0.5, na.rm = T) - quantile(data1$pokles_out, 0.5, na.rm = T)

wilcox.test(data$pokles_out[data$manufacturer=="Bright"], 
            data$pokles_out[data$manufacturer=="Amber"], 
            alternative = "greater", 
            conf.level = 0.95,
            conf.int = T)
