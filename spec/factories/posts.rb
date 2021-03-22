FactoryBot.define do
  factory :post do
    title "My blog"
    content "Blog content for my first blog"
    association :user
  end
end