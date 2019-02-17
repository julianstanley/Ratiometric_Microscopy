### Point 1: We can determine a cell's redox state from the excitation-emission pattern of a genetically-encoded protein sensor.



**Some background on sensors**

We work with fluorescent sensors. You shine light of a certain wavelength at them and, depending on that wavelength, the sensor shines light back at different intensities.

The relationship between the wavelength of the of light you shine on a sensor ("excitation wavelength") and the amount of light that it sends back ("emission intensity") is called an absorption spectrum. 

Our sensors have an extra feature in that they have two "states", like the "on" and "off" state of a light switch. In one state, the sensor is oxidized and, in the other, the sensor is reduced. These two different states will have different absorption spectra. For our sensor, they look like Figure 1:

------

<img src="C:\Users\Julian\Desktop\2018 Ubuntu Shared\GitShared\Ratiometric_Microscopy\Final Report\Figures\Spectra\GFP1-R12\roGFP1-R12_spectra_JPEG.jpg" width="400px" />

**Figure 1**. The horizontal (x) axis shows the wavelength $\lambda$ of light being shined on the sensor. The vertical (y) axis shows the amount of light that the sensor shines back at the microscope.

---------------



**How do spectra change at different redox states?**

If we have a whole population of sensors, some fraction of them will be oxidized (depending on the redox state of the cell).  If half of the sensors are oxidized and half are reduced, then the resulting excitation-emission spectrum will be exactly halfway between the "oxidized" and "reduced" spectra. In fact, for any percentage of sensors that are oxidized and reduced, the resulting spectra will be the weighted average between the two extreme spectra (Figure 2). 

------------

<img src="C:\Users\Julian\Desktop\2018 Ubuntu Shared\GitShared\Ratiometric_Microscopy\Final Report\Figures\Spectra\GFP1-R12\Mid_Ox\roGFP1r12_mids_even_JPG.jpg" width="400px" />

**Figure 2.** The horizontal axis shows the wavelength $\lambda$ of light being shined on the vertical axis shows the amount of light that the sensor shines back at the microscope. The solid blue line shows the "extreme" case in which all sensors are reduced, and the solid red line shows the "extreme"case where all the sensors are oxidized. For cases where the sensors are not fully oxidized or fully reduced, the emission is a weighted average of the two extremes. 

---------------



**Some background on why the "percent oxidized" is useful**

Our goal with **point 1** is to "determine a cell's redox state", right? So what does the "percent oxidized" have to do with redox state?

Everything, it turns out. When a redox-sensitive GFP is designed, physical chemists generally measure that protein's *midpoint potential*, which is the redox potential at which exactly half of the sensors are oxidized and half are reduced. 

If we know the midpoint potential of a redox-sensitive GFP and the fraction of sensors that are oxidized, we can use the Nernst equation to figure out the redox potential of the environment where the redox-sensitive GFP lives. 

The Nernst equation can be written like this: $E = E^\circ - \frac{RT}{2F}*ln(\frac{Reduced}{Oxidized})$. In that equation, $E$ is the redox potential and $E^\circ$ is the midpoint potential. $R$, $T$, and $F$ are the gas constant, the temperature, and the faraday constant, respectively. These are all constants and, under normal lab conditions, $\frac{RT}{2F}$ equals approximately $12.71$. 

If this doesn't quite make sense yet, let's do an example. Let's figure out what the redox potential of the cell must be if either $30\%$, $50\%$, or $70\%$ of our sensors are oxidized. Let's say that our midpoint potential is $-270 mV$. Also remember that $30\%$ oxidized means that $0.3$ of the sensors are oxidized while $1-0.3=0.7$ of the sensors are reduced.

* $30\%$: $E = -270mV - 12.71 * ln(\frac{0.7}{0.3}) = -280 mV$
* $50\%$: $E = -270mV - 12.71 * ln(\frac{0.5}{0.5}) = -270 mV$ *At $50\%$ oxidized, the potential is the midpoint
* $70\%$: $E = -270mV - 12.71 * ln(\frac{0.3}{0.7}) = -259 mV$

So we can see that, if we can figure out the percentage of sensors that are oxidized in a cell, we can also figure out the redox potential. 



**So, we're done, right?**

