# ---------- Overview
# Class: Sensor
#         Attributes: -ox (Matrix of oxidized intensity values at wavelengths)
#                     -red (Matrix of reduced intensity values at wavelengths)
#                     -E0 (Single value describing the midpoint potential of the sensor)
#
# Design choice: Sensor does not have any methods. Instead, functions are public
# and take a sensor object as an argument.
#
# Constructor functions:
#                       - Sensor(matrix, matrix, numeric) --> Sensor 
#                       - SensorPoint(numeric, numeric, numeric, numeric, numeric) --> Sensor
#                       - SensorValues(numeric, numeric, numeric,
#                                     numeric (optional), numeric (optional), numeric (optional))
# 
# Functions:
#            - plotOxRed(Sensor) --> Plot of a sensor's spectra
#            - plotROxD(Sensor, numeric, numeric, numeric, numeric) --> Plot R vs OxD for a sensor
#            - plotRPrimeOxD(Sensor, numeric, numeric, numeric, numeric) --> Plot R' vs OxD for a sensor
#            - plotRDoublePrimeOxD(Sensor, numeric, numeric, numeric, numeric) --> Plot R'' vs OxD for a sensor
#            - plotRE(Sensor, numeric, numeric, numeric, numeric) --> Plot R vs E for a sensor
#            - plotRPrimeE(Sensor, numeric, numeric, numeric, numeric) --> Plot R' vs E for a sensor
#            - plotRDoublePrimeE(Sensor, numeric, numeric, numeric, numeric) --> Plot R'' vs E for a sensor


# ----------- Sensor class definition 
# Ox: Matrix of [X, Y] spectrum values in oxidized state
# Red: Matrix of [X, Y] spectrum values in reduced state
setClass("Sensor",
         slots = list(ox = "matrix", red = "matrix", E0 = "numeric"))


# ----------- Sensor constructors
# Main constructor
# ARGS: Two, 2-by-N matricies 
# -- oxMatrix: matrix of x and y values in oxidized state
# -- redMatrix: matrix of x and y values in reduced state
Sensor <- function(oxMatrix, redMatrix, E0) {
  
  return(new("Sensor", ox = oxMatrix,
             red = redMatrix, E0 = E0));
}

# Additional constructor for seperate x and y arrays
SensorPoint <- function(xOx, yOx, xRed, yRed, E0) {
  return(Sensor(createPos(xOx, yOx), createPos(xRed, yRed), E0));
}

# Additional constructor for Rmax, Rmin, and delta
# Helps by making vectors corresponding to values given
SensorValues <- function(Rmax, Rmin, delta, lambda_1 = 410, lambda_2 = 470, E0 = -265
                          ) {
  return(Sensor(createPos(c(lambda_1, lambda_2),c(Rmax*delta, delta)), 
                 createPos(c(lambda_1, lambda_2), c(Rmin, 1) ), E0)); 
}

# Helper to create a 2-column matrix from two vectors
createPos <- function(X, Y) {
  
  return( 
    cbind(matrix(na.omit(X)), na.omit(Y))
  );
}

# ----------- Sensor "method" functions
getAttributes <- function(sensor, lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high) {
  # Returns array [Rmin, Rmax, D470]
  # Get the average value from each emission range
  lambda_1_ox <- mean(subset(sensor@ox, sensor@ox[,1] >= lambda_1_low & sensor@ox[,1] <= lambda_1_high)[,2])
  lambda_2_ox <- mean(subset(sensor@ox, sensor@ox[,1] >= lambda_2_low & sensor@ox[,1] <= lambda_2_high)[,2])
  lambda_1_red <- mean(subset(sensor@red, sensor@red[,1] >= lambda_1_low & sensor@red[,1] <= lambda_1_high)[,2])
  lambda_2_red <- mean(subset(sensor@red, sensor@red[,1] >= lambda_2_low & sensor@red[,1] <= lambda_2_high)[,2])
  
  # Define minimum, maximum, and delta
  Rmax <- lambda_1_ox/lambda_2_ox
  Rmin <- lambda_1_red/lambda_2_red
  delta <- lambda_2_ox/lambda_2_red
  
  # Return the array
  return(c(Rmin, Rmax, delta, lambda_1_ox, lambda_2_ox, lambda_1_red, lambda_2_red));
}

# ---------- Utils
# Define the funtion oxidized
OXD <- function(R, Rmin, Rmax, delta) {
  return (
    (R - Rmin)/((R - Rmin) + (delta*(Rmax - R)))
  )
}

# Define the funtion oxidized for normalized data
OXD_norm <- function(R, Rmin, Rmax, delta) {
  return (
    ((R-Rmin)/(Rmax-Rmin))
    / ( 
      ((R-Rmin)/(Rmax-Rmin)) - (delta*((R-Rmin)/((Rmax-Rmin)))) + delta
    )
  )
}

