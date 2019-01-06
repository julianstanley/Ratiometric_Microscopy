# A dataframe that consists of emission at a given wavelength
spectrum_data <- data.frame(lambda = c(410, 420, 430, 440, 450), emission_state1 = c(1, 2, 3, 4, 5), emission_state2 = c(50, 40, 30, 20, 10))

# Define a domain-specific formula
E <- function(e0, R, Rmin, Rmax, delta) {
    return(e0 - 12.71 * log((delta*Rmax - delta*R)/(R-Rmin)))
}

# Convenience
emission_410 <- subset(spectrum_data, spectrum_data$lambda == 410)
emission_450 <- subset(spectrum_data, spectrum_data$lambda == 450)

# Define some parameters
e0 <- -275 
Rmin <- emission_410$emission_state1/emission_450$emission_state1
Rmax <- emission_410$emission_state2/emission_450$emission_state2
delta <- emission_450$emission_state1/emission_450$emission_state2
R <- seq(Rmin, Rmax, by = 0.001)
E_values <- E(e0, R, Rmin, Rmax, delta)

# Define a list based on one pair
# Would be easier to search if list_410_450 could be accessed
# within a larger database via the tuple key (410, 450)

list_410_450 <- list(e0 = e0, Rmin = Rmin, Rmax = Rmax,
                     delta = delta, R = R, E_values = E_values)

