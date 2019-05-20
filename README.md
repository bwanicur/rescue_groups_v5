# RescueGroupsV5

This is the wrapper for the new <a target="_blank" href="https://api.rescuegroups.org/v5/public/docs">Rescue Groups API V5</a>

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
# configure the client globally
RescueGroupsV5::Config.set(:api_key, API_KEY_HERE)
client = RescueGroupsV5::Client.new

# or per client instance
client = RescueGroupsV5::Client.new(API_KEY_HERE)

options = {
  fields: {
    animals: [ :name, :breedPrimary ],
    orgs: [ :name, :city ]
  },
  zipcode: '92107',
  radius_in_miles: 15
}
result = client.search_animals(options)
```

## Request Options
### Fields Option:
A hash where each key is the name of an object and each value is an array of fields to include: `{ object: [ :collection, :of, :fields ] }`

### Supported Objects:
- animals
- orgs

### Available Fields:
- [Animals](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/animal.rb)
- [Breeds](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/breed.rb)
- [Organizations](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/organization.rb)
- [Contacts](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/contact.rb)
- [Statuses](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/status.rb)

Example:
```ruby
options[:fields] = {
  animals: [ :name, :ageGroup, :breedPrimary ],
  orgs: [ :name, :city ]
}
```

### Sort:
An array of hashes with the following keys:

- object: (aniamls, organizations, events)
- sort_value: they attribute to use for sorting
- direction:  sort direction

```ruby
# sort by Animal breedPrimary - ascending, then Organization name ascending
options[:sort] = [
  {
    object: :animals,
    sort_value: :breedPrimary,
    direction: :ascending
  },
  {
    object: :orgs,
    sort_value: :name,
    direction: :ascending
  }
]
```

### Start:
The record index.  Integer value.  Defaults to 0.
```ruby
options[:start] = {
  start: 50
}
```

### Limit:
Simple integer limit (Rescue Groups API enforces a max limit of 250).  Defaults to 25.
```ruby
options[:limit] = {
  limit: 50
}
```

### Other Options:

- Nest Data:  This gem can nest included data under the parent object. \
If you want this feature, set `nest_data` to true.  Included data will still \
be under the `included` section of the response, regardless of this option.
```ruby
{
  nest_data: false # Defaults to false
}
```

### Location Filtering:
_Only available on search requests_

The following "global" filters are available to search by location.

```ruby
options[:zipcode] = '92107' # string zipcode
```

```ruby
options[:radius_in_miles] = 20 # integer value
```

### General Filters:
_Only available on search requests_

An array of hashes containing the following keys:

- object: animals, organizations, events
- field_name: the object's field
- operation: see list of operations [here](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/services/filter_builder.rb)
- value

```ruby
options[:filters] = [
  {
    object: :animals,
    fieldName: :breedPrimary,
    operation: :contains,
    value: 'Staffordshire'
  },
  {
    object: :animals,
    operation: :greater_than,
    fieldName: :birthDate,
    value: '01-01-2012'
  }  
]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bwanicur/rescue_groups_v5.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
