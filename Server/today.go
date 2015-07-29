package main

import (
  "github.com/gorilla/mux"
  "encoding/json"
  "fmt"
  "net/http"
  "time"
)

type TodayOffers struct {
    Date string `json:"date"`
    City string `json:"city"`
    CityCode string `json:"city_code"`
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
  if err != nil {
    panic(err.Error())
  }
  
  city, _ := findCityByCode(city_code)
  
  response := &TodayOffers{
    Date: time.Now().Format("2006-01-02"),
    City: city.Name,
    CityCode: city.Code,
  }
  
  var restaurants []Restaurant
  _, err = dbmap.Select(&restaurants, "SELECT * FROM restaurants WHERE city_id = ?", city.Id)
  checkErr(err, "Select failed")
  
  fmt.Println("All rows:")
  for x, p := range restaurants {
    fmt.Printf("    %d: %v\n", x, p)
  }
  
  jsonResponse, _ := json.Marshal(response)
  
  fmt.Fprintf(w, string(jsonResponse))
}
