
# ----------- Spectra class definition 
# Ox: Matrix of [X, Y] spectrum values in oxidized state
# Red: Matrix of [X, Y] spectrum values in reduced state
setClass("Spectra",
         slots = list(ox = "matrix", red = "matrix"))


# ----------- Spectra constructors
# Main constructor
# ARGS: Two, 2-by-N matricies 
# -- oxMatrix: matrix of x and y values in oxidized state
# -- redMatrix: matrix of x and y values in reduced state
Spectra <- function(oxMatrix, redMatrix) {
  
  return(new("Spectra", ox = oxMatrix,
             red = redMatrix));
}

# Additional constructor for seperate x and y arrays
SpectraPoint <- function(xOx, yOx, xRed, yRed) {
  return(Spectra(createPos(xOx, yOx), createPos(xRed, yRed)));
}

# Helper to create a 2-column matrix from two vectors
createPos <- function(X, Y) {
  
  return( 
    cbind(matrix(na.omit(X)), na.omit(Y))
  );
  
}

# ----------- Plotting functions
plotOxRed <- function(spectra, main) {
  plot(spectra@ox[,2] ~ spectra@ox[,1], type = "l", main = main, ylim = c(0, max(spectra@ox[,2], 
                                                                                 spectra@red[,2])))
  points(spectra@red[,2] ~ spectra@red[,1], type = "l", col = "red")
}

# Requirement: R = lambda_2/lambda_1
plotROxD <- function(spectra, lambda_1_low, lambda_1_high, lambda_2_low, lambda_2_high) {
  # Get the average value from each emission range
  lambda_1_ox <- mean(subset(spectra@ox, spectra@ox[,1] > lambda_1_low & spectra@ox[,1] < lambda_1_high)[,2])
  lambda_2_ox <- mean(subset(spectra@ox, spectra@ox[,1] > lambda_2_low & spectra@ox[,1] < lambda_2_high)[,2])
  lambda_1_red <- mean(subset(spectra@red, spectra@red[,1] > lambda_1_low & spectra@red[,1] < lambda_1_high)[,2])
  lambda_2_red <- mean(subset(spectra@red, spectra@red[,1] > lambda_2_low & spectra@red[,1] < lambda_2_high)[,2])
  
  # Define minimum, maximum, and delta
  Rmax <- max(lambda_1_ox/lambda_2_ox, lambda_1_red/lambda_2_red)
  Rmin <- min(lambda_1_ox/lambda_2_ox, lambda_1_red/lambda_2_red)
  delta <- lambda_2_ox/lambda_2_red
  
  print(Rmax)
  print(Rmin)
  print(delta)
  
  # Define the funtion oxidized
  OXD <- function(R, Rmin, Rmax, delta) {
    return (
      (R - Rmin)/((R - Rmin) + (delta*(Rmax - R)))
    )
  }
  
  # Generate inital values of R
  R <- seq(Rmin, Rmax, by = 0.001)
  magR <- length(R)
  
  # Generate inital values of oxD
  yOXD = OXD(R, rep(Rmin, each = magR), 
             rep(Rmax, each = magR), 
             rep(delta, each = magR))
  # Set  size
  par(pty = 's') 
  
  # Plotvalue
  plot(R, yOXD,
       type = 'l', main = "
       Fraction oxidized \n at measured ratio",
       ylab = "OxD", xlab = "R",
       xlim = c(0, Rmax))
  
  
}
# ----------- 
# ----------- Use case

# Create GFP1
GFP1 <- SpectraPoint(dig$Oxidized.X.GFP.1, 
                         dig$Oxidized.Y.GFP.1, 
                         dig$Reduced.X.GFP.1, 
                         dig$Reduced.Y.GFP.1)

# Create GFP 2
GFP2 <- SpectraPoint(dig$ï..Oxidized.X.GFP2,
                     dig$Oxidized.Y.GFP.2,
                     dig$Reduced.X.GFP2,
                     dig$Reduced.Y.GFP2)

# Plot GFP 1 and 2
dev.off()
par(mfrow = c(1, 2), pty = 's')
plotOxRed(GFP1, main = "GFP1")
plotOxRed(GFP2, main = "GFP2")

# Plot OxD vs R
dev.off()
plotROxD(GFP2, 485, 495, 395, 405)





