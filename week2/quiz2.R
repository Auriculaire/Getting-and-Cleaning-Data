2013-11-07T13:25:07Z

download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv',destfile = 'getdata-data-ss06pid', method = 'curl')
acs <- read.csv('getdata-data-ss06pid')
install.packages('sqldf')

library('sqldf')
head(sqldf("select pwgtp1 from acs where AGEP < 50"))
sqldf("select AGEP where unique from acs")

all(sqldf("select distinct AGEP from acs") == unique(acs$AGEP))

library(XML)
url <- "http://biostat.jhsph.edu/~jleek/contact.html"
html <- htmlTreeParse(url, useInternalNodes=TRUE)
class(html)
con <- url(url)
htmlCode <- readLines(con)
nchar(c(htmlCode[10], htmlCode[20], htmlCode[30], htmlCode[100]))

download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for', 
              destfile = 'getdata-wksst8110.for', method = 'curl')

sum(read.fwf('getdata-wksst8110.for', skip = 4, widths=c(12, 7,4, 9,4, 9,4, 9,4))[,4])