So now let's try to set up an experiment. First, you record the emission spectra of an animal in a fully oxidized environment, and then an animal in a fully reduced environment so that you obtain your "extreme" cases of fully oxidized and fully reduced sensors. Then, you measure an animal with an unknown redox potential, and see how closely that spectrum falls towards the oxidized or reduced extreme. From there, you should be able to at least estimate the percentage of sensors that are oxidized.



**Why we're not done yet.**

The big problem with the above approach is that it's difficult and would take a long time to measure the entire emission-excitation spectra for each experimental case.

So what if, instead of measuring the *whole* spectra, we just use one wavelength? For example, at around $400 nm$ in Figure 1, a reduced cell should emit much more light than an oxidized cell, right? The problem with using just one wavelength is that it depends on the concentration of sensors. For example, let's say that you have two cells, Cell A and Cell B. Cell A is fully oxidized, and has 1,000 sensors all emitting light at a relative emission of 500 units, for a total emission of $500 * 1000 = 500,000$ units. Cell B is fully reduced, but only has 500 units. Even though each reduced sensor emits 1000 units of light--twice that of an oxidized sensor--the total emission is $1000 * 500 = 500,000$ units of light, indistinguishable from the oxidized cell.

The solution is to instead use two wavelengths, and take the ratio. Let's take the same case of Cell A and Cell B from the paragraph before. Let's assume that, at wavelength 1, oxidized and reduced sensors emit 500 and 1000 units, respectively and, at wavelength 2, oxidized and reduced sensors emit 150 and 400 units, respectively. If, as before, Cell A is fully oxidized, it's **ratio** emission is $\frac{500*1000}{150 * 100} = 6.67$ ratio units, whereas Cell B is fully reduced with a ratio emission of $\frac{1000 * 500}{400 * 500}  = 2.5$ ratio units. Since ratio is independent of concentration, it can be used to determine the redox potential. 



**Optional detour: Say that again, but this time with math.**

If all the sensors are in an oxidized or reduced state, the emission intensity that we record at any wavelength $\lambda$ is equal to the emission of one sensor at that wavelength, multiplied by the total number of sensors:

$I_{\lambda, Oxidized, Total} = N_{Total} * I_{\lambda, Oxidized}$

$I_{\lambda, Reduced, Total} = N_{Total} * I_{\lambda, Reduced}$



In a mixed population, the emission intensity is a weighted average of the two extremes:

$I_{\lambda, Mixed, Total} = \frac{N_{Oxidized}}{N_{Reduced}}(I_{\lambda, Oxidized, Total} = N_{Total} * I_{\lambda, Oxidized}) + (1-\frac{N_{Oxidized}}{N_{Reduced}})(I_{\lambda, Reduced, Total} = N_{Total} * I_{\lambda, Reduced})$



By taking the ratio between the intensity at two wavelengths ($\lambda_1$ and $\lambda_2$), the total number of molecules $N_{Total}$ cancels:

$R = \frac{I_{\lambda_1, Mixed, Total}}{I_{\lambda_2, Mixed, Total}} = \frac{I_{\lambda_1, Mixed, Total} = \frac{N_{Oxidized}}{N_{Reduced}}(I_{\lambda_1, Oxidized, Total} = N_{Total} * I_{\lambda_1, Oxidized}) + (1-\frac{N_{Oxidized}}{N_{Reduced}})(I_{\lambda_1, Reduced, Total} = N_{Total} * I_{\lambda_1, Reduced})}{I_{\lambda_2, Mixed, Total} = \frac{N_{Oxidized}}{N_{Reduced}}(I_{\lambda_2, Oxidized, Total} = N_{Total} * I_{\lambda_2, Oxidized}) + (1-\frac{N_{Oxidized}}{N_{Reduced}})(I_{\lambda_2, Reduced, Total} = N_{Total} * I_{\lambda_2, Reduced})} =$

$\frac{\frac{N_{Oxidized}}{N_{Total}} * I_{\lambda_1, Oxidized} + (1 - \frac{N_{Oxidized}}{N_{Total}}) * I_{\lambda_1, Reduced}}{\frac{N_{Oxidized}}{N_{Total}} * I_{\lambda_2, Oxidized} + (1 - \frac{N_{Oxidized}}{N_{Total}}) * I_{\lambda_2, Reduced}}$



