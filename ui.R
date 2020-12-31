library(shinydashboard)

skin <- Sys.getenv("DASHBOARD_SKIN")
skin <- tolower(skin)
if (skin == "")
    skin <- "black"


sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("EDA", tabName = "eda", icon = icon("dashboard")),
        menuItem("Predictions-ARIMA", icon = icon("bar-chart-o"),tabName = "arima"
                # menuSubItem("ARIMA", tabName = "arima"),
                 #menuSubItem("Monte-Carlo", tabName = "montecarlo")
        )
    )
)

body <- dashboardBody(
    tabItems(
        tabItem("eda",
                
                # Boxes with solid headers
                fluidRow(
                    box(
                        title = "Enter Stock Code", width = 4, solidHeader = TRUE, status = "primary",
                        selectInput("StockCode1", "Stock Code", choices = c("AAPL (Apple)" = "AAPL",
                                                                            "AMZN (Amazon)" = "AMZN",
                                                                            "GOOG (Goolge)" = "GOOG",
                                                                            "F (Ford)" = "F",
                                                                            "GM(General Motors)"= "GM",
                                                                            "TSLA (TSLA)" = "TSLA")),
                        dateInput("start_date1", "Start Date", value = "2010-11-18"),
                        dateInput("end_date1", "End Date", value = "2020-01-31"),

                        actionButton(inputId = "click1", label = "Show")
                    )
                    
                ),
                fluidRow(
                    
                    box(
                        title = "Chart Series",
                        status = "primary",
                        plotOutput("chartseries", height = 350),
                        height = 500
                    ),
                    box(
                        title = "Yearly Return",
                        width = 6,
                        plotOutput("yearlyReturn", height = 350),
                        height = 500
                    )
                    
                )
        ),
        tabItem("arima",
                # Boxes with solid headers
                fluidRow(
                    box(
                        title = "Enter Stock Code", width = 4, solidHeader = TRUE, status = "primary",
                        selectInput("StockCode", "Stock Code", choices = c("AAPL (Apple)" = "AAPL",
                                                                          "AMZN (Amazon)" = "AMZN",
                                                                          "GOOG (Goolge)" = "GOOG",
                                                                          "F (Ford)" = "F",
                                                                          "GM(General Motors)"= "GM",
                                                                          "TSLA (TSLA)" = "TSLA")),
                        dateInput("start_date", "Start Date", value = "2010-11-18"),
                        dateInput("end_date", "End Date", value = "2020-01-31"),
                        textInput("days", "How many days of future prection", value = 180),
                        actionButton(inputId = "click", label = "Predict")
                    )
                    
                ),
                fluidRow(
                    
                    box(
                        title = "Auto Arima",
                        status = "primary",
                        plotOutput("auto.arima", height = 350),
                        height = 400
                    ),
                    box(
                        title = "Auto Arima - Forecast Point(Last 10 Days)",
                        
                        width = 6,
                        tableOutput("auto.arima1"),
                        height = 400
                    ),
                    box(
                        title = "Mean forecasting prediction tendency",
                        plotOutput("auto.arima2", height = 350),
                        height = 400
                    )
                    
                )
                )
    )
    
)

header <- dashboardHeader(
    title = "Stock Market Analysis"
)

ui <- dashboardPage(header, sidebar, body, skin = skin)