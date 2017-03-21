FactoryGirl.define do
  factory :invite do
    cupping_id 1
    status :pending

    association :grader, factory: :user
  end
end