**Main points, thus far**

- Ratiometric sensors are like normal fluorescent sensors in that, if you excite them with a certain wavelength of light, they emit light at a certain intensity. 

- To record a concentration-independent measure of redox state, we excite ratiometric sensors at *two* wavelengths, and we record the ratio of the emissions at those two different wavelengths. 

  

**How do we find the fraction oxidized from the ratio emission R?**

In short, we use a function that takes an **R** value and returns a fraction oxidized, or **OxD**. That function has three constant values that vary depending on each sensor and each microscope. The first two values are the maximum and minimum values of R, $R_{max}$ and $R_{min}$, which correspond to the $R$ values where all of the sensors are oxidized or all reduced.  The third constant value can be a bit more confusing: it is the ratio between the oxidized and reduced emissions at *one* wavelength, specifically the second wavelength in the ratio ($\lambda_2$ of $R = \frac{I_{\lambda_1}}{I_{\lambda_2}})$. We call that third parameter $\delta_{\lambda_2}$. 

Once we have those three parameters, which we can determine experimentally, we can find the fraction oxidized (**OxD**) by the following equation:

$OxD = \frac{R_{min} - R}{(R_{min} - R) + \delta_{\lambda_2}(R-R_{max})}$

And from there, the redox potential can be found from the fraction oxidized, as we showed above.



**Optional detour: How'd you get that equation?**

Where did that equation for the fraction oxidized come from? 

Assume a fully reduced state. Then, the intensities observed at a wavelength $\lambda$ are equal to the product of $N_T$, the total number of roGFP molecules, and $I_{\lambda, R}$, the intensity of each roGFP molecule at a given wavelength in the  reduced state.
$$
I_{\lambda, R} = N_T * I_{\lambda, R} \\
I_{\lambda, Ox} = N_T * I_{\lambda, Ox}
$$
At a redox state between maximally reduced and maximally oxidized, the intensity at a given wavelength is a weighted sum of the molecules found at either discretely oxidized or reduced state. We therefore can rewrite any state in in terms of the previous two equations (as we showed in the last math detour)
$$
I_{\lambda} = \frac{N_{Ox}}{N_T} * I_{\lambda, Ox} +  \frac{N_{Red}}{N_T} * I_{\lambda, Red}
$$
Consider the intensity ratio:
$$
\frac{I_{\lambda_1}}{I_{\lambda_2}} = \frac{\frac{N_{Ox}}{N_T} * I_{\lambda_1, Ox} +  (1-\frac{N_{Ox}}{N_T}) * I_{\lambda_1, Red}}
                             {\frac{N_{Ox}}{N_T} * I_{\lambda_2, Ox} +  (1-\frac{N_{Ox}}{N_T}) * I_{\lambda_2, Red}} =
$$

For brevity, let $OxD = \frac{N_{Ox}}{N_{T}}​$. Then cross-multiply:

$$
I_{\lambda_1}*OxD*(I_{\lambda_2, Ox} +  (1-OxD) * I_{\lambda_2, Red}) =
$$

$$
I_{\lambda_2}*OxD * (I_{\lambda_1, Ox} +  (1-OxD) * I_{\lambda_1, Red})
$$

Simplify and express $OxD$ in terms of known quantities:

$$
OxD = \frac{I_{\lambda_2}I_{\lambda_1, Red}-I_{\lambda_1}I_{\lambda_2, Red}}{I_{\lambda_1}I_{\lambda_2,Ox} - I_{\lambda_1}I_{\lambda_2, Red} - I_{\lambda_2}I_{\lambda_1, Ox} + I_{\lambda_2}I_{\lambda_1, Red}}
$$
To simplify, let:

$$
R_{Red} = \frac{I_{\lambda_1, R}}{I_{\lambda_2, R}}
$$

$$
R_{Ox} = \frac{I_{\lambda_1, Ox}}{I_{\lambda_2, Ox}}
$$

$$
\frac{I_{\lambda_1}}{I_{\lambda_2}} = \frac{I_{\lambda_1}}{I_{\lambda_2}}
$$

$$
\delta_{\lambda_2} = \frac{I_{\lambda_2,Ox}}{I_{\lambda_2,Red}}
$$

