def string_only_numbers
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
