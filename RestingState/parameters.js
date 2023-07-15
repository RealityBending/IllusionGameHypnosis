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
// Display raw data
raw_data = false
// Debriefing questionnaire
var items = [
    "I had busy thoughts",
    "I had rapidly switching thoughts",
    "I had difficulty holding onto my thoughts",
    "I thought about others",
    "I thought about people I like",
    "I placed myself in other people's shoes",
    "I thought about my feelings",
    "I thought about my behaviour",
    "I thought about myself",
    "I thought about things I need to do",
    "I thought about solving problems",
    "I thought about the future",
    "I felt sleepy",
    "I felt tired",
    "I had difficulty staying awake",
    "I felt comfortable",
    "I felt happy",
    "I felt relaxed",
    "I was conscious of my body",
    "I thought about my heartbeat",
    "I thought about my breathing",
    // "I felt ill",
    // "I thought about my health",
    // "I felt pain",
    // "I thought in images",
    // "I pictured events",
    // "I pictured places",
    // "I thought in words",
    // "I had silent conversations",
    // "I imagined talking to myself",
]
var dimensions = [
    "DoM_1",
    "DoM_2",
    "DoM_3",
    "ToM_1",
    "ToM_2",
    "ToM_3",
    "Self_1",
    "Self_2",
    "Self_3",
    "Plan_1",
    "Plan_2",
    "Plan_3",
    "Sleep_1",
    "Sleep_2",
    "Sleep_3",
    "Comfort_1",
    "Comfort_2",
    "Comfort_3",
    "SomA_1",
    "SomA_2",
    "SomA_3",
    // "Health_1", "Health_2", "Health_3",
    // "Visual_1", "Visual_2", "Visual_3",
    // "Verbal_1", "Verbal_2", "Verbal_3",
]

var check_items = [
    "I had my eyes closed",
    "I was able to rate the statements above",
]
