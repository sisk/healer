def set_english
  I18n.stub(:locale).and_return("en")
end

def set_spanish
  I18n.stub(:locale).and_return("es")
end