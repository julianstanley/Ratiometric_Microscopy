library(shiny)


# Define the user interface for the shiny app
ui <- fluidPage(
  
  # App title ----
  titlePanel("OxD and E from intensity ratio values"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Delta dynamic range at 470 (previously called instrument factor alpha)
      sliderInput(inputId = "delta",
                  label = "Delta value at 470:",
                  min = 0.000,
                  max = 1.000,
                  value = 0.171),
      
      # Input: I410/470 when fully oxidized
      sliderInput(inputId = "maxOx",
                  label = "Intensity ratio at maximal oxidation",
                  min = 0.001,
                  max = 10.000,
                  value = 5.207),
      
      # Input: I410/470 when fully reduced
      sliderInput(inputId = "maxRed",
                  label = "Intensity ratio at maximal reduction",
                  min = 0.001,
                  max = 10.000,
                  value = 0.667),
      
      # Input: sensor midpoint potential
      sliderInput(inputId = "e0",
                  label = "Sensor midpoint potential",
                  min = -400,
                  max = -100,
                  value = -265)
    ),
    
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: OxD plot ----
      plotOutput(outputId = "oxdPlot"),
      
      # Output: E plot
      plotOutput(outputId = "ePlot")
    )
  )
)

# Define this app's server logic ----
server <- function(input, output, session) {
  
  # Define the OxDPlot
  output$oxdPlot <- renderPlot({
    
    # Define the OxD function
    FOx <- function(exp, red, ox, delta) {
      return (
        (exp - red)/((exp - red) + (delta*(ox - exp)))
      )
    }
    
    # Generate samples values between the maximally reduced and oxidized values
    x <- seq(input$maxRed, input$maxOx, by = 0.001)
    magX <- length(x)
    yOx = FOx(x, rep(input$maxRed, each = magX), 
            rep(input$maxOx, each = magX), 
            rep(input$delta, each = magX))
    
    # Create a line plot with the samples input values
    plot(x, yOx,
         type = 'l', main = "Fraction of sensor molecules oxidized at intensity",
          ylab = expression('OxD'['roGFP']), xlab = expression('R'['410/470']))
    
  }, res = 92)
  
  # Define potential plot
  output$ePlot <- renderPlot({
    
    # -------------------------------------------------
    # Begin repeated code -- not sure how to fix given shiny restrictions 
    
    # Define the OxD function
    FOx <- function(exp, red, ox, delta) {
      return (
        (exp - red)/((exp - red) + (delta*(ox - exp)))
      )
    }
    
    # Generate samples values between the maximally reduced and oxidized values
    x <- seq(input$maxRed, input$maxOx, by = 0.001)
    magX <- length(x)
    yOx = FOx(x, rep(input$maxRed, each = magX), 
              rep(input$maxOx, each = magX), 
              rep(input$delta, each = magX))
    
    # -------------------------------------------------
    # End repeated code
    
    # Define the Nernst function
    FE <- function(e0, OxD) {
      return(e0 - 12.71 * log((1-OxD)/OxD))
    }
    
    # Generate sample values for each value of OxD
    yE = FE(rep(input$e0, each = length(yOx)), yOx)
    
    # Create a line plot with the samples input values
    plot(x, yE,
         type = 'l', main = "Redox potential at intensity",
         ylab = expression('E'['roGFP']), xlab = expression('R'['410/470']))
    

  }, res = 92)
  
  }

# Create Shiny app ----
shinyApp(ui = ui, server = server)