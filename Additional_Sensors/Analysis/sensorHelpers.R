# Define the fraction oxidized
OXD <- function(R, Rmin, Rmax, delta) {
    return (
        (R - Rmin)/((R - Rmin) + (delta*(Rmax - R)))
    )
}

# The fraction oxidized can be generalized to fraction state 1
# Or fraction deprotenated
FrStateOne <- OXD
FrDeprot <- OXD

# Define the redox potential
E <- function(e0, R, Rmin, Rmax, delta) {
    return(e0 - 12.71 * log((delta*Rmax - delta*R)/(R-Rmin)))
}

# Define the pH
pH <- function(pKa, R, Rmin, Rmax, delta) {
    return(pKa - log((delta*Rmax - delta*R)/(R-Rmin), base = 10))
}

Eeff <- function(delta_470, e0) {
    return (
        e0 - 12.71 * log(delta_470)
    )
}

pHeff <- function(delta_470, pKa) {
    return(
        pKa - log(delta_470, base = 10)
    )
}

# Define the derivative of OxD
D_OXD <- function(R, Rmin, Rmax, delta) {
    return (
        (delta * (Rmax - Rmin)) /
            ((R * (delta - 1) - (delta * Rmax) + Rmin)^2)
    )
}

# Define the derivative of FrDeprot
D_FrDeprot <- function(R, Rmin, Rmax, delta) {
    return (
        (delta * (Rmax - Rmin)) /
            ((R * (delta - 1) - (delta * Rmax) + Rmin)^2)
    )
}

# Define the derivative of E
D_E <- function(R, Rmin, Rmax) {
    return(
        (-12.71*(Rmax-Rmin))/((R-Rmin)*(R-Rmax))
    )
}

# Define the derivative of pH
D_pH <- function(R, Rmin, Rmax) {
    return(
        (Rmax-Rmin)/((R-Rmin)*(R-Rmax))
    )
}

# Define a percent error
Error_E <- function(R, Rmin, Rmax, delta, e0, percent_error) {
    answer <- c()
    for (Rind in R) {
        if((Rind * (1 - percent_error/100) >= Rmin) && (Rind * (1 + percent_error/100) <= Rmax)) {
            err <- max(
                abs(E(R = Rind, e0 = e0, Rmin = Rmin, Rmax = Rmax, delta = delta) 
                    - E(R = Rind * (1 + percent_error/100), e0 = e0, Rmin = Rmin, Rmax = Rmax, delta = delta)),
                abs(E(R = Rind, e0 = e0, Rmin = Rmin, Rmax = Rmax, delta = delta) 
                    - E(R = Rind * (1 - percent_error/100), e0 = e0, Rmin = Rmin, Rmax = Rmax, delta = delta))
            )
            answer <- c(answer, err)
        }
        
        else {
            
            answer <- c(answer, Inf)
            
        }
    }
    
    return(answer)
    
}

# Percent error in pH is the same, but with pKa
Error_pH <- function(R, Rmin, Rmax, delta, pKa, percent_error) {
    answer <- c()
    for (Rind in R) {
        if((Rind * (1 - percent_error/100) >= Rmin) && (Rind * (1 + percent_error/100) <= Rmax)) {
            err <- max(
                abs(E(R = Rind, pKa = pKa, Rmin = Rmin, Rmax = Rmax, delta = delta) 
                    - E(R = Rind * (1 + percent_error/100), pKa = pKa, Rmin = Rmin, Rmax = Rmax, delta = delta)),
                abs(E(R = Rind, pKa = pKa, Rmin = Rmin, Rmax = Rmax, delta = delta) 
                    - E(R = Rind * (1 - percent_error/100), pKa = pKa, Rmin = Rmin, Rmax = Rmax, delta = delta))
            )
            answer <- c(answer, err)
        }
        
        else {
            
            answer <- c(answer, Inf)
            
        }
    }
    
    return(answer)
    
}

# Turn two pairs of lambda-emission spectra into a 3-column dataframe
combine <- function(ox_lambda, ox_value, red_lambda, red_value) {
    start <- max(ox_lambda[1], red_lambda[1])
    end <- min(ox_lambda[length(ox_lambda)], red_lambda[length(red_lambda)])
    
    range <- seq(start, end, by = 0.1)
    ox_value_new <- c()
    red_value_new <- c()
    
    for (lambda in range) {
        # Find the ox value closest to the lambda
        closest_value = Inf
        closest_index = NaN
        for (old_lambda_index in 1:length(ox_lambda)) {
            old_lambda_diff = abs(ox_lambda[old_lambda_index] - lambda)
            if (old_lambda_diff < closest_value) {
                closest_value = old_lambda_diff
                closest_index = old_lambda_index
            }
        }
        
        ox_value_new <- c(ox_value_new, ox_value[closest_index])
        
        # Find the red value closest to the lambda
        closest_value = Inf
        closest_index = NaN
        for (old_lambda_index in 1:length(red_lambda)) {
            old_lambda_diff = abs(red_lambda[old_lambda_index] - lambda)
            if (old_lambda_diff < closest_value) {
                closest_value = old_lambda_diff
                closest_index = old_lambda_index
            }
        }
        
        red_value_new <- c(red_value_new, red_value[closest_index])
        
        
    }
    
    return(data.frame(lambda = range, ox = ox_value_new, red = red_value_new))
    
}

