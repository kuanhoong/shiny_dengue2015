## app.R ##

#to run this code, this must be placed inside the session working directory; install shiny, shinydashboard, and ggplot2; in the console: runApp()

#install.packages(c("devtools", "shiny"))
#devtools::install_github("rstudio/shinydashboard")
#install.packages("ggplot2"")

library(shiny)
library(shinydashboard)
library(ggplot2) 

#this is the data source
dengue2015<-read.csv("dengue2015.csv")

ui <- dashboardPage (
  dashboardHeader(title = "2015 Malaysia Dengue Outbreak"),
  dashboardSidebar(
    sidebarMenu(
    menuItem("Dengue Table", tabName = "tableView", icon = icon("tasks")),
    menuItem("Total Outbreak by States", tabName = "outbreakByStates", icon = icon("star")),
    menuItem("Outbreak Duration by States", tabName = "outbreakDurationByStates", icon = icon("fire")),
    menuItem("Help/Documentation", tabName = "help", icon = icon("question"))
    )
  ),
  dashboardBody (
    width = 700,
    tabItems(
      tabItem(tabName = "tableView",
      h2("Dengue 2015 Table"), 
      dataTableOutput("dengueTable")
      ),
      tabItem(tabName = "outbreakByStates",
        box(plotOutput("outbreakByStates"),
            height = 500, width = 700
              )
      ),
      tabItem(tabName = "outbreakDurationByStates",
        selectInput("byState",
        label="State",
        choices=c("Johor", "Melaka", "Pahang", "Penang", "Perak","Sabah","Sarawak","Selangor"),
        selected="Selangor",
        width = 200),
                          
        box(plotOutput("outbreakDurationByStates"),
        height = 500, width = 700
              )
      ),
      tabItem(tabName = "help", 
h1("About 2015 Malaysia Dengue Dashboard"),

div(class = "about-class", p("I am currently a senior lecturer in the Faculty of Computing and Informatics at Multimedia University."), 
    
p("This project made use of the following packages: shiny, shinydashboard, ggplot to display plot and analysis of 2015 Malaysia Dengue Outbreak Data. Dengue Dataset is available from http://data.gov.my/view.php?view=254"), 

p("The first menu on the left displays the 2015 Malaysia Dengue data inside a table. The second menu is Total Dengue Outbreak by States. The third menu is a jitter plot of Week No vs Outbreak Duration by State."),

p("For more info on other big data projects, please do contact me: kuanhoong@gmail.com"))
      )
    )
  )
)

server <- function(input, output) {
  
  output$dengueTable <- renderDataTable({ dengue2015 })
  
  output$outbreakByStates <- renderPlot({
    #Histogram plots for Total Cases
    #grouped by number of states (indicated by color)
   ggplot(data=dengue2015, aes(x=dengue2015$State, fill=dengue2015$State)) + geom_bar()+labs(title="2015 Malaysia Total Dengue Outbreak Cases by States", x="States",y="Total Cases", fill="States")
  })

output$outbreakDurationByStates<-renderPlot({
  #Jitter plots for Outbreak Duration by State
  dengue2015.filter<-dengue2015[dengue2015$State==input$byState,]
  
  ggplot(data=dengue2015.filter, aes(x=dengue2015.filter$Week, y=dengue2015.filter$Duration))+geom_jitter(color="blue")+labs(title="2015 Malaysia Total Dengue Outbreak Cases", x="Week No",y="Outbreak Duration")
})
}

shinyApp(ui = ui, server = server)