# Reading mySQL

# Data is structured in
#   * Databases
#     * Tables within databases (comparable to data frames)
#       * Fields within tables
# Each row is called a record

install.packages('RMySQL')
library(RMySQL)

# Connect to the University of California Santa Cruz Genomic mySQL server
ucscDb <- dbConnect(MySQL(), user="genome",
                    host='genome-mysql.cse.ucsc.edu')
# pass the query "show databases" to the mysql server
result <- dbGetQuery(ucscDb, "show databases;")
# disconnect from the ucsc server
dbDisconnect(ucscDb)

result

# Connect to the HG19 database of the UCSC mysql server
hg19 <- dbConnect(MySQL(), user='genome', db="hg19",
                  host='genome-mysql.cse.ucsc.edu')
# What tables are in the database?
allTables <- dbListTables(hg19)
# How many tables?
length(allTables)
head(allTables)

# Let's look at a specific table(think dataframe)
# What are the fields (think column names)
dbListFields(hg19,'affyU133Plus2')
# How many rows/records does the table have?
dbGetQuery(hg19, "select count(*) from affyU133Plus2")
# We can donwload the table locally
affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)

# mySQL tables can be enormous, much too big to load into R
# When using mySQL you may want to subset the data
query <- dbSendQuery(hg19, "select * from affyu133Plus2 where misMatches between 1 and 3")
                              # * denotes all observations
# Those results are currently stored on the remote server. 
# Use fetch to get the results
affyMis <- fetch(query)
quantile(affyMis$misMatches)

# fetch can return a subset of the data as well
affyMis <- fetch(query, n=10); dbClearResult(query)
dim(affyMisSmall)
dbDisconnect(hg19)

# additional information
# RMySQL vignette http://cran.r-project.org/web/packages/RMySQL/RMySQL.pdf
# List of commands http://www.pantz.org/software/mysql/mysqlcommands.html
# A nice blog post summarizing some other commands http://www.r-bloggers.com/mysql-and-r/

# ---------------------------------------------------------------------------------------

# Reading HDF5
# High Performance data storage
# * Used for storing large data sets
# * Supports storing a range of data types
# * Heirarchical data format == HDF
# * /groups/ containing zero or more data sets and metadata
#     * Have a /group header/ with group name and list attributes
#     * Have a /group symbol table/ with a list of objects in group
# * /datasets/ multidimensional array of data elements with metadata
#     * Have a /header/ with name, datatype, dataspace, and storage layout
#     * Have a /data array/ with the data (think )

getwd()
setwd('./course.work/coursera/johns hopkins university/Getting and Cleaning Data')

# The hdf5 package is hosted through the bioconductor project
download.file("http://bioconductor.org/biocLite.R", destfile='biocLite.R', method = 'curl')
source('biocLite.R')
biocLite("rhdf5")

# Let's start by creating a hdf5 file
library(rhdf5)
created<-h5createFile('example.h5')

# Create two groups 
created = h5createGroup('example.h5', 'foo')
created <- h5createGroup('example.h5', 'baa')

# Create a subgroup
created <- h5createGroup('example.h5', 'foo/foobaa')

# Take a look at what we created
h5ls("example.h5")

# Write to groups
A = matrix(1:10, nr=5, nc=2)
h5write(A, 'example.h5', 'foo/A')
B = array(seq(0.1, 2.0, by = 0.1), dim=c(5,2,2))
attr(B, "scale") <- "liter"
h5write(B, "example.h5", "foo/foobaa/B")
h5ls("example.h5")

df <- data.frame(1L:5L, 
                 seq(0,1,length.out=5),
                 c('ab', 'cde', 'fghi', 'a', 's'), 
                 stringsAsFactors=FALSE)
df

h5write(df, 'example.h5', 'df')
h5ls('example.h5')

# Okay now that we have a hdf5 file to work with, 
#     let's try reading some information back out of it
readA <- h5read('example.h5', 'foo/A')
readA
all(readA == A)
readB <- h5read('example.h5', 'foo/B')

# Let's modify the h5 file
h5write(c(12,13,14), 'example.h5', 'foo/A', index = list(1:3,1))
h5read('example.h5', 'foo/A')
h5read('example.h5', 'foo/A', index = list(2:4,2))

# hdf5 can be used to optimize reading writing from disk in R
# tutorial: http://www.bioconductor.org/packages/release/bioc/vignettes/rhdf5/inst/doc/rhdf5.pdf

# Reading Data from the Web
# Webscraping

con <- url("http://scholar.google.com/citations?user=HI-I60AAAA&hl=en")
htmlcode <- readLines(con)
close(con)
htmlcode

library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C)AAAAJ&h1=en"
html <- htmlTreeParse(url, useInternalNodes=TRUE)
xpathSApply(html, '//title', xmlValue)
xpathSApply(html, "//td[@id='col-citedby']", xmlValue)

library(httr); html2 <- GET("http://scholar.google.com/citations?user=HI-I6C)AAAAJ&hl=en")
content2 <- content(html2, as="text")
parsedHtml <- htmlParse(content2, asText=TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)

pg2 <- GET("http://httpbin.org/basic-auth/user/passwd",
            authenticate("user","passwd"))
pg2
names(pg2)
# Using handles
google <- handle("http://google.com")
pg1 <- GET(handle = google, path = '/')
pg2 <- GET(handle = google, path = 'search')

