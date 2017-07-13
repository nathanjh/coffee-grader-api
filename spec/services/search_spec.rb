require 'rails_helper'

RSpec.describe Search do
  describe 'validations' do
    context 'given a valid table name' do
      it 'instantiates an instance of Search class' do
        expect(Search.new('users', ['name'])).to be_a(Search)
        expect { Search.new('users', ['name']) }.not_to raise_error
      end
    end
    context 'given an invalid table name' do
      it 'raises an exception with message' do
        expect { Search.new('sand_fleas', ['fleaness']) }
          .to raise_error(RuntimeError)
          .with_message('No such table: sand_fleas, in current database.')
      end
    end
    context 'given a capitalization error in table name' do
      it 'raises an exception and provides a suggestion' do
        expect { Search.new('Coffees', ['name']) }.to raise_error(RuntimeError)
          .with_message('No such table: Coffees, in current database. Did you mean coffees?')
      end
    end
    context 'given a valid table name, but invalid column name(s)' do
      it 'raises an exception with message' do
        expect { Search.new('coffees', ['food_pairing']) }
          .to raise_error(RuntimeError)
          .with_message('No such column: food_pairing, on coffees table.')
      end
    end
  end

  describe '#call' do
    before(:example) do
      { email: 'test@me.com', username: 'test_the_search' }
        .each { |k, v| create(:user, k => v) }
      @users_search = Search.new('users', %w(username email))
    end

    context 'given a search term that matches one or more records' do
      it 'returns an array of matching objects' do
        search_results = @users_search.call('test')
        expect(search_results.length).to eq 2
        expect(search_results.first).to be_a User

        search_results = @users_search.call('me.com')
        expect(search_results.length).to eq 1
      end
    end
    context 'given a search terms that does not match any records' do
      it 'returns an empty array if no matches found' do
        search_results = @users_search.call('nomatch')
        expect(search_results.empty?).to be true
      end
    end
  end
end
