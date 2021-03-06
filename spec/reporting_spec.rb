require 'spec_helper'

describe Spendthrift::Reporting do


  describe '.spending_per_month_by_category' do


    before :example do
      @test_data = [
          {
              "amount": 10,
              "category": ["Shops", "Supermarkets and Groceries"],
              "date": "2018-05-11",
              "name": "Whole Foods",
              "transaction_id": 1
          },
          {
              "amount": 15,
              "category": ["Shops", "Supermarkets and Groceries"],
              "date": "2018-05-11",
              "name": "Whole Foods",
              "transaction_id": 2
          },
          {
              "amount": 120,
              "category": ["Shops", "Supermarkets and Groceries"],
              "date": "2018-05-12",
              "name": "Whole Foods",
              "transaction_id": 3
          },
          {
              "amount": 100,
              "category": ["Food and Drink", "Restaurants"],
              "date": "2018-05-15",
              "name": "Flaco Taco Nacho",
              "transaction_id": 4
          },
          {
              "amount": 4,
              "category": ["Shops", "Digital Purchases"],
              "date": "2018-06-15",
              "name": "Google",
              "transaction_id": 4
          },
      ]
    end


    it 'sums up monthly spending per category' do
      result = Spendthrift::Reporting.spending_per_month_by_category @test_data


      expect(result[[2018, 5]][["Shops", "Supermarkets and Groceries"]]).to eq(145)
      expect(result[[2018, 5]][["Food and Drink", "Restaurants"]]).to eq(100)
      expect(result[[2018, 6]][["Shops", "Digital Purchases"]]).to eq(4)

    end

  end


  describe '.convert_list_keys_to_string' do


    it 'joins items in list to create string key' do
      result = Spendthrift::Reporting.list_keys_to_month_start_date_string [2018, 5] => {shops: 123}, [2018, 6] => {shops: 200}
      expect(result).to eq({"20180501" => {:shops => 123}, "20180601" => {:shops => 200}})
    end
  end

  describe '.generate_html_report' do

    before :example do
      @sample_data = {
          "20180901"=>
              {"Service-Telecommunication Services"=>114.44,
               "Food and Drink-Restaurants"=>241.41,
               "Shops-Clothing and Accessories-Women's Store"=>-31.23,
               "Shops-Supermarkets and Groceries"=>1477.2500000000002,
               "Shops-Amazon"=>184.19},
          "20180801"=>
              {"Service-Telecommunication Services"=>114.44,
               "Food and Drink-Restaurants"=>241.41,
               "Shops-Clothing and Accessories-Women's Store"=>-31.23,
               "Shops-Supermarkets and Groceries"=>1477.2500000000002,
               "Shops-Amazon"=>184.19}
     }
    end

    it 'generates  html tables' do
        template = Spendthrift::Reporting.generate_html_report(@sample_data)
        expect(Nokogiri.HTML(template).search("table").length).to eq(2)
    end
  end

end
