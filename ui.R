library("ggvis")

shinyUI(pageWithSidebar(
  headerPanel("1973/1974 Fuel Efficiency"),
  sidebarPanel(
    h4('Make your selections'),
    sliderInput('ui.wt', label='Weight (in Tons)',value = 3, min = 1, max = 6, step = 1),
    sliderInput('ui.qsec', label='Quater mile (in Seconds)',value = 18, min = 14, max = 23, step = 1),
    radioButtons('ui.am',label='Transmission Type', choices = c("Manual"=1,"Automatic"=0)),
    h2(' '),
    h4('More info'),
    p('Please click on the Getting Started tab on the right panel for more information about this product')
     ),
  mainPanel(
    tabsetPanel(
    tabPanel("Results",
      h4('Current selection'),
      verbatimTextOutput('selection'), 
      h4(''),
      h4("Results"),
      verbatimTextOutput('wt'),  
      h4(''),
      h4("Plots"),
      plotOutput('barWT'),
      plotOutput('barQsec')),
    tabPanel("Getting Started / Documentation",
       h4('How to interact with this product'),
       p('Move the sliders and the option boxes to update the results'),
       h4('Goal'),
       p('The goal is to estimate the average fuel efficiency based on 3 features of the vehicle.'),
       h4('Why only 3 features?'),
       p('By using a linear regression model, it was determined that the 3 features used are sufficient to estimate the fuel efficiency.'),
       h4('Why a range?'),
       p('Due to the size of the dataset, we can only estimate a range of minimum and maximum average fuel efficiency'),
       p('Statistically speaking, the results say that we are 95% certain that the mean of the population (of 1974 model cars) is somewhere within the range that is returned in the Results section '),
       h4('Plots'),
       p('The plots shows the comparison of Automatic and Manual transmissions, using discrete values for Weight on the first plot (1-6 tons), and Quarter Mile for the second plot (14-23 seconds). The black points show the actual car values for the selected Transmission Type.'),
       h4('Interesting points'),
       p('- The range is smaller the closer the Current Selection is to where the data points are concentrated '),
       p('- The ranges for automatic and manual transmission continually overlap. This says that the True Mean could be the same for both.  We can then conclude that is not possible to say that automatic or manual are better for MPG ')      
             )
    )
  )
))