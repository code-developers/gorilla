class String
    def indent(amount : Int32, prefix : String)
      self.each_line.map { |line|
        (prefix * amount) + line
      }.join "\n"
    end
end