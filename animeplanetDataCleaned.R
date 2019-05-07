#to clear the current global environment: rm(list=ls())
library(dtplyr)
library(stringi)
library(tidyverse)
library(dplyr)
library(pbapply)
library(lettercase)

setwd("F:/DWBIProject/DataSets")
trim <- function (x) {
  gsub("^\\s+|\\s+$", "", x)
}
if(file.exists("AnimePlanetList_final.csv"))
{
  file.remove("AnimePlanetList_final.csv")
}
if(file.exists("MyanimeList_final.csv"))
{
  file.remove("MyanimeList_final.csv")
}
if(file.exists("Sm_animeThings_final.csv"))
{
  file.remove("Sm_animeThings_final.csv")
}
animePlanetList <- read.csv("animeplanetData.csv")
#head(animePlanetList)
animePlanetList$AnimePlanet_Rating<-((animePlanetList$AnimePlanet_Rating/5)*10)
animePlanetList$Anime_alt_title<-NULL
animePlanetList$Type<-NULL
animePlanetList$animeRelease_year<-NULL

animePlanetList$Anime_studio<-gsub("\\W"," ",animePlanetList$Anime_studio)
animePlanetList$Anime_studio<-gsub("  "," ",animePlanetList$Anime_studio)
animePlanetList$Anime_studio<-str_to_title(str_decapitalize(trim(animePlanetList$Anime_studio)))
#animePlanetList$Anime_studio<-str_snake_case(animePlanetList$Anime_studio, whitespace = getOption("lettercase.whitespace","[^\\w\\s-\\.]"))
temp_Title<-animePlanetList$Anime_name
temp_Title<-gsub("\\W"," ",temp_Title)
#to replace extra spaces with just the one space
temp_Title<-gsub("  "," ",temp_Title)
temp_Title<-str_title_case(trim(temp_Title))
myAnimeList<-read.csv("MyAnimeList_DF.csv")
myAnimeseriesList<-myAnimeList[myAnimeList$Mode=="TV",]
animePlanetList$Anime_name<-temp_Title
animePlanetList$Tempcombo<-gsub(" ","",paste(animePlanetList$Anime_name,animePlanetList$Release_Year))
myAnimeseriesList_airingYear<-as.POSIXct(myAnimeseriesList$Aired_Date)
myAnimeseriesList_airingYear<-format(myAnimeseriesList_airingYear, "%Y")
myAnimeseriesList$TempCombo<-gsub(" ","",paste(myAnimeseriesList$Title,myAnimeseriesList_airingYear))
combined_animePlanet_Data<-animePlanetList[animePlanetList$Tempcombo %in% myAnimeseriesList$TempCombo,]
some_anime_things_List<-read.csv("Anime_Series_Revenues_List_DF.csv")
combinedDataSomeanimeThings<-some_anime_things_List[some_anime_things_List$TitleYearCombo %in% combined_animePlanet_Data$Tempcombo,]
#head(combinedDataSomeanimeThings)

combined_MyAnimePlanetList<-myAnimeseriesList[myAnimeseriesList$TempCombo %in% combinedDataSomeanimeThings$TitleYearCombo,]

final_animePlanetList<-combined_animePlanet_Data[combined_animePlanet_Data$Tempcombo %in% combinedDataSomeanimeThings$TitleYearCombo,]
final_animePlanetList$Release_Date<-combinedDataSomeanimeThings[combinedDataSomeanimeThings$TitleYearCombo %in% combined_animePlanet_Data$Tempcombo,]$Release_Date
final_animePlanetList$Tempcombo<-NULL
final_myanimeList <- combined_MyAnimePlanetList
final_myanimeList$TempCombo<-NULL
final_sm_animeThings<-combinedDataSomeanimeThings
final_sm_animeThings$TitleYearCombo<-NULL
if(nrow(final_animePlanetList)>0)
{
  write.csv(final_animePlanetList,file="AnimePlanetList_final.csv",row.names = FALSE)
}
if(nrow(final_myanimeList)>0)
  {
  write.csv(final_myanimeList,file="MyanimeList_final.csv",row.names = FALSE)
}
if(nrow(final_sm_animeThings)>0)
  {
  write.csv(final_sm_animeThings,file="Sm_animeThings_final.csv",row.names = FALSE)
}

