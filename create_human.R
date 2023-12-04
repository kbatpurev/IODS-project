#Author: Khorloo Batpurev
#Date: 28/11/2023
#This R script does the following steps:
#1. Reads in human development and gender inequality data
#2. Creates a summary dataframe of relevant variables
#3. Makes column names easier to type
#4. Creates 2 new variables in Gender inequality data
.libPaths()
.libPaths(new="C:/LocalData/batkhor/Packages")

library(here)
library(dplyr)
library(data.table)
library(readr)
library(boot)

print(date())

#1==============================================================================================================================================
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

#2==============================================================================================================================================
str(hd)
glimpse(hd)

str(gii)
glimpse(gii)

#After exploring the data, i decided to join them so that its in one place
df<-left_join(hd, gii, by="Country")
glimpse(df)
df$Country<-as.factor(df$Country)
vars<-df[,c(3:7,10:17)] #I removed the ranks, country name, and GNI per Capita Rank minus HDI Rank variables from the summary table because it doesn't make sense to to arithmatics on them. 
df_summary<-as.data.frame(colMeans(vars, na.rm = TRUE))
df_summary

#3==============================================================================================================================================
lookup <- c(hdi_rank = "HDI Rank" , 
            hdi = "Human Development Index (HDI)",
            life_exp="Life Expectancy at Birth",
            exp_edu="Expected Years of Education",
            mean_edu="Mean Years of Education",
            gni="Gross National Income (GNI) per Capita",
            gni_per_cap="Gross National Income (GNI) per Capita",
            gni_diff_hdi="GNI per Capita Rank Minus HDI Rank",
            gii_rank="GII Rank",
            gii="Gender Inequality Index (GII)",
            mat_mort="Maternal Mortality Ratio",
            ad_birth="Adolescent Birth Rate",
            perc_parl="Percent Representation in Parliament",
            fem_sec="Population with Secondary Education (Female)",
            male_sec="Population with Secondary Education (Male)",
            fem_part="Labour Force Participation Rate (Female)",
            male_part="Labour Force Participation Rate (Male)")
df<-rename(df, all_of(lookup))
#4==============================================================================================================================================
#I am going to continue with the big dataframe
df<-df%>%mutate(prop_secondary_ed=fem_sec/male_sec,
                prop_labour=fem_part/male_part) 
glimpse(df)
#5==============================================================================================================================================
#I did this in Step 2. 
str(df)
#19 (17 original + 2 new) variables from 195 Countries

write_csv(df,"C:/LocalData/batkhor/Coursework/IODS_23/IODS-project/human_data_for_ex5.csv")


