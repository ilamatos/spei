#####################################################################################
#       RCODE TO CALCULATE SPEI AND SEASONALITY INDEX FOR A GIVEN STUDY AREA        #
#####################################################################################

# Load packages ---------------------
#library(remotes)
#remotes::install_github("mikejohnson51/AOI")
library(SPEI)
library(tidyverse)
library(lubridate)
library(ggpubr)
library(ggpmisc)
library(climateR)
library(sf)
library(rnaturalearth)

# Download TerraClimate data ---------

# coordinates of study area (Konza)
site_coord <- data.frame(name = "Konza", 
                         lon = -96.613075, 
                         lat = 39.103784)

# convert coordinates dataframe to a sf object
site_sf <- sf::st_as_sf(site_coord, 
                        coords = c("lon", "lat"),
                        crs = 4269) 

# plot point (site coordinates) in the global map
world <- rnaturalearth::ne_countries(scale = "small",
                                     returnclass = "sf") 
ggplot() +
  geom_sf(data = world,
          mapping = aes(geometry = geometry),
          fill = "white") +
  geom_sf(data = site_sf,
          aes(geometry = geometry),
          size = 1,
          color = "red") +
  theme_bw()

ggsave("Figures/globalmap.png", dpi = 300, width = 10, height = 6, units = "cm")


# download water climate data for the study site

dt_Konza <- getTerraClim(AOI = site_sf, #Konza prairie coordinates
                      varname = c("ppt","pet"), # variables to be downloaded 
                      # ppt = monthly precipitation
                      # pet = monthly evapotranspiration
                      startDate = "1959-01-01", # start date
                      endDate  = "2023-12-31") # end date

# this may take a while to download.
# alternatively, read the data already downloaded

dt_Konza <- read_csv("data/terraclimate_konza.csv")
glimpse(dt_Konza)

# add year and 
dt <- dt_Konza %>% mutate(date = parse_date_time(date, 'ymd')) %>% 
  mutate(year=year(date), month=month(date))%>%
  mutate( pet=pet*0.1, pr = pr)%>% #adjust variable scales (https://code.earthengine.google.com/dataset/IDAHO_EPSCOR/TERRACLIMATE)
  select(date,year,month,pet,pr) 
glimpse(dt)

# create pr_drought column to store precipitation for drought plot

# half the precipitation for the experimental years (2018-2023)
dt2<-dt%>% mutate(pr_drought = ifelse(year == 2018 | year == 2019 | year == 2020 |
                                         year == 2021 | year == 2022 | year == 2023, pr/2, pr))

# correct precipitation for Feb and March months
dt2[710,6]<-18.1 # Feb 2018
dt2[711,6]<-38.5 # Mar 2018
dt2[722,6]<-35.3 # Feb 2019
dt2[723,6]<-83.8 # Mar 2019
dt2[734,6]<-18.8 # Feb 2020
dt2[735,6]<-58.6 # Mar 2020
dt2[746,6]<-8.2 # Feb 2021
dt2[747,6]<-91.6 # Mar 2021
dt2[758,6]<-7.6 # Feb 2022
dt2[759,6]<-57.7 # Mar 2022
dt2[770,6]<-27.7 # Feb 2023
dt2[771,6]<-33.2 # Mar 2023

# calculate SPEI --------------

# compute difference precipitation (pr) minus evapotranspiration (pet)

glimpse(dt2)
dt2$bal <- dt2$pr - dt2$pet # control plots
dt2$bald <- dt2$pr_drought - dt2$pet # drought plots

# convert data to a time series
dt_ts<- ts(dt2[,-c(1,2)],start= c(1959,1),end= c(2023, 12), frequency=12)
glimpse(dt_ts)

# calculate 12-months SPEI
spei12c <- spei(dt_ts[,"bal"],12) #control plots
spei12d <- spei(dt_ts[,"bald"],12) #drought


# Plot SPEI -------------------------

# 12-months SPEI control ------

# historical plot 1959-2023
dtc <- spei12c$fitted
kk <- as.data.frame(dtc)
kk$time <- as.character(time(dtc))
kk <- melt(kk, id.vars = "time")
kk$time <- as.numeric(kk$time)
kk$na <- as.numeric(ifelse(is.na(kk$x), 0, NA))
kk$cat <- ifelse(kk$x > 0, "neg", "pos")

