package main

import (
  "github.com/gorilla/mux"
  "encoding/json"
  "fmt"
  "net/http"
  "time"
  "strconv"
)

type TodayOffers struct {
    Date string `json:"date"`
    City string `json:"city"`
    CityCode string `json:"city_code"`
    Restaurants []Restaurant `json:"restaurants"`
}

func getCityFromUrl(r *http.Request) (id string, err error) {
	if city, ok := mux.Vars(r)["city"]; ok {
		id = city
	} else {
		err = fmt.Errorf("Invalid City\n")
	}
	return
}

func todaysOffers(w http.ResponseWriter, r *http.Request) {
  
  city_code, err := getCityFromUrl(r)
  checkErr(err, "Could not find City name from URL")
  
  city, _ := findCityByCode(city_code)

  response := &TodayOffers{
    Date: time.Now().Format("2006-01-02"),
    City: city.Name,
    CityCode: city.Code,
  }
  
  var restaurants []Restaurant
  _, err = dbmap.Select(&restaurants, "SELECT * FROM restaurants WHERE city_id = ?", city.Id)
  checkErr(err, "Select failed")
  
  var restaurantids = make([]string, len(restaurants))
  
  for i, r := range restaurants {
    restaurantids[i] = strconv.Itoa(r.Id)
  }
  
  var offers []Offer
  // TODO: See how SELECt ... WHERE ... IN works with Gorp
  _, err = dbmap.Select(&offers, "SELECT * FROM offers WHERE restaurant_id IN (SELECT id FROM restaurants WHERE city_id = :city_id) AND offer_date = :offer_date", map[string]interface{}{
    "city_id": city.Id,
    "offer_date": time.Now().Format("2006-01-02"),
  })
  checkErr(err, "Offers select failed")
  
  for i, r := range restaurants {
    restaurants[i].Offers = []Offer{}
    
    for _, o := range offers {
      
      if o.RestaurantId == r.Id {
        restaurants[i].Offers = append(restaurants[i].Offers, o)
      }
    }
  }
  
  response.Restaurants = restaurants
  
  jsonResponse, _ := json.Marshal(response)
  
  fmt.Fprintf(w, string(jsonResponse))
}
