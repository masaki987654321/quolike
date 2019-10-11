User.create!(name:  "Example User",
             email: "example@example.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)
             
99.times do |n|
  name = "number-#{n+1}"
  email = "example-#{n+1}@example.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end