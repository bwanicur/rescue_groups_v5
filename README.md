# RescueGroupsV5

A Ruby wrapper for the <a target="_blank" href="https://api.rescuegroups.org/v5/public/docs">RescueGroups.org API v5</a> (public endpoints).

**Note:** the v5 public API is primarily read-only for now. It does not support creating, updating, or deleting animals or organizations, so this gem only provides methods for searching and reading data.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rescue_groups_v5'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rescue_groups_v5

## Usage

```ruby
client = RescueGroupsV5::Client.new(API_KEY_HERE)

result = client.search_animals(
  views: [:available, :dogs],
  postalcode: "92107",
  miles: 25,
  fields: {
    animals: [:name, :breedPrimary, :distance],
    orgs: [:name, :city]
  },
  include: [:orgs],
  sort: [{ object: :animals, sort_value: :distance, direction: :ascending }],
  limit: 10
)

result["meta"]["count"] # total matching animals
result["data"]          # array of animals
result["included"]      # related objects requested with `include`
```

Every method returns the parsed JSON response as a Hash with `meta`, `data` and (when requested) `included` keys. API errors are not raised; they are returned under an `errors` key:

```ruby
result["errors"] # => [{ "status" => 400, "title" => "Invalid Sort", "detail" => "..." }]
```

### Client Methods

| Method | API endpoint |
|---|---|
| `search_animals(opts)` | `POST /public/animals/search/{views}` |
| `get_animal(id, opts)` | `GET /public/animals/{id}` |
| `get_animal_breeds(opts)` | `GET /public/animals/breeds` |
| `search_orgs(opts)` | `POST /public/orgs/search/{views}` |
| `get_org(id, opts)` | `GET /public/orgs/{id}` |
| `get_org_animals(org_id, opts)` | `GET /public/orgs/{id}/animals` |
| `search_org_animals(org_id, opts)` | `POST /public/orgs/{id}/animals/search/{views}` |

### Nesting Included Data

The client can copy each `included` object's attributes into the matching entry under the parent's `relationships`. Set `nest_data` to true to enable this. The `included` section is still returned either way.

```ruby
client = RescueGroupsV5::Client.new(API_KEY_HERE, nest_data: true)

animal = client.search_animals(include: [:orgs])["data"].first
animal["relationships"]["orgs"]["data"].first["name"] # => "Second Chance Dog Rescue"
```

## Request Options

### Views

_Search methods only._

Views are predefined searches from the API, passed as an array of names. Multiple views are combined (AND).

```ruby
client.search_animals(views: [:available, :cats, :isspecialneeds])
```

Animal searches (`search_animals` and `search_org_animals`) default to `[:available]`. To search all animals, including adopted ones, pass an empty array:

```ruby
client.search_animals                # available animals only
client.search_animals(views: [])     # every animal, any status
```

Org searches have no default view.

An unknown view raises `RescueGroupsV5::InvalidViewError` (an `ArgumentError`) before any request is sent.

**Animal views:** `available`, `adopted`, `isspecialneeds`, `isneedingfoster`, `urgent`, `iscourtesylisting`, and one view per species: `alpacas`, `birds`, `cats`, `chickens`, `chinchillas`, `cows`, `degus`, `dogs`, `donkeys`, `ducks`, `ferrets`, `fish`, `frogs`, `geckos`, `geese`, `gerbils`, `goats`, `groundhogs`, `hamsters`, `hedgehogs`, `horses`, `iguanas`, `lizards`, `llama`, `mice`, `otters`, `pigs`, `ponies`, `rabbits`, `rats`, `sheep`, `skunks`, `snakes`, `tarantulas`, `tortoises`, `turkeys`, `turtles`

Some documented animal views are broken in the API and are not supported. Use a filter instead:

```ruby
# haspic (has no effect in the API)
{ object: :animals, field_name: :pictureCount, operation: :greater_than_or_equal, criteria: 1 }

# guineapigs, hermitcrabs, prairiedogs, sugargliders (always return no results)
{ object: :species, field_name: :plural, criteria: "Guinea Pigs" } # or "Hermit Crabs", "Prairie Dogs", "Sugar Gliders"
```

The API treats a criteria of `0` as blank, so use `operation: :greater_than_or_equal, criteria: 1` rather than `operation: :greater_than, criteria: 0`.

**Org views:** `rescue`. The API's documented `shelter` view is broken (it always returns no results), so use a filter instead:

```ruby
client.search_orgs(filters: [{ object: :orgs, field_name: :type, criteria: "Shelter" }])
```

### Location

_Search methods only._

Search within a radius of a postal code (US and Canada) or a lat/lon point. The distance is `miles` or `kilometers` and defaults to 10 miles. Results include a `distance` attribute.

```ruby
client.search_animals(postalcode: "92107", miles: 25)
client.search_animals(lat: 32.7174, lon: -117.1628, kilometers: 10)
```

### Filters

_Search methods only._

An array of hashes with these keys:

- `object`: `:animals` or `:orgs`
- `field_name`: the object's field
- `operation`: defaults to `:equals`. One of `:equals`, `:not_equal`, `:less_than`, `:less_than_or_equal`, `:greater_than`, `:greater_than_or_equal`, `:contains`, `:not_contain`, `:blank`, `:not_blank`
- `criteria`: the value to compare against. An array with `:equals` matches any of the values.

Multiple filters are combined (AND).

```ruby
client.search_animals(filters: [
  { object: :animals, field_name: :breedPrimary, operation: :contains, criteria: "Staffordshire" },
  { object: :animals, field_name: :sizeGroup, criteria: ["Small", "Medium"] },
  { object: :animals, field_name: :birthDate, operation: :greater_than, criteria: "2020-01-01T00:00:00Z" }
])
```

Date criteria must be full ISO 8601 timestamps (`"2020-01-01T00:00:00Z"`). A bare date like `"2020-01-01"` makes the API return a 500 error.

### Fields

A hash where each key is an object name and each value is an array of fields to return. Use it to reduce the size of the response. All fields are returned when it is omitted.

```ruby
client.search_animals(fields: {
  animals: [:name, :ageGroup, :breedPrimary],
  orgs: [:name, :city]
})
```

Available fields:
- [Animals](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/animal.rb)
- [Breeds](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/breed.rb)
- [Colors](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/color.rb)
- [Contacts](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/contact.rb)
- [Orgs](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/org.rb)
- [Statuses](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/status.rb)

### Include

An array of related objects to return in the `included` section.

```ruby
client.search_animals(include: [:orgs, :breeds, :pictures])
```

### Sort

An array of hashes with these keys:

- `object`: `:animals` or `:orgs`
- `sort_value`: the field to sort by
- `direction`: `:ascending` (default) or `:descending`

```ruby
# animals by distance, then by name descending
client.search_animals(
  postalcode: "92107",
  sort: [
    { object: :animals, sort_value: :distance, direction: :ascending },
    { object: :animals, sort_value: :name, direction: :descending }
  ]
)
```

### Page

The page number for paginated results. Defaults to 1.

```ruby
client.search_animals(page: 2)
```

### Limit

The number of results per page. Defaults to 25; the API maximum is 250.

```ruby
client.search_animals(limit: 50)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bwanicur/rescue_groups_v5.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
