library(shiny)

# Define UI for application that draws a plot
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Top n Ranks of Irish Baby Names"),
  
  # Sidebar with a slider input for the mean, sd and obs
  sidebarLayout(
    sidebarPanel(
    
      
      br(), 

      helpText("This is an application to visualize and explore the popularity of Irish babynames provided by Central Statistics Office. Yearly Top n ranks of the most popular baby names will be displayed based on the user input."),
      
      br(),
      
      helpText("Specify the year, gender and number of Names you want to include to diplay the ranking.he gender can be Male, Female or both."),
      
      br(),

      p("Data obtained from ",
        a("Central Statistics Office.", 
          href = "http://www.cso.ie/px/pxeirestat/database/eirestat/Irish%20Babies%20Names/Irish%20Babies%20Names_statbank.asp")),

      textInput("year", value = "2013", label = h4("Year:")), 

      selectInput(inputId = "sex",
            label = "Sex:",
            choices = c("Male" = "male", 
                        "Female" = "female",
                        "Both" = "both"),
            selected = "boys"),
      
      sliderInput("number",
                  "Top n Rank:",
                  min = 1,
                  max = 20,
                  value = 4),

      submitButton("Update")
      
   
           
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
#       verbatimTextOutput("year"),
#       verbatimTextOutput("sex"),
#       verbatimTextOutput("number")
    )
  )
))