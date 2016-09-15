allSeasons <- read.csv('https://raw.githubusercontent.com/johnburnmurdoch/johnburnmurdoch.github.io/master/slides/r-ggplot/changing-tides-of-football.csv', stringsAsFactors = F)
oneSeason <- allSeasons %>% filter(year==2016)

library(ggplot2)
library(dplyr)
library(tidyr)
library(magrittr)
library(RColorBrewer)
library(scales)

#1
ggplot(oneSeason
       ,aes(x=1,score,col=country)) + 
  geom_point(size=3) + 
  scale_color_manual(breaks=unique(allSeasons$country),values=brewer_pal('qual',2)(7)) +
  theme_bw() +
  theme(legend.position="right", legend.direction="vertical") +
  xlab('')

#2
ggplot(oneSeason
       ,aes(rank,score,col=country)) + 
  geom_point(size=3) + 
  scale_color_manual(breaks=unique(allSeasons$country),values=brewer_pal('qual',2)(7)) +
  theme_bw() +
  theme(legend.position="top")

#3
ggplot(oneSeason
       ,aes(rank,score,col=country)) + 
  geom_path() + 
  geom_point(size=3) + 
  scale_color_manual(breaks=unique(allSeasons$country),values=brewer_pal('qual',2)(7)) +
  theme_bw() +
  theme(legend.position="top")

#4
ggplot(allSeasons %>%
         filter(year==2016 & country %in% c('ENG','ESP')) %>%
         dplyr::select(score, rank, country) %>% 
         spread(., country, score) %>% 
         rowwise() %>%
         mutate(
           gap = ESP-ENG,
           max = max(ESP,ENG),
           min = min(ESP,ENG)
         )
       ,aes(rank,min,fill=gap>0)) + 
  geom_rect(aes(xmin = rank-0.5, xmax=rank+0.5, ymin=min, ymax=max), alpha=0.5) +
  scale_fill_manual(breaks=unique(allSeasons$country),values=brewer_pal('qual',2)(7)) +
  theme_bw() +
  theme(legend.position="none")

#5
ggplot(oneSeason %>%
         filter(country == 'ENG'),aes(rank,score,col=country)) + 
  geom_ribbon(aes(ymin = atw, ymax = atb, fill=country),col='transparent', alpha=0.5) +
  geom_path(alpha=1, size=1.5) + 
  geom_point(size=3) + 
  scale_color_manual(breaks=unique(allSeasons$country),values=brewer_pal('qual',2)(7)) +
  scale_fill_manual(breaks=unique(allSeasons$country),values=brewer_pal('qual',2)(7)) +
  theme_bw() +
  theme(legend.position="none")

#6
ggplot(oneSeason %>%
         filter(country == 'ENG'),aes(rank,score,col=country, fill=country)) + 
  geom_rect(aes(xmin=rank-0.5, xmax=rank+0.5, ymin = atw, ymax = atb),col='transparent', alpha=0.5) +
  geom_point(size=5) + 
  scale_color_manual(breaks=unique(allSeasons$country),values=brewer_pal('qual',2)(7)) +
  scale_fill_manual(breaks=unique(allSeasons$country),values=brewer_pal('qual',2)(7)) +
  theme_bw() +
  theme(legend.position="none")

#7
ggplot(oneSeason %>%
         filter(country == 'ENG'),aes(rank,score,col=country, fill=country)) + 
  geom_rect(aes(xmin=rank-0.45, xmax=rank+0.45, ymin = atw, ymax = atb),col='transparent', alpha=0.5) +
  geom_point(size=5) + 
  scale_color_manual(breaks=unique(allSeasons$country),values=brewer_pal('qual',2)(7)) +
  scale_fill_manual(breaks=unique(allSeasons$country),values=brewer_pal('qual',2)(7)) +
  theme_bw() +
  theme(legend.position="none")

#8
ggplot(allSeasons,aes(rank,score,col=country)) + 
  geom_path() + 
  geom_point(size=1) + 
  scale_color_manual(breaks=unique(allSeasons$country),values=brewer_pal('qual',2)(7)) +
  facet_wrap(~year, ncol=4) + 
  theme_bw() +
  theme(legend.position="top")

#9
ggplot(allSeasons %>%
         filter(country %in% c('ENG','ESP')) %>%
         dplyr::select(score, year, rank, country) %>% 
         spread(., country, score) %>% 
         rowwise() %>%
         mutate(
           gap = ESP-ENG,
           max = max(ESP,ENG),
           min = min(ESP,ENG)
         )
       ,aes(rank,min,fill=gap>0)) + 
  geom_rect(aes(xmin = rank-0.5, xmax=rank+0.5, ymin=min, ymax=max), alpha=0.5) +
  scale_fill_manual(breaks=unique(allSeasons$country),values=brewer_pal('qual',2)(7)) +
  facet_wrap(~year, ncol=4) + 
  theme_bw() +
  theme(legend.position="none")

#10
ggplot(allSeasons %>% filter(country == 'ENG'),aes(rank,score,col=country, fill=country)) + 
  geom_rect(aes(xmin=rank-0.45, xmax=rank+0.45, ymin = atw, ymax = atb),col='transparent', alpha=0.5) +
  geom_path(alpha=1) + 
  geom_point(size=1) + 
  scale_color_manual(breaks=unique(allSeasons$country),values=brewer_pal('qual',2)(7)) +
  scale_fill_manual(breaks=unique(allSeasons$country),values=brewer_pal('qual',2)(7)) +
  facet_wrap(~year, ncol=4) + 
  theme_bw() +
  theme(legend.position="none")