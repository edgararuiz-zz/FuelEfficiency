library(ggplot2)



shinyServer(
  function(input, output) {

    
    model <- lm(mpg~wt+qsec+am, mtcars)
    
    output$selection <- renderPrint({
      var.qsec <- input$ui.qsec
      var.wt <- input$ui.wt
      var.am <- if(as.numeric(input$ui.am)==0){'Auto'}else{'Manual'}
      
      #print(paste("Weight:",var.wt)); print(paste("Quarter mile:", var.qsec)); print(paste("Transmission:", var.am))
      print(paste("Weight:",var.wt," | Quarter mile:", var.qsec," | Transmission:", var.am))
    }) 
    
    output$wt <- renderPrint({
      var.qsec <- input$ui.qsec
      var.wt <- input$ui.wt
      var.am <- as.numeric(input$ui.am)
      pred.result <- predict(model, data.frame(qsec=var.qsec, wt=var.wt  , am=var.am), interval="conf", level=.95)
      print(paste("95% certain that, on average,MPG will be between",round(pred.result[3], digits=1), "and",round(pred.result[2], digits=1)))
    })
    
    
    output$barWT <- renderPlot({
      var.qsec <- input$ui.qsec
      var.wt <- input$ui.wt
  
      var.am <- as.numeric(input$ui.am)

      
      qsec.auto <-  predict(model, data.frame(qsec=var.qsec, wt=c(1:6),am= 0), interval="conf", level=.95)
      qsec.man <-  predict(model, data.frame(qsec=var.qsec, wt=c(1:6),am= 1), interval="conf", level=.95)
      
      qsec.frame <- rbind(qsec.auto, qsec.man)
      rownames(qsec.frame) <- c(1:12)
      qsec.frame <- as.data.frame(qsec.frame)
      qsec.type <- c(rep("Auto", times=6), rep("Man", times=6))
      qsec.frame <- cbind(qsec.frame, qsec.type)
      qsec.frame <- cbind(qsec.frame, rep(c(1:6),times=2))
      rownames(qsec.frame) <- c(1:12)
      qsec.col <- c("fit", "lwr", "upr","type" ,"wt")
      colnames(qsec.frame) <- qsec.col      
      pred.result <- predict(model, data.frame(qsec=var.qsec, wt=var.wt  , am=var.am), interval="conf", level=.95)
 
      qsec.plot <- ggplot(data=qsec.frame,aes(x=wt,y=fit))
      qsec.plot <- qsec.plot + geom_smooth(aes(ymin=lwr, ymax=upr, fill=factor(type)), data=qsec.frame, stat = "identity")
      qsec.plot <- qsec.plot + annotate("text", label=paste("min:" ,round(pred.result[2],digits=1)), x=var.wt,y=pred.result[2], colour="red") 
      qsec.plot <- qsec.plot + annotate("text", label=paste("max:" ,round(pred.result[3],digits=1)), x=var.wt,y=pred.result[3], colour="red") 
      qsec.plot <- qsec.plot + annotate("pointrange", x = var.wt, y = pred.result[1], ymin = pred.result[2], ymax =pred.result[3],colour = "red", size = 1)
      qsec.plot <- qsec.plot + labs(y="Miles per Gallon", x="Weight (Tons)", title="MPG over Weight")
      qsec.plot <- qsec.plot + scale_fill_discrete(name = "Transmission type", labels=c("Automatic","Manual"))
      qsec.plot <- qsec.plot + theme(legend.position="bottom")
      qsec.plot <- qsec.plot + geom_point(data=subset(mtcars, am==var.am),mapping = aes(x=wt, y=mpg))
      
      plot(qsec.plot)  
            
    })
    
    
    
    output$barQsec<- renderPlot({
  
      
      var.qsec <- input$ui.qsec
      var.wt <- input$ui.wt
      var.am <- as.numeric(input$ui.am)
      
      
      wt.auto <-  predict(model, data.frame(qsec=c(14:23), wt=var.wt,am= 0), interval="conf", level=.95)
      wt.man <-  predict(model, data.frame(qsec=c(14:23), wt=var.wt,am= 1), interval="conf", level=.95)

      wt.frame <- rbind(wt.auto, wt.man)
      rownames(wt.frame) <- c(1:20)
      wt.frame <- as.data.frame(wt.frame)
      wt.type <- c(rep("Auto", times=10), rep("Man", times=10))
      wt.frame <- cbind(wt.frame, wt.type)
      wt.frame <- cbind(wt.frame, rep(c(14:23),tidmes=2))
      rownames(wt.frame) <- c(1:20)
      wt.col <- c("fit", "lwr", "upr","type" ,"qsec") 
      colnames(wt.frame) <- wt.col 
      pred.result <- predict(model, data.frame(qsec=var.qsec, wt=var.wt  , am=var.am), interval="conf", level=.95)
      
      wt.plot <- ggplot(data=wt.frame,aes(x=qsec,y=fit))
      wt.plot <- wt.plot + geom_smooth(aes(ymin=lwr, ymax=upr, fill=factor(type)), data=wt.frame, stat = "identity")
      wt.plot <- wt.plot + annotate("text", label=paste("min:" ,round(pred.result[2],digits=1)), x=var.qsec,y=pred.result[2], colour="red")   
      wt.plot <- wt.plot + annotate("text", label=paste("max:" ,round(pred.result[3],digits=1)), x=var.qsec,y=pred.result[3], colour="red")   
      wt.plot <- wt.plot + annotate("pointrange", x = var.qsec, y = pred.result[1], ymin = pred.result[2], ymax =pred.result[3],colour = "red", size = 1)
      wt.plot <- wt.plot + labs(y="Miles per Gallon", x="Quarter Mile (In Seconds)", title="MPG over Quarter Mile")
      wt.plot <- wt.plot + scale_fill_discrete(name = "Transmission type", labels=c("Automatic","Manual"))
      wt.plot <- wt.plot + theme(legend.position="bottom")
      wt.plot <- wt.plot + geom_point(data=subset(mtcars, am==var.am),mapping = aes(x=qsec, y=mpg))
      plot(wt.plot)
      
      
    })
    
    
  }
)