p1<-ggplot(kk, aes(.data[["time"]], .data[["x"]],
                    fill = cat,
                    color = cat))+
  geom_bar(stat = "identity")+  
      scale_fill_manual(values=c('blue','red')) +  # classic SPEI look
      scale_color_manual(values=c('blue','red')) + # classic SPEI look
  #scale_fill_manual(values = c("cyan3", "tomato")) + # new look
  #scale_color_manual(values = c("cyan3", "tomato"))+ # new look
  geom_hline(yintercept = 0, color = "black")+
  theme_bw()+
  scale_y_continuous(limits = c(-3, 4), breaks = c(-3, -2.5, -2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4))+
  ylab("12-months SPEI control") +
  xlab("Time") +
  theme(
    legend.position = "none",
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0));p1

# experimental years 2019-2022 ----------

ee<-window(spei12c$fitted, start = c(2018,1), end=c(2023,12))
eec<-as.data.frame(ee)%>%mutate(year = rep(2018:2023, each=12), time = rep(1:12, times = 6))
glimpse(eec)

## 2018 
d18<-eec%>%filter(year == "2018")
d18$cat <- ifelse(d18$x > 0, "neg", "pos")

p2<-ggplot(data = d18, aes(x=time, y=x,  fill = cat, color = cat))+
  geom_bar (stat="identity") +
  theme_bw()+
  #ylim(c(-3.5,3.5))+
  scale_fill_manual(values=c('blue','red')) +  # classic SPEI look
  scale_color_manual(values=c('blue','red')) + # classic SPEI look
  geom_hline(yintercept = 0, color = "black")+
  scale_y_continuous(limits = c(-3,3), breaks = c(-3, -2, -1, 0, 1, 2, 3))+
  scale_x_continuous(limits = c(0,13), breaks = seq(0, 13, by = 1), labels = c("", "J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D", ""))+
  xlab("2018")+ ylab ("SPEI control")+
  theme(
    legend.position = "none",
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0)); p2

## 2019 
d19<-eec%>%filter(year == "2019")
d19$cat <- ifelse(d19$x > 0, "neg", "pos")

p3<-ggplot(data = d19, aes(x=time, y=x,  fill = cat, color = cat))+
  geom_bar (stat="identity") +
  theme_bw()+
  #ylim(c(-3.5,3.5))+
  scale_fill_manual(values=c('blue','red')) +  # classic SPEI look
  scale_color_manual(values=c('blue','red')) + # classic SPEI look
  geom_hline(yintercept = 0, color = "black")+
  scale_y_continuous(limits = c(-3,3), breaks = c(-3, -2, -1, 0, 1, 2, 3))+
  scale_x_continuous(limits = c(0,13), breaks = seq(0, 13, by = 1), labels = c("", "J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D", ""))+
  xlab("2019")+ ylab ("SPEI control")+
  theme(
    legend.position = "none",
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0)); p3

## 2020
d20<-eec%>%filter(year == "2020")
d20$cat <- ifelse(d20$x > 0, "neg", "pos")

p4<-ggplot(data = d20, aes(x=time, y=x,  fill = cat, color = cat))+
  geom_bar (stat="identity") +
  theme_bw()+
  #ylim(c(-3.5,3.5))+
  scale_fill_manual(values=c('blue','red')) +  # classic SPEI look
  scale_color_manual(values=c('blue','red')) + # classic SPEI look
  geom_hline(yintercept = 0, color = "black")+
  scale_y_continuous(limits = c(-3,3), breaks = c(-3, -2, -1, 0, 1, 2, 3))+
  scale_x_continuous(limits = c(0,13), breaks = seq(0, 13, by = 1), labels = c("", "J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D", ""))+
  xlab("2020")+ ylab ("SPEI control")+
  theme(
    legend.position = "none",
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0)); p4

## 2021
d21<-eec%>%filter(year == "2021")
d21$cat <- ifelse(d21$x > 0, "neg", "pos")

