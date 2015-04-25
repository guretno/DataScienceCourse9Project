Top n Ranks Irish Baby Names
========================================================
author: Feri Guretno
date: 25/04/2015

Advantage of the Ranking of Baby Names
========================================================
Every parents surely want to give the best names for their baby. Usually they will look up from baby names dictionary and see the meaning of the names. We hope that by visualize the Top n Rank of Baby names for given year, parents can use this as reference of what is the most popular baby names for every given year.

Chosen the most popular baby names may not be always the option by most parents since they sometimes want to give a unique names instead.

Data
========================================================
The data was downloaded from Central Statistics Office. The data then further pre-processed into a useful format using R and a px package than can be visualized in the plot diagram.

```{r, echo=FALSE}
library(shiny)
library(ggplot2)
library(pxR)

# load the data sets
boys  <- read.px("./data/boys.px")

data <- boys$DATA$value

# Convert the dataframe into a long format manually
l <- length(data$value)

# initialize empty vector to hold amounts
amount <- c()

# If the row is odd then add the next row's value to it
for (i in 1:l){
if (i%%2 == 1){
  amount <- c(amount, data$value[i+1])
}
}

# append the amount to the rank row
DF <- with(data, subset(data, Statistic == "Rank of Name in Ireland (Number)"))
DF$amount <- amount
DF$Statistic <- NULL
names(DF) <- c("Year", "Name", "Rank", "Amount")

# get the names for the top n ranks for a specific year
DF2 <- with(DF, subset(DF, Year == "2010" & Rank %in% c(1:5)))

DF2
```

And the visualized bar graph

```{r, echo=FALSE}
names <- DF$Name
  
  # Plot the graph
  p1 <- ggplot(data = DF, aes(x = Rank, y = Amount, fill = Name))

  # Plot in bar graph and stacked it if both gender is chosen
  p1 + 
    geom_bar(stat = "identity") + 
    geom_text(aes(label = Amount), size = 3, hjust = 0.5, vjust = 3, position =     "stack") +
    labs(title = 'Top n Rank Irish Babies Name',
         y = 'Number of babies', x = 'Rank', fill = 'Name')
```


Using the App
========================================================

Specifiy the following using slider bars & dropdown box:
- Year (e.g. 2013)
- Sex ( Male, Female, Both)
- Top n Ranks ( e.g. 3 ranks)

About
========================================================

This applet was made as a project for Coursera's class on Developing Data Products. 

It uses data available from the Central Statistics Office in order to generate graphs on the most popular baby names in Ireland for specific years. ("http://www.cso.ie/px/pxeirestat/database/eirestat/Irish%20Babies%20Names/Irish%20Babies%20Names_statbank.asp")

It was written in R and hosted by shiny apps at https://efge.shinyapps.io/TopRankIrishBabyNames/
