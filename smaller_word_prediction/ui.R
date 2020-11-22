library(shiny)
shinyUI(fluidPage(
    titlePanel("Word Prediction"),
    fluidPage(
        sidebarPanel(
            textInput("text",label = h3("Text Input"), value = "please input"),
            submitButton("Submit")
        ),
        mainPanel(
            h3("Predicted Text Output"),
            textOutput("value")
        )
    )
))
