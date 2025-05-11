use "collections"
use "net/http"
use "json"

actor Main
  new create(env: Env) =>
    let country = "Uzbekistan"
    HTTPClient(env.root as AmbientAuth).get("https://disease.sh/v3/covid-19/countries/" + country, CovidHandler)

class CovidHandler is HTTPHandler
  fun ref apply(response: HTTPResponse ref) =>
    try
      let json = JsonDoc.parse(String.from_array(response.body))?.data as JsonObject
      let cases = json.data("cases") as JsonNumber
      let deaths = json.data("deaths") as JsonNumber
      let recovered = json.data("recovered") as JsonNumber
      @printf[I32]("Holatlar: %d\nVafot: %d\nSog'aygan: %d\n".cstring(),
        cases.i64().i32(), deaths.i64().i32(), recovered.i64().i32())
    else
      @printf[I32]("Xatolik\n".cstring())
    end
