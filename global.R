library(shiny)
library(ggplot2)
library(plyr)
library(RColorBrewer)

# Data is a subset of the original data file, and cleaned with OpenRefine

data <- read.table("data.tsv", 
                   header = TRUE,
                   sep = "\t",
                   encoding = "UTF-8",
                   stringsAsFactors = FALSE)

names(data) <- c("id", "decade", "composer")

# Get rid of unnecessary (here) chars in strings
data$id <- sub("_.+", "", data$id)
data$decade <- substring(data$decade, 1, 3)

# Number of concerts per decade
concerts <- aggregate(data$id, by = list(Decade = data$decade), function(x) length(unique(x)))
# Clean composer data
data <- data[data$composer != "***",]
data <- data[data$composer != "",]
data <- data[data$composer != "väliaika",]

# How many works by a composer was played in various concerts?
playedByConcert <- count(data, c("decade", "id", "composer"))
playedByConcertOrder <- playedByConcert[order(playedByConcert$freq, decreasing = TRUE), c("id", "composer", "freq")]
n <- 7
multi <- playedByConcertOrder[playedByConcertOrder$freq >= n,]
names(multi) <- c("Date", "Composer", "Number of works")
# http://stackoverflow.com/questions/8652674/r-xtable-and-dates
multi$Date <- as.character(as.Date(multi$Date, "%Y%m%d"))

# How many works by a composer was played in a decade?
# Same as: aggregate(data$year, by = list(Decade = data$decade, Composer = data$composer), function(x) length(x))
playedByDecade <- count(data, c("decade", "composer"))

# Combined stats for calculating percentages
stats <- merge(playedByDecade, concerts, by.x = "decade", by.y = "Decade")
names(stats) <- c("Decade", "composer", "inConcert", "allConcerts")

# In how many concerts have composers been played in percentually by decade?
stats$percent <- round((stats$inConcert / stats$allConcerts) * 100, 2)

# How much composers to show to choose from = number of works played at least in one decade
nc <- 50


