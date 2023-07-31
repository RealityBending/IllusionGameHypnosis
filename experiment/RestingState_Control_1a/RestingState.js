// Parameters Customization
// ==========================
// To change the parameters, make sure you are editing the file locally
// (you need to download the repository)
// Change what you want, save and run your local index.html

// experiment version
version = "1.0"
// Resting state duration in min
duration = 8
// [x, y, width, height] in pixels. Set to [0, 0, 0, 0] to disable.
marker_position = [0, 0, 200, 200]
// Are all the questions from the debriefing required?
questions_required = false
// Record webcam?
record_webcam = false
// Display raw data at the end
raw_data = false

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

var RS_instructions = {
    type: jsPsychHtmlButtonResponse,
    stimulus:
        "<p><b>Instructions</b></p>" +
        // Don't give exact time so that participants don't count
        "<p>A rest period is about to start.</p>" +
        "<p>Simply <b>relax</b> and remain seated quietly with your eyes closed. Please try <b>not to fall asleep</b>.</p> " +
        "<p>Once the resting period is over, you will hear a beep. You can then open your eyes and proceed.</p>" +
        "<p>Once you are ready, close your eyes. The rest period will shortly begin.</p>",
    choices: ["Continue"],
}

if (record_webcam) {
    var extensions = [{ type: jsPsychExtensionRecordVideo }]
} else {
    var extensions = []
}

// Functions ===================================================================
function create_marker(marker_position, color = "black") {
    const html = `<div id="marker" style="position: absolute; background-color: ${color};\
left:${marker_position[0]}px; top:${marker_position[1]}px; \
width:${marker_position[2]}px; height:${marker_position[3]}px";></div>`
    document.querySelector("body").insertAdjacentHTML("beforeend", html)
}

// Tasks ======================================================================
// Create blank grey screen just before rest period
var RS_buffer = {
    type: jsPsychHtmlKeyboardResponse,
    on_start: function () {
        document.body.style.backgroundColor = "#808080"
        document.body.style.cursor = "none"
        create_marker(marker_position, (color = "white"))
    },
    on_finish: function () {
        document.querySelector("#marker").remove()
    },
    stimulus: "",
    choices: ["s"],
    trial_duration: 1000, // 1 second
    css_classes: ["fixation"],
}

// Create blank grey screen for resting state
var RS_task = {
    type: jsPsychHtmlKeyboardResponse,
    extensions: extensions,
    on_load: function () {
        create_marker(marker_position)
    },
    stimulus: "<p style='font-size:150px;'>+</p>",
    choices: ["s"],
    trial_duration: duration * 60 * 1000,
    css_classes: ["fixation"],
    data: {
        screen: "resting",
        time_start: function () {
            return performance.now()
        },
    },
    on_finish: function (data) {
        document.querySelector("#marker").remove()
        data.duration = (performance.now() - data.time_start) / 1000 / 60
    },
}

// Play beep
var RS_beep = {
    type: jsPsychAudioButtonResponse,
    on_start: function () {
        document.body.style.backgroundColor = "#FFFFFF"
        document.body.style.cursor = "auto"
    },
    stimulus: ["utils/beep.mp3"],
    prompt: "<p>It's over! Please press continue.</p>",
    choices: ["Continue"],
}
// Questionnaire ========================================================================

// Mini IPIP6 questionnaire
var scale = ["1",
"2",
"3",
"4",
"5",
"6",
"7",]
var questions = []
for (const [index, element] of ipip6_items.entries()) {
questions.push({
    prompt: "<b>" + element + "</b>",
    name: ipip6_dimensions[index],
    ticks: scale,
    required: questions_required,
})
}

// Randomize order (comment this out to deactivate the randomization)
// questions = questions.sort(() => Math.random() - 0.5)


// Make questionnaire task
var ipip6_questionaire = {
    type: jsPsychMultipleSlider,
    questions: questions,
    randomize_question_order: true,
    preamble:
        "<h2>IPIP6</h2>",
    require_movement: questions_required,
    slider_width: null,
    min: 1,
    max: 7,
    slider_start: 4,
    step: 1,
    ticks: scale,
    data: {
        screen: "IPIP6_dimensions",
    },
}