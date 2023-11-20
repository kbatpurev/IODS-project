#Author: Khorloo Batpurev
#This R script does the following steps:
#1. Reads the data into R
#2. Joins the data
#3. Removes duplicates
#4. Some queries in the data (determine high alcohol use)
#5. Saves the final dataset

library(here)
library(dplyr)
library(data.table)
library(readr)
library(boot)

print(date())
#Data comes from this
source_url<-"https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets"

#1======================================================================================================
#Read the data in - I did this locally on my computer
setwd("C:/LocalData/batkhor/Coursework/IODS_23/IODS-project/")
studentmat<-read.delim2("Data/student-mat.csv", header = TRUE, sep = ";")
str(studentmat)
studentport<-read.delim2("Data/student-por.csv",header=TRUE,sep=";")
str(studentport)

#2======================================================================================================
#Join the data 
#First define the columns that we don't want
free_cols<-c("failures","paid","absences","G1","G2","G3")

#Subset from the original dataframe columns
join_cols <- setdiff(colnames(studentmat), free_cols)

#merge it
students_inboth<-merge(studentmat,studentport,by=join_cols)
print(nrow(students_inboth)) # 370 students
dim(students_inboth)
glimpse(students_inboth)
#3======================================================================================================
unique_students<-distinct(students_inboth)
dim(unique_students)
#Dimension doesn't seem to have changed! So they must have all been unique rows

#4======================================================================================================
#Some queries (determine high alcohol use)
unique_students<-unique_students%>%mutate(alc_use_weekday=mean(Dalc),#average of weekday
                                          alc_use_weekend=mean(Walc),#average of weekend
                                          alc_use=(Dalc+Walc)/2)#global average of alcohol consumption throughout the week

#The following case_when statement does individual's alcohol intake either on weekday or weekend, 
#and then the average of all students' alcohol use throughout the week. Note that the answers are different. 
#Just goes to show slight differences in ways interpret the question makes a big difference. 
unique_students<-unique_students%>%mutate(high_use_each_case=case_when(Dalc>2|Walc>2 ~TRUE,TRUE~FALSE),
                                          high_use=case_when(alc_use>2~TRUE,TRUE~FALSE))
#The true/false thing makes it a little awkward with this script. Basically what follows the first "~" is what should appear 
#in the alc_use column if the logical statement is true.In this case, if such and such is above 2, its true, otherwise false.
#Then after the ",TRUE~" is what will appear when the logical statement is false. Note these can be 
#character strings if hashed inside " ". 

#5======================================================================================================
glimpse(unique_students)
print(nrow(unique_students))
#370 students
write_csv(unique_students,"students_from_math_and_porteguese_classes_and_alc_consumption.csv")
