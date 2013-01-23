class String

  POLISH_LOWER = "\xc4\x85\xc5\xbc\xc5\x9b\xc5\xba\xc4\x99\xc4\x87\xc5\x84\xc3\xb3\xc5\x82"
  POLISH_UPPER = "\xc4\x84\xc5\xbb\xc5\x9a\xc5\xb9\xc4\x98\xc4\x86\xc5\x83\xc3\x93\xc5\x81"
  POLISH = (POLISH_LOWER + POLISH_UPPER).force_encoding("UTF-8")
  ENGLISH = 'azszecnolAZSZECNOL'
  POLISH_SIZE = POLISH.length

  def pl2en!
    (0..POLISH_SIZE - 1).each do |i|
      self.gsub!(POLISH[i], ENGLISH[i])
    end
    self
  end

  def pl2en
    copy = self
    (0..POLISH_SIZE - 1).each do |i|
      copy = copy.gsub(POLISH[i], ENGLISH[i])
    end
    copy
  end

end
