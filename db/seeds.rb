User.create!(name:  "Example User",
             email: "example@example.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)
             
50.times do |n|
  name = "number-#{n+1}"
  email = "example-#{n+1}@example.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end
               
25.times do |n|
    user_id = n+1
    content = "qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq#{n+1}" 
    Question.create!(user_id: user_id,
                     content: content)
end

10.times do
  20.times do |n|
    user_id = n+1
    question_id = n+1
    content = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-#{n+1}" 
    Answer.create!(user_id: user_id,
                 question_id: question_id,
                 content: content)
  end
end