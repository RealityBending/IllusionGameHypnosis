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

// Questionnaire ========================================================================

// Mini IPIP6 questionnaire
var questions = []
for (const [index, element] of ipip6_items.entries()) {
    questions.push({
        prompt: "<b>" + element + "</b>",
        name: ipip6_dimensions[index],
        ticks: ["Inaccurate", "Accurate"],
        required: false,
        min: 0,
        max: 1,
        step: 0.01,
        slider_start: 0.5,
    })
}

// Make questionnaire task
var ipip6_questionaire = {
    type: jsPsychMultipleSlider,
    questions: questions,
    randomize_question_order: false,
    preamble:
        "<p><b>About your personality...</b></p><p>Please answer the following questions based on how accurately each statement describes you in general.</p>",
    require_movement: true,
    slider_width: 600,
    data: {
        screen: "IPIP6",
    },
}
