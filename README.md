# Ruby on Rails: Numerical String Validation
Disclaimer: I don't claim this to be the most effective way to validate a 'numerical string' in rails.<br>
Instead, I wanted to share this to hopefully save people some trouble.<br>
Suppose you have a certain value in your rails model such as a social security number, passport number, etc.<br>
At first thought one might try to save this as an 'integer' datatype. There are a few problems with this though...<br>
1. Instead of validating for length, you'll have to validate by the integer value (must be greater than or less than).
2. Most importantly, anything that begins with a 000 will not save properly because integers in Ruby cannot begin with 0.
- For example, lets say you have a value which you want to save as an integer, like '001234'.
- This won't save as '001234', and it might not be apparent if you weren't aware that Try this in the rails console. If you type in a variable like `number = 001234`, Ruby will interpret it as 668.
- What is the science behind this? It's all in Ruby's Integer class! Read [this StackOverflow post](http://stackoverflow.com/questions/28545559/how-to-work-with-leading-zeros-in-integers) for more information!
3. To get around this, save it as a string! Suppose you have a model field that can only be 12 numbers. An example validation could be as follows:

```
class ExampleModel < ActiveRecord::Base
  validates :model_field, uniqueness: true, presence: true,
  length: { minimum: 12, maximum: 12, message: 'must be 12 numbers' }
  validate :string_only_contain_numbers    
  
  def string_only_contain_numbers
    if model_field.nil?
      errors.add(:model_field, 'cannot be blank')
    else
      string_numbers = (0..9).to_a.join('').to_s.split('')
      model_field_chars = model_field.split('')
      model_field_chars.each do |num|
        errors.add(:model_field, 'can only contain valid numbers (0-9).') unless string_numbers.include?(num)
      end
    end
  end
end
```

UPDATE: A more simpler implementation, suggested by a colleague:

```
def string_only_contain_numbers
  errors.add(:code, 'can only contain numbers 0-9') unless code.scan(/\D/).empty? # will return any non digit character
end
```

4. In this case, I simply created an array of numbers where the numbers are saved as strings ['0', '1', '2'] and then broke the model_field into an array, and compared the two arrays. If the model_field contains a value that isn't one of the numerical string values, it throws an error. voila! Saving it as a string can also make your other validatiosn simpler because you can validate the length like a string, rather than setting a minimum or maximum value for the number. <br>

5. For your testing environment, if you're using FactoryBot (formerly FactoryGirl) or just want to generate a string of random numbers, you can do something like this:

```
FactoryBot.define do
  # Will generate a string of 12 numerals. 
  sequence :numerical_string do |n|
    ((1..1000).to_a.shuffle.join.to_s + n.to_s)[0, 12]
  end
end

# Without FactoryBot
((1..1000).to_a.shuffle.join.to_s)[0, 12]
```

Hope this helps someone!


