# -*- coding: utf-8 -*-
import glob
import itertools
import json
import os
import random

import matplotlib.pyplot as plt
import neurokit2 as nk
import numpy as np
import pandas as pd
import pyllusion as ill

# Parameters
width = 800
height = 800

# ill.Ebbinghaus(illusion_strength=1, difference=1.4).to_image(width=800, height=800)
# ill.Ebbinghaus(illusion_strength=1, difference=-1.4).to_image(width=800, height=800)

# i = ill.Ebbinghaus(illusion_strength=1, difference=1.4)
# i.get_parameters()["Position_Outer_x_Left"]
# i = ill.Ebbinghaus(illusion_strength=1, difference=-1.4)
# i.get_parameters()["Position_Outer_x_Right"]

# ill.image_circle(size=1, x=0.5, y=0, color="red", width=800, height=800)
# ill.image_circle(size=1, x=-0.5, y=0, color="red", width=800, height=800)

# Delete all existing stimuli
for f in glob.glob("stimuli/*"):
    os.remove(f)


# Convenience functions
def save_mosaic(
    strengths, differences, function, name="Delboeuf", target_only=False, **kwargs
):
    imgs = []
    for strength in [abs(min(strengths, key=abs)), max(strengths)]:
        for difference in [abs(min(differences, key=abs)), max(differences)]:
            img = function(
                illusion_strength=strength, difference=difference, **kwargs
            ).to_image(width=width, height=height, target_only=target_only)
            img = ill.image_text(
                "Difference: "
                + str(np.round(difference, 2))
                + ", Strength: "
                + str(np.round(strength, 2)),
                y=0.88,
                size=40,
                image=img,
            )
            imgs.append(img)
    img = ill.image_mosaic(imgs, ncols=2)
    img = ill.image_line(length=2, rotate=0, image=img)
    img = ill.image_line(length=2, rotate=90, image=img)
    img.save("materials/examples/" + name + "_Mosaic.png")
    return img


def generate_images(
    data, strengths, differences, function, name="Delboeuf", target_only=False, **kwargs
):
    for strength in strengths:
        for difference in differences:
            img = function(
                illusion_strength=strength, difference=difference, **kwargs
            ).to_image(width=width, height=height, target_only=target_only)

            if target_only is True:
                tar = "perceptual_"
            else:
                tar = ""
            path = f"{name}_{tar}{np.round(strength, 5):<07}_{np.round(difference, 5):<07}.png"
            img.save("stimuli/" + path)

            # Compute expected response
            if name in [
                "Delboeuf",
                "Ebbinghaus",
                "VerticalHorizontal",
                "White",
                "Zollner",
                "RodFrame",
            ]:
                if difference > 0:
                    correct = "arrowleft"
                else:
                    correct = "arrowright"
            elif name in ["MullerLyer", "Contrast", "Poggendorff", "Ponzo"]:
                if difference > 0:
                    correct = "arrowup"
                else:
                    correct = "arrowdown"

            # Randomize fixation cross position
            # fix_cross = ["+", " +", "+ ", "\n+", "+\n", "\n +", "\n+ ", " +\n", "+ \n"]

            # Save parameters
            data.append(
                {
                    "Illusion_Type": name,
                    "Illusion_Strength": f"{strength:<012}",
                    "Difference": f"{difference:<012}",
                    "stimulus": "stimuli/" + path,
                    # "fix_cross": random.choice(fix_cross),
                    "data": {
                        "screen": "Trial",
                        "block": name,
                        "correct_response": correct,
                    },
                }
            )

    save_mosaic(strengths, differences, function, name=name, **kwargs)
    return data


def save_json(data, name="stimuli"):
    file = "stimuli/" + name + ".js"
    # 1. Save data to a javascript file
    with open(file, "w") as fp:
        json.dump(data, fp)

    # 2. Re-read and add "var test_stimuli ="
    with open(file) as f:
        updatedfile = "var " + name + " = " + f.read()
    with open(file, "w") as f:
        f.write(updatedfile)


def doublelinspace(mini=0.1, maxi=1, n=6, transformation="lin", show=True):
    log = np.log(np.linspace(np.exp(0), np.exp(1), int(n / 2), endpoint=True))
    log = log * (maxi - mini) + mini

    lin = np.linspace(0, 1, int(n / 2), endpoint=True)
    lin = lin * (maxi - mini) + mini

    exp = nk.expspace(0, 1, int(n / 2), out=float)
    exp = exp * (maxi - mini) + mini

    sq = (np.linspace(0 ** (1 / 2), 1 ** (1 / 2), int(n / 2), endpoint=True)) ** 2
    sq = sq * (maxi - mini) + mini

    cb = (np.linspace(0 ** (1 / 3), 1 ** (1 / 3), int(n / 2), endpoint=True)) ** 3
    cb = cb * (maxi - mini) + mini

    if show is True:
        plt.plot(log, [-0.2] * len(lin), "o", label="log")
        plt.plot(lin, [0] * len(lin), "o", label="linear")
        plt.plot(exp, [0.2] * len(lin), "o", label="exp")
        plt.plot(sq, [0.4] * len(lin), "o", label="square")
        plt.plot(cb, [0.6] * len(lin), "o", label="cube")
        plt.legend()

    if transformation in ["log"]:
        x = log
    if transformation in ["lin", "linear"]:
        x = lin
    elif transformation == "exp":
        x = exp
    elif transformation == "square":
        x = sq
    elif transformation == "cube":
        x = cb

    vec = np.round(np.concatenate((-1 * x[::-1], x)), 5)
    # if mini == -0:
    #     vec = np.delete(vec, [int(size / 2) - 1])

    mid = n // 2
    block1 = np.concatenate((vec[0:mid:2], vec[mid + 1 :: 2]))
    block2 = np.concatenate((vec[1:mid:2], vec[mid::2]))
    return vec, block1, block2