p5<-ggplot(data = d21, aes(x=time, y=x,  fill = cat, color = cat))+
  geom_bar (stat="identity") +
  theme_bw()+
  #ylim(c(-3.5,3.5))+
  scale_fill_manual(values=c('red','blue')) +  # classic SPEI look
  scale_color_manual(values=c('red','blue')) + # classic SPEI look
  geom_hline(yintercept = 0, color = "black")+
  scale_y_continuous(limits = c(-3,3), breaks = c(-3, -2, -1, 0, 1, 2, 3))+
  scale_x_continuous(limits = c(0,13), breaks = seq(0, 13, by = 1), labels = c("", "J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D", ""))+
  xlab("2021")+ ylab ("SPEI control")+
  theme(
    legend.position = "none",
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0)); p5

## 2022
d22<-eec%>%filter(year == "2022")
d22$cat <- ifelse(d22$x > 0, "neg", "pos")

p6<-ggplot(data = d22, aes(x=time, y=x,  fill = cat, color = cat))+
  geom_bar (stat="identity") +
  theme_bw()+
  #ylim(c(-3.5,3.5))+
  scale_fill_manual(values=c('red','blue')) +  # classic SPEI look
  scale_color_manual(values=c('red','blue')) + # classic SPEI look
  geom_hline(yintercept = 0, color = "black")+
  scale_y_continuous(limits = c(-3,3), breaks = c(-3, -2, -1, 0, 1, 2, 3))+
  scale_x_continuous(limits = c(0,13), breaks = seq(0, 13, by = 1), labels = c("", "J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D", ""))+
  xlab("2022")+ ylab ("SPEI control")+
  theme(
    legend.position = "none",
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0)); p6

## 2023
d23<-eec%>%filter(year == "2023")
d23$cat <- ifelse(d23$x > 0, "neg", "pos")

p7<-ggplot(data = d23, aes(x=time, y=x,  fill = cat, color = cat))+
  geom_bar (stat="identity") +
  theme_bw()+
  #ylim(c(-3.5,3.5))+
  scale_fill_manual(values=c('red','blue')) +  # classic SPEI look
  scale_color_manual(values=c('red','blue')) + # classic SPEI look
  geom_hline(yintercept = 0, color = "black")+
  scale_y_continuous(limits = c(-3,3), breaks = c(-3, -2, -1, 0, 1, 2, 3))+
  scale_x_continuous(limits = c(0,13), breaks = seq(0, 13, by = 1), labels = c("", "J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D", ""))+
  xlab("2023")+ ylab ("SPEI control")+
  theme(
    legend.position = "none",
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0)); p7

# 12-months SPEI drought ------

# historical plot 1959-2023
dtc <- spei12d$fitted
kk <- as.data.frame(dtc)
kk$time <- as.character(time(dtc))
kk <- melt(kk, id.vars = "time")
kk$time <- as.numeric(kk$time)
kk$na <- as.numeric(ifelse(is.na(kk$x), 0, NA))
kk$cat <- ifelse(kk$x > 0, "neg", "pos")

p8<-ggplot(kk, aes(.data[["time"]], .data[["x"]],
               fill = cat,
               color = cat))+
  geom_bar(stat = "identity")+  
  scale_fill_manual(values=c('blue','red')) +  # classic SPEI look
  scale_color_manual(values=c('blue','red')) + # classic SPEI look
  #scale_fill_manual(values = c("cyan3", "tomato")) + # new look
  #scale_color_manual(values = c("cyan3", "tomato"))+ # new look
  geom_hline(yintercept = 0, color = "black")+
  theme_bw()+
  #ylim(c(-3.5,4))+
  scale_y_continuous(limits = c(-3, 4), breaks = c(-3, -2.5, -2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4))+
  ylab("12-months SPEI drought") +
  xlab("Time") +
  theme(
    legend.position = "none",
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0));p8

# experimental years 2019-2022 ----------

ee<-window(spei12d$fitted, start = c(2018,1), end=c(2023,12))
eec<-as.data.frame(ee)%>%mutate(year = rep(2018:2023, each=12), time = rep(1:12, times = 6))
glimpse(eec)

## 2018
d18<-eec%>%filter(year == "2018")
d18$cat <- ifelse(d18$x > 0, "neg", "pos")

