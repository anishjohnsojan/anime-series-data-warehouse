#to clear the current global environment: rm(list=ls())
#Installing the rvest package
#install.packages('rvest')
#install.packages('xml2')
#install.packages('stringr')
#install.packages('data.table')
#install.packages('lubridate')
#Loading the rvest package
library('xml2')
library('rvest')
library('stringr')
library('data.table')
library('lubridate')
library('lettercase')
setwd("F:/DWBIProject/DataSets")
if(file.exists("MyAnimeList_DF.csv"))
{
  file.remove("MyAnimeList_DF.csv")
}
trim <- function (x) {
  gsub("^\\s+|\\s+$", "", x)
}
#Specifying the url for desired website to be scrapped
mainSrcUrl <- 'https://myanimelist.net/topanime.php'
titleNode<-'.fs14.fw-b'
rankNode<-'.top-anime-rank-text'
scoreNode<-'.text.on'
detailsNode<-'.mt4'
getMALurl<- function(srcUrl,count){
  count<-as.character(((count-1)*50))
  createUrl<-paste(srcUrl,"?limit=",count,sep="")
  return(createUrl)
}
getMALdata<-function(Node){
  data_main<-NULL
  for(i in 1:8)
  {
    url<-getMALurl(mainSrcUrl,i)
    webpage <- read_html(url)
    req_data_html <- html_nodes(webpage,Node)
    req_data <- html_text(req_data_html)
    data_main<-c(data_main,req_data)
  }
  return(data_main)
}

getMembersData<-function(membersData){
  #creation of members data
  members_dataTemp<-membersData
  members_dataTemp<-gsub("members","",members_dataTemp)
  members_dataTemp<-gsub(",","",members_dataTemp)
  membersData<-as.numeric(members_dataTemp)
  return(membersData)
}

getAnimeMode<-function(animeTypedata)
{
  animeType_dataTemp<-animeTypedata
  animeType_dataTemp<-gsub("\\(.*\\)","",animeType_dataTemp)
  animeTypedata<-animeType_dataTemp
  return(animeTypedata)
}

getAnimeAiringDate<-function(animeAiringData)
{
  animeAiringYearTemp<-animeAiringData
  animeAiringYearTemp<-gsub("-.*","",animeAiringYearTemp)
  animeAiringYearTemp<-paste('01',animeAiringYearTemp,sep = "")
  airing_dataTempYear<-as.Date(animeAiringYearTemp,format = "%d%b%Y")
  animeAiringData<-airing_dataTempYear
  return(animeAiringData)
}

animeType_data<-NULL
airing_data<-NULL
members_data<-NULL
details_data<-getMALdata(detailsNode)
title_data<-getMALdata(titleNode)
rank_data<-as.numeric(getMALdata(rankNode))
score_data<-as.numeric(getMALdata(scoreNode))

details_data<-gsub(" ","",details_data)
temp<-strsplit(details_data,"\n",fixed=TRUE)

for(i in 1:length(temp))
{
  for(j in 1:length(temp[[i]]))
  {if(str_length(temp[[i]][[j]])>0)
  {
    #create animeType list
    if(j==2)animeType_data<-c(animeType_data,temp[[i]][[j]])
    #create airing_data list
    if(j==3)airing_data<-c(airing_data,temp[[i]][[j]])
    #create members_data list
    if(j==4)members_data<-c(members_data,temp[[i]][[j]])
  }}
}

cleanTitleData<-function(titleData){
  tempTitleData<-titleData
  #to clean all unidentified words and symbols
  tempTitleData<-gsub("\\W"," ",tempTitleData)
  #to replace extra spaces with just the one space
  tempTitleData<-gsub("  "," ",tempTitleData)
  #add the updated clean list of titles
  titleData<-str_to_title(str_decapitalize(trim(tempTitleData)))
  return(titleData)
}
members_data<-getMembersData(members_data)
animeType_data<-getAnimeMode(animeType_data)
airing_date<-getAnimeAiringDate(airing_data)
# mode_code<-NULL
# for(i in seq(1,length(animeType_data)))
# {
#   print(paste("Mode:",animeType_data[i]))
#   if(animeType_data[i]=="TV")
#   {
#     mode_code<-c("M001",mode_code)
#   }
#   if(animeType_data[i]=="Movie")
#   {
#     mode_code<-c("M002",mode_code)
#   }
#   if(animeType_data[i]=="OVA")
#   {
#     mode_code<-c("M003",mode_code)
#   }
#   if(animeType_data[i]=="Special")
#   {
#     mode_code<-c("M004",mode_code)
#   }
#   if(animeType_data[i]=="Music")
#   {
#     mode_code<-c("M005",mode_code)
#   }
#   if(animeType_data[i]=="ONA")
#   {
#     mode_code<-c("M006",mode_code)
#   }
# }

title_data<-cleanTitleData(title_data)

myanimeList_df<-data.frame(Rank=rank_data,Title=title_data,Mode=animeType_data,Aired_Date=airing_date,Score=score_data,Member_Count=members_data)
#rownames(myanimeList_df)<-c(1:nrow(myanimeList_df))


if(nrow(myanimeList_df)>0)
{
  print(paste("My Anime List successfully extracted ",nrow(myanimeList_df),"rows"))
  write.csv(myanimeList_df,file="MyAnimeList_DF.csv",row.names = FALSE)
}
