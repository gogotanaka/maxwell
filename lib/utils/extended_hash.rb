class Hash
  def map_to_hash &block
    ret = {}
    each { |k,v| ret[k] = block.call(k,v) }
    ret
  end
end