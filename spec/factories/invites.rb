FactoryGirl.define do
  factory :invite do
    status :pending
    cupping
    association :grader, factory: :user
  end
end
