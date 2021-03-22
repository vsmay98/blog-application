FactoryBot.define do
  factory :user do
    sequence(:email) {|n| "temp#{n}@gmail.com"}
    password "123456"

    factory :admin do
      admin true
    end
  end
end