## A deterministic model for the spread of measles within a secondary school
As part of my co-op at York University, I have set a goal for myself to create a simple model of how measles would spread within a secondary school. 

The accuracy of this model is at best questionable, mostly because as populations get smaller, stochasticity because more and more of a major player in the behavior of the infection and this holds especially true in a confined area such as a secondary school. This is somehow compensated with a set of transmission matrices that will hopefully describe to some *reasonable* accuracy how students in different grades interact with each other.

### Mathematical Model
The current model is a simple compartmental model that is based on an SEIR model, which is most similar to the behavior the measles virus. It has been modified to include a "vaccinated" compartment, as well as accounting for different interactions between students in different grades. A more in-depth explanation follows below.

![](https://i.ibb.co/02JqSDb/image.png)

Here *S* is a function of time representing the portion of the population that is susceptible to the disease, *V* is for the portion that is vaccinated, *E* for exposed, *I* for infected, and *R* for recovered. You will notice that there is a little *i* in subscript for all the functions. This simply means that each grade has it's own version of the compartments. 

There are some important constants to note.

β is a matrix that contains the average number of possible disease-causing interactions that an individual in grade *i* might have with an individual in grade *j*. It is important to note that in any given school day, there are certain periods of the day where an individual will have a different probability of interacting with any individuals. When students are in a hallway, they will have a lower probability of interacting with people in their own grade, but a higher probability of interacting with people in different grades than them. This will be further explored in a future study.

ω represents the *ineffectiveness* of a vaccine. The measles vaccine has been found to be 96.7% effective after a second dose[^1], so in this case, ω is equal to (1 - 0.967).

σ is equal to 1 / X, where X is the average number of latent days of the infection.

γ is equal to 1 / X, where X is the average days it takes to recover from the disease.

Certain dynamics such as births and deaths are (for now) ignored. There are generally two reasons for this. First of all, for the purpose of this study, it is considered impossible for a person to be born into high school, and other situations similar to births, such as a student transferring into the school is considered an unlikely enough event that it can be safely ignored. The second reason is that measles outbreaks are historically quite short, so such dynamics won't generally apply during the outbreak.

------
### Exploration of simulation
tSpan = 1, then students are at home;

tSpan = 2, then students are in the hall, between classes;

tSpan = 3, then students are in class.

Disease always starts in grade 9.

------

**Assuming a vaccinated population of 0%, over 100 days:**
![](https://i.ibb.co/r7tGTrB/1.png)

**Assuming a vaccinated population of 10%, over 100 days:**
![](https://i.ibb.co/P9tzBYF/2.png)

**Assuming a vaccinated population of 25%, over 100 days:**
![](https://i.ibb.co/FmKmNJ1/3.png)

**Assuming a vaccintaed population of 50%, over 100 days:**
![](https://i.ibb.co/nQbgSQH/4.png)

**Assuming a vaccinated population of 90%, over 100 days:**
![](https://i.ibb.co/CMMvxcY/5.png)

Note: 100 days is not enough to show the infection reach it's steady state.

**Assuming a vaccinated population of 100%, over 100 days:**
![](https://i.ibb.co/ygp7450/6.png)

Note: 100 days is not enough to show the infection reach it's steady state.

------

[^1]: Pillsbury, A., & Quinn, H. (2015). An assessment of measles vaccine effectiveness, Australia, 2006-2012. Western Pacific surveillance and response journal : WPSAR, 6(3), 43-50. doi:10.5365/WPSAR.2015.6.2.007
