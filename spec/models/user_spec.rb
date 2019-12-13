require 'rails_helper'

RSpec.describe User, type: :model do

  before(:each) do 
    @user = User.create(email: "john@ue.com", password: "Doekiee")
  end

  context "validation" do

    it "is valid with valid attributes" do
      expect(@user).to be_a(User)
      expect(@user).to be_valid
    end

    describe "#email" do
      it "should not be valid without email" do
        bad_user = User.create(last_name: "Doe", password: "azerty")
        expect(bad_user).not_to be_valid
        expect(bad_user.errors.include?(:email)).to eq(true)
      end
    end

    describe "#password" do
      it "should not be valid without password" do
        bad_user = User.create(email: "John@cad.com")
        expect(bad_user).not_to be_valid
        expect(bad_user.errors.include?(:password)).to eq(true)
      end
    end

    describe "#password" do
      it "should not be lower that 6 characters" do
        invalid_user = User.create(email: "jeu@jde.com", password: "azer")
        expect(invalid_user).not_to be_valid
        expect(invalid_user.errors.include?(:password)).to eq(true)
      end
    end

  end

  context "associations" do

    describe "books" do
      it "should have_many organisers" do
				city = City.create(name: "adadaz")
        organiser = Organiser.create(user: @user, city: city)
        expect(@user.organisers.include?(organiser)).to eq(true)
      end
    end

  end



  context "public instance methods" do

    describe "#full_name" do

      it "should return a string" do
        expect(@user.email).to be_a(String)
      end

      it "should return the full name" do
        user_1 = User.create(first_name: "John", last_name: "Doe", password: "azerty", email: "ada@ejheh.com")
        expect(user_1.last_name).to eq("Doe")
        expect(user_1.email).to eq("ada@ejheh.com")
      end
    end

  end

end