def visualize_density(diffs1, diffs2, strengths1, strengths2):
    # Visualize stimuli
    block1 = list(itertools.product(diffs1, strengths1))
    block2 = list(itertools.product(diffs2, strengths2))
    plt.plot([x[0] for x in block1], [y[1] for y in block1], "o", label="Block 1")
    plt.plot([x[0] for x in block2], [y[1] for y in block2], "o", label="Block 2")
    plt.legend()
    plt.title(f"N total = {len(block1) + len(block2)}")


# =============================================================================
# Make Stimuli
# =============================================================================
data_training = []
data_block1 = []
data_block2 = []

# -------------------------- Vertical Horizontal Illusion --------------------------


# Training
# ----------------

ill.VerticalHorizontal(illusion_strength=-33, difference=1).to_image(
    width=800, height=600
).save("materials/instructions/VerticalHorizontal_Demo.png")

data_training = generate_images(
    data_training,
    strengths=[-33, -4.5, 4.5, 33],
    differences=[-0.9, 0.9],
    function=ill.VerticalHorizontal,
    name="VerticalHorizontal",
)

# Illusion task
# ----------------

_, strengths2, strengths1 = doublelinspace(
    mini=4.5, maxi=45, n=20, transformation="lin"
)
_, diffs1, diffs2 = doublelinspace(mini=0.03, maxi=0.3, n=16, transformation="exp")

visualize_density(diffs1, diffs2, strengths1, strengths2)

data_block1 = generate_images(
    data_block1,
    strengths=strengths1,
    differences=diffs1,
    function=ill.VerticalHorizontal,
    name="VerticalHorizontal",
)

data_block2 = generate_images(
    data_block2,
    strengths=strengths2,
    differences=diffs2,
    function=ill.VerticalHorizontal,
    name="VerticalHorizontal",
)


# -------------------------- MullerLyer Illusion --------------------------

# Training
# ----------------

ill.MullerLyer(illusion_strength=-10, difference=0.7).to_image(
    width=800, height=600
).save("materials/instructions/MullerLyer_Demo.png")

data_training = generate_images(
    data_training,
    strengths=[-23, -3, 3, 23],
    differences=[-0.7, 0.7],
    function=ill.MullerLyer,
    name="MullerLyer",
)

# Illusion task
# ----------------
_, strengths2, strengths1 = doublelinspace(
    mini=3.0, maxi=30, n=20, transformation="lin"
)
_, diffs1, diffs2 = doublelinspace(mini=0.045, maxi=0.45, n=16, transformation="exp")

visualize_density(diffs1, diffs2, strengths1, strengths2)

data_block1 = generate_images(
    data_block1,
    strengths=strengths1,
    differences=diffs1,
    function=ill.MullerLyer,
    name="MullerLyer",
)

data_block2 = generate_images(
    data_block2,
    strengths=strengths2,
    differences=diffs2,
    function=ill.MullerLyer,
    name="MullerLyer",
)


# -------------------------- Ebbinghaus Illusion --------------------------


# Training
# ----------------

ill.Ebbinghaus(illusion_strength=-1.4, difference=1.4).to_image(
    width=800, height=600
).save("materials/instructions/Ebbinghaus_Demo.png")

data_training = generate_images(
    data_training,
    strengths=[-1, -0.15, 0.15, 1],
    differences=[-1.4, 1.4],
    function=ill.Ebbinghaus,
    name="Ebbinghaus",
)

# Illusion task
# ----------------
_, strengths2, strengths1 = doublelinspace(
    mini=0.15, maxi=1.5, n=20, transformation="lin"
)
_, diffs1, diffs2 = doublelinspace(mini=0.05, maxi=0.5, n=16, transformation="exp")

visualize_density(diffs1, diffs2, strengths1, strengths2)


data_block1 = generate_images(
    data_block1,
    strengths=strengths1,
    differences=diffs1,
    function=ill.Ebbinghaus,
    name="Ebbinghaus",
)

data_block2 = generate_images(
    data_block2,
    strengths=strengths2,
    differences=diffs2,
    function=ill.Ebbinghaus,
    name="Ebbinghaus",
)

# -------------------------- Save data --------------------------
save_json(data_training, name="stimuli_training")
save_json(data_block1, name="stimuli_part1")
save_json(data_block2, name="stimuli_part2")

(len(data_training) + len(data_block1) + len(data_block2))
