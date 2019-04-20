source("sensorHelpers.R")

# Write a function that, given a sensor and two sets of lambda bands, returns a list of properties
# Sensor data format: 
initSensor <- function(sensor_data, lambda_1, lambda_2, e0 = 0, pH = FALSE, pKa = 0) {
    # Clean data
    ox_lambda <- na.omit(sensor_data[[1]])
    ox_value <- na.omit(sensor_data[[2]])
    red_lambda <- na.omit(sensor_data[[3]])
    red_value <- na.omit(sensor_data[[4]])
    
    # Set delta
    delta <- mean(ox_value[ox_lambda >= lambda_2[1] & ox_lambda <= lambda_2[2]]) /  
        mean(red_value[red_lambda >= lambda_2[1] & red_lambda <= lambda_2[2]])
    
    # Set Rmin and Rmax
    Rmin <- mean(red_value[red_lambda >= lambda_1[1] & red_lambda <= lambda_1[2]]) /  
        mean(red_value[red_lambda >= lambda_2[1] & red_lambda <= lambda_2[2]])
    
    Rmax <- mean(ox_value[ox_lambda >= lambda_1[1] & ox_lambda <= lambda_1[2]]) /  
        mean(ox_value[ox_lambda >= lambda_2[1] & ox_lambda <= lambda_2[2]])
    
    
    if (pH) {
        # Generate some R, OxD, and pH values
        R <- seq(Rmin, Rmax, by = 0.001)
        Deprot_values <- OXD(R, Rmin, Rmax, delta)
        pH_values <- E(pKa, R, Rmin, Rmax, delta)
        
        # Generate R' and R''
        RPrime <- R/Rmin
        RDoublePrime <- (R-Rmin)/(Rmax-Rmin)
        
        # Generate partial derivatives
        Deprot_sen <- D_FrDeprot(R = R, Rmin = Rmin, Rmax = Rmax, delta = delta)
        pH_sen <- D_pH(R = R, Rmin = Rmin, Rmax = Rmax)
        
        # Generate 2% errors
        Error2 <- Error_E(R = R, Rmin = Rmin, Rmax = Rmax, delta = delta, e0 = e0, percent_error = 2) 
        
        # Return the final list
        return(list(data = combine(ox_lambda, ox_value, red_lambda, red_value), pKa = pKa, apKa= pHeff(delta_470 = delta, pKa = pKa),
                    Deprot_sen = Deprot_sen, pH_sen = pH_sen, Error2 = Error2,
                    delta = delta, Rmin = Rmin, Rmax = Rmax, R = R, FrDeprot = Deprot_values, pH = pH_values, 
                    RPrime = RPrime, RDoublePrime = RDoublePrime))
    }
    
    else {
        # Generate some R, OxD, and E values
        R <- seq(Rmin, Rmax, by = 0.001)
        OxD_values <- OXD(R, Rmin, Rmax, delta)
        E_values <- E(e0, R, Rmin, Rmax, delta)
        
        # Generate R' and R''
        RPrime <- R/Rmin
        RDoublePrime <- (R-Rmin)/(Rmax-Rmin)
        
        # Generate partial derivatives
        OxD_sen <- D_OXD(R = R, Rmin = Rmin, Rmax = Rmax, delta = delta)
        E_sen <- D_E(R = R, Rmin = Rmin, Rmax = Rmax)
        
        # Generate 2% errors
        Error2 <- Error_pH(R = R, Rmin = Rmin, Rmax = Rmax, delta = delta, pKa = pKa, percent_error = 2) 
        
        # Return the final list
        return(list(data = combine(ox_lambda, ox_value, red_lambda, red_value), e0 = e0, Eeff = Eeff(delta_470 = delta, e0 = e0),
                    OxD_sen = OxD_sen, E_sen = E_sen, Error2 = Error2,
                    delta = delta, Rmin = Rmin, Rmax = Rmax, R = R, OxD = OxD_values, E = E_values, 
                    RPrime = RPrime, RDoublePrime = RDoublePrime))
    
    }
}
