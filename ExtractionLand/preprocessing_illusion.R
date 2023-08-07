library(tidyverse)
library(lubridate)
library(jsonlite)

# Initialize data
metadata_participants <- data.frame()

demo <- data.frame(Participant_ID = character(),
                   Gender = character(),
                   Age = numeric(),
                   Ethnicity = character(),
                   stringsAsFactors = FALSE)

# List participants files
participants <- list.files("pilots/beh/")

participant <- "auz_test_phase1.json"

# Function to capitalize the first letter of a string
capitalize_first <- function(x) {
  paste0(toupper(substr(x, 1, 1)), substr(x, 2, nchar(x)))
}

# Loop through participants
for (participant in participants) {
  
  # Load file
  data <- fromJSON(paste0("pilots/beh/", participant), flatten = TRUE)
  
  # Find participant ID
  participant_id <- data[!is.na(data$screen) & data$screen == "participant_info", "response"][[1]]$Participant_ID
  
  # Find demographic information from "demographics" screen
  demographic_response <- data[!is.na(data$screen) & data$screen == "demographics", "response"][[1]]
  
  # Find gender, age, and ethnicity
  gender <- demographic_response$gender
  gender <- capitalize_first(gender)
  gender <- ifelse(gender %in% c("Nonbinary", "Non_binary", "Non-binary"), "Other", gender)
  if (!gender %in% c("Female", "Male", "Other")) {
    stop(paste("Manually assign gender:", gender))
  }
  
  age <- as.numeric(demographic_response$age)
  if (!is.na(age) && (age < 18 || age > 85)) {
    stop("Manually assign age")
  }
  
  ethnicity <- demographic_response$ethnicity
  ethnicity <- capitalize_first(ethnicity)
  valid_ethnicities <- c(
    "White",
    "English / Welsh / Scottish / Northern Irish / British",
    "Irish",
    "Gypsy or Irish Traveller",
    "Any other White background",
    "Mixed / Multiple ethnic groups",
    "White and Black Caribbean",
    "White and Black African",
    "White and Asian",
    "Any other Mixed / Multiple ethnic background",
    "Asian / Asian British",
    "Indian",
    "Pakistani",
    "Bangladeshi",
    "Chinese",
    "Any other Asian background",
    "Black / African / Caribbean / Black British",
    "African",
    "Caribbean",
    "Any other Black / African / Caribbean background",
    "Other ethnic group",
    "Arab",
    "Any other ethnic group"
  )
  if (!ethnicity %in% valid_ethnicities) {
    stop("Manually assign ethnicity")
  }
  
  # Save
  demo <- rbind(demo, data.frame(
    Participant_ID = participant_id,
    Gender = gender,
    Age = age,
    Ethnicity = ethnicity
  ))
}
  
  metadata_participants <- rbind(metadata_participants, demo)

  # RS =========================================================================
  rs <- data[!is.na(data$screen) & data$screen == "RS_assessment", ]

  df_rs <- as.data.frame(fromJSON(unlist(rs$response)))
  df_rs <- df_rs[, order(colnames(df_rs))] # Reorder by alphabetical order
  df_rs <- cbind(data.frame(
    Participant_ID = demo$Participant_ID,
    Duration = rs$rt / 1000 / 60
  ), df_rs)

  # Metadata
  # TODO: complete with all the items
  metadata_phase1 <- toJSON(list(
    Participant_ID = list(
      Description = "Unique participant identifier"
    ),
    Duration = list(
      Description = "Time to complete the post resting state assessment",
      Units = "minutes"
    ),
    Age = list(
      Description = "The age of the participant",
      Units = "years"
    ),
    Gender = list(
      Description = "Gender of the participant",
      Units = "NA"  # Since it's a categorical variable, units are not applicable
    ),
    Ethnicity = list(
      Description = "Ethnicity of the participant",
      Units = "NA"  # Since it's a categorical variable, units are not applicable
    ),
    DoM = list(
      Description = "Discontinuity of Mind,average score for Resting State questionaire"
    ),
    ToM = list(
      Description = "Theory of Mind, average score for Resting State questionaire"
    ),
    Self = list(
      Description = "Self, average score for Resting State questionaire"
    ),
    Plan = list(
      Description = "Planning, average score for Resting State questionaire"
    ),
    Sleep = list(
      Description = "Sleepiness, average score for Resting State questionaire"
    ),
    Comfort = list(
      Description = "Comfort, average score for Resting State questionaire"
    ),
    SomA = list(
      Description = "Somatic Awarness, average score for Resting State questionaire"
    )
  ), auto_unbox = TRUE)


  # IPIP6 =====================================================================
  ipip6 <- data[!is.na(data$screen) & data$screen == "IPIP6", ]
  ipip6 <- lapply(lapply(unlist(ipip6$response), fromJSON), as.data.frame)
  
  
  # Reverse scores with "_R" suffix
  ipip6[grepl("_R", names(ipip6))] <- 7 - ipip6[grepl("_R", names(ipip6))]
  
  
  # Calculate scores for IPIP6 dimensions
  df$IPIP6_Extraversion <- rowMeans(ipip6[grepl("Extraversion", names(ipip6))])
  df$IPIP6_Agreeableness <- rowMeans(ipip6[grepl("Agreeableness", names(ipip6))])
  df$IPIP6_Conscientiousness <- rowMeans(ipip6[grepl("Conscientiousness", names(ipip6))])
  df$IPIP6_Neuroticism <- rowMeans(ipip6[grepl("Neuroticism", names(ipip6))])
  df$IPIP6_Openness <- rowMeans(ipip6[grepl("Openness", names(ipip6))])
  df$IPIP6_HonestyHumility <- rowMeans(ipip6[grepl("HonestyHumility", names(ipip6))])
  
  # Metadata for IPIP6
  ipip6_json <- toJSON(list(
    IPIP6_Extraversion = list(
      Description = "Extraversion dimension score for IPIP6 questionnaire",
      Units = "NA"  
    ),
    IPIP6_Agreeableness = list(
      Description = "Agreeableness dimension score for IPIP6 questionnaire",
      Units = "NA"
    ),
    IPIP6_Conscientiousness = list(
      Description = "Conscientiousness dimension score for IPIP6 questionnaire",
      Units = "NA"
    ),
    IPIP6_Neuroticism = list(
      Description = "Neuroticism dimension score for IPIP6 questionnaire",
      Units = "NA"
    ),
    IPIP6_Openness = list(
      Description = "Openness dimension score for IPIP6 questionnaire",
      Units = "NA"
    ),
    IPIP6_HonestyHumility = list(
      Description = "HonestyHumility dimension score for IPIP6 questionnaire",
      Units = "NA"
    )
  ), auto_unbox = TRUE)
  
  
  # PID5 ======================================================================
  pid5 <- data[!is.na(data$screen) & data$screen == "PID5", ]
  pid5 <- lapply(lapply(unlist(pid5$response), fromJSON), as.data.frame)
  
  # Reverse scores with "_R" suffix
  pid5[grepl("_R", names(pid5))] <- 5 - pid5[grepl("_R", names(pid5))]
  
  # Calculate scores for PID5 dimensions
  df$PID5_Disinhibition <- rowMeans(pid5[grepl("Disinhibition", names(pid5))])
  df$PID5_Detachment <- rowMeans(pid5[grepl("Detachment", names(pid5))])
  df$PID5_Psychoticism <- rowMeans(pid5[grepl("Psychoticism", names(pid5))])
  df$PID5_NegativeAffect <- rowMeans(pid5[grepl("NegativeAffect", names(pid5))])
  df$PID5_Antagonism <- rowMeans(pid5[grepl("Antagonism", names(pid5))])
  
  # Metadata for PID5
  pid5_json <- toJSON(list(
    PID5_Disinhibition = list(
      Description = "Disinhibition dimension score for PID5 questionnaire",
      Units = "NA"  
    ),
    PID5_Detachment = list(
      Description = "Detachment dimension score for PID5 questionnaire",
      Units = "NA"
    ),
    PID5_Psychoticism = list(
      Description = "Psychoticism dimension score for PID5 questionnaire",
      Units = "NA"
    ),
    PID5_NegativeAffect = list(
      Description = "Negative Affect dimension score for PID5 questionnaire",
      Units = "NA"
    ),
    PID5_Antagonism = list(
      Description = "Antagonism dimension score for PID5 questionnaire",
      Units = "NA"
    )
  ), auto_unbox = TRUE)
  

# Copy physio into clean



# Save participants metadata
path <- "./Reality Bending Lab - PrimalsInteroception/"

write.table(metadata_participants, file = paste0(path, "participants.tsv"), quote = FALSE, sep = "\t", row.names = FALSE)

metadata_participants_json <- toJSON(list(
  Participant_ID = list(
    Description = "Unique participant identifier"
  ),
  gender = list(
    Description = "Gender of the participant",
    Levels = list("Female" = "female", "Male" = "male")
  ),
  age = list(
    Description = "Age of the participant at time of testing",
    Units = "years"
  )
), auto_unbox = TRUE)

write(metadata_participants_json, paste0(path, "participants.json"))
