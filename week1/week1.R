# Determining and changing the working directory
getwd()
setwd('.')

#Determining the contents of a directory
list.files('.')

# Checking for and creating directories
if(!file.exists('data')){
  dir.create('data')
}

# Getting files from the internet
fileUrl <- 'http://i2.kym-cdn.com/photos/images/newsfeed/000/406/325/b31.jpg'
download.file(fileUrl, destfile = './data/cat.jpg', method='curl')
dateDownloaded <- date()

# Reading excel files
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
download.file(fileUrl, destfile='./data/cameras.xlxs', method='curl')
dateDownloaded <- date()

# xlxs package is currently unavailable for R version 3.12
# install.packages("xlxs")
# library(xlxs) 
# cameraData <- read.xls("./data/cameras.xlxs",sheetIndex = 1, header = TRUE)
# colIndex <- 2:3
# rowIndex <- 1:4
# cameraDataSubset <- read.xls("./data/cameras.xlxs",sheetIndex = 1, 
#                              colIndex = colIndex, rowIndex=rowIndex)
# cameraDataSubset

install.packages("gdata") # XLConnect another option as well
library(gdata) 
cameraData <- read.xls("./data/cameras.xlxs",sheet = 1)
head(cameraData)

# Reading XML
install.packages("XML")
library(XML)
fileUrl <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileUrl, useInternal=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)
# Access various tags of the xml file as a list
rootNode[[1]]
# May be done recursively
rootNode[[1]][[1]]
# Look at each tag
xmlSApply(rootNode,xmlValue)
# Retreiving various tage values using xpath language
#   /node Top level node
#   //node Node at any level
#   node[@attr-name] Node with an attribute name
#   node[@attr-name='bob'] Node with an attribute name='bob'
# more info http://www.stat.berkeley.edu/~statcur/Workshop2/Presentations/XML.pdf

# names
xpathSApply(rootNode,'//name',xmlValue)
#price
xpathSApply(rootNode,'//price',xmlValue)

#Let's try applying what we learned to the Baltimore Ravens ESPN site
fileUrl <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileUrl, useInternal=TRUE)
scores <- xpathSApply(doc, "//li[@class='score']", xmlValue)
  # tag name is li (li means list apparently)
  # // indicates the tag is sought at any level
  # [@class] indicates the tag should have an attribute called class
  # [@class = 'score'] only return instances in which the class attribute has a value of 'score'
scores

teams <- xpathSApply(doc, "//li[@class='team-name']", xmlValue)
teams

# short tutorial for XML http://www.omegahat.org/RSXML/shortIntro.pdf
# long tutorial for XML http://www.omegahat.org/RSXML/Tour.pdf
# guide to XML package http://www.stat.berkeley.edu/~statcur/Workshop2/Presentations/XML.pdf

# Reading Json
# Javascript Object Notation
# similar idea to XML but different syntax

install.packages('jsonlite')
library(jsonlite)
jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)
# object mat be nested. Taking an object from the previous command
names(jsonData$owner)
jsonData$owner$login
# R data frames may be easily exported to JSON format
myjson <- toJSON(iris, pretty=TRUE)
cat(myjson)
# or visa-versa
iris2 <- fromJSON(myjson)
head(iris2)

# more info http://www.json.org/
# tutorial on jsonlite http://www.r-bloggers.com/new-package-jsonlite-a-smarter-json-encoderdecoder/
# jsonlite vignette http://cran.r-project.org/web/packages/jsonlite/vignettes/json-mapping.pdf

# Data tables are a faster and more memory efficient implementation of the data frame
install.packages("data.table")
library("data.table")
# Data tables have the same initiation format
DF <- data.frame(x=rnorm(9),y=rep(c('a','b','c'), each=3), z=rnorm(9))
head(DF,3)
DT <- data.table(x=rnorm(9),y=rep(c('a','b','c'), each=3), z=rnorm(9))
head(DT,3)

# To see all data tables currently in memory
tables()

# Subsetting data tables
DT[2]
DT[DT$y == 'a',] # same as a data frame

# subsetting columns is different than in data frames
DF[,c(2,3)]
DT[,c(2,3)]
# instead, the second indices are used for calculating functions over columns
DT[, mean(x)] # 1 function
DT[, list(mean(x), sum(z))] # multiple functions
DT[,table(y)]

# adding new columns
DT[,w:=z^2]
DT[, m:={tmp <-(x+z);log2(tmp+5)}] # chained operations
DT           #whereas data frames would create a new instance for the operation, 
             #  tables do the operation on the current instance
DT[,a := x>0] # plyr-like operations
DT[,b:=mean(x+w),by=a]

# while ths improves memory performance (and allows for larger data sets), it has implictions.
DT2 <- DT
DT2
DT[,y:=2]
DT2       #so it works a lot like python

# To make a copy, an explicit command must be used
DT2 <- copy(DT)
DT[,y:=3]
head(DT,n=3)
head(DT2,n=3)

# Special variables
# .N An integer, length 1, containing the number
set.seed(123);
DT <- data.table(x=sample(letters[1:3], 1E5, TRUE))
DT
DT[, .N, by=x]
DT  # basically .N counts the instances of each unique element om a specofoed column.

# Data tables have keys and can be indexed much more rapidly than data.frames
DT <- data.table(x = rep(c('a','b','c'), each=100), y=rnorm(300))
DT
setkey(DT, x)
DT['a']

# Data tables can be rapidly joined
DT1 <- data.table(x=c('a','a','b','dt1'), y=1:4)
DT2 <- data.table(x=c('a','b','dt2'), z=5:7)
setkey(DT1, x); setkey(DT2, x)
DT1
DT2
merge(DT1,DT2)
