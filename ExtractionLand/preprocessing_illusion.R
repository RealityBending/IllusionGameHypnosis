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
  rs_json <- toJSON(list(
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


  # Tapping ====================================================================
  # df_tap <- data.frame()
  # for(tap in 1:3) {
  #   s <- paste0("TAP", tap, "_")
  #   tap_start <- min(data[!is.na(data$screen) & data$screen == paste0(s, "waiting"), "time_start"])
  #   tap_times <- data[!is.na(data$screen) & data$screen == paste0(s, "tap"), "time_start"]
  #
  #   df_tap <- rbind(
  #     df_tap,
  #     data.frame(
  #       Participant_ID = demo$Participant_ID,
  #       Trial_Order = 1:length(tap_times),
  #       Tapping_Times = tap_times - tap_start,
  #       Condition = ifelse(tap == 1, "Baseline", ifelse(tap == 2, "Slower", "Faster"))
  #
  #       )
  #     )
  # }

  # TODO
  tap_json <- list()


  # HCT ========================================================================
  hct_count <- data[!is.na(data$screen) & data$screen == "HCT_count", ]
  hct_confidence <- data[!is.na(data$screen) & data$screen == "HCT_confidence", ]
  hct_interval <- data[!is.na(data$screen) & data$screen == "HCT_interval", ]

  df_hct <- data.frame(
    Participant_ID = demo$Participant_ID,
    Trial_Order = 1:nrow(hct_count),
    Answer = as.numeric(unlist(hct_count$response)),
    Confidence = as.numeric(unlist(lapply(unlist(hct_confidence$response), fromJSON))),
    Duration = round(hct_interval$duration * 60, 2),
    Interval = hct_interval$interval
  )

  # TODO: add json metadata with columns info
  hct_json <- list()

  # PI-99 ======================================================================
  pi99 <- data[!is.na(data$screen) & data$screen == "PI99", ]
  pi99 <- lapply(lapply(unlist(pi99$response), fromJSON), as.data.frame)

  pi99[grepl("_R", names(pi99))] <- 5 - pi99[grepl("_R", names(pi99))]

  df$PI_Enticing <- rowMeans(pi99[grepl("GE_", names(pi99))])
  df$PI_Alive <- rowMeans(pi99[grepl("A_", names(pi99))])
  df$PI_Safe <- rowMeans(pi99[grepl("GS_", names(pi99))])
  df$PI_Good <- rowMeans(pi99[grepl("G", names(pi99))])
  df$PI_Changing <- rowMeans(pi99[grepl("Changing", names(pi99))])
  df$PI_Hierarchical <- rowMeans(pi99[grepl("Hierarchical", names(pi99))])
  df$PI_Understandable <- rowMeans(pi99[grepl("Understandable", names(pi99))])

  # MAIA ======================================================================
  maia <- data[!is.na(data$screen) & data$screen == "MAIA", ]
  maia <- lapply(lapply(unlist(maia$response), fromJSON), as.data.frame)

  maia[grepl("_R", names(maia))] <- 1 - maia[grepl("_R", names(maia))]

  df$MAIA_Noticing <- rowMeans(maia[grepl("Noticing", names(maia))])
  df$MAIA_NotDistracting <- rowMeans(maia[grepl("NotDistracting", names(maia))])
  df$MAIA_NotWorrying <- rowMeans(maia[grepl("NotWorrying", names(maia))])
  df$MAIA_AttentionRegulation <- rowMeans(maia[grepl("AttentionRegulation", names(maia))])
  df$MAIA_EmotionalAwareness <- rowMeans(maia[grepl("EmotionalAwareness", names(maia))])
  df$MAIA_SelfRegulation <- rowMeans(maia[grepl("SelfRegulation", names(maia))])
  df$MAIA_BodyListening <- rowMeans(maia[grepl("BodyListening", names(maia))])
  df$MAIA_Trusting <- rowMeans(maia[grepl("Trusting", names(maia))])

  # IAS ======================================================================
  ias <- data[!is.na(data$screen) & data$screen == "IAS", ]
  ias <- lapply(lapply(unlist(ias$response), fromJSON), as.data.frame)
}

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
