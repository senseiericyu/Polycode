/*

type User @model @auth(rules: [{ allow: owner }]) {
  id: ID!
  username: String!
  email: String!
  xp: Int
  streak: Int
  lastPracticeDate: AWSDate
  quizProgresses: [UserQuizProgress] @hasMany(indexName: "byUser", fields: ["id"])
}

 type Quiz @model {
   id: ID!
   title: String!
   level: Int
   questions: [Question] @hasMany(indexName: "byQuiz", fields: ["id"])
 }


 type Question @model
   @key(name: "byQuiz", fields: ["quizID"]) {
   id: ID!
   quizID: ID!
   quiz: Quiz @belongsTo(fields: ["quizID"])
   prompt: String!
   options: [String!]!
   correctAnswerIndex: Int!
 }


 type UserQuizProgress @model
   @auth(rules: [{ allow: owner }])
   @key(name: "byUser", fields: ["userID"])
   @key(name: "byQuiz", fields: ["quizID"]) {
   id: ID!
   userID: ID!
   user: User @belongsTo(fields: ["userID"])
   quizID: ID!
   quiz: Quiz @belongsTo(fields: ["quizID"])
   score: Int
   isCompleted: Boolean
   lastAttempt: AWSDateTime
 }


*/
