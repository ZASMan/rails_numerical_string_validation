# Ruby on Rails: Numerical String Validation
Suppose you have a certain value in your rails model such as a social security number, passport number, etc.
At first thought one might try to save this as an 'integer' datatype. A few problems with this though...
1. Instead of validating for length, you'll have to validate by the integer value (must be greater than or less than).
2. Most importantly, anything that begins with a 000 will not save properly because integers in Ruby cannot begin with 0.
- For example, lets say you have a value which you want to save as an integer, like '001234'. Try this in the rails console. If you type in a variable like `number = 001234`, Ruby will interpret it as 668.
3. To get around this, save it as a string! Suppose you have a model field that can only be 12 numbers. An example validation could be as follows:

example_model.rb:

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
