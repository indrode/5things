module TaskUtils
  def new_key(length=20)
    s = ''
    length.times do
      s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr
    end
    s
  end
end