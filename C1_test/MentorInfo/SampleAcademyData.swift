import Foundation

let sampleAcademy = Ada(experts: [
    Expertise(expertArea: "Tech", mentors: [
        Mentor(mentorName: "Issac", mentorAvailable: "가능"),
        Mentor(mentorName: "Haward", mentorAvailable: "불가능"),
        Mentor(mentorName: "Jaesung", mentorAvailable: "가능")

    ]),
    Expertise(expertArea: "Design", mentors: [
        Mentor(mentorName: "Jiku", mentorAvailable: "가능"),
        Mentor(mentorName: "Saya", mentorAvailable: "가능"),
        Mentor(mentorName: "Friday", mentorAvailable: "불가능")

    ])
])
