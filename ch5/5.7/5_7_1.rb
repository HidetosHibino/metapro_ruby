class Fixnum
  alias_method :old_plus, :+

  def +(value)
    self.old_plus(value).old_plus(1)
  end
end

p 1 + 1