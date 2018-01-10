namespace :subscribe do
  desc 'Send a notification for subscribers'
  task weekly: :environment do
    NewProductsEmail.run
  end
end
