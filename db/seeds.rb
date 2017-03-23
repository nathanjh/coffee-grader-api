if Rails.env.development?
  # coffees
  Array.new(50) do
    Coffee.create!(name: Faker::Coffee.blend_name,
                   origin: Faker::Coffee.origin,
                   producer: Faker::Name.name)
  end if Coffee.count.zero?

  # roasters
  Array.new(10) do
    Roaster.create!(name: Faker::Hipster.words(1)[0].capitalize + ' Roastery',
                    location: Faker::Address.city,
                    website: Faker::Internet.url)
  end if Roaster.count.zero?

  # users
  users =
    # let's make sure we have enough users for invites to make sense
    if User.count < 10
      Array.new(10) do
        User.create!(name: Faker::Name.name,
                     username: Faker::Internet.user_name,
                     email: Faker::Internet.email,
                     password: 'password',
                     password_confirmation: 'password')
      end
    else
      User.all.limit(10)
    end

  # only make past cuppings if no cuppings exist
  past_cuppings =
    if Cupping.count.zero?
      users.map.with_index do |user, idx|
        user.hosted_cuppings.create!(location: Faker::Address.street_address,
                                     cup_date: DateTime.now - idx,
                                     cups_per_sample: 5) if idx.even?
      end
    else
      []
    end

  # always make new future cuppings
  future_cuppings = users.map.with_index do |user, idx|
    user.hosted_cuppings.create!(location: Faker::Address.street_address,
                                 cup_date: DateTime.now + idx,
                                 cups_per_sample: 3) if idx.odd?
  end

  # all cuppings
  cuppings = future_cuppings + past_cuppings

  # to get rid of nil values
  cuppings.select! { |cupping| !cupping.nil? }

  # add cupped coffees to cuppings
  cuppings.each do |cupping|
    3.times do
      cupping.cupped_coffees.create!(roast_date: cupping.cup_date - 1,
                                     coffee_alias: "#{cupping.id}-#{rand(999)}",
                                     coffee_id: Coffee.all.sample.id,
                                     roaster_id: Roaster.all.sample.id)
    end
  end

  # add invites to cuppings
  cuppings.each do |cupping|
    3.times do
      cupping.invites.create!(grader_id:
        if cupping.invites.empty?
          User.where('id != ?', cupping.host_id).sample.id
        else
          User.where('id != ? AND id NOT IN (?)', cupping.host_id,
                     cupping.invites.pluck(:grader_id))
                       .sample.id
        end)
    end
  end
end
