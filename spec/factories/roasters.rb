FactoryGirl.define do
  factory :roaster do
    name { Faker::Hipster.words(1)[0] + " Cafe"}
    location { Faker::Address.city }
    website { Faker::Internet.url }
  end
end
