FactoryBot.define do
  factory :comment do
    comment "This is a comment"
    association :post
    association :user
  end
end