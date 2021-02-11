---
title: "Lab 10 Homework"
author: "Manhar Sekhon"
date: "2021-02-11"
output:
  html_document: 
    theme: spacelab
    keep_md: yes
---



## Instructions
Answer the following questions and complete the exercises in RMarkdown. Please embed all of your code and push your final work to your repository. Your final lab report should be organized, clean, and run free from errors. Remember, you must remove the `#` for the included code chunks to run. Be sure to add your name to the author header above. For any included plots, make sure they are clearly labeled. You are free to use any plot type that you feel best communicates the results of your analysis.  

Make sure to use the formatting conventions of RMarkdown to make your report neat and clean!  

## Load the libraries

```r
library(tidyverse)
library(janitor)
library(here)
library(naniar)
```

## Desert Ecology
For this assignment, we are going to use a modified data set on [desert ecology](http://esapubs.org/archive/ecol/E090/118/). The data are from: S. K. Morgan Ernest, Thomas J. Valone, and James H. Brown. 2009. Long-term monitoring and experimental manipulation of a Chihuahuan Desert ecosystem near Portal, Arizona, USA. Ecology 90:1708.

```r
deserts <- read_csv(here("lab10", "data", "surveys_complete.csv"))
```

```
## 
## -- Column specification --------------------------------------------------------
## cols(
##   record_id = col_double(),
##   month = col_double(),
##   day = col_double(),
##   year = col_double(),
##   plot_id = col_double(),
##   species_id = col_character(),
##   sex = col_character(),
##   hindfoot_length = col_double(),
##   weight = col_double(),
##   genus = col_character(),
##   species = col_character(),
##   taxa = col_character(),
##   plot_type = col_character()
## )
```

1. Use the function(s) of your choice to get an idea of its structure, including how NA's are treated. Are the data tidy? 


```r
glimpse(deserts)
```

```
## Rows: 34,786
## Columns: 13
## $ record_id       <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, ...
## $ month           <dbl> 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, ...
## $ day             <dbl> 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16,...
## $ year            <dbl> 1977, 1977, 1977, 1977, 1977, 1977, 1977, 1977, 197...
## $ plot_id         <dbl> 2, 3, 2, 7, 3, 1, 2, 1, 1, 6, 5, 7, 3, 8, 6, 4, 3, ...
## $ species_id      <chr> "NL", "NL", "DM", "DM", "DM", "PF", "PE", "DM", "DM...
## $ sex             <chr> "M", "M", "F", "M", "M", "M", "F", "M", "F", "F", "...
## $ hindfoot_length <dbl> 32, 33, 37, 36, 35, 14, NA, 37, 34, 20, 53, 38, 35,...
## $ weight          <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,...
## $ genus           <chr> "Neotoma", "Neotoma", "Dipodomys", "Dipodomys", "Di...
## $ species         <chr> "albigula", "albigula", "merriami", "merriami", "me...
## $ taxa            <chr> "Rodent", "Rodent", "Rodent", "Rodent", "Rodent", "...
## $ plot_type       <chr> "Control", "Long-term Krat Exclosure", "Control", "...
```



```r
naniar::miss_var_summary(deserts)
```

```
## # A tibble: 13 x 3
##    variable        n_miss pct_miss
##    <chr>            <int>    <dbl>
##  1 hindfoot_length   3348     9.62
##  2 weight            2503     7.20
##  3 sex               1748     5.03
##  4 record_id            0     0   
##  5 month                0     0   
##  6 day                  0     0   
##  7 year                 0     0   
##  8 plot_id              0     0   
##  9 species_id           0     0   
## 10 genus                0     0   
## 11 species              0     0   
## 12 taxa                 0     0   
## 13 plot_type            0     0
```

```r
##The data is not tidy.
```


2. How many genera and species are represented in the data? What are the total number of observations? Which species is most/ least frequently sampled in the study?


```r
deserts %>%
  summarize(n_genera=n_distinct(genus),
            n_species=n_distinct(species),
            n=n())
```

```
## # A tibble: 1 x 3
##   n_genera n_species     n
##      <int>     <int> <int>
## 1       26        40 34786
```



```r
deserts %>% 
  count(species_id, sort=T)
```

```
## # A tibble: 48 x 2
##    species_id     n
##    <chr>      <int>
##  1 DM         10596
##  2 PP          3123
##  3 DO          3027
##  4 PB          2891
##  5 RM          2609
##  6 DS          2504
##  7 OT          2249
##  8 PF          1597
##  9 PE          1299
## 10 NL          1252
## # ... with 38 more rows
```



```r
deserts %>% 
  count(species, sort=T) %>% 
  head(n=1)
```

```
## # A tibble: 1 x 2
##   species      n
##   <chr>    <int>
## 1 merriami 10596
```


```r
deserts %>% 
  count(species, sort=T) %>% 
  tail(n=1)
```

```
## # A tibble: 1 x 2
##   species     n
##   <chr>   <int>
## 1 viridis     1
```

3. What is the proportion of taxa included in this study? Show a table and plot that reflects this count.


```r
deserts %>% 
  count(taxa, sort=T)
```

```
## # A tibble: 4 x 2
##   taxa        n
##   <chr>   <int>
## 1 Rodent  34247
## 2 Bird      450
## 3 Rabbit     75
## 4 Reptile    14
```


```r
deserts %>% 
  count(taxa) %>% 
  ggplot(aes(x=taxa, y=log10(n), fill=taxa)) + geom_col()+
  theme(plot.title = element_text(size = rel(1.5), hjust = 0.5))+
  labs(title = "Proportion of taxa",
       x = "Taxa")
```

![](lab10_hw_files/figure-html/unnamed-chunk-11-1.png)<!-- -->


4. For the taxa included in the study, use the fill option to show the proportion of individuals sampled by `plot_type.`


```r
deserts %>% 
  ggplot(aes(x=taxa, fill=plot_type)) + geom_bar(position="dodge") +
  scale_y_log10()+
  theme(plot.title = element_text(size = rel(1.5), hjust = 0.5)) +
  labs(title = "Taxa by plot type",
       x = "Taxa",
       y = "Number of individuals")
```

![](lab10_hw_files/figure-html/unnamed-chunk-12-1.png)<!-- -->


5. What is the range of weight for each species included in the study? Remove any observations of weight that are NA so they do not show up in the plot.


```r
deserts %>% 
  filter(weight!="NA") %>% 
  ggplot(aes(x=species, y=weight, fill=species)) +
  geom_boxplot()+
  coord_flip()+
  theme(plot.title = element_text(size = rel(1.5), hjust = 0.5))+
  labs(title = "Weight distribution for each species",
       x = "Species",
       y = "Weight")
```

![](lab10_hw_files/figure-html/unnamed-chunk-13-1.png)<!-- -->


6. Add another layer to your answer from #4 using `geom_point` to get an idea of how many measurements were taken for each species.


```r
deserts %>% 
  filter(weight!="NA") %>% 
  ggplot(aes(x=species, y=weight, fill=species)) +
  geom_boxplot()+
geom_point(size=0.5)+
  coord_flip()+
  theme(plot.title = element_text(size = rel(1.5), hjust = 0.5))+
  labs(title = "Weight distribution for each species",
       x = "Species",
       y = "Weight")
```

![](lab10_hw_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

7. [Dipodomys merriami](https://en.wikipedia.org/wiki/Merriam's_kangaroo_rat) is the most frequently sampled animal in the study. How have the number of observations of this species changed over the years included in the study?


```r
deserts %>% 
  filter(species_id=="DM") %>% 
  group_by(year) %>% 
  summarize(n_observations=n())%>% 
  ggplot(aes(x=year, y=n_observations, fill=year)) + 
  geom_col()+
  theme(plot.title = element_text(size = rel(1.5), hjust = 0.5))+
  labs(title = "Dipodomys merriami observed over the years",
       x = "Year",
       y = "Number of observations")
```

![](lab10_hw_files/figure-html/unnamed-chunk-15-1.png)<!-- -->


8. What is the relationship between `weight` and `hindfoot` length? Consider whether or not over plotting is an issue.


```r
deserts %>% 
  ggplot(aes(x=weight, y=hindfoot_length))+
  geom_jitter(na.rm=T, size=0.2)+
  theme(plot.title = element_text(size = rel(1.5), hjust = 0.5))+
  labs(title = "Relationship between Weight and Hindfoot length",
       x = "Weight",
       y = "Hindfoot length")
```

![](lab10_hw_files/figure-html/unnamed-chunk-16-1.png)<!-- -->


9. Which two species have, on average, the highest weight? Once you have identified them, make a new column that is a ratio of `weight` to `hindfoot_length`. Make a plot that shows the range of this new ratio and fill by sex.


```r
deserts %>% 
  filter(weight!="NA") %>% 
  group_by(species) %>% 
  summarize(mean_weight=mean(weight)) %>% 
  arrange(desc(mean_weight))
```

```
## # A tibble: 22 x 2
##    species      mean_weight
##    <chr>              <dbl>
##  1 albigula           159. 
##  2 spectabilis        120. 
##  3 spilosoma           93.5
##  4 hispidus            65.6
##  5 fulviventer         58.9
##  6 ochrognathus        55.4
##  7 ordii               48.9
##  8 merriami            43.2
##  9 baileyi             31.7
## 10 leucogaster         31.6
## # ... with 12 more rows
```


```r
deserts %>% 
  filter(species=="albigula" | species=="spectabilis") %>% 
  filter(weight!="NA" & hindfoot_length!="NA" & sex!="NA") %>% 
  mutate(ratio=weight/hindfoot_length) %>% 
  select(species, weight, hindfoot_length, sex, ratio)%>% 
  ggplot(aes(x=species, y=ratio, fill=sex)) + 
  geom_boxplot()+
  theme(plot.title = element_text(size = rel(1.5), hjust = 0.5))+
  labs(title = "Ratio of Weight to Hindfoot length",
       x = "Species",
       y = "Ratio")
```

![](lab10_hw_files/figure-html/unnamed-chunk-18-1.png)<!-- -->


10. Make one plot of your choice! Make sure to include at least two of the aesthetics options you have learned.


```r
deserts %>% 
  filter(weight!="NA") %>% 
  ggplot(aes(x=plot_type, y=hindfoot_length, color=plot_type)) +
  geom_boxplot()+
  coord_flip()+
geom_point(size=0.5)+
  theme(plot.title = element_text(size = rel(1.5), hjust = 0.5))+
  labs(title = "Hindfoot lenths by plot type",
       x = "Plot type",
       y = "Hindfoot length")
```

```
## Warning: Removed 1545 rows containing non-finite values (stat_boxplot).
```

```
## Warning: Removed 1545 rows containing missing values (geom_point).
```

![](lab10_hw_files/figure-html/unnamed-chunk-19-1.png)<!-- -->


## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences. 
