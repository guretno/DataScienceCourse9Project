library(shiny)
library(ggplot2)
library(pxR)

# load the data sets
boys  <- read.px("./data/boys.px")
girls <- read.px("./data/girls.px")

# Function to pre-process the data
getData <- function(sex){
  
  # preprocess the data
  if (sex == "male"){
    data <- boys$DATA$value
  }
  if (sex == "female"){
    data <- girls$DATA$value
  }
  if (sex == "both"){
    data <- rbind(boys$DATA$value, girls$DATA$value)
  }
  
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
  DF
}

# pre-process both the data sets
male_data <- getData("male")
female_data <- getData("female")
both_data <- getData("both")

getTopRanks <- function(sex, n, year) {
  
  # get the processsed data 
  if (sex == "male"){
    data <- male_data
  }
  if (sex == "female"){
    data <- female_data
  }
  if (sex == "both"){
    data <- both_data
  }
  
  
  # get the names for the top n ranks for a specific year
  DF <- with(data, subset(data, Year == year & Rank %in% c(1:n)))
  names <- DF$Name
  
  # Plot the graph
  p1 <- ggplot(data = DF, aes(x = Rank, y = Amount, fill = Name))

  # Plot in bar graph and stacked it if both gender is chosen
  p1 + 
    geom_bar(stat = "identity") + 
    geom_text(aes(label = Amount), size = 3, hjust = 0.5, vjust = 3, position =     "stack") +
    labs(title = 'Top n Rank Irish Babies Name',
         y = 'Number of babies', x = 'Rank', fill = 'Name')

}

# Define server logic required to draw a histogram
shinyServer(
  
  function(input, output) {
    
    #
    #  1) It is "reactive" and therefore should re-execute automatically
    #     when inputs change
    #  2) Its output type is a plot
    
    output$distPlot <- renderPlot({
      
      # Extract input values
      year <- input$year
      sex  <- input$sex
      number    <- input$number
      
      output$year <- renderPrint(year)
      output$sex <- renderPrint(sex)
      output$number <- renderPrint(number)
      
      getTopRanks(sex, number, year) 
    })
  })
