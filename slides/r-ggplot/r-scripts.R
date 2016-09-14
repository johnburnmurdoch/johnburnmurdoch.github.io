#1
ggplot(data %>% 
         filter(year==2016)
       ,aes(x=1,score,col=country)) + 
  geom_point(size=3) + 
  scale_color_manual(breaks=unique(data$country),values=brewer_pal('qual',2)(7)) +
  facet_wrap(~year, ncol=4) + 
  theme_bw() +
  theme(legend.position="right", legend.direction="vertical") +
  xlab('')

#2
ggplot(data %>% 
         filter(year==2016)
       ,aes(rank,score,col=country)) + 
  geom_point(size=3) + 
  scale_color_manual(breaks=unique(data$country),values=brewer_pal('qual',2)(7)) +
  facet_wrap(~year, ncol=4) + 
  theme_bw() +
  theme(legend.position="none", legend.direction="vertical") +
  xlab('')

#3
ggplot(data %>% 
         filter(year==2016)
       ,aes(rank,score,col=country)) + 
  geom_path() + 
  geom_point(size=3) + 
  scale_color_manual(breaks=unique(data$country),values=brewer_pal('qual',2)(7)) +
  facet_wrap(~year, ncol=4) + 
  theme_bw() +
  theme(legend.position="top") +
  xlab('')

#4
ggplot(data %>%
         filter(year==2016 & country %in% c('ENG','ESP')) %>%
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
  scale_fill_manual(breaks=unique(data$country),values=brewer_pal('qual',2)(7)) +
  theme_bw() +
  theme(legend.position="top")

#5
ggplot(data %>%
         filter(year==2016 & country == 'ENG'),aes(rank,score,col=country)) + 
  geom_ribbon(aes(ymin = atw, ymax = atb, fill=country),col='transparent', alpha=0.5) +
  geom_path(alpha=1, size=1.5) + 
  geom_point(size=3) + 
  scale_color_manual(breaks=unique(data$country),values=brewer_pal('qual',2)(7)) +
  scale_fill_manual(breaks=unique(data$country),values=brewer_pal('qual',2)(7)) +
  theme_bw() +
  theme(legend.position="none")

#6
ggplot(data %>%
         filter(year==2016 & country == 'ENG'),aes(rank,score,col=country, fill=country)) + 
  geom_rect(aes(xmin=rank-0.5, xmax=rank+0.5, ymin = atw, ymax = atb),col='transparent', alpha=0.5) +
  geom_point(size=5) + 
  scale_color_manual(breaks=unique(data$country),values=brewer_pal('qual',2)(7)) +
  scale_fill_manual(breaks=unique(data$country),values=brewer_pal('qual',2)(7)) +
  theme_bw() +
  theme(legend.position="none")

#7
ggplot(data %>%
         filter(year==2016 & country == 'ENG'),aes(rank,score,col=country, fill=country)) + 
  geom_rect(aes(xmin=rank-0.45, xmax=rank+0.45, ymin = atw, ymax = atb),col='transparent', alpha=0.5) +
  geom_point(size=5) + 
  scale_color_manual(breaks=unique(data$country),values=brewer_pal('qual',2)(7)) +
  scale_fill_manual(breaks=unique(data$country),values=brewer_pal('qual',2)(7)) +
  theme_bw() +
  theme(legend.position="none")

#8
ggplot(data,aes(rank,score,col=country)) + 
  geom_path() + 
  geom_point(size=1) + 
  scale_color_manual(breaks=unique(data$country),values=brewer_pal('qual',2)(7)) +
  facet_wrap(~year, ncol=4) + 
  theme_bw() +
  theme(legend.position="top")

#9
ggplot(data %>%
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
  scale_fill_manual(breaks=unique(data$country),values=brewer_pal('qual',2)(7)) +
  facet_wrap(~year, ncol=4) + 
  theme_bw() +
  theme(legend.position="none")

#10
ggplot(data %>% filter(country == 'ENG'),aes(rank,score,col=country, fill=country)) + 
  geom_rect(aes(xmin=rank-0.45, xmax=rank+0.45, ymin = atw, ymax = atb),col='transparent', alpha=0.5) +
  geom_path(alpha=1) + 
  geom_point(size=1) + 
  scale_color_manual(breaks=unique(data$country),values=brewer_pal('qual',2)(7)) +
  scale_fill_manual(breaks=unique(data$country),values=brewer_pal('qual',2)(7)) +
  facet_wrap(~year, ncol=4) + 
  theme_bw() +
  theme(legend.position="none")