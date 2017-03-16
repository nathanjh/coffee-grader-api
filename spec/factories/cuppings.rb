FactoryGirl.define do
  factory :cupping do
    location { Faker::Address.street_address }
    cup_date '2017-02-27 10:56:43'
    cups_per_sample 4

    association :host, factory: :user
  end
end
