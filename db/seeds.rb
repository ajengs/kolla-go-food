# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Order.delete_all
LineItem.delete_all
Review.delete_all

Food.delete_all

Restaurant.delete_all

Restaurant.create!(
  [
    {
      name: 'Richeese Company',
      address: 'Jl Pemda Cibinong'
    },
    {
      name: 'RFC',
      address: 'Jl dimana-mana'
    },
    {
      name: 'Outfront',
      address: 'Jl Pemda Cibinong'
    }
  ]
)

Category.delete_all

Category.create!(
  [
    { name: 'local' },
    { name: 'spicy' },
    { name: 'sweet' },
    { name: 'recommended' },
  ]
)

Food.create!(
  name: "Tenderloin Steak",
  description:
    %(<p><em>Daging terbaik</em>
      Tenderloin steak
      </p>),
  image_url: "tenderloin.jpg",
  price: 95000.00,
  restaurant_id: 3
)

Food.create!(
  name: "Sirloin Steak",
  description:
    %(<p><em>Daging terbaik Sirloin</em>
      Sirloin steak
      </p>),
  image_url: "sirloin.jpg",
  price: 80000.00,
  restaurant_id: 3
)

Food.create!(
  name: "Orange Juice",
  description:
    %(<p><em>Juice dari jeruk terbaik</em>
      Orang Juice juice
      </p>),
  image_url: "orange-juice.jpg",
  price: 20000.00,
  category_id: 3,
  restaurant_id: 1
)

Food.create!(
  name: "Mango Juice",
  description:
    %(<p><em>Mangoooooooooooo</em>
      Juice
      </p>),
  image_url: "mango-juice.jpg",
  price: 21000.00,
  category_id: 4,
  restaurant_id: 2
)

Buyer.delete_all

Buyer.create!(
  [
    {
      email: 'abc@yahoo.com',
      name: 'Achmad Basir Charlie',
      phone: '08756896899',
      address: 'Jl. ini gang itu no. 70, Kotabatu'
    },
    {
      email: 'def@gmail.com',
      name: 'Dinda Evelyn Fransisca',
      phone: '08573478386',
      address: 'Jl. hahaha no. 88, Jakarta'
    },
    {
      email: 'ghi@hotmail.com',
      name: 'Gian Harum Indria',
      phone: '08534532423',
      address: 'Jl. Krakatau Gg. apa no. 7, Lalala'
    }
  ]
)

User.delete_all

User.create!(
  [
    {
      username: 'ajeng',
      password: '12345678',
      password_confirmation: '12345678'
    }
  ]
)

Role.create!(
  [
    { name: 'administrator' },
    { name: 'customer' }
  ]
) 
