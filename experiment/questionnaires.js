// Mini IPIP6 questionnaire
var ipip6_items = [
    "I am the life of the party",
    "I sympahtize with others' feelings",
    "I get chores done right away",
    "I have frequent mood swings",
    "I have a vivid imagination",
    "I feel entitled to more of everything",
    "I dont talk a lot",
    "I am not interested in other people's problems",
    "I have difficulty understanding abstract ideas",
    "I like order",
    "I make a mess of things",
    "I deserve more things in life",
    "I do not have a good imagination",
    "I feel others' emotions",
    "I am relaxed most of the time",
    "I get upset easily",
    "I seldom feel blue",
    "I would like to be seen driving around in a really expensive car",
    "I keep in the background",
    "I am not really interested in others",
    "I am not interested in abstract ideas",
    "I often forget to put things back in their proper place",
    "I talk to a lot of different people at parties",
    "I would get a lot of pleasure from owning expensive luxury goods",
]
var ipip6_dimensions = [
    "Extraversion_1",
    "Agreeableness_2",
    "Conscientiousness_3",
    "Neuroticism_4",
    "Openness_5",
    "HonestyHumility_6_R",
    "Extraversion_7_R",
    "Agreeableness_8_R",
    "Openness_9_R",
    "Conscientiousness_10",
    "Conscientiousness_11_R",
    "HonestyHumility_12_R",
    "Openness_13_R",
    "Agreeableness_14",
    "Neuroticism_15_R",
    "Neuroticism_16",
    "Neuroticism_17_R",
    "HonestyHumility_18_R",
    "Extraversion_19_R",
    "Agreeableness_20_R",
    "Openness_21_R",
    "Conscientiousness_22_R",
    "Extraversion_23",
    "HonestyHumility_24_R",
]

// Personality Inventory for DSM-V - Brief (Maladaptive Traits)
var pid_items = [
    "People would describe me as reckless",
    "I feel like I act totally on impulse",
    "Even though I know better, I can't stop making rash decisions",
    "I often feel like nothing I do really matters",
    "Others see me as irresponsible",
    "I'm not good at planning ahead",
    "My thoughts often don't make sense to others",
    "I worry about almost everything",
    "I get emotional easily, often for very little reason",
    "I fear being alone in life more than anything else",
    "I get stuck on one way of doing things, even when it's clear it won't work",
    "I have seen things that weren't really there",
    "I steer clear of romantic relationships",
    "I'm not interested in making friends",
    "I get irritated easily by all sorts of things",
    "I don't like to get too close to people",
    "It's no big deal if I hurt other people's feelings",
    "I rarely get enthusiastic about anything",
    "I crave attention",
    "I often have to deal with people who are less important than me",
    "I often have thoughts that make sense to me but that other people say are strange",
    "I use people to get what I want",
    "I often 'zone out' and then suddenly come to and realize that a lot of time has passed",
    "Things around me often feel unreal, or more real than usual",
    "It is easy for me to take advantage of others",
]

var pid_dimensions = [
    "Disinhibition_1",
    "Disinhibition_2",
    "Disinhibition_3",
    "Detachment_4",
    "Disinhibition_5",
    "Disinhibition_6",
    "Psychoticism_7",
    "NegativeAffect_8",
    "NegativeAffect_9",
    "NegativeAffect_10",
    "NegativeAffect_11",
    "Psychoticism_12",
    "Detachment_13",
    "Detachment_14",
    "NegativeAffect_15",
    "Detachment_16",
    "Antagonism_17",
    "Detachment_18",
    "Antagonism_19",
    "Antagonism_20",
    "Psychoticism_21",
    "Antagonism_22",
    "Psychoticism_23",
    "Psychoticism_24",
    "Antagonism_25",
]

// Short Suggestibility Scale (SSS  21 items; Kotov, Bellman & Watson, 2004)
// From the Multidimensional Iowa Suggestibility Scale (MISS)
var sss_items = [
    "I am easily influenced by other people's opinions",
    "I can be influenced by a good commercial",
    "When someone coughs or sneezes, I usually feel the urge to do the same",
    "Imagining a refreshing drink can make me thirsty",
    "A good salesperson can really make me want their product",
    "I get a lot of good practical advice from magazines or TV",
    "If a product is nicely displayed, I usually want to buy it",
    "When I see someone shiver, I often feel a chill myself",
    "I get my style from certain celebrities",
    "When people tell me how they feel, I often notice that I feel the same way",
    "When making a decision, I often follow other people's advice",
    "Reading descriptions of tasty dishes can make my mouth water",
    "I get many good ideas from others",
    "I frequently change my opinion after talking with others",
    "After I see a commercial for lotion, sometimes my skin feels dry",
    "I discovered many of my favorite things through my friends",
    "I follow current fashion trends",
    "Thinking about something scary can make my heart pound",
    "I have picked-up many habits from my friends",
    "If I am told I don't look well, I start feeling ill",
    "It is important for me to fit in",
]

var sss_dimensions = [
    "SSS_1",
    "SSS_2",
    "SSS_3",
    "SSS_4",
    "SSS_5",
    "SSS_6",
    "SSS_7",
    "SSS_8",
    "SSS_9",
    "SSS_10",
    "SSS_11",
    "SSS_12",
    "SSS_13",
    "SSS_14",
    "SSS_15",
    "SSS_16",
    "SSS_17",
    "SSS_18",
    "SSS_19",
    "SSS_20",
    "SSS_21",
]

// Questionnaire ========================================================================

// IPIP
var ipip6_questionaire = {
    type: jsPsychMultipleSlider,
    // This function is loaded in RestingState.js
    questions: format_questions_analog(ipip6_items, ipip6_dimensions),
    randomize_question_order: false,
    preamble:
        "<p><b>About your personality...</b></p><p>Please answer the following questions based on how accurately each statement describes you in general.</p>",
    require_movement: false,
    slider_width: 600,
    data: {
        screen: "IPIP6",
    },
}

// PID
var pid_questions = []
for (const [index, element] of pid_items.entries()) {
    pid_questions.push({
        prompt: "<b>" + element + "</b>",
        name: pid_dimensions[index],
        labels: [
            "Very or Often False",
            "Sometimes or Somewhat False",
            "Sometimes or Somewhat True",
            "Very or Often True",
        ],
        required: false,
    })
}

var pid5_questionaire = {
    type: jsPsychSurveyLikert,
    questions: pid_questions,
    randomize_question_order: false,
    preamble:
        "<p><b>About yourself...</b></p><p>Below is a list of things different people might say about themselves.</p>" +
        "<p>Please select the response that best describes you.</p>",
    require_movement: false,
    slider_width: 700,
    data: {
        screen: "PID5",
    },
}

// SSS
var sss_questions = []
for (const [index, element] of sss_items.entries()) {
    sss_questions.push({
        prompt: "<b>" + element + "</b>",
        name: sss_dimensions[index],
        labels: [
            "Not at all or very slightly",
            "A little",
            "Somewhat",
            "Quite a bit",
            "A lot",
        ],
        required: false,
    })
}

var sss_questionaire = {
    type: jsPsychSurveyLikert,
    questions: sss_questions,
    randomize_question_order: true,
    preamble:
        "<p><b>About your sensitivity and adaptability...</b></p>" +
        "<p>Please indicate to what extent the following statements apply to you.</p>",
    require_movement: false,
    slider_width: 700,
    data: {
        screen: "SSS",
    },
}
