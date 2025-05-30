package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)

type WeatherResponse struct {
	CurrentWeather struct {
		Temperature float64 `json:"temperature"`
	} `json:"current_weather"`
}

func main() {

	response, err := http.Get("https://api.open-meteo.com/v1/forecast?latitude=48.8566&longitude=2.3522&current_weather=true")
	if err != nil {
		panic(err)
	}
	defer response.Body.Close()


	var data WeatherResponse
	if err := json.NewDecoder(response.Body).Decode(&data); err != nil {
		panic(err)
	}


	output := fmt.Sprintf("Current temperature in Paris: %.1f°C", data.CurrentWeather.Temperature,)
	fmt.Printf(output)

}
