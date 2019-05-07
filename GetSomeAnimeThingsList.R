setwd("F:/DWBIProject/DataSets")
#to clear the current global environment: rm(list=ls())
library(htmltab)
library(lettercase)
library(stringr)
library(tm)
trim <- function (x) {
  gsub("^\\s+|\\s+$", "", x)
  }
if(file.exists("Anime_Series_Revenues_List_DF.csv"))
{
  file.remove("Anime_Series_Revenues_List_DF.csv")
}

url<-"http://www.someanithing.com/series-data-quick-view-2"
sm_anime_thng <- htmltab(doc=url, which=1)

#head(sm_anime_thng)
rownames(sm_anime_thng)<-c(1:nrow(sm_anime_thng))

sm_anime_thng$`Gross in ¥1m (1st rls only)`<-gsub("¥","",sm_anime_thng$`Gross in ¥1m (1st rls only)`)
sm_anime_thng$`Gross in ¥1m (1st rls only)`<-gsub(",","",sm_anime_thng$`Gross in ¥1m (1st rls only)`)

gross_revenues_1mill_Yen<-as.numeric(sm_anime_thng$`Gross in ¥1m (1st rls only)`)

sm_anime_thng$`Avg Sales`<-as.numeric(gsub(",","",sm_anime_thng$`Avg Sales`))
sm_anime_thng$`Re-rls`<-as.numeric(gsub(",","",sm_anime_thng$`Re-rls`))
sm_anime_thng$Total<-as.numeric(gsub(",","",sm_anime_thng$Total))
#sm_anime_thng$SeasonCode<-trim(gsub(" ","",paste(sm_anime_thng$Season,sm_anime_thng$Year)))
for(i in seq(1,nrow(sm_anime_thng)))
{
  if(sm_anime_thng[i,1]=="Hagane no Renkinjutsushi")
  {
    sm_anime_thng[i,1]<-"Fullmetal Alchemist"
  } 
  if(sm_anime_thng[i,1]=="Hagane no Renkinjutsushi (2009)")
  {
    sm_anime_thng[i,1]<-"Fullmetal Alchemist Brotherhood"
  }
}
sm_anime_thng$Title <- gsub("\\(.*","",sm_anime_thng$Title)
sm_anime_thng_temp_Title<-sm_anime_thng$Title
sm_anime_thng_temp_Title<-gsub("\\W"," ",sm_anime_thng_temp_Title)
#to replace extra spaces with just the one space
sm_anime_thng_temp_Title<-gsub("  "," ",sm_anime_thng_temp_Title)
sm_anime_thng_temp_Title<-str_to_title(str_decapitalize(trim(sm_anime_thng_temp_Title)))
sm_anime_thng$Studio<-gsub("\\W"," ",sm_anime_thng$Studio)
sm_anime_thng$Studio<-gsub("  "," ",sm_anime_thng$Studio)
sm_anime_thng$Studio<-str_to_title(str_decapitalize(trim(sm_anime_thng$Studio)))

