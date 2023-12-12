
bprs<-read.delim2("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt",header = TRUE, sep = " ", dec = ",")

rats<-read.delim2("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt",header = TRUE, sep = "\t", dec = ",")


names(bprs)
summary(bprs)


#This is a repeated measures dataset with 40 rows and 11 columns. There are 2 types of treatments (1 and 2) and 20 participants in each treatment. The treatments have been repeated over a period of 8 weeks on each participant, with an initial measurement at week0. 


names(rats)
summary(rats)

#### **Task 2 - Factorise variables** 

#The two categorical variables in bprs dataset are the Treatment type and the Subject, the rest are continuous. 
bprs$treatment<-as.factor(bprs$treatment)
bprs$subject<-as.factor(bprs$subject)

#In rats data its the ID and Group variables that are categorical, and the rest are continous. 
rats$ID<-as.factor(rats$ID)
rats$Group<-as.factor(rats$Group)


#### **Task 3 - Reshape the dataframes** 

bprslong<-pivot_longer(bprs, 
                       cols = -c(treatment, subject),
                       names_to = "weeks",
                       values_to="values")%>%arrange(weeks)
head(bprslong)

ratslong<-pivot_longer(rats, 
                       cols = -c(ID, Group),
                       names_to = "time",
                       values_to="values")%>%arrange(time)
head(ratslong)

#### **Task 4 - Understand the long format** 

#View(bprslong)
summary(bprslong)

#View(ratslong)
summary(ratslong)



#The long format allows us to structure data in a way that separates the repeated measures or the "nestedness" of the data from the measurements which are always continuous and numerical. The long format is necessary for linear mixed models that require all the predictor variables under one variable name (syntax wise as well as model interpretation wise), separated from the identity of variables that tells us about the hierarchy in the data (nestedness/repeated measures). 

#The bprs long format has 360 rows and 4 variables, compared to the 40 rows and 11 variables in wide format. Each treatment is comprised of 180 values, the measurement for each subject is repeated 9 times (including week0) under each treatment. The values for the subjects under both treatment ranges between 18 and 95. This is a balanced dataset that has equal number of values for each treatment and subject. 

#Similarly, the rats long format has 176 observations and 4 variables vs 16 obs and 13 variables in the wide format. Group one has 88 observations compared to group 2 and 3, so this is not a balanced dataset. Values for treatment range between 225 and 628.  

