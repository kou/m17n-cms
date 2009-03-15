module AsciiValueValidator
  def validate_ascii_value(key, value, options={})
    case value
    when /\s/
      errors.add(key, :have_space, :value => value)
    when /[?:;'"!@\#$%^&*()+=|~`\[\]{}\\]/
      errors.add(key, :have_symbol, :value => value)
    else
      if /\// =~ value and !options[:accept_slash]
        errors.add(key, :have_symbol, :value => value)
      elsif /-/ =~ value and !options[:accept_hyphen]
        errors.add(key, :have_symbol, :value => value)
      elsif /_/ =~ value and !options[:accept_underscore]
        errors.add(key, :have_symbol, :value => value)
      elsif /\A[^a-zA-Z0-9]+\z/ =~ value
        errors.add(key, :have_japanese, :value => value)
      elsif !options[:default_is_valid]
        errors.add(key, :invalid, :value => value)
      end
    end
  end
end