We can now re-derive the definition of $OxD$ in terms of ratio values.

Step: Re-arrange terms, multiply by $\frac{-1}{-1}$:
$$
OxD =  \frac{I_{\lambda_1}I_{\lambda_2,R} - I_{\lambda_2}I_{\lambda_1,R}}{I_{\lambda_1}I_{\lambda_2,R} - I_{\lambda_2}I_{\lambda_1,R} + I_{\lambda_2}I_{\lambda_1,Ox} - I_{\lambda_2, Ox}I_{\lambda_1}}
$$
Step: Work to factor out $I_{470, R}I_{470}$ from the numerator and denominator write some in terms of ratio values:
$$
OxD = \frac{I_{\lambda_2, R}I_{\lambda_2}(\frac{I_{\lambda_1}}{I_{\lambda_2}} - R_{Red})}{I_{\lambda_2, R}I_{\lambda_2}(\frac{I_{\lambda_1}}{I_{\lambda_2}}-R_{Red} + \delta_{\lambda_2}(R_{Ox}-\frac{I_{\lambda_1}}{I_{\lambda_2}}))}  
$$
And simplify:


$$
OxD = \frac{\frac{I_{\lambda_1}}{I_{\lambda_2}} - R_{Red}}{\frac{I_{\lambda_1}}{I_{\lambda_2}}-R_{Red} + \delta_{\lambda_2}(R_{Ox}-\frac{I_{\lambda_1}}{I_{\lambda_2}})} =
$$

$$
\frac{R - R_{Min}}{R-R_{Min} + \delta_{\lambda_2}(R_{Max}-R)}
$$



**Understanding the map from R to OxD**

In the last section, we found the equation for the map between *R* and *OxD*. But what would a graph of that equation look like?

Well, it depends on (1) the properties of the redox sensor and (2) the wavelengths you choose to measure your ratio emissions. 

For the case of roGFP1-R12 and the ratio $\frac{410}{470}$nm, the graph looks like Figure 3. 

----------



<img src="C:\Users\Julian\Desktop\2018 Ubuntu Shared\GitShared\Ratiometric_Microscopy\Final Report\Figures\R_OxD_plain\R_OxD_JPEG.jpg" width="400px" />

**Figure 3.** Map from ratio emission (horizontal axis) to fraction oxidized (vertical axis), for the ratio of $\frac{410}{470}$of the roGFP1-R12 sensor. 

-------------



In general, all graphs between R and OxD will range from $R_{min}$ to $R_{max}$. However, sensors with a $\delta_{\lambda_2}$ value closer to $1$ will have graphs that are more linear. Sensors with a $\delta_{\lambda_2}$ higher than 1 will curve upwards, whereas those with a value lower than 1 will curve downwards (Figure 4). 

-----------

<img src="C:\Users\Julian\Desktop\2018 Ubuntu Shared\GitShared\Ratiometric_Microscopy\Final Report\Figures\R_OxD_delta\R_OXD_delta_no470_JPG.jpg" width="400px" />

**Figure 4.** Map from ratio emission (horizontal axis) to fraction oxidized (vertical axis), a general case for showing the trend for any sensor. 

--------------------



Recall from the previous sections that the $\delta_{\lambda_2}$ depends on the ratio between the emission of an oxidized and reduced sensor at the *second* wavelength in the ratio emission. If that's the case, then choosing different second wavelengths with different ratios between oxidized and reduced emissions should change the linearity of the map between R and OxD (Figure 5). 

---------------------

<img src="C:\Users\Julian\Desktop\2018 Ubuntu Shared\GitShared\Ratiometric_Microscopy\Final Report\tempFigures\delta_twoPanel.png" width="800px" />

**Figure 5** Left: the $\delta$ value (vertical axis) of the roGFP1-R12 sensor at different wavelengths (horizontal axis). Boxes correspond to wavelengths shown in the right panel. Right: The map between R and OxD for roGFP1-R12 when different second wavelengths are chosen for the emission ratio.

-----------



**Understanding the map between R and E**

