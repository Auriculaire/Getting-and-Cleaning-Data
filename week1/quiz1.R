getwd()
setwd('./course.work/coursera/johns hopkins university/Getting and Cleaning Data')
fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
args(download.file)
download.file(fileUrl, destfile = './data/quiz1.csv', method = "curl")
quiz1 <- read.csv('./data/quiz1.csv')
names(quiz1)
length(which(quiz1$VAL == 24))

library(gdata) 
fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx'
download.file(fileUrl, destfile = './data/quiz1.xlsx')
quiz1 <- read.xls('./data/quiz1.xlsx', sheet=1)
dat <- quiz1[18:23, 7:15]
sum(dat$Zip*dat$Ext,na.rm=T)
names(quiz1)

library(XML)
fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml'
quizXml <- download.file(fileUrl, destfile='./data/quiz1.xml', method='curl')

fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
download.file(fileUrl, destfile = './data/quiz1.b.csv', method='curl')
DT <- fread('./data/quiz1.b.csv')
names(DT)

system.time(mean(DT$pwgtp15,by=DT$SEX))
system.time(DT[,mean(pwgtp15),by=SEX])
system.time(mean(DT[DT$SEX==1,]$pwgtp15)) + system.time(mean(DT[DT$SEX==2,]$pwgtp15))
system.time(rowMeans(DT)[DT$SEX==1]) + system.time(rowMeans(DT)[DT$SEX==2])
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
