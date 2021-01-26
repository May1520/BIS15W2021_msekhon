---
title: "Lab 4 Homework"
author: "Manhar Sekhon"
date: "2021-01-24"
output:
  html_document: 
    theme: spacelab
    keep_md: yes
---



## Instructions
Answer the following questions and complete the exercises in RMarkdown. Please embed all of your code and push your final work to your repository. Your final lab report should be organized, clean, and run free from errors. Remember, you must remove the `#` for the included code chunks to run. Be sure to add your name to the author header above.  

Make sure to use the formatting conventions of RMarkdown to make your report neat and clean!  

I had to make some adjustments in order for your markdown file to neat cleanly. When you work with large data sets, there is no need to print out the results when you are doing large filters/subsets. These will all show up in the markdown file making it hard to read.

## Load the tidyverse

```r
library(tidyverse)
```

## Data
For the homework, we will use data about vertebrate home range sizes. The data are in the class folder, but the reference is below.  

**Database of vertebrate home range sizes.**  
Reference: Tamburello N, Cote IM, Dulvy NK (2015) Energy and the scaling of animal space use. The American Naturalist 186(2):196-211. http://dx.doi.org/10.1086/682070.  
Data: http://datadryad.org/resource/doi:10.5061/dryad.q5j65/1  

**1. Load the data into a new object called `homerange`.**

```r
homerange <- readr::read_csv("data/Tamburelloetal_HomeRangeDatabase.csv")
```

```
## Parsed with column specification:
## cols(
##   .default = col_character(),
##   mean.mass.g = col_double(),
##   log10.mass = col_double(),
##   mean.hra.m2 = col_double(),
##   log10.hra = col_double(),
##   preymass = col_double(),
##   log10.preymass = col_double(),
##   PPMR = col_double()
## )
```

```
## See spec(...) for full column specifications.
```

**2. Explore the data. Show the dimensions, column names, classes for each variable, and a statistical summary. Keep these as separate code chunks.**  

```r
dim(homerange)
```

```
## [1] 569  24
```


```r
colnames(homerange)
```

```
##  [1] "taxon"                      "common.name"               
##  [3] "class"                      "order"                     
##  [5] "family"                     "genus"                     
##  [7] "species"                    "primarymethod"             
##  [9] "N"                          "mean.mass.g"               
## [11] "log10.mass"                 "alternative.mass.reference"
## [13] "mean.hra.m2"                "log10.hra"                 
## [15] "hra.reference"              "realm"                     
## [17] "thermoregulation"           "locomotion"                
## [19] "trophic.guild"              "dimension"                 
## [21] "preymass"                   "log10.preymass"            
## [23] "PPMR"                       "prey.size.reference"
```


```r
#glimpse(homerange)
```


```r
#summary(homerange)
```


**3. Change the class of the variables `taxon` and `order` to factors and display their levels.**  

```r
homerange$taxon <- as.factor(homerange$taxon)
levels(homerange$taxon)
```

```
## [1] "birds"         "lake fishes"   "lizards"       "mammals"      
## [5] "marine fishes" "river fishes"  "snakes"        "tortoises"    
## [9] "turtles"
```


```r
homerange$order<-as.factor(homerange$order)
levels(homerange$order)
```

```
##  [1] "accipitriformes"    "afrosoricida"       "anguilliformes"    
##  [4] "anseriformes"       "apterygiformes"     "artiodactyla"      
##  [7] "caprimulgiformes"   "carnivora"          "charadriiformes"   
## [10] "columbidormes"      "columbiformes"      "coraciiformes"     
## [13] "cuculiformes"       "cypriniformes"      "dasyuromorpha"     
## [16] "dasyuromorpia"      "didelphimorphia"    "diprodontia"       
## [19] "diprotodontia"      "erinaceomorpha"     "esociformes"       
## [22] "falconiformes"      "gadiformes"         "galliformes"       
## [25] "gruiformes"         "lagomorpha"         "macroscelidea"     
## [28] "monotrematae"       "passeriformes"      "pelecaniformes"    
## [31] "peramelemorphia"    "perciformes"        "perissodactyla"    
## [34] "piciformes"         "pilosa"             "proboscidea"       
## [37] "psittaciformes"     "rheiformes"         "roden"             
## [40] "rodentia"           "salmoniformes"      "scorpaeniformes"   
## [43] "siluriformes"       "soricomorpha"       "squamata"          
## [46] "strigiformes"       "struthioniformes"   "syngnathiformes"   
## [49] "testudines"         "tetraodontiformes\xa0" "tinamiformes"
```


**4. What taxa are represented in the `homerange` data frame? Make a new data frame `taxa` that is restricted to taxon, common name, class, order, family, genus, species.**  

```r
taxa <- data.frame(select(homerange, "taxon", "common.name", "class", "order", "family", "genus", "species"))
```


