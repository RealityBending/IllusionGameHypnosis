import io
import os
import time

import autoreject
import matplotlib.pyplot as plt
import mne
import neurokit2 as nk
import numpy as np
import pandas as pd
import PIL
import pyllusion as ill
import scipy.stats

# Convenience functions ======================================================================
mne.set_log_level(verbose="WARNING")


# Variables ==================================================================================
# Change the path to your local data folder.
# The data can be downloaded from OpenNeuro (TODO).
path = "C:/Users/domma/Box/Data/IllusionGameHypnosis/Reality Bending Lab - IllusionGameHypnosis/"
# path = "C:/Users/dmm56/Box/Data/IllusionGameHypnosis/Reality Bending Lab - IllusionGameHypnosis/"

# Get participant list
meta = pd.read_csv(path + "participants.tsv", sep="\t")

# Initialize variables
df = pd.DataFrame()

# sub = "sub-001"
# Loop through participants ==================================================================
for sub in meta["participant_id"].values:
    # Print progress and comments
    print(sub)
    print("  * " + meta[meta["participant_id"] == sub]["Comments"].values[0])

    # Path to EEG data
    path_eeg = path + sub + "/eeg/"
    path_beh = path + sub + "/beh/"

    # Questionnaires -------------------------------------------------------------------------
    file = [file for file in os.listdir(path_beh) if "Questionnaires" in file]
    file = path_beh + [f for f in file if ".tsv" in f][0]
    dfsub = pd.read_csv(file, sep="\t")

    # Illusion Game --------------------------------------------------------------------------
    # Load behavioral data
    file = [file for file in os.listdir(path_beh) if "IG" in file]
    file = [path_beh + f for f in file if ".tsv" in f]
    df_ig = pd.concat([pd.read_csv(i, sep="\t") for i in file], axis=0)


# Clean up and Save data
dfsub = pd.merge(meta, dfsub)
dfsub.to_csv("../data/data_Participants.csv", index=False)
df_ig.to_csv("../data/data_IllusionGame.csv", index=False)

print("Done!")
