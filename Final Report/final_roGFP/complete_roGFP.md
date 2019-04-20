    knitr::opts_chunk$set(echo = TRUE)
    shh <- suppressPackageStartupMessages
    shh(require(sensorOverlord))
    shh(require(ggplot2))
    shh(require(cowplot))

    ## Warning: package 'cowplot' was built under R version 3.5.3

Initalize Sensors
-----------------

    sensor_repo <- "../Raw_Spectra/"

    # roGFP1
    roGFP1_data <- read.csv(paste(sensor_repo, "rogfp1.csv", sep = ""), header = TRUE)
    roGFP1_spectra <- spectraMatrixFromValues(
        lambdas_minimum = roGFP1_data$Lambda_Reduced, 
        values_minimum = roGFP1_data$Values_Reduced,
        lambdas_maximum = roGFP1_data$Lambda_Oxidized,
        values_maximum = roGFP1_data$Values_Oxidized)
    roGFP1_sensor <- new("redoxSensor", Rmin = 4.3, Rmax = 30.6, delta = 0.2, e0 = -281)

    # roGFP1-R9
    roGFP1_R9_data <- read.csv(paste(sensor_repo, "rogfp1_R9.csv", sep = ""), header = TRUE)
    roGFP1_R9_spectra <- spectraMatrixFromValues(
        lambdas_minimum = roGFP1_R9_data$Lambda_reduced, 
        values_minimum = roGFP1_R9_data$reduced,
        lambdas_maximum = roGFP1_R9_data$Lambda_oxidized,
        values_maximum = roGFP1_R9_data$oxidized)
    roGFP1_R9_sensor <- new("redoxSensor", newSensorFromSpectra(roGFP1_R9_spectra,
                                             lambda_1 = c(380, 400), lambda_2 = c(460, 480)),
                            e0 = -278)

    # roGFP1-R12 empirical
    roGFP1_R12_empirical_sensor <- new("redoxSensor", 
                                       Rmin = 0.667, Rmax = 5.207, delta = 0.171, e0 = -265)

    # roGFP1-R12 from spectra
    roGFP1_R12_data <- read.csv(paste(sensor_repo, "rogfp1_R12.csv", sep = ""), 
                                header = FALSE)
    roGFP1_R12_spectra <- spectraMatrixFromValues(
        lambdas_minimum = roGFP1_R12_data$V3, 
        values_minimum = roGFP1_R12_data$V4,
        lambdas_maximum = roGFP1_R12_data$V1,
        values_maximum = roGFP1_R12_data$V2)
    roGFP1_R12_sensor <- new("redoxSensor", newSensorFromSpectra(roGFP1_R9_spectra, 
                                              lambda_1 = c(390, 410), lambda_2 = c(460, 480)),
                             e0 = -265)

    # roGFP1_iE
    roGFP1_iE_data <- read.csv(paste(sensor_repo, "rogfp1_iE.csv", sep = ""), header = FALSE, fileEncoding="UTF-8-BOM")
    roGFP1_iE_spectra <- spectraMatrixFromValues(
        lambdas_minimum = roGFP1_iE_data$V3, 
        values_minimum = roGFP1_iE_data$V4,
        lambdas_maximum = roGFP1_iE_data$V1,
        values_maximum = roGFP1_iE_data$V2)
    roGFP1_iE_sensor <- new("redoxSensor", Rmin = 0.856, Rmax = 3.875, delta = 0.5, e0 = -236)

    # roGFP2
    roGFP2_data <- read.csv(paste(sensor_repo, "rogfp2.csv", sep = ""), header = FALSE, fileEncoding="UTF-8-BOM")
    roGFP2_spectra <- spectraMatrixFromValues(
        lambdas_minimum = roGFP2_data$V3, 
        values_minimum = roGFP2_data$V4,
        lambdas_maximum = roGFP2_data$V1,
        values_maximum = roGFP2_data$V2)
    roGFP2_sensor <- new("redoxSensor", Rmin = 0.09, Rmax = 1.7, delta = 0.3, e0 = -272)

    # grx1_roGFP2
    grx1_roGFP2_sensor <-  new("redoxSensor", Rmin = 0.3, Rmax = 2.0, delta = 0.5, e0 = -272)

    # roGFP2_iL
    roGFP2_iL_data <- read.csv(paste(sensor_repo, "rogfp2_iL.csv", sep = ""), header = FALSE, fileEncoding="UTF-8-BOM")
    roGFP2_iL_spectra <- spectraMatrixFromValues(
        lambdas_minimum = roGFP2_iL_data$V3, 
        values_minimum = roGFP2_iL_data$V4,
        lambdas_maximum = roGFP2_iL_data$V1,
        values_maximum = roGFP2_iL_data$V2)
    roGFP2_iL_sensor <- new("redoxSensor", Rmin = 0.19, Rmax = 0.45, delta = 0.65, e0 = -229)

    # roGFP3
    roGFP3_data <- read.csv(paste(sensor_repo, "rogfp3.csv", sep = ""), header = TRUE)
    roGFP3_spectra <- spectraMatrixFromValues(
        lambdas_minimum = roGFP3_data$Lambda_330, 
        values_minimum = roGFP3_data$X.330.mv,
        lambdas_maximum = roGFP3_data$Lambda_240,
        values_maximum = roGFP3_data$X.240.mv)
    roGFP3_sensor <- new("redoxSensor", newSensorFromSpectra(roGFP3_spectra,
                                             lambda_1 = c(380, 400), lambda_2 = c(460, 480)),
                         e0 = -299)


    # roGFP4
    roGFP4_data <- read.csv(paste(sensor_repo, "rogfp4.csv", sep = ""), header = TRUE)
    roGFP4_spectra <- spectraMatrixFromValues(
        lambdas_minimum = roGFP4_data$Lambda_320, 
        values_minimum = roGFP4_data$X.320.mv,
        lambdas_maximum = roGFP4_data$Lambda_230,
        values_maximum = roGFP4_data$X.230.mv)
    roGFP4_sensor <- new("redoxSensor", newSensorFromSpectra(roGFP4_spectra,
                                             lambda_1 = c(380, 400), lambda_2 = c(460, 480)),
                         e0 = -286)

    # roGFP5
    roGFP5_data <- read.csv(paste(sensor_repo, "rogfp5.csv", sep = ""), header = TRUE)
    roGFP5_spectra <- spectraMatrixFromValues(
        lambdas_minimum = roGFP5_data$Lambda_330 , 
        values_minimum = roGFP5_data$X.330.mv,
        lambdas_maximum = roGFP5_data$Lambda_250,
        values_maximum = roGFP5_data$X.250.mv)
    roGFP5_sensor <- new("redoxSensor", newSensorFromSpectra(roGFP5_spectra,
                                             lambda_1 = c(380, 400), lambda_2 = c(460, 480)), 
                         e0 = -296)
    # roGFP6
    roGFP6_data <- read.csv(paste(sensor_repo, "rogfp6.csv", sep = ""), header = TRUE)
    roGFP6_spectra <- spectraMatrixFromValues(
        lambdas_minimum = roGFP6_data$Lambda_310 , 
        values_minimum = roGFP6_data$X.310.mv,
        lambdas_maximum = roGFP6_data$Lambda_230,
        values_maximum = roGFP6_data$X.230.mv)
    roGFP6_sensor <- new("redoxSensor", newSensorFromSpectra(roGFP6_spectra,
                                             lambda_1 = c(380, 400), lambda_2 = c(460, 480)),
                         e0 = -280)

