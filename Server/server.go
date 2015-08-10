package main

import (
  "github.com/gorilla/mux"
  "net/http"
  "encoding/json"
  "time"
  
  // "bytes"
  "flag"
  "fmt"
  "log"
  "database/sql"
  "os"
  "gopkg.in/gorp.v1"
  _ "github.com/go-sql-driver/mysql"
)

var db *sql.DB
var dbmap *gorp.DbMap

type City struct {
  Id int
  Name string
  Code string
  CountryCode string
}

func findCityByCode(code string) (*City, error) {
  var c City
  
  err := db.QueryRow("SELECT id, name, code, country_code FROM cities WHERE code = ?", code).Scan(&c.Id, &c.Name, &c.Code, &c.CountryCode)
  
	if err != nil {
		return &City{}, err
	} else {
    return &c, nil
  }
}

type Restaurant struct {
  Id int `db:"id" json:"-"`
  Name string `db:"name" json:"name"`
  Code string `db:"code" json:"code"`
  CityId int `db:"city_id" json:"-"`
  Offers []Offer `db:"-" json:"offers"`
}

func findRestaurantByCode(code string) (*Restaurant, error) {
  var r Restaurant
  
  err := db.QueryRow("SELECT id, name, code, city_id FROM restaurants WHERE code = ?", code).Scan(&r.Id, &r.Name, &r.Code, &r.CityId)
  
	if err != nil {
    return &Restaurant{}, err
	} else {
    return &r, nil
  }
}

type OfferImport struct {
  CityCode string `json:"city_code"`
  RestaurantCode string `json:"restaurant_code"`
  Offers []Offer
  Date string
}

type Offer struct {
  Id int64 `db:"id" json:"-"`
  Name string `db:"name" json:"name"`
  Description string `db:"description" json:"description"`
  Price float64 `db:"price" json:"price"`
  OfferDate time.Time `db:"offer_date" json:"-"`
  RestaurantId int `db:"restaurant_id" json:"-"`
}

func (o *Offer) create() (int64, error) {
  stmt, err := db.Prepare("INSERT INTO offers(name, description, price, offer_date, restaurant_id) VALUES(?, ?, ?, ?, ?)")
  // TODO: Add proper error handling
  if err != nil {
	   panic(err.Error())
  }
  res, err := stmt.Exec(o.Name, o.Description, o.Price, o.OfferDate, o.RestaurantId)
  if err != nil {
	  panic(err.Error())
  }
  lastId, err := res.LastInsertId()
  if err != nil {
	  panic(err.Error())
  }
  
  o.Id = lastId
  
  return lastId, nil
}

func findOfferByDateAndRestaurant(date time.Time, restaurant_id int) (*Offer, error) {
  var o Offer
  
  err := dbmap.SelectOne(&o, "SELECT id, offer_date, restaurant_id, name, description, price FROM offers WHERE restaurant_id = ? AND offer_date = ?", restaurant_id, date)
  
	if err != nil {
    return nil, err
	} else {
    return &o, nil
  }
}

// Decoding arbitrary data http://blog.golang.org/json-and-go

func createOffer(w http.ResponseWriter, r *http.Request) {
  
  var oi OfferImport
  
  err := json.NewDecoder(r.Body).Decode(&oi)
  if err != nil {
    fmt.Println("Error in offer decode")
    fmt.Println(err.Error())
  }
  
  w.Header().Set("Content-Type", "application/json")
  
  import_date, _ := time.Parse("2006-01-02", oi.Date)
  
  // TODO: Handle city not found error
  var city, _ = findCityByCode(oi.CityCode)
  // TODO: Handle restaurant not found error
  var restaurant, _ = findRestaurantByCode(oi.RestaurantCode)
  var offer, _ = findOfferByDateAndRestaurant(import_date, restaurant.Id)
  
  if offer == nil {
    fmt.Println(fmt.Sprintf("Creating offer for %s on date %s\n", restaurant.Name, import_date))
    
    for i := range oi.Offers {
      var o = oi.Offers[i]
      
      o.OfferDate = import_date
      o.RestaurantId = restaurant.Id
      
      o.create()
    }
  } else {
    fmt.Println(fmt.Sprintf("Offers already exist for %s on date %s\n", restaurant.Name, import_date))
  }
  
	fmt.Fprintf(w, city.Name)
}

func initDb() *gorp.DbMap {
  // connect to db using standard Go database/sql API
  // use whatever database/sql driver you wish
  db, err := sql.Open("mysql", config.Database)
  checkErr(err, "sql.Open failed")

  // construct a gorp DbMap
  dbmap := &gorp.DbMap{Db: db, Dialect: gorp.MySQLDialect{"InnoDB", "UTF8"}}

  // add a table, setting the table name to 'posts' and
  // specifying that the Id property is an auto incrementing PK
  // dbmap.AddTableWithName(Post{}, "posts").SetKeys(true, "Id")

  // create the table. in a production system you'd generally
  // use a migration tool, or create the tables via scripts
  // err = dbmap.CreateTablesIfNotExists()
  // checkErr(err, "Create tables failed")
  
  dbmap.TraceOn("[gorp]", log.New(os.Stdout, "Paevapraed:", log.Lmicroseconds))

  return dbmap
}

func checkErr(err error, msg string) {
  if err != nil {
    log.Fatalln(msg, err)
  }
}

type Configuration struct {
	Host        string
	Port        string
  Database    string
	Logfile     string
}

var config = Configuration{}

func init() {
  if config.Port = os.Getenv("PORT"); config.Port == "" {
		flag.StringVar(&config.Port, "port", "8000", "HTTP Port")
	}
  if config.Host = os.Getenv("HOST"); config.Host == "" {
    flag.StringVar(&config.Host, "host", "", "HTTP Hostname")
  }
  if config.Database = os.Getenv("DB"); config.Database == "" {
    flag.StringVar(&config.Database, "db", "", "Database URL")
  }
  flag.Parse()
}

func main() {
  dbm := initDb()
  dbmap = dbm
  defer dbm.Db.Close()
  
  // TODO: Take database settings from configuration
  conn, err := sql.Open("mysql", config.Database)

	if err != nil {
		panic(err.Error()) // Just for example purpose. You should use proper error handling instead of panic
	}
	defer conn.Close()
  
  db = conn
  
  err = conn.Ping()
	if err != nil {
		panic(err.Error()) // TODO: proper error handling instead of panic in your app
	}
  
  router := mux.NewRouter()
  router.HandleFunc("/api/v1/offers", createOffer).Methods("POST")
  router.HandleFunc("/api/v1/{city:.*}/today", todaysOffers).Methods("GET")
  
  if err := http.ListenAndServe(fmt.Sprintf("%s:%s", config.Host, config.Port), router); err != nil {
    panic(err.Error())
  }
}
