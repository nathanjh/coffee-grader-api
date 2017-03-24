FactoryGirl.define do
  factory :invite do
    # status { (0..3).to_a.sample }
    #
    status :pending
    cupping
    association :grader, factory: :user
  end
end
