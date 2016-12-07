class Hash
  def deep_merge(second)
    merger = proc do |key, v1, v2|
      if v1.is_a?(Hash) && v2.is_a?(Hash)
        v1.merge(v2, &merger)
      elsif v1.is_a?(Array) && v2.is_a?(Array)
        v1 | v2
      elsif [:undefined, nil, :nil].include?(v2)
        v1
      else
        v2
      end
    end
    self.merge(second.to_hash, &merger)
  end
end
