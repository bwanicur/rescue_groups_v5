# frozen_string_literal: true

module ParsedResponse
  def parsed_response
    {
      "meta" => {
        "count" => 2_900_763,
        "countReturned" => 2,
        "requestTime" => 1_552_180_155,
        "responseTime" => 1_552_180_155,
        "responseMs" => 43
      },
      "data" => [
        {
          "type" => "animals",
          "id" => "100000",
          "attributes" => {
            "name" => "Shyann",
            "breedPrimary" => "Domestic Long Hair"
          },
          "relationships" => {
            "orgs" => {
              "data" => [
                {
                  "type" => "orgs",
                  "id" => "16"
                }
              ]
            }
          },
          "meta" => []
        },
        {
          "type" => "animals",
          "id" => "10000001",
          "attributes" => {
            "name" => "Sam (and Bobby)",
            "breedPrimary" => "Tiger"
          },
          "relationships" => {
            "orgs" => {
              "data" => [
                {
                  "type" => "orgs",
                  "id" => "2608"
                }
              ]
            }
          },
          "meta" => []
        }
      ],
      "included" => [
        {
          "type" => "orgs",
          "id" => "16",
          "attributes" => {
            "name" => "Animal Relief Fund",
            "city" => "Hollywood"
          },
          "relationships" => [],
          "meta" => []
        },
        {
          "type" => "orgs",
          "id" => "2608",
          "attributes" => {
            "name" => "Quincy Animal Shelter",
            "city" => "Quincy"
          },
          "relationships" => [],
          "meta" => []
        }
      ]
    }
  end
end
