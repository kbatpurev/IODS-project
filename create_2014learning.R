#Author: Khorloo Batpurev
#This R script does the following steps:
#1. Reads learning2014 data into R
#2. Creates analysis dataset
#3. Save the analysis dataset


.libPaths()
.libPaths(new="C:/Data/RStudio")

library(abind)
library(here)
library(dplyr)
library(data.table)
library(ggplot2)
library(wesanderson)
library(readr)

setwd("C:/Users/kb0r/OneDrive - Department of Environment, Energy and Climate Action/phd/ojo/IODS_data/")

#1======================================================================================================
studentdata<-read.csv("learning2014data.csv")
head(studentdata)
#The normal read.csv doesn't work. This attempt involved copy/paste .txt file into an excel and save as.csv. 

#Lets try something else, which is to use another command called read.delim2. This time go to web location 
#of text file, right click save as and save it locally as a .txt file.
studentdata<-read.delim2("JYTOPKYS3-data.txt", header = TRUE, sep = "\t", dec = ",")
str(studentdata)
#Viola! works. #183 obs and 60 variables. Alternative of course is read.table function

#2======================================================================================================
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
deep_columns <- select(studentdata, one_of(deep_questions))
studentdata$deep <- rowMeans(deep_columns)
surf_columns<-select(studentdata,one_of(surface_questions))
studentdata$surf<-rowMeans(surf_columns)
stra_columns<-select(studentdata,one_of(strategic_questions))
studentdata$stra<-rowMeans(stra_columns)

studentdata$attitude <- studentdata$Attitude / 10
student_sub<-dplyr::select(studentdata,c("gender","Age","attitude", "deep", "stra", "surf", "Points"))
#I know the exercise.2 does it slightly differently, but for me this way is more intuitive 
str(student_sub)

#Filter data to exclude rows where Points are 0
student_sub<-filter(student_sub,Points!=0)
str(student_sub)

#3======================================================================================================
glimpse(student_sub) #glimpse is an alternative that i use as it gives the data type (chr, int, dbl) in a nicer format
head(student_sub)
write.csv(student_sub,"learning2014.csv")
#this code saves the dataset straight into my working directory because i called the code #library(here) at the start. 
#otherwise, i will have to copy paste file location in front of the .csv

