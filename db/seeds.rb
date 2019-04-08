# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

require 'activity_log_seeder'

ActivityLog.delete_all

seed_file = File.new('db/seed_data.csv', 'r')
ActivityLogSeeder.import!(seed_file)