Original roGFP spectra
----------------------

    gfp1_spectraPlot <- plotSpectra(roGFP1_spectra, "Reduced", "Oxidized") + ggtitle("roGFP1")
    gfp2_spectraPlot <- plotSpectra(roGFP2_spectra, "Reduced", "Oxidized") + ggtitle("roGFP2")
    gfp3_spectraPlot <- plotSpectra(roGFP3_spectra, "Reduced", "Oxidized") + ggtitle("roGFP3")
    gfp4_spectraPlot <- plotSpectra(roGFP4_spectra, "Reduced", "Oxidized") + ggtitle("roGFP4")
    gfp5_spectraPlot <- plotSpectra(roGFP5_spectra, "Reduced", "Oxidized") + ggtitle("roGFP5")
    gfp6_spectraPlot <- plotSpectra(roGFP6_spectra, "Reduced", "Oxidized") + ggtitle("roGFP6")

    plot_grid(gfp1_spectraPlot, gfp2_spectraPlot, gfp3_spectraPlot, gfp4_spectraPlot, gfp5_spectraPlot, gfp6_spectraPlot, ncol = 2)

![](complete_roGFP_files/figure-markdown_strict/unnamed-chunk-1-1.png)

iL and iE spectra
-----------------

    gfp1_iE_spectraPlot <- plotSpectra(roGFP1_iE_spectra, "Reduced", "Oxidized") + ggtitle("roGFP1-iE")
    gfp2_iL_spectraPlot <- plotSpectra(roGFP2_iL_spectra, "Reduced", "Oxidized") + ggtitle("roGFP1-iL")

    plot_grid(gfp1_iE_spectraPlot, gfp2_iL_spectraPlot)

![](complete_roGFP_files/figure-markdown_strict/unnamed-chunk-2-1.png)

R12 and R9
----------

    gfp1_R12_spectraPlot <- plotSpectra(roGFP1_R12_spectra, "Reduced", "Oxidized") + ggtitle("roGFP1-R12")
    gfp1_R9_spectraPlot <- plotSpectra(roGFP1_R9_spectra, "Reduced", "Oxidized") + ggtitle("roGFP1-R9")

    plot_grid(gfp1_R9_spectraPlot, gfp1_R12_spectraPlot)

