require 'rails_helper'


describe "the signup process", type: :feature do
  before :each do
    User.create(email: 'user@example.com', password: 'password')
  end

  it "signs me in" do
    # on va sur la page de création d'utilisateurs
    visit 'http://localhost:3000/users/sign_up'

    # dans le formulaire des users, on remplit les données qu'il faut
    within("#new_user") do
      fill_in(id = "user_email", with: 'user@example.com')
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
    end

    # clik clik
    click_button 'Sign Up'

    # la page affichée devrait afficher des bonnes nouvelles
    expect(page).to have_content 'My organiser'
  end
end
