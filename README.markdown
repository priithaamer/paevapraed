## Pläust API

Päeva pakkumised

`GET /api/v1/tartu/today.json`

    {
      date: "2015-07-15",
      city: "Tartu",
      city_code: "tartu",
      country: "Eesti",
      country_code: "ee",
      currency: "EUR",
      restaurants: [
        {
          name: "HotPot",
          code: "hotpot",
          url: "/api/v1/tartu/restaurants/hotpot.json",
          offers: [
            {
              name: "JADE SEAFOOD SOUP",
              description: "Mõnus kalasupp"
              price: 3.5
            },
            {
              name: "CHICKEN IN BLACK PEPPER SAUCE",
              description: "Kanafilee tükid musta pipraga marineeritult kastmes.",
              price: 3.5
            },
            {
              name: "MURGH MALAI METHI",
              description: "Küpsetatud kanafilee tükid indiapärases kooreses kastmes",
              price: 4.5
            }
          ]
        },
        {
          name: "Polpo",
          code: "polpo",
          url: "/api/v1/tartu/restaurants/polpo.json",
          offers: [
            {
              name: "Polpo selge küülikusupp",
              price: 3
            },
            {
              name: "Vürtsikas grillitud seafilee praekartuliga",
              price: 5.5
            },
            {
              name: "Penne lihapallide ja köögiviljadega koorekastmes",
              price: 4.5
            }
          ]
        },
        {
          name: "Vilde",
          code: "vilde",
          url: "/api/v1/tartu/restaurants/vilde.json",
          offers: [
            {
              name: "Vilde šnitsel ahjukartuli, sinepikastme ja soojade köögiviljadega",
              price: 3.5
            },
            {
              name: "Kanafilee päevalilleseemnetega kuskussi, mündikastme ja värske salatiga",
              price: 3.5
            },
            {
              name: "Mozzarella salat",
              price: 3.5
            },
            {
              name: "Kookose-laimikook",
              price: 1.5
            }
          ]
        }
      ]
    }
    
### Päeva info

`GET /api/v1/tartu/date/2015-07-15.json`

Sama mis Today, ainult valitud päeva info. 404 kui päeva infot ei ole.

### Linnad

`GET /api/v1/cities`

    [
      {city: "Tartu", code: "tartu"},
      {city: "Tallinn", code: "tallinn"}
    ]

### Pakkumise lisamine

`POST /api/v1/offers`

    {
      "date": "2015-07-22",
      "city_code": "tartu",
      "country_code": "ee",
      "currency": "EUR",
      "restaurant_code": "polpo",
      "offers": [
        {
          "name": "Polpo selge küülikusupp",
          "price": 3
        },
        {
          "name": "Vürtsikas grillitud seafilee praekartuliga",
          "price": 5.5
        }
      ]
    }

## API testserver

Mine mockide kataloogi `PaevapraedTests/json`

    ruby -run -e httpd . -p 9090