# Define a function to modify with non-limiting data
spectra_adjust <- function(state_1_spectra, state_2_spectra, state_1_fraction, state_2_fraction) {
    A <- (state_1_spectra/state_1_fraction-state_2_spectra/state_2_fraction)/((1-state_1_fraction)/state_1_fraction-(1-state_2_fraction)/state_2_fraction)
    B <- (state_1_spectra/(1-state_1_fraction)-state_2_spectra/(1-state_2_fraction))/(state_1_fraction/(1-state_1_fraction)-state_2_fraction/(1-state_2_fraction))
    
    return(matrix(c(A,B), ncol = 2))
}

#Define coolwarm color gradient
coolwarm <- colorRampPalette(c(
    rgb( 60, 81,198, maxColorValue = 255),
    rgb( 61, 86,203, maxColorValue = 255),
    rgb( 63, 91,207, maxColorValue = 255),
    rgb( 65, 96,212, maxColorValue = 255),
    rgb( 67,101,216, maxColorValue = 255),
    rgb( 69,106,220, maxColorValue = 255),
    rgb( 71,111,224, maxColorValue = 255),
    rgb( 74,116,227, maxColorValue = 255),
    rgb( 76,121,231, maxColorValue = 255),
    rgb( 79,127,233, maxColorValue = 255),
    rgb( 83,132,236, maxColorValue = 255),
    rgb( 86,137,238, maxColorValue = 255),
    rgb( 90,143,240, maxColorValue = 255),
    rgb( 94,148,242, maxColorValue = 255),
    rgb( 99,153,243, maxColorValue = 255),
    rgb(103,159,244, maxColorValue = 255),
    rgb(109,164,244, maxColorValue = 255),
    rgb(114,169,245, maxColorValue = 255),
    rgb(120,174,245, maxColorValue = 255),
    rgb(126,179,245, maxColorValue = 255),
    rgb(132,184,244, maxColorValue = 255),
    rgb(139,188,243, maxColorValue = 255),
    rgb(146,193,242, maxColorValue = 255),
    rgb(153,197,241, maxColorValue = 255),
    rgb(161,201,239, maxColorValue = 255),
    rgb(169,205,238, maxColorValue = 255),
    rgb(177,209,236, maxColorValue = 255),
    rgb(186,212,233, maxColorValue = 255),
    rgb(195,215,231, maxColorValue = 255),
    rgb(204,218,229, maxColorValue = 255),
    rgb(214,221,226, maxColorValue = 255),
    rgb(223,223,223, maxColorValue = 255),
    rgb(235,218,215, maxColorValue = 255),
    rgb(245,213,207, maxColorValue = 255),
    rgb(255,206,198, maxColorValue = 255),
    rgb(255,192,184, maxColorValue = 255),
    rgb(255,180,170, maxColorValue = 255),
    rgb(255,168,159, maxColorValue = 255),
    rgb(255,157,148, maxColorValue = 255),
    rgb(255,147,139, maxColorValue = 255),
    rgb(255,138,130, maxColorValue = 255),
    rgb(255,129,122, maxColorValue = 255),
    rgb(255,121,115, maxColorValue = 255),
    rgb(255,113,109, maxColorValue = 255),
    rgb(255,105,103, maxColorValue = 255),
    rgb(255, 98, 98, maxColorValue = 255),
    rgb(255, 91, 93, maxColorValue = 255),
    rgb(255, 85, 89, maxColorValue = 255),
    rgb(255, 78, 85, maxColorValue = 255),
    rgb(255, 72, 81, maxColorValue = 255),
    rgb(255, 67, 78, maxColorValue = 255),
    rgb(255, 61, 75, maxColorValue = 255),
    rgb(255, 56, 72, maxColorValue = 255),
    rgb(255, 50, 70, maxColorValue = 255),
    rgb(255, 45, 67, maxColorValue = 255),
    rgb(255, 41, 65, maxColorValue = 255),
    rgb(252, 35, 62, maxColorValue = 255),
    rgb(242, 30, 58, maxColorValue = 255),
    rgb(233, 24, 55, maxColorValue = 255),
    rgb(223, 20, 51, maxColorValue = 255),
    rgb(212, 15, 48, maxColorValue = 255),
    rgb(202, 11, 44, maxColorValue = 255),
    rgb(191,  7, 41, maxColorValue = 255),
    rgb(180,  4, 38, maxColorValue = 255)))

colors4 <- c(
    rgb(151, 99, 172, maxColorValue = 255),
    rgb(214, 154, 191, maxColorValue = 255),
    rgb(249, 188, 112, maxColorValue = 255),
    rgb(224, 120, 34, maxColorValue = 255))
