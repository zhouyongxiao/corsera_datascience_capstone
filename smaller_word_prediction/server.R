library(shiny)
library(plyr)
if (!exists('freq.bigram.twitter')) {
        freq.bigram.twitter <- readRDS(file = "freq_bigram_twitter.rds")
}
predict_word <- function(rawinput, input_length) {
        input_value <- rawinput
        splitted <- strsplit(input_value, " ")
        if (input_length > 1) {
        input_value <- paste(splitted[[1]][input_length])
        input_length <- 1
        }
        word_twitter <- data.frame(freq.bigram.twitter[grep(paste('^',input_value, '[[:space:]][[:alnum:]]', sep = ""),freq.bigram.twitter[,2])[c(1:5)],])
        wordtable <- word_twitter
        if (!is.na(wordtable[1,1])){
        wordtable_new <- ddply(wordtable, .(word), summarise, frequency = sum(frequency))
        wordtable_new <- (wordtable_new[order(wordtable_new$frequency, decreasing = TRUE),])
        word_list <- sapply(strsplit(as.character(wordtable_new[, 1]), split = " "), "[", input_length + 1 )
        } else {
        word_list <- '_noword_'
        }
        mylist <- list("word_list" = word_list, "input_length" = input_length, "input_value" = input_value)
        return(mylist)
}
shinyServer(function(input, output) {
        output$value <- renderText({
                input_length <- sapply(strsplit(input$text, " "), length)
                rawinput <- input$text
                if (!exists('freq.bigram.twitter')) {
                        freq.bigram.twitter <- readRDS(file = "freq_bigram_twitter.rds")
                }
                temp_result <- predict_word(rawinput, input_length)
                word_list <- paste(strsplit(temp_result$word_list, " "), collapse=", ")
    })
})