sm_anime_thng$Source<-gsub(".*\\(","",sm_anime_thng$Source)
sm_anime_thng$Source<-gsub("\\).*","",sm_anime_thng$Source)
sm_anime_thng$Source<-trim(gsub("\\W","_",trim(sm_anime_thng$Source)))
sm_anime_thng$Source<-trimws(sm_anime_thng$Source,"b")
sm_anime_thng$Source_Code<-""
for(i in seq(1,nrow(sm_anime_thng)))
{ 
  #print(paste(sm_anime_thng[i,9]))
  if(sm_anime_thng[i,9]=="game")
  {
    sm_anime_thng[i,10]="SC01"
  }
  if(sm_anime_thng[i,9]=="live_action")
  {
    sm_anime_thng[i,10]="SC02"
  }
  if(sm_anime_thng[i,9]=="historical_work")
  {
    sm_anime_thng[i,10]="SC03" 
  }
     if(sm_anime_thng[i,9]=="figures")
  {
       sm_anime_thng[i,10]="SC04"
  } 
  if(sm_anime_thng[i,9]=="original_character")
  {
    sm_anime_thng[i,10]="SC05" 
  } 
  if(sm_anime_thng[i,9]=="tabletop_rpg")
  {
    sm_anime_thng[i,10]="SC06"
  }
  if(sm_anime_thng[i,9]=="card_game")
  {
    sm_anime_thng[i,10]="SC22"
  }
  if(sm_anime_thng[i,9]=="comic_book")
  {
    sm_anime_thng[i,10]="SC21"
  }
  if(sm_anime_thng[i,9]=="radio_show")
  {
    sm_anime_thng[i,10]="SC20"
  }
  if(sm_anime_thng[i,9]=="company_mascot")
  {
    sm_anime_thng[i,10]="SC19"
  }
  if(sm_anime_thng[i,9]=="visual_combat_book")
  {
    sm_anime_thng[i,10]="SC18"
  }
  if(sm_anime_thng[i,9]=="stage_play")
  {
    sm_anime_thng[i,10]="SC17"
  }
  if(sm_anime_thng[i,9]=="study_guides")
  {
    sm_anime_thng[i,10]="SC16"
  }
  if(sm_anime_thng[i,9]=="drama_CD")
  {
    sm_anime_thng[i,10]="SC15"
  }
  if(sm_anime_thng[i,9]=="pachinko")
  {
    sm_anime_thng[i,10]="SC14"
  }
  if(sm_anime_thng[i,9]=="songs")
  {
    sm_anime_thng[i,10]="SC13"
  }
  if(sm_anime_thng[i,9]=="doujinshi")
  {
    sm_anime_thng[i,10]="SC12"
  }
  if(sm_anime_thng[i,9]=="news_app")
  {
    sm_anime_thng[i,10]="SC11"
  }
  if(sm_anime_thng[i,9]=="manga")
  {
    sm_anime_thng[i,10]="SC07"
  }
  if(sm_anime_thng[i,9]=="visual_novel")
  {
    sm_anime_thng[i,10]="SC08"
  }
  if(sm_anime_thng[i,9]=="original")
  {
    sm_anime_thng[i,10]="SC09"
  }
  if(sm_anime_thng[i,9]=="novel")
  {
    sm_anime_thng[i,10]="SC10"
  }
}
sm_anime_thng$Source<-trim(gsub("_"," ",sm_anime_thng$Source))
#head(sm_anime_thng_temp_Title)

animelist <- read.csv("MyAnimeList_DF.csv")
#animelist_ty <- animelist[,c(2,4)]
tempCombo1<-gsub(" ","",paste(sm_anime_thng_temp_Title,sm_anime_thng$Year))
some_anime_things_df <- data.frame(Title=sm_anime_thng_temp_Title,Re_Rls=sm_anime_thng$`Re-rls`,Avg_Sales=sm_anime_thng$`Avg Sales`,TotalSales=sm_anime_thng$Total,Release_Year=sm_anime_thng$Year,Season=sm_anime_thng$Season, Studio=sm_anime_thng$Studio, Source=sm_anime_thng$Source, Revenue=gross_revenues_1mill_Yen, TitleYearCombo=tempCombo1,Source_Code=sm_anime_thng$Source_Code)
#rownames(some_anime_things_df)<-c(1:300)
#some_anime_things_df<-some_anime_things_df[]
anime_airingYear<-as.POSIXct(animelist$Aired_Date)
anime_airingYear<-format(anime_airingYear, "%Y")
animelist$TempCombo<-gsub(" ","",paste(animelist$Title,anime_airingYear))
combined_data<-some_anime_things_df[some_anime_things_df$TitleYearCombo %in% animelist$TempCombo,]
#tempDate<-animelist[combined_data$TitleYearCombo %in% animelist$TempCombo,]$Aired_Date
combined_data$Release_Date<-NULL
for(i in seq(1:nrow(combined_data)))
{
  for(j in seq(1:nrow(animelist)))
{    
    if(combined_data[i,"TitleYearCombo"]==animelist[j,"TempCombo"])
    {
      combined_data[i,"Release_Date"]<-animelist[j,"Aired_Date"]
    }
  }
}

if(nrow(combined_data)>0)
{
  print(paste("Some Anime Things successfully extracted ",nrow(combined_data),"rows" )) 
  write.csv(combined_data,file="Anime_Series_Revenues_List_DF.csv",row.names = FALSE)
}
