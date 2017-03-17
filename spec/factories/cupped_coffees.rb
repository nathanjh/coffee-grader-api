FactoryGirl.define do
  factory :cupped_coffee do
    roast_date DateTime.now - 1
    coffee_alias Faker::Lorem.characters(5)
    coffee
    roaster
    cupping
  end
end