p9<-ggplot(data = d18, aes(x=time, y=x,  fill = cat, color = cat))+
  geom_bar (stat="identity") +
  theme_bw()+
  #ylim(c(-3.5,3.5))+
  scale_fill_manual(values=c('blue','red')) +  # classic SPEI look
  scale_color_manual(values=c('blue','red')) + # classic SPEI look
  geom_hline(yintercept = 0, color = "black")+
  scale_y_continuous(limits = c(-3,3), breaks = c(-3, -2, -1, 0, 1, 2, 3))+
  scale_x_continuous(limits = c(0,13), breaks = seq(0, 13, by = 1), labels = c("", "J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D", ""))+
  xlab("2018")+ ylab ("SPEI drought")+
  theme(
    legend.position = "none",
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0)); p9

## 2019 
d19<-eec%>%filter(year == "2019")
d19$cat <- ifelse(d19$x > 0, "neg", "pos")

p10<-ggplot(data = d19, aes(x=time, y=x,  fill = cat, color = cat))+
  geom_bar (stat="identity") +
  theme_bw()+
  #ylim(c(-3.5,3.5))+
  scale_fill_manual(values=c('blue','red')) +  # classic SPEI look
  scale_color_manual(values=c('blue','red')) + # classic SPEI look
  geom_hline(yintercept = 0, color = "black")+
  scale_y_continuous(limits = c(-3,3), breaks = c(-3, -2, -1, 0, 1, 2, 3))+
  scale_x_continuous(limits = c(0,13), breaks = seq(0, 13, by = 1), labels = c("", "J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D", ""))+
  xlab("2019")+ ylab ("SPEI drought")+
  theme(
    legend.position = "none",
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0)); p10

## 2020
d20<-eec%>%filter(year == "2020")
d20$cat <- ifelse(d20$x > 0, "neg", "pos")

p11<-ggplot(data = d20, aes(x=time, y=x,  fill = cat, color = cat))+
  geom_bar (stat="identity") +
  theme_bw()+
  #ylim(c(-3.5,3.5))+
  scale_fill_manual(values=c('red','blue')) +  # classic SPEI look
  scale_color_manual(values=c('red','blue')) + # classic SPEI look
  geom_hline(yintercept = 0, color = "black")+
  scale_y_continuous(limits = c(-3,3), breaks = c(-3, -2, -1, 0, 1, 2, 3))+
  scale_x_continuous(limits = c(0,13), breaks = seq(0, 13, by = 1), labels = c("", "J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D", ""))+
  xlab("2020")+ ylab ("SPEI drought")+
  theme(
    legend.position = "none",
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0)); p11
## 2021
d21<-eec%>%filter(year == "2021")
d21$cat <- ifelse(d21$x > 0, "neg", "pos")

p12<-ggplot(data = d21, aes(x=time, y=x,  fill = cat, color = cat))+
  geom_bar (stat="identity") +
  theme_bw()+
  #ylim(c(-3.5,3.5))+
  scale_fill_manual(values=c('red','blue')) +  # classic SPEI look
  scale_color_manual(values=c('red','blue')) + # classic SPEI look
  geom_hline(yintercept = 0, color = "black")+
  scale_y_continuous(limits = c(-3,3), breaks = c(-3, -2, -1, 0, 1, 2, 3))+
  scale_x_continuous(limits = c(0,13), breaks = seq(0, 13, by = 1), labels = c("", "J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D", ""))+
  xlab("2021")+ ylab ("SPEI drought")+
  theme(
    legend.position = "none",
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0)); p12

## 2022
d22<-eec%>%filter(year == "2022")
d22$cat <- ifelse(d22$x > 0, "neg", "pos")

p13<-ggplot(data = d22, aes(x=time, y=x,  fill = cat, color = cat))+
  geom_bar (stat="identity") +
  theme_bw()+
  #ylim(c(-3.5,3.5))+
  scale_fill_manual(values=c('red','blue')) +  # classic SPEI look
  scale_color_manual(values=c('red','blue')) + # classic SPEI look
  geom_hline(yintercept = 0, color = "black")+
  scale_y_continuous(limits = c(-3,3), breaks = c(-3, -2, -1, 0, 1, 2, 3))+
  scale_x_continuous(limits = c(0,13), breaks = seq(0, 13, by = 1), labels = c("", "J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D", ""))+
  xlab("2022")+ ylab ("SPEI drought")+
  theme(
    legend.position = "none",
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0)); p13

