# Sarah Graves
# R assignment 8
# mammal extinctions
# November 16th, 2015


#### LOAD PACKAGES #####
library(dplyr)
library(ggplot2)

#### CUSTOM FUNCTIONS #####
subset_mammal_data <- function(data){
  # subset data frame to only include extinct and extant species groups
  subset_data1 <- data[data$status == "extinct" | data$status == "extant",]
  
  subset_data2 <- subset_data1[subset_data1$continent != "Af",]
  
  return(subset_data2)
}


calculate_mean_mass_byGroups <- function(data, groups, type = "long"){
  # calcualtes the mean of the "combined_mass" column across different groups
  # NAs are removed from the calculation
  # only extinct and extant status groups are considered
  # inputs: 
  #   data = data frame with column to be averaged, must have the "combined_mass"column
  #   groups = character vector that specify which columns to group by
 
  mean_df <- 
    data %>% 
    # use the vector of groups in the group by function
    # information for how to do this found here: 
    # http://stackoverflow.com/questions/21208801/group-by-multiple-columns-in-dplyr-using-string-vector-input
    group_by_(.dots = groups) %>% 
    summarize(mean_mass = mean(combined_mass, na.rm = T)) 

  
  # return output format based on designated type
  # long format is the output of the summarize function
  # return the dataframe as is
  if (type == "long"){
    
    return(mean_df)
  
  # if the wide format is specified, convert from long to wide
    # this format is useful for summary tables
    # use the spread function of the tidyr package
    # specify the status as the "key" column and the mean_mass as the "value" column
  } else {
    
    mean_df_wide <- 
    mean_df %>% 
      spread(status,mean_mass)
    
    return(mean_df_wide)
  }
  
}
  


#### LOAD DATA #####
mammal_sizes <- read.csv("data/MOMv3.3.txt", header = F, sep = "\t", stringsAsFactors = F, na.strings = "-999")

# set column names
colnames(mammal_sizes) <- c("continent", "status", "order", 
                            "family", "genus", "species", "log_mass", "combined_mass", 
                            "reference")

#### SUBSET DATA ####

# use function to re-assign data object as a subset of the data
mammal_sizes <- subset_mammal_data(mammal_sizes)


#### CALCULATE MEAN MASS BY STATUS GROUP ####

# apply the custom function to generate table of mean mass by status group
mean_mass_byStatus <- calculate_mean_mass_byGroups(mammal_sizes, groups = "status")

mean_mass_byStatus

#### CALCULATE MEAN MASS BY STATUS AND CONTINENT ####

# apply the custom function to generate a table of the mean mass for extant and extinct species for each continent
# use the wide format
mean_mass_byStatusContinent <- calculate_mean_mass_byGroups(mammal_sizes, groups = c("status","continent"), type="wide")

# save the summary by status and continent to csv file
write.csv(mean_mass_byStatusContinent,"data/continent_mass_differences.csv")