It's been a few sections since we worked with the Nernst equation, so recall that it's $E = E^\circ - \frac{RT}{2F}*ln(\frac{Reduced}{Oxidized})$, where $E^\circ$ is the midpoint potential and $\frac{RT}{2F}$ is a constant. We can rewrite this equation in terms of only fraction oxidized by writing: $E = E^\circ - \frac{RT}{2F}*ln(\frac{1-Oxidized}{Oxidized})$. If we want to write this equation in terms of $R$, instead of the fraction oxidized, we can just plug in $\frac{R - R_{Min}}{R-R_{Min} + \delta_{\lambda_2}(R_{Max}-R)}$ in the two spots where "Oxidized" occurs. After we do so and simplify, we get the following: 
$$
E(R) = E^\circ - \frac{RT}{2F} * (ln(\delta_{\lambda_2}) + ln(\frac{R_{max} - R}{R - R_{min}}))
$$
This map is centered around some value and, as the ratio gets closer to the minimum or maximum, the redox potential (E) "explodes" in absolute value (Figure 6). 

--------

<img src="C:\Users\Julian\Desktop\2018 Ubuntu Shared\GitShared\Ratiometric_Microscopy\Final Report\Figures\R_E_plain\R_E_plain_JPG.jpg" width="400px" />

**Figure 6.** Map from ratio emission (horizontal axis) to redox potential (vertical axis), for the ratio of $\frac{410}{470}$of the roGFP1-R12 sensor. 

-----------



I mentioned that the map between R and the redox potential is centered around *some* value. That value is called the **adjusted redox potential** ($E^\circ_{adj}$), and it's equal to the redox potential at which $50\%$ of the sensors are oxidized. As we saw with Figure 4, the  R value where $50\%$ of the sensors are oxidized depends on the value of $\delta_{\lambda_2}$. To find the adjusted redox potential, we can rearrange the terms in the equation that maps between R and E:
$$
E(R) = E^\circ - \frac{RT}{2F} *ln(\delta_{\lambda_2}) + \frac{RT}{2F}ln(\frac{R_{max} - R}{R - R_{min}}))
$$
Or:
$$
E(R) = E^\circ_{adj} + \frac{RT}{2F}ln(\frac{R_{max} - R}{R - R_{min}}))
$$
, where 
$$
E^\circ_{adj} = E^\circ + \frac{RT}{2F}ln(\delta_{\lambda_2})
$$


So, if your $\delta_{\lambda_2}$ value equals 1, then $E^\circ_{adj} = E^\circ + \frac{RT}{2F}ln(1) = E^\circ$.   As $\delta_{\lambda_2}$ gets bigger, the adjusted $E^\circ$ decreases by a factor of $\frac{RT}{2F}ln(\delta_{\lambda_2})$, or about $12.71*ln(\delta_{\lambda_2})$, and the opposite for smaller values of $\delta_{\lambda_2}$ (Figure 7). 

-------

<img src="C:\Users\Julian\Desktop\2018 Ubuntu Shared\GitShared\Ratiometric_Microscopy\Final Report\Figures\R_E_delta\R_E_delta_no470_JPG.jpg" width="400px" />

**Figure 7.** Map from ratio emission (horizontal axis) to normalized redox potential (vertical axis), a general case for showing the trend for any sensor. 

-----------



**Conclusion/Summary of point 1**

At this point, we know that a sensor has a distinct excitation-emission pattern, and that we measure a ratio emission from two wavelengths in order to assess the redox state. 

Once we have a ratio measurement, we can find the fraction of sensors oxidized by this equation:
$$
OxD = \frac{R - R_{Min}}{R-R_{Min} + \delta_{\lambda_2}(R_{Max}-R)}
$$
And the redox potential by this equation:
$$
E(R) = E^\circ_{adj} + \frac{RT}{2F}ln(\frac{R_{max} - R}{R - R_{min}}))
$$
The choice of wavelengths for the ratio measurement matters, in part because the choice determines our value for $\delta_{\lambda_2}$, which effects the linearity of the map between R and OxD, and the apparent midpoint of the map between R and E. 

### Point 2: Our ratiometric measurements have some noise, or level of precision. If we know that level of precision, we can estimate how accurately we can measure the redox state.



**Let's revisit our R**

In the previous section, we talked about the ratio emission, $R$. We used R as a measure of how oxidized our population of sensors were. It was important that R was a ratio so that our emission was concentration-independent. 

