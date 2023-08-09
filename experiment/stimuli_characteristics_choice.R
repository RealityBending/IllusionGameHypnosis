library(tidyverse)
library(easystats)
library(patchwork)

# Path to existing GAM models
path1 <- "C:/Dropbox/RECHERCHE/Studies/2023/IllusionGameValidation/study2/models/"
path2 <- "C:/Dropbox/RECHERCHE/Studies/IllusionGameReliability/analysis/models/"


for(i in c("ebbinghaus", "verticalhorizontal", "mullerlyer")) {
  load(paste0(path2, "gam_", i, "_err.RData"))
  load(paste0(path2, "gam_", i, "_rt.RData"))
}

gam_ebbinghaus_err2 <- gam_ebbinghaus_err
gam_ebbinghaus_rt2 <- gam_ebbinghaus_rt
gam_verticalhorizontal_err2 <- gam_verticalhorizontal_err
gam_verticalhorizontal_rt2 <- gam_verticalhorizontal_rt
gam_mullerlyer_err2 <- gam_mullerlyer_err
gam_mullerlyer_rt2 <- gam_mullerlyer_rt

for(i in c("ebbinghaus", "verticalhorizontal", "mullerlyer")) {
  load(paste0(path1, "gam_", i, "_err.RData"))
  load(paste0(path1, "gam_", i, "_rt.RData"))
}


get_minmax <- function(gam_err) {
  d <- insight::get_data(gam_err)
  paste0("Illusion Diff: [", min(d$Illusion_Difference), ", ", max(d$Illusion_Difference), "]")
}

make_plot <- function(gam_err, gam_rt, gam_err2=NULL, gam_rt2=NULL, diff=NULL, strength=NULL, error = 0.2){
  prederr <- estimate_relation(gam_err, at=c(diff, "Illusion_Strength"), length=c(5, 100))
  predrt <- estimate_relation(gam_rt, at=c(diff, "Illusion_Strength"), length=c(5, 100)) |>
    mutate(Predicted = datawizard::rescale(Predicted, to=c(min(prederr$Predicted), max(prederr$Predicted))))

  p <- ggplot(prederr, aes(x = Illusion_Strength, y=Predicted)) +
    geom_hline(yintercept=error, linetype="dotted") +
    geom_vline(xintercept=strength, linetype="dotted") +
    geom_line(data=predrt, aes(color=Illusion_Difference, group=Illusion_Difference), linetype="dashed", linewidth=1)

  if(!is.null(gam_err2)) {
    prederr2 <- estimate_relation(gam_err2, at=c(diff, "Illusion_Strength"), length=c(5, 100))
    predrt2 <- estimate_relation(gam_rt2, at=c(diff, "Illusion_Strength"), length=c(5, 100)) |>
      mutate(Predicted = datawizard::rescale(Predicted, to=c(min(prederr$Predicted), max(prederr$Predicted))))
    p <- p +
      geom_line(data=prederr2, aes(color=Illusion_Difference, group=Illusion_Difference), linewidth=1, alpha=0.5) +
      geom_line(data=predrt2, aes(color=Illusion_Difference, group=Illusion_Difference), linetype="dashed", linewidth=1, alpha=0.5)
  }

  p +
    geom_line(aes(color=Illusion_Difference, group=Illusion_Difference), linewidth=1) +
    theme_modern() +
    scale_colour_gradientn(colours=c("#F44336", "#FFB300", "#4CAF50"))
}

# Vertical Horizontal
p1 <- make_plot(gam_verticalhorizontal_err, gam_verticalhorizontal_rt,
          gam_verticalhorizontal_err2, gam_verticalhorizontal_rt2,
          diff="Illusion_Difference=c(0.05, 0.225)",
          strength=c(-45, 45), error=c(0.2)) |
  make_plot(gam_verticalhorizontal_err, gam_verticalhorizontal_rt,
            diff="Illusion_Difference=c(0.03, 0.3)",
            strength=c(-45, 45), error=c(0.1))
p1


# Muller-Lyer
get_minmax(gam_mullerlyer_err)
p2 <- make_plot(gam_mullerlyer_err, gam_mullerlyer_rt,
          gam_mullerlyer_err2, gam_mullerlyer_rt2,
          diff="Illusion_Difference=c(0.05, 0.35)",
          strength=c(-23, 23), error=c(0.2)) |
  make_plot(gam_mullerlyer_err, gam_mullerlyer_rt,
            diff="Illusion_Difference=c(0.045, 0.45)",
            strength=c(-30, 30), error=c(0.1))
p2

# Ebbinghaus
get_minmax(gam_ebbinghaus_err)
p3 <- make_plot(gam_ebbinghaus_err, gam_ebbinghaus_rt,
          gam_ebbinghaus_err2, gam_ebbinghaus_rt2,
          diff="Illusion_Difference=c(0.09, 0.28)",
          strength=c(-1, 1), error=c(0.2)) |
  make_plot(gam_ebbinghaus_err, gam_ebbinghaus_rt,
            diff="Illusion_Difference=c(0.05, 0.5)",
            strength=c(-1.5, 1.5), error=c(0.1))
p3



p1 / p2 / p3
