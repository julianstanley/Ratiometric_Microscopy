# Background on sensors

We work with fluorescent sensors. You shine light of a certain wavelength at them and, depending on that wavelength, the sensor shines light back at different intensities.

The relationship between the wavelength of the of light you shine on a sensor ("excitation wavelength") and the amount of light that it sends back ("emission intensity") is called an absorption spectrum. 

Our sensors have an extra feature in that they have two "states", like the "on" and "off" state of a light switch. In one state, the sensor is oxidized and, in the other, the sensor is reduced. These two different states will have different absorption spectra. For our sensor, they look like Figure 1:

-----------

<img src="C:\Users\Julian\Desktop\2018 Ubuntu Shared\GitShared\Ratiometric_Microscopy\Final Report\Sensor Comparison\rogfp1r12_spectra.jpg" width="500px" />

**Figure 1**. The horizontal (x) axis shows the wavelength $\lambda$ of light being shined on the sensor. The vertical (y) axis shows the amount of light that the sensor shines back at the microscope. Notice that, at the wavelengths around 350-400nm, the sensor gives off  **more** light if it's oxidized but, around 450-600nm, the sensor gives of **less** light if it's oxidized.  That'll come in handy in a moment.

-------

Let's now imagine that you have the GFP1-R12 sensor in a cell and you shine some light on it, and it shines light back at you at a certain intensity. But, when you come back two days later and do the same thing two days later, the intensity changes. This change could be due to different factors--in this case, let's say that some of the GFP1-R12 sensor proteins were degraded. 

To control for that error, we record the ratio of light emitted after the sensor is excited at two different wavelengths. For example: in figure 1 above, a reduced sensor emits at an intensity of ~500 at 410nm and ~400 at 470nm. We might record a $\frac{410nm}{470nm}$ emission level of $\frac{5}{4}$ for the reduced sensor. While the actual emission values (~600 and ~300) may change due to lots of external factors, the *ratio* between those two emission values is relatively stable. We call this ratio between two emission values **R**. Note that we can pick any wavelengths to record a fractional emission level, but we chose $410$ and $470$ because they maximize the contrast between the *oxidized* and *reduced* emission spectra, but that's not important for this section. 



#### Main points

* Ratiometric sensors are like normal fluorescent sensors in that, if you excite them with a certain wavelength of light, they emit light at a certain intensity. 
* To minimize error, we excite ratiometric sensors at *two* wavelengths, and we record the ratio of the emissions at those two different wavelengths. 



# The experimental question

In a real experiment, we are going to have *lots* of sensors proteins giving off light. And, depending on the redox potential within a cell, some percentage of sensors will be oxidized, and some percentage will be reduced.

Our goal in most experiments is to go backwards. We don't know the redox potential or how many sensors are oxidized, but we want to figure it out. So, based on the emission of light that we get from sensors, we want to determine the percentage of sensors that are oxidized and from there figure out the redox potential. How can we do that?



#### Main point

* We want use a measurement from a light-emitting redox sensor to figure out how many sensors are oxidized and how many are reduced, and thereby estimate the redox potential in a cell. 

# Finding the the fraction of oxidized sensors

To start off, let's figure out what the $\frac{410nm}{470nm}$ emission value would be if **all** of the sensors were oxidized. We would say that a cell with all sensors oxidized has a *fraction oxidized*, or *OxD*, of $1$. Looking at the blue trace in Figure 1, we can see the, at $410 nm$, the sensor emits at ~$700$ and, at $470nm$, the sensor emits $~100$. By eye, a $\frac{410nm}{470nm}$ value of $\frac{700}{100}=7$ seems reasonable. Using digitized plot data, we can determine that the actual value is $7.12$, pretty close. Since an *OxD* value of 1--where all sensors are oxidized--is the largest value we could possibly record, so we call it $R_{max}$. 

Then, let's look at the other extreme: what would the $\frac{410nm}{470nm}$ value be if  **none** of the sensors were oxidized? We would say that a cell with no sensors oxidized has an *OxD* of $0$. For that, we look at the red trace in Figure 1. We actually looked at that exact case in the previous section and, by eye, the value seemed close to $\frac{5}{4}$. Again using digitized plot data, the true value is $1.42$. An *OxD* value of 0--where all sensors are reduced--is the smallest value we could possibly record, so we call it $R_{min}$. 

