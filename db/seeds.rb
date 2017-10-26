# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Food.delete_all

Food.create!(
  name: "Tenderloin Steak",
  description:
    %(<p><em>Daging terbaik</em>
      Tenderloin steak
      </p>),
  image_url: "tenderloin.jpg",
  price: 95000.00
)

Food.create!(
  name: "Sirloin Steak",
  description:
    %(<p><em>Daging terbaik Sirloin</em>
      Sirloin steak
      </p>),
  image_url: "sirloin.jpg",
  price: 85000.00
)

Food.create!(
  name: "Orange Juice",
  description:
    %(<p><em>Juice dari jeruk terbaik</em>
      Orang Juice juice
      </p>),
  image_url: "orange-juice.jpg",
  price: 95000.00
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
