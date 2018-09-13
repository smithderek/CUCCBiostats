
######################################
#1) Set data frame based on REDCap   #
######################################
#Sample size of 96 needed, 48 per treatment group, 12 per stratification group, randomize an additional 96 for 192 total allocations

#data frame based on variables used in randomization- 40 patients per each combo of gender and age, based on total randomization n
temp<-data.frame(sex=rep(c(1,2),each=96), age_grp=rep(rep(c(1,2),each=48),2))
  #check 
  table(temp)
  
#######################
#2) Input parameters  #
#######################

set.seed(4576) #change from development/ testing to production

n_groups<-2 #number of study groups
block_size<-6  #must be a multiple of the sum of ratio of group allocation, i.e. 1:1 needs multiple of 2, 
                #also needs to be multiple of number stratification groups, i.e. 2 sex levels x 2 age groups
                #also needs to be a factor of number of subjects in each stratification group
n_tot<-192 #must be a multiple of the block size, inflate needed sample size to allow for additional randomizations

#############################
#3) Generate randomization  #
#############################
x<-NULL #randomization variable

z<-seq(1,n_tot,block_size) #set break points for each block 

#group assignment for each block
for(i in z){
  x[i:(i+(block_size-1))]<-c(sample(c(rep(1:n_groups,each=block_size/n_groups))))
  x
}

##########################################
#4) Create randomization allocation table#
##########################################

#add randomization to dataset created earlier
dat<-cbind(trt_grp=x, temp)

#check
table(dat$trt_grp,dat$sex,dat$age_grp)

#export
write.csv(dat,'test_allocation.csv',row.names=FALSE)