So, what about the case where exactly **half** of the sensors were oxidized, with an *OxD* of 0.5? Intuitively, you might think that the ratio value would be right in the middle of $7.12$ and $1.42$--so $4.27$. But that isn't always the case. 

Previous studies showed that the relationship between the ratio of a sensors emission at two wavelengths ($R$) and the percentage of sensors that are oxidized ($OxD$) depends on one more factor: the ratio of "oxidized" and "reduced" emission values at the second wavelength being measured. If that ratio is $1$ (so, if, at the second wavelength, the sensor emits the same value regardless of whether it's oxidized or reduced), then the sensor behaves as we expect (in a linear manner)--so an *OxD* of 0.5 would be right in the middle of  $7.12$ and $1.42$, at $4.27$. That would be the case if our second wavelength, instead of being $470 nm$, was actually ~$430 nm$ (where the blue and red curves meet in Figure 1). 

In this case, we look at both the blue and red curves in Figure 1 at the $470 nm$ wavelength. So, at $470 nm$ wavelength, the oxidized (blue) trace is around 100 and the reduced (red) trace is around 300 so we can predict that their ratio would be around $\frac{1}{3}$ (based on digitized plots, the value is actually $0.26$) . This ratio means that there is a nonlinear relationship between $R$ and $OxD$, and that, rather half of sensors being oxidized ($OxD = 0.5$) when $R$ is halfway between $R_{min}$ and $R_{max}$, closer to $80\%$ of the sensors will be oxidized at that point ($OxD \approx 0.8$). 

In past literature, this ratio value has been called the *instrument factor*, or $\alpha$. Acknowledging that this value is actually a fold-change at a certain wavelength, we propose the notation of $\delta_{\lambda}$--so, in this case, $\delta_{470}$ is $0.26$, but $\delta_{430}$ is $1$. 

So, in this case, $\delta_{470}$ is $0.26$. What if it were different? Figure 2 shows how the relationship between $R$ and the fraction oxidized at different values of $\delta_{470}$.  

---------

<img src="C:\Users\Julian\Desktop\2018 Ubuntu Shared\GitShared\Ratiometric_Microscopy\Final Report\Figures\R_OxD_delta\R_OXD_delta_JPEG.jpg" width="500px" />

**Figure 2.** The horizontal axis shows all values of the emission ratio $R$, which range from the lowest possible value, $R_{min}$, where no sensors are oxidized, to the highest possible value, $R_{max}$, where all sensors are oxidized. The vertical axis shows the corresponding fraction of sensors that are oxidized, $OxD$. Each line represents a different value of the ratio of emission in the oxidized and reduced form of the $470$ wavelength, $\delta_{470}$. Notice that, for small $\delta_{470}$ values (below 1), when we are halfway between $R_{min}$ and $R_{max}$, our fraction oxidized is bigger than $50\%$ and, for large values (above 1), our fraction oxidized at that $R$ value will be smaller than $50\%$. 

-------------

#### Main points

* The relationship between the emission ratio that we record and the fraction of sensors that are oxidized in a cell depends on three factors: (1) the ratio when all sensors are oxidized, (2) the ratio when no sensors are oxidized, and (3) the ratio of emission between an oxidized and a reduced sensor at the *second* wavelength in the original emission ratio.
* The ratio of emission between an oxidized and reduced sensor at the second wavelength of the original emission ratio changes the linearity of the conversion between the emission ratio and the fraction of oxidized sensors. 
  * When the oxidized/reduced ratio ($\delta$) is one, the relationship is perfectly linear (at halfway between the maximum and minimum emission values, **half** of the sensors are oxidized) 
  * When the oxidized/reduced ratio ($\delta$) is above one, the relationship is concave up (at halfway between the maximum and minimum emission values, **fewer than half** of the sensors are oxidized). 
  * When the oxidized/reduced ratio ($\delta$) is below one, the relationship is concave down (at halfway between the maximum and minimum emission values, **more than half** of the sensors are oxidized). 

# Finding the error in the fraction of oxidized sensors

In a real-world experiment, our measure of the emission ratio $R$ is not going to be perfect. When we perform experiments in *C. elegans* with roGFP-R12, we see a variation in $R$ of about $5\%$. 

...(To be continued)