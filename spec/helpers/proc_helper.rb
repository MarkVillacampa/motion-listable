class Proc
  alias orig_call call
  def call(*args)
    @called ||= 0
    @called += 1
    orig_call(*args)
  end

  def called?
    @called ||= 0
    @called > 0
  end
end
