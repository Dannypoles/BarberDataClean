library(tidyverse)
library(writexl)

Rac <- read.csv("~/Desktop/PopulationByRace.csv")

cn <- colnames(Rac)
white_cn <- c()
black_cn <- c()
aian_cn <- c()
asian_cn <- c()
nhopi_cn <- c()
other_cn <- c()

##For each listed race, we want to find all columns which include
##people of their race
for (i in 1:72) {
  
  ##Check if the race is included in each column name
  check <- cn[i]
  
  if(grepl("White",check,fixed = TRUE)){
    white_cn <- append(white_cn,i)
  }
  
  if(grepl("Black",check,fixed = TRUE)){
    black_cn <- append(black_cn,i)
  }
  
  if(grepl("American.Indian",check,fixed = TRUE)){
    aian_cn <- append(aian_cn,i)
  }
  
  if(grepl("Asian",check,fixed = TRUE)){
    asian_cn <- append(asian_cn,i)
  }
  
  if(grepl("Native.Hawaiian",check,fixed = TRUE)){
    nhopi_cn <- append(nhopi_cn,i)
  }
  
  if(grepl("Some.Other",check,fixed = TRUE)){
    other_cn <- append(other_cn,i)
  }
  
}

##Some columns are currently saved as characters, we need them
##saved as numerics
for(i in 2:72){
  column <- Rac[[cn[i]]]
  if(!is.numeric(column[1])){
    Rac[[cn[i]]] <- as.numeric(gsub(",","",column))
  }
}

##For each race, sum the columns containing people of that race
##to find the total number of people who are at least partially
##of that race, and the percentage of people in the county who
##have each specific racial background
Rac <- Rac %>%
  mutate(White = select(., white_cn) %>% rowSums(na.rm = TRUE),
         Black = select(., black_cn) %>% rowSums(na.rm = TRUE),
         AIAN = select(., aian_cn) %>% rowSums(na.rm = TRUE),
         Asian = select(., asian_cn) %>% rowSums(na.rm = TRUE),
         NHOPI = select(., nhopi_cn) %>% rowSums(na.rm = TRUE),
         Other = select(., other_cn) %>% rowSums(na.rm = TRUE),
         White_pct = White/Total.,
         Black_pct = Black/Total.,
         AIAN_pct = AIAN/Total.,
         Asian_pct = Asian/Total.,
         NHOPI_pct = NHOPI/Total.,
         Other_pct = Other/Total.,)

##We only need some of the information, so we save it in a 
##new dataframe
proj_vec <- c(1,2,73:84)
Rac.proj <- Rac[,proj_vec]
colnames(Rac.proj) <- c("County","Population",colnames(Rac.proj)[3:14])

##Export our new data as a .csv
write.csv(Rac.proj, file = "~/Desktop/CountyPopulationByRace.csv", row.names = FALSE)