# Helper function to generate statuses
printStatus <- function(lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high, 
                        lambda_1_ox, lambda_2_ox, lambda_1_red, lambda_2_red, Rmin, Rmax, delta) {
  print("Status updates:")
  print(paste("The mean intensity at:", lambda_1_low, 
              "-", lambda_1_high, "is:", round(lambda_1_ox, digits=2), "when oxidized"))
  print(paste("The mean intensity at:", lambda_2_low, 
              "-", lambda_2_high, "is:", round(lambda_2_ox, digits=2), "when oxidized"))
  print(paste("The mean intensity at:", lambda_1_low, 
              "-", lambda_1_high, "is:", round(lambda_1_red, digits=2), "when reduced"))
  print(paste("The mean intensity at:", lambda_2_low, 
              "-", lambda_2_high, "is:", round(lambda_2_red, digits=2), "when reduced"))
  print(paste("Rmax is:", round(Rmax,digits=2)))
  print(paste("Rmin is:", round(Rmin,digits=2)))
  print(paste("Delta is:", round(delta,digits=2)))
}

# Define the Nernst function in terms of oxD
E_OXD <- function(e0, oxD) {
  return(e0 - 12.71 * log((1-oxD)/oxD))
}


# Define dE with respect to OxD
dEdOxD <- function(OxD) {
  return(-12.71 * (1/(
                      (1-OxD)*OxD)
                      ))
}

# Define dOxD with respect to R
dOxDdR <- function(R, Rmin, Rmax, delta) {
  return (
      (delta*(Rmin - Rmax))/
        ((-1*Rmin - delta*(Rmax-R) + R)^2)
  )
}

# Define dE with respect to R
dEdR <- function(R, Rmin, Rmax, delta) {
  return (
    -12.71 * (Rmin-Rmax)/((Rmin-R)*(R-Rmax))
  )
}

# ----------- Plotting functions
plotOxRed <- function(sensor, main = "", type = "l") {
  plot(sensor@ox[,2] ~ sensor@ox[,1], type = type, main = main, ylim = c(0, max(sensor@ox[,2], 
                                                                                 sensor@red[,2])), 
       xlim = c(350, 500), xlab = "Wavelength (nm)", ylab = "Relative intensity")
  points(sensor@red[,2] ~ sensor@red[,1], type = type, col = "red")
}

# Plot generally
# TODO: Make this generalizable for E and OxD
plotREq <- function(sensor, lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high,
                    main = "", points = FALSE, xlab = "", ylab = "", color = "black",
                    status = FALSE, prime = 0, equation = OXD) {
  
  # Get attributes of the sensor
  attributes <- getAttributes(sensor, lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high)
  Rmin <- attributes[1]; Rmax <- attributes[2]; delta <- attributes[3]
  lambda_1_ox <- attributes[4]; lambda_2_ox <- attributes[5]; 
  lambda_1_red <- attributes[6] ;lambda_2_red <- attributes[7]
  
  
  # If requested, print a status update
  if(status) {
    printStatus(lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high, 
                lambda_1_ox, lambda_2_ox, lambda_1_red, lambda_2_red, Rmin, Rmax, delta)
  }
  
  # Generate values for R
  R <- seq(Rmin, Rmax, by = 0.001)
  magR <- length(R)
  
  # If we want to plot R', set a normalization factor of Rmin
  if(prime == 2) {
    xPlot <- (R-Rmin)/(Rmax-Rmin)
    limPlot <- c(0, 1)
    labPlot <- "R''"
  }
  
  else if(prime == 1) {
    xPlot <- R/Rmin 
    limPlot <- c(1,Rmax/Rmin)
    labPlot <- "R'"
  }
  
  else {
    xPlot <- R
    limPlot <- c(0, Rmax)
    labPlot <- "R"
  }
  
  # Generate values based on the equation given
  # Equations signature must be: R, Rmin, Rmax, delta
  yOXD = equation(R, rep(Rmin, each = magR), 
                  rep(Rmax, each = magR), 
                  rep(delta, each = magR))
  
  # Make future graphs square
  par(pty = 's') 
  
  # By request, either make a new graph or plot on an existing graph
  if(points){
    points(xPlot, yOXD, type = 'l', col = color)
  }
  
  else {
    plot(xPlot, yOXD,
         type = 'l', main = main,
         ylab = ylab, xlab = labPlot,
         xlim = limPlot, col = color)
  }
}

