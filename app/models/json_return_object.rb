class JsonReturnObject
  attr_accessor :message
  attr_accessor :code
  @time_stamp
  def initialize
    @time_stamp = Time.now.getutc.to_i
  end
end