![](complete_roGFP_files/figure-markdown_strict/unnamed-chunk-3-1.png)

12 Total sensors created
------------------------

-   roGFP1 - roGFP6 (6)
-   roGFP1-iE and roGFP2-iL (2)
-   roGFP1-R9 and roGFP1-R12 and empirical roGFP1-R12 (3)
-   grx1\_roGFP2 (No spectra, 1)

<!-- -->

    q <- function(...) {
      sapply(match.call()[-1], deparse)
    }

    sensorList <- q(roGFP1_sensor, roGFP2_sensor, roGFP3_sensor, roGFP4_sensor, 
                    roGFP5_sensor, roGFP6_sensor, roGFP1_iE_sensor, roGFP2_iL_sensor,
                    roGFP1_R9_sensor, roGFP1_R12_sensor, roGFP1_R12_empirical_sensor, grx1_roGFP2_sensor)

    charsMatrix <- c()

    for (sensorName in sensorList) {
        sensor <- get(sensorName)
        charsMatrix <- rbind(charsMatrix, c(sensorName, round(sensor@Rmin,2), 
                                            round(sensor@Rmax,2), round(sensor@delta,2), round(sensor@e0,2)))
    }

    knitr::kable(data.frame(charsMatrix), col.names = c("Sensor", "Rmin", "Rmax", "Delta", "e0"), digits = 2)

<table>
<thead>
<tr class="header">
<th style="text-align: left;">Sensor</th>
<th style="text-align: left;">Rmin</th>
<th style="text-align: left;">Rmax</th>
<th style="text-align: left;">Delta</th>
<th style="text-align: left;">e0</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">roGFP1_sensor</td>
<td style="text-align: left;">4.3</td>
<td style="text-align: left;">30.6</td>
<td style="text-align: left;">0.2</td>
<td style="text-align: left;">-281</td>
</tr>
<tr class="even">
<td style="text-align: left;">roGFP2_sensor</td>
<td style="text-align: left;">0.09</td>
<td style="text-align: left;">1.7</td>
<td style="text-align: left;">0.3</td>
<td style="text-align: left;">-272</td>
</tr>
<tr class="odd">
<td style="text-align: left;">roGFP3_sensor</td>
<td style="text-align: left;">1.04</td>
<td style="text-align: left;">4.69</td>
<td style="text-align: left;">0.23</td>
<td style="text-align: left;">-299</td>
</tr>
<tr class="even">
<td style="text-align: left;">roGFP4_sensor</td>
<td style="text-align: left;">0.04</td>
<td style="text-align: left;">0.16</td>
<td style="text-align: left;">0.35</td>
<td style="text-align: left;">-286</td>
</tr>
<tr class="odd">
<td style="text-align: left;">roGFP5_sensor</td>
<td style="text-align: left;">1.19</td>
<td style="text-align: left;">9.34</td>
<td style="text-align: left;">0.16</td>
<td style="text-align: left;">-296</td>
</tr>
<tr class="even">
<td style="text-align: left;">roGFP6_sensor</td>
<td style="text-align: left;">0.06</td>
<td style="text-align: left;">0.41</td>
<td style="text-align: left;">0.36</td>
<td style="text-align: left;">-280</td>
</tr>
<tr class="odd">
<td style="text-align: left;">roGFP1_iE_sensor</td>
<td style="text-align: left;">0.86</td>
<td style="text-align: left;">3.88</td>
<td style="text-align: left;">0.5</td>
<td style="text-align: left;">-236</td>
</tr>
<tr class="even">
<td style="text-align: left;">roGFP2_iL_sensor</td>
<td style="text-align: left;">0.19</td>
<td style="text-align: left;">0.45</td>
<td style="text-align: left;">0.65</td>
<td style="text-align: left;">-229</td>
</tr>
<tr class="odd">
<td style="text-align: left;">roGFP1_R9_sensor</td>
<td style="text-align: left;">1.58</td>
<td style="text-align: left;">8.53</td>
<td style="text-align: left;">0.27</td>
<td style="text-align: left;">-278</td>
</tr>
<tr class="even">
<td style="text-align: left;">roGFP1_R12_sensor</td>
<td style="text-align: left;">1.58</td>
<td style="text-align: left;">8.26</td>
<td style="text-align: left;">0.27</td>
<td style="text-align: left;">-265</td>
</tr>
<tr class="odd">
<td style="text-align: left;">roGFP1_R12_empirical_sensor</td>
<td style="text-align: left;">0.67</td>
<td style="text-align: left;">5.21</td>
<td style="text-align: left;">0.17</td>
<td style="text-align: left;">-265</td>
</tr>
<tr class="even">
<td style="text-align: left;">grx1_roGFP2_sensor</td>
<td style="text-align: left;">0.3</td>
<td style="text-align: left;">2</td>
<td style="text-align: left;">0.5</td>
<td style="text-align: left;">-272</td>
</tr>
</tbody>
</table>