# Requirement: R = lambda_1/lambda_2
# Plot the main R vs OxD plot
plotROxD <- function(sensor, lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high,
                     main = "", ylab = "OxD", points = FALSE, 
                     color = "black", status = FALSE, prime = 0, equation = OXD, ylim = c(0,1)) {
  
  # Get attributes of the sensor
  attributes <- getAttributes(sensor, lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high)
  Rmin <- attributes[1]; Rmax <- attributes[2]; delta <- attributes[3]
  lambda_1_ox <- attributes[4]; lambda_2_ox <- attributes[5]; 
  lambda_1_red <- attributes[6] ;lambda_2_red <- attributes[7]
  
  
  # If requested, print a status update
  if(status) {
    printStatus(lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high, 
                lambda_1_ox, lambda_2_ox, lambda_1_red, lambda_2_red, Rmin, Rmax, delta)
  }
  
  # Generate values for R
  R <- seq(Rmin, Rmax, by = 0.001)
  magR <- length(R)
  
  # If we want to plot R', set a normalization factor of Rmin
  if(prime == 2) {
    xPlot <- (R-Rmin)/(Rmax-Rmin)
    limPlot <- c(0, 1)
    labPlot <- "R''"
  }
  
  else if(prime == 1) {
    xPlot <- R/Rmin 
    limPlot <- c(1,Rmax/Rmin)
    labPlot <- "R'"
  }
  
  else {
    xPlot <- R
    limPlot <- c(0, Rmax)
    labPlot <- "R"
  }
  
  print(limPlot)
  print(labPlot)
  
  # Generate values for OxD
  yOXD = equation(R, rep(Rmin, each = magR), 
             rep(Rmax, each = magR), 
             rep(delta, each = magR))
  
  # Make future graphs square
  par(pty = 's') 
  
  # By request, either make a new graph or plot on an existing graph
  if(points){
    points(xPlot, yOXD, type = 'l', col = color)
  }
  
  else {
  plot(xPlot, yOXD,
       type = 'l', main = main,
       ylab = ylab, xlab = labPlot, ylim = ylim,
       xlim = limPlot, col = color)
  }
}

# Plot the R' vs OxD plot
# Requirement: R' = lambda_2/lambda_1/Rmin
# Plot the main R' vs OxD plot
plotRPrimeOxD <- function(sensor, lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high, 
                          main = "", ylab = "OxD", points = FALSE, color = "black", status = FALSE) {
  
  plotROxD(sensor, lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high, 
           main = "", ylab = ylab, points = points, color = color, status = status, prime = 1)
}

# Plot the R'' vs OxD plot
# Requirement: R'' = lambda_2-Rmin/lambda_1/Rmax-Rmin
# Plot the main R' vs OxD plot
plotRDoublePrimeOxD <- function(sensor, lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high,
                                main = "", ylab = "OxD", points = FALSE, color = "black", status = FALSE) {
 
   plotROxD(sensor, lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high, 
           main = "",ylab = ylab, points = points, color = color, status =status, prime = 2, equation = OXD_norm);
}


# Requirement: R = lambda_1/lambda_2
# Plot the main R vs E plot
plotRE <- function(sensor, lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high,
                     main = "", points = FALSE, color = "black", status = FALSE, prime = 0, equation = OXD) {
  
  # Get attributes of the sensor
  attributes <- getAttributes(sensor, lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high)
  Rmin <- attributes[1]; Rmax <- attributes[2]; delta <- attributes[3]
  lambda_1_ox <- attributes[4]; lambda_2_ox <- attributes[5]; 
  lambda_1_red <- attributes[6] ;lambda_2_red <- attributes[7]
  
  # Status
  if(status) {
    printStatus(lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high, 
                lambda_1_ox, lambda_2_ox, lambda_1_red, lambda_2_red, Rmin, Rmax, delta)
  }
  
  # Generate inital values of R
  R <- seq(Rmin, Rmax, by = 0.001)
  magR <- length(R)
  
  
  # If we want to plot R', set a normalization factor of Rmin
  if(prime == 2) {
    xPlot <- (R-Rmin)/(Rmax-Rmin)
    limPlot <- c(0, 1)
    labPlot <- "R''"
  }
  
  else if(prime == 1) {
    xPlot <- R/Rmin 
    limPlot <- c(1,Rmax/Rmin)
    labPlot <- "R'"
  }
  
  else {
    xPlot <- R
    limPlot <- c(0, Rmax)
    labPlot <- "R"
  }
  
  # Generate inital values of oxD
  yE = E_OXD(sensor@E0, equation(R, rep(Rmin, each = magR), 
             rep(Rmax, each = magR), 
             rep(delta, each = magR)))
  
  # Set  size
  par(pty = 's') 
  
  # Plotvalue
  if(points){
    points(xPlot, yE, type = 'l', col = color)
  }
  
  else {
    plot(xPlot, yE,
         type = 'l', main = main,
         ylab = "E", xlab = labPlot,
         xlim = limPlot, col = color)
  }
}

# Requirement: R = lambda_1/lambda_2
# Plot the main R' vs E plot
plotRPrimeE <- function(sensor, lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high,
                   main = "", points = FALSE, color = "black", status = FALSE) {
  
  plotRE(sensor, lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high,
         main, points, color, status, 
         prime = 1)
}

# Plot the R'' vs E plot
# Requirement: R'' = lambda_2-Rmin/lambda_1/Rmax-Rmin
# Plot the main R'' vs E plot
plotRDoublePrimeE <- function(sensor, lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high,
                                main = "", points = FALSE, color = "black", status = FALSE) {
  plotRE(sensor, lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high,
         main, points, color, status, 
         prime = 2, equation = OXD_norm)
}