## 2023
d23<-eec%>%filter(year == "2023")
d23$cat <- ifelse(d23$x > 0, "neg", "pos")

p14<-ggplot(data = d23, aes(x=time, y=x,  fill = cat, color = cat))+
  geom_bar (stat="identity") +
  theme_bw()+
  #ylim(c(-3.5,3.5))+
  scale_fill_manual(values=c('red','blue')) +  # classic SPEI look
  scale_color_manual(values=c('red','blue')) + # classic SPEI look
  geom_hline(yintercept = 0, color = "black")+
  scale_y_continuous(limits = c(-3,3), breaks = c(-3, -2, -1, 0, 1, 2, 3))+
  scale_x_continuous(limits = c(0,13), breaks = seq(0, 13, by = 1), labels = c("", "J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D", ""))+
  xlab("2023")+ ylab ("SPEI drought")+
  theme(
    legend.position = "none",
    strip.background = element_blank(),
    strip.text = element_text(hjust = 0)); p14


# Save SPEI figure ---------------------------

pall<-ggarrange(p8,p9,p10,p11,p12,p13, p14,
  p1,p2,p3,p4,p5,p6, p7, 
           nrow =2, ncol =7, 
          widths = c(2, 1,1,1,1,1,1,
                     2,1,1,1,1,1,1), labels = "auto");pall

ggsave(pall,file='Figures/SPEI_terraclimate.png',width=34,height=14, units = "cm", dpi = 600)


# Calculate rainfall seasonality index ------------

# calculate rainfall seasonality 
df_map <- dt2 %>%
  group_by(year) %>%
  summarize(ap=sum(pr,na.rm=T)) %>% 
  summarize(map=mean(ap, na.rm=T), max_ap=max(ap,na.rm=T)) 
# map is the average mean annual precipitation for the reference period (1959-2023)
# max_ap is the maximum mean annual precipitation in the long-term record

# calculation of D
df_mmp <- dt2 %>% 
  group_by(month) %>%
  summarize(mmp=mean(pr,na.rm=T)) 
p_m <- df_mmp$mmp/df_map$map
int_pm <- p_m*log((p_m/(1/12)), base=2) 
D_bar <- sum(int_pm)

# calculation of S
S <- D_bar*(df_map$map/df_map$max_ap)  
S

# Correlate terraclimate vs. local precipitation -----------

# calculate historical map 1982-2022 Terraclimate

glimpse(dt2)

map_tc<-dt2%>%group_by(year)%>%summarise(ppt= sum(pr))
mean(map_tc$ppt) # 889.6154 historical mean annual precipitation 1959-2023


map_tc2<-map_tc%>%filter(year > 1981, year < 2023) 
mean(map_tc2$ppt) # 903.5366 historical mean annual precipitation 1982-2022
glimpse(map_tc2)

# correlate map from terraclimate versus map from local weather station (headquarters)

# read headquarters data
map_hq<-read_csv("Data/APT011.csv") # local map data
glimpse(map_hq)

# calculate map
map_hq2<-map_hq%>%group_by(year)%>%summarise(ppt_hq = sum(ppt))
glimpse(map_hq2)

map_tc2<-map_tc%>%filter(year > 1981)

# bind TerraClimate and local ppt data
map_all<-cbind(map_tc2, map_hq2)

# plot relationship MAP TerraClimate x MAP headquarters
ggplot(map_all[,-1], aes(x = ppt, y = ppt_hq ))+ # OBS remove local data for 2010 (rain gauge problem?)
  geom_point(size =3, alpha =.5)+
  geom_smooth(method = "lm", color = "black")+
  theme_bw()+
  stat_poly_eq(use_label(c("eq", "R2", "P"))) +
  xlab ("MAP TerraClimate (mm)")+
  ylab("MAP Headquarters (mm)")+
  ylim(c(0,1500))+
  xlim(c(0,1500))+
  geom_abline(intercept = 0, slope = 1, color="red", 
              linetype="dashed", size=1)

ggsave(p11,file='Figures/MAP_correl.png',width=12,height=12, units = "cm", dpi = 600)
