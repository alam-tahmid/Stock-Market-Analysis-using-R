library('quantmod')
library('ggplot2')
library('forecast')
library('tseries')
library(quantmod)
library(dplyr)


server <- function(input, output) {
    

    set.seed(122)
    histdata <- rnorm(500)
    
    
    #Auto.Arima - plot
    output$auto.arima <- renderPlot({
        
        if (is.null(input$StockCode) || is.null(input$StockCode))
            return()
        
        data <- eventReactive(input$click, {
            (input$StockCode) 
        })
        Stock <- as.character(data())
        print("In Arima Plotting")
        print(Stock)
        
       # term <- 180
        term <- input$days
        Stock_df<-as.data.frame(getSymbols(Symbols = Stock, 
                                           src = "yahoo", 
                                           from =input$start_date,
                                           to =input$end_date, 
                                           env = NULL))

        Stock_df$Close = Stock_df[,4]

        #arima
        fit <- auto.arima(Stock_df$Close,seasonal = FALSE)
        fit.forecast <- forecast(fit, h = term)
        plot(fit.forecast,  main = Stock)
        fit.forecast
        
    })
    
    #Auto.Arima1 - Table
    output$auto.arima1 <- renderTable({

        if (is.null(input$StockCode) || is.null(input$StockCode))
            return()
        
        data <- eventReactive(input$click, {
            (input$StockCode)
        })
        Stock <- as.character(data())
        print(Stock)
        term <- input$days
        Stock_df<-as.data.frame(getSymbols(Symbols = Stock, 
                                           src = "yahoo", 
                                           from =input$start_date,
                                           to = input$end_date,
                                           env = NULL))

        Stock_df$Close = Stock_df[,4]
        #arima
        fit <- auto.arima(Stock_df$Close,seasonal = FALSE)
        fit.forecast <- forecast(fit, h = term)
        fit.forecast <- as.data.frame(fit.forecast)
        (tail(fit.forecast, n = 10))
    })
    
    #Auto.Arima - Mean Tendency
    output$auto.arima2 <- renderPlot({
        
        if (is.null(input$StockCode) || is.null(input$StockCode))
            return()
        
        data <- eventReactive(input$click, {
            (input$StockCode) 
        })
        Stock <- as.character(data())
        print(Stock)
        
        Stock_df<-getSymbols(Symbols = Stock, 
                                           src = "yahoo", 
                                           from =input$start_date,
                                           to =input$end_date, 
                                           env = NULL)
        
        close <- Stock_df[,4]
        N <- length(close)
        n <- 0.7*N
        train <- close[1:n, ]
        test  <- close[(n+1):N,  ]
        
        trainarimafit <- auto.arima(train, lambda = "auto")
        predlen <- length(test)
        trainarimafit <- forecast(trainarimafit, h=predlen)
        meanvalues <- as.vector(trainarimafit$mean)
        precios <- as.vector(test)
        
        plot(meanvalues, type= "l", col= "red", main = Stock, ylab = "Mean Value")
        lines(precios, type = "l")
        
    })
    
    #Chart Series
    output$chartseries <- renderPlot({
        
        if (is.null(input$StockCode1) || is.null(input$StockCode1))
            return()
        
        
        print("In chart sereies")
        data <- eventReactive(input$click1, {
            (input$StockCode1)
        })
        Stock <- as.character(data())
        print(Stock)
        
        Stock_df<- getSymbols(Symbols = Stock, 
                                           src = "yahoo", 
                                           from =input$start_date1,
                                           to = input$end_date1,
                                           env = NULL)
        Stock_df%>%
            Ad()%>%
            chartSeries(theme = "white",
                        TA="addEMA(50, col='red');addEMA(100, col='blue');addEMA(200, col='yellow')",
                        name = Stock)
    })
    output$yearlyReturn <- renderPlot({
        
        if (is.null(input$StockCode1) || is.null(input$StockCode1))
            return()
        
        data <- eventReactive(input$click1, {
            (input$StockCode1)
        })
        Stock <- as.character(data())
        
        print("In the yearly return")
        print(Stock)
        
        Stock_df<- getSymbols(Symbols = Stock, 
                              src = "yahoo", 
                              from =input$start_date1,
                              to =input$end_date1,
                              env = NULL)
        
        
        yearly_return <- yearlyReturn(Stock_df)
        yearly_return_df <- data.frame(Date = index(yearly_return), coredata(yearly_return)*100)
        
        ggplot(yearly_return_df,aes(x=Date,y=yearly.returns)) + geom_line()
    })
    
}