**5. The variable `taxon` identifies the large, common name groups of the species represented in `homerange`. Make a table the shows the counts for each of these `taxon`.**  

```r
table(homerange$taxon)
```

```
## 
##         birds   lake fishes       lizards       mammals marine fishes 
##           140             9            11           238            90 
##  river fishes        snakes     tortoises       turtles 
##            14            41            12            14
```


**6. The species in `homerange` are also classified into trophic guilds. How many species are represented in each trophic guild.**  

```r
table(homerange$trophic.guild)
```

```
## 
## carnivore herbivore 
##       342       227
```


**7. Make two new data frames, one which is restricted to carnivores and another that is restricted to herbivores.**  

```r
carnivore <- data.frame(filter(homerange, trophic.guild == "carnivore"))
```


```r
herbivore <- data.frame(filter(homerange, trophic.guild == "herbivore"))
```


**8. Do herbivores or carnivores have, on average, a larger `mean.hra.m2`? Remove any NAs from the data.**  

```r
mean(carnivore$mean.hra.m2, na.rm = T)
```

```
## [1] 13039918
```


```r
mean(herbivore$mean.hra.m2, na.rm = T)
```

```
## [1] 34137012
```


```r
##Herbivores have a larger mean.hra.m2 on average.
```


**9. Make a new dataframe `deer` that is limited to the mean mass, log10 mass, family, genus, and species of deer in the database. The family for deer is cervidae. Arrange the data in descending order by log10 mass. Which is the largest deer? What is its common name?**  

```r
deer <- data.frame(select(homerange, "mean.mass.g", "log10.mass", "family", "genus", "species"))
deer <- filter(deer, family == "cervidae")
deer <- arrange(deer, desc("log.10.mass"))
deer
```

```
##    mean.mass.g log10.mass   family      genus     species
## 1    307227.44    5.48746 cervidae      alces       alces
## 2     62823.19    4.79812 cervidae       axis        axis
## 3     24050.27    4.38112 cervidae  capreolus   capreolus
## 4    234757.78    5.37062 cervidae     cervus     elaphus
## 5     29450.32    4.46909 cervidae     cervus      nippon
## 6     71449.63    4.85400 cervidae       dama        dama
## 7     13499.88    4.13033 cervidae  muntiacus     reevesi
## 8     53864.17    4.73130 cervidae odocoileus    hemionus
## 9     87884.04    4.94391 cervidae odocoileus virginianus
## 10    35000.16    4.54407 cervidae ozotoceros bezoarticus
## 11     7499.98    3.87506 cervidae       pudu        puda
## 12   102058.69    5.00885 cervidae   rangifer    tarandus
```


```r
filter(homerange, species == "alces" & genus == "alces")
```

```
## # A tibble: 1 x 24
##   taxon common.name class order family genus species primarymethod N    
##   <fct> <chr>       <chr> <fct> <chr>  <chr> <chr>   <chr>         <chr>
## 1 mamm… moose       mamm… arti… cervi… alces alces   telemetry*    <NA> 
## # … with 15 more variables: mean.mass.g <dbl>, log10.mass <dbl>,
## #   alternative.mass.reference <chr>, mean.hra.m2 <dbl>, log10.hra <dbl>,
## #   hra.reference <chr>, realm <chr>, thermoregulation <chr>, locomotion <chr>,
## #   trophic.guild <chr>, dimension <chr>, preymass <dbl>, log10.preymass <dbl>,
## #   PPMR <dbl>, prey.size.reference <chr>
```


```r
##The largest dear is alces alces and it's common name is Moose.
```


**10. As measured by the data, which snake species has the smallest homerange? Show all of your work, please. Look this species up online and tell me about it!** **Snake is found in taxon column**    

```r
snake<-filter(homerange, taxon=="snakes")
```


```r
min(snake$mean.hra.m2)
```

```
## [1] 200
```


```r
filter(snake, mean.hra.m2==200)
```

```
## # A tibble: 1 x 24
##   taxon common.name class order family genus species primarymethod N    
##   <fct> <chr>       <chr> <fct> <chr>  <chr> <chr>   <chr>         <chr>
## 1 snak… namaqua dw… rept… squa… viper… bitis schnei… telemetry     11   
## # … with 15 more variables: mean.mass.g <dbl>, log10.mass <dbl>,
## #   alternative.mass.reference <chr>, mean.hra.m2 <dbl>, log10.hra <dbl>,
## #   hra.reference <chr>, realm <chr>, thermoregulation <chr>, locomotion <chr>,
## #   trophic.guild <chr>, dimension <chr>, preymass <dbl>, log10.preymass <dbl>,
## #   PPMR <dbl>, prey.size.reference <chr>
```


```r
##The snake with the smallest homerange is Namaqua dwarf adder. This is a venomous snake. It is native to a small region on the border between Namibia and South Africa.
```


## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences.   
