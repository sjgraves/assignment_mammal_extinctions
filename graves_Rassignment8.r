# Sarah Graves
# R assignment 8
# mammal extinctions
# November 16th, 2015


#### LOAD PACKAGES #####
library(dplyr)
library(ggplot2)

#### CUSTOM FUNCTIONS #####


#### LOAD DATA #####
mammal_sizes <- read.csv("data/MOMv3.3.txt", header = F, sep = "\t", stringsAsFactors = F, na.strings = "-999")

# set column names
colnames(mammal_sizes) <- c("continent", "status", "order", 
                            "family", "genus", "species", "log_mass", "combined_mass", 
                            "reference")


