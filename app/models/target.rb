class Target
  include Mongoid::Document

  %w(pic what who why where watch and_what when).each do |fname|
    field fname.to_sym, type: String
  end
end
