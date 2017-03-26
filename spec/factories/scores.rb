FactoryGirl.define do
  factory :score do
    roast_level 1
    aroma 8
    aftertaste 7.25
    acidity 9
    body 6.5
    uniformity 8
    balance 9.5
    clean_cup 6.5
    sweetness 8.25
    overall 9
    defects 1
    total_score 71
    notes "tea-like"

    association :grader, factory: :user
    cupping
    cupped_coffee

  end
end
