FactoryGirl.define do
  factory :score do
    roast_level { score_range(1, 4, 1) }
    aroma { score_range(6, 10) }
    acidity { score_range(6, 10) }
    body { score_range(6, 10) }
    flavor { score_range(6, 10) }
    sweetness { score_range(6, 10) }
    clean_cup { score_range(6, 10) }
    balance { score_range(6, 10) }
    uniformity { score_range(6, 10) }
    aftertaste { score_range(6, 10) }
    overall { score_range(6, 10) }
    defects { score_range(0, 10, 2) }
    total_score do
      [aroma, acidity, body, flavor, sweetness, clean_cup,
       balance, uniformity, aftertaste, overall].inject(:+)
    end
    final_score { total_score - defects }
    notes { Faker::Coffee.notes }

    association :grader, factory: :user
    cupping
    cupped_coffee
  end
end

def score_range(min, max, step = 0.25)
  (min..max).step(step).to_a.sample
end
