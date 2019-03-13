# RescueGroupsV5

This is the wrapper for the new [Rescue Groups API V5](https://api.rescuegroups.org/v5/public/docs)

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
### Fields:
A hash where each key is the name of an object and each value is an array of fields to include: `{ object: [ :collection, :of, :fields ] }`

Supported Objects:
- animals
- orgs

Fields:
- [Animal](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/animal.rb)
- [Breed](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/breed.rb)
- [Organization](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/organzation.rb)
- [Contact](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/contact.rb)
- [Status](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/fields/status.rb)

Example:
```ruby
options[:fields] = {
  animals: [ :name, :ageGroup, :breedPrimary ],
  organizations: [ :name, :city ]
}
```

### Sort:
A hash where the value is an object.  The hash will have to keys:  `sort_value` and `direction (:ascending / :descending)`:
```ruby
# sort by Animal breedPrimary - ascending, then Organization name ascending
options[:sort] = {
  animals: {
    sort_value: :breedPrimary,
    direction: :ascending
  },
  orgs: {
    sort_value: :name,
    direction: :ascending
  }
}
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

### Options:
_TODO_

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

A Hash containing object names for the keys.  The value for each key should be metadata about the filter. The metadata data should have the following keys:

- operation (see list of operations [here](https://github.com/bwanicur/rescue_groups_v5/blob/master/lib/rescue_groups_v5/services/filter_builder.rb))
- field name (the object's field)
- value

```ruby
options[:filters] = {
  animals: {
    operation: :equals,
    fieldName: :breedPrimary,
    value: 'Staffordshire Bull Terrier'
  },
  animals: {
    operation: :greater_than,
    fieldName: :birthDate,
    value: '01-01-2012'
  }
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bwanicur/rescue_groups_v5.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