Thus far, we have treated R like it was a static value. But, like most measurements, it will vary each time we measure it. If we have an object with a known ratio value of $1$ and we measure it $1000$ times, we may get values anywhere between $0.999$ and $1.0001$. We refer to the size, or tightness, of this range as the precision of our measurement. 

Depending on the experimental setup, $R$ may be more or less precise. In the Apfeld lab, our predicted precision of $R$ has a $95\%$ confidence interval of around $\pm 3\%$ So, if we have a known ratio value of $1$, $95\%$ of the values fall between $0.97$ and $1.03$. Thus, for any true value of $R$, there is a range of values that you could observe. Since the error is relative, the larger the true value of $R$, the bigger the range of observable values (Figure 8). 

-------------

<img src="C:\Users\Julian\Desktop\2018 Ubuntu Shared\GitShared\Ratiometric_Microscopy\Final Report\Figures\R_precision\R_precision_R12_JPG.jpg" width="400px" />

**Figure 8**. The true ratio of roGFP1-R12 (horizontal axis) and the range of possible observed ratios (vertical axis). Shaded area represents observable values of R. 

----------



But, we know that our determination of the fraction of sensors that are oxidized and thereby the redox potential is dependent on our value of $R$. So if our $R$ varies by some amount, then our observed measures of $OxD$ and $E$ will also differ. We can see that the level of variation is especially problematic near the minimum and maximum values of R (Figure 9). 

----------

<img src="C:\Users\Julian\Desktop\2018 Ubuntu Shared\GitShared\Ratiometric_Microscopy\Final Report\tempFigures\precision_twoPanel.png" width="800px" />

**Figure 9**. The true ratio of roGFP1-R12 (horizontal axis) and the range of possible observed OxD's (left) and E's (right). Shaded area represents observable values of OxD or E.  

---------



Biologically, why does it matter that our observation of $R$ varies? When we talked about a *true* value of $R$ in the previous discussion, we're talking about the true $R$ that we would expect from a cell that has a certain redox potential. Since we know that every $R$ maps to an $E$, we know what redox potential a cell must have at any true ratio. 

Using that knowledge, we can convert the horizontal axis in Figure 9 (right) to make a new graph. Figure 10 shows that, if we know the true redox potential in a cell, we can predict the ranges of redox potentials that we could observe, given the precision in our measurements. So, for example, if we know that the cytosol of intestinal cells in a worm is around $-260mv$, we can expect to observe values that are very close to that--maybe between $-262 mv$ and $-258 mv$. But, if the cells had a redox potential of $-210mv$ instead, we would see a much bigger range--maybe between $-200mv$ and $-220mv$ (Figure 10). 

--------

<img src="C:\Users\Julian\Desktop\2018 Ubuntu Shared\GitShared\Ratiometric_Microscopy\Final Report\Figures\E_E_Precision\E_E_simple_JPG.jpg" width="400px" />

**Figure 10**. The true redox potential (horizontal axis) and the range of redox potentials you may observe (vertical axis). Shaded area represents observable redox potentials. 

----------



The graph in Figure 10 can be a little hard to interpret, so we can also plot the amount of error in E for every true value for E. In other words: at a redox potential of $260mv$, we can expect our measurements to deviate from $260mv$ by as much as around $2 mv$, given our level of precision (Figure 11).

------------

<img src="C:\Users\Julian\Desktop\2018 Ubuntu Shared\GitShared\Ratiometric_Microscopy\Final Report\Figures\E_E_Precision\E_E_absolute_JPG.jpg" width="400px" />

**Figure 11**. The true redox potential (horizontal axis) and the deviations from the true redox potential you may observe (vertical axis). Shaded region represents possible observed errors. 

--------



**Conclusion/Summary of point 2**

We can measure our precision in $R$ by measuring a cell with a known ratio value (a ratio of $\frac{410}{410}$, for example). We expect our precision to be around $\pm 3\%$. Once we know that precision, we can determine what values of $R$ that we can observe (for any true value). From there, we can estimate how far off our measurements of $E$ may be. Interestingly, the error in our measurement of $E$ depends on what value we're trying to measure--for example, it may be relatively small at $260mv$ but very large at $200mv$. 



