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
      
      splitLayout(cellWidths = c("50%", "50%"), plotOutput("oxdPlot"), plotOutput("ePlot")), 
      
      # Output: OxD plot ----
      #plotOutput(outputId = "oxdPlot", width = "50%"),
      
      # Output: E plot
      #plotOutput(outputId = "ePlot", width = "50%"),
      
      # Output: D Partial plot, E
      plotOutput(outputId = "ePartialPlot", width = "50%")
      
      # Output: ROx Partial plot
      
      # Output: RRed Partial plot
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
         type = 'l', main = "Fraction of molecules oxidized at intensity",
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
  
  # Define the partial with respect to delta plot
  output$ePartialPlot <- renderPlot({
    
    # Define the Nernst partial equation
    PD <- function(z, r, o, d, e) {
      return (
        (12.71 * (-r+z) * 
        (-r+d * (o-z)+z) * 
        ((o-z)/(-r+d *(o-z)+z)^3-((o-z)  *
        (1-(-r+z)/(-r+d * (o-z)+z)))/((-r+z) *
        (-r+d * (o-z)+z)^2)))/(1-(-r+z)/(-r+d * (o-z)+z))
      )
    }
    
    # Generate samples values between the maximally reduced and oxidized values
    x <- seq(input$maxRed, input$maxOx, by = 0.001)
    magX <- length(x)
    yPD = PD(x, rep(input$maxRed, each = magX), 
              rep(input$maxOx, each = magX), 
              rep(input$delta, each = magX),
              rep(input$e0, each = magx))
    
    # Create a line plot with the samples input values
    plot(x, yPD,
         type = 'l', main = "Redox potential at intensity",
         ylab = "Partial of d/E", xlab = expression('R'['410/470']))
    
    
  }, res = 92)
  }
  

# Create Shiny app ----
shinyApp(ui = ui, server = server)