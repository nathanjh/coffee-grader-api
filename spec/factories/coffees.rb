FactoryGirl.define do
  factory :coffee do
    name { Faker::Coffee.blend_name }
    origin { Faker::Coffee.origin }
    producer { Faker::Name.name }
    variety { Faker::Coffee.variety }
  end
end