### Point 3: If we know how accurately we can measure the redox state at different redox potentials, we can predict a range of values that any given sensor is well-suited to measure. 

We know from the previous section that the roGFP1-R12 sensor is better-suited to measure $-260mv$ than $-200mv$. But what range of values is the sensor *well-suited* to measure? 

The definition of *well-suited* will depend on the question being asked. If we are looking for large differences--of say, $40mv$--the sensor may be well-suited to measure a very wide range of redox potentials. But, for seeing small differences, it may only be well-suited to a smaller range. 

To help us made a decision, we can use a sensor phase plot, like the one in Figure 12. We choose some cutoff of desired accuracy (in this case, we chose $2mv$) and all redox potentials that fall within the curve and to the left of that cutoff are potentials that the sensor is well-suited to measure.

--------

<img src="C:\Users\Julian\Desktop\2018 Ubuntu Shared\GitShared\Ratiometric_Microscopy\Final Report\Figures\Phase_plot\Phase_Descriptions_R12_JPG.jpg" width="400px" />

**Figure 12**. The accuracy is shown in the horizontal axis. For example, an accuracy of $2mv$ means that, given the known precision, we can expect measurements to be within $2mv$ of the true value. Redox potentials are shown on the vertical axis. Redox potentials within the curve can be measured at the accuracy in which they first enter the curve, and all redox values within a vertical cross-section at a certain accuracy can be measured within that accuracy.

-------------



If we know that we want all of our values to be accurate within $2mV$, and we know the range of biological values that we expect to measure, we determine whether the range of values that our sensor is well-suited to measure includes the biological range (Figure 13). 

--------

<img src="C:\Users\Julian\Desktop\2018 Ubuntu Shared\GitShared\Ratiometric_Microscopy\Final Report\tempFigures\comparison_bioRange.png" width="600px" />

**Figure 13**. The range of redox values that roGFP1-R12 is well-suited to measure includes all of the biological range we wish to study.

-----------



**Conclusion/Summary of point 3**

When we are beginning an experiment, if we know (1) the approximate biological range of values we wish to study, and (2) the accuracy to which we need to observe that biological range, we can determine whether our sensor is well-suited for the experiment.



### Point 4: If we can predict a values that any sensor is well-suited to measure, we can compare how well different sensors can measure redox values that we care about. 

In the previous section, we looked at the suitability of *one* sensor to measure a range of values. However, that analysis can also be applied to comparing sensors. 

As an example, let's take five sensors: roGFP1, roGFP1, roGFP1-R12, roGFP1-iE, and roGFP2-iL. We can see that they occupy different spaces of redox potentials at different levels of accuracy (Figure 14). We can see, for example, that roGFP1-iE and roGFP2-iL occupy very similar spaces, but roGFP1-iE almost always has a higher accuracy than roGFP2-iL, so the later should probably only be used for reasons unrelated to accuracy, like kinetics or ease of use. 

--------------------

<img src="C:\Users\Julian\Desktop\2018 Ubuntu Shared\GitShared\Ratiometric_Microscopy\Final Report\tempFigures\comparison_phase_many.png" width="500px"/>

**Figure 14.** Phase plot to compare multiple sensors. The accuracy is shown in the horizontal axis. Redox potentials are shown on the vertical axis. Redox potentials within the curve can be measured at the accuracy in which they first enter the curve, and all redox values within a vertical cross-section at a certain accuracy can be measured within that accuracy.

--------------



Just as before, the phase plot can be compressed down to a 2D plot once we choose a suitable accuracy. For example, let's say that we would like to be accurate to $2mv$ and we are trying to measure a wide range of values, from $-320mv$ to $-260 mv$. In that case, we can see that no one sensor is well-suited to measure that entire range, but roGFP1, roGFP2, and roGFP1-R12 can each measure a subset of the range (Figure 15).

---------

<img src="C:\Users\Julian\Desktop\2018 Ubuntu Shared\GitShared\Ratiometric_Microscopy\Final Report\tempFigures\comparison_many_2.png" width="500px"/>

**Figure 13**. A comparison of the redox potentials that each of five sensors are well-suited to measure to an accuracy of $2mv$. 

---------







