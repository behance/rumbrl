# Extensions for native Hash to allow for log ingestion
module HashExtensions
  def to_log
    to_hash
  end
end

::Hash.include(HashExtensions)
