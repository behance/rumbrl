module Rumbrl
  # serializes & flattens hashes
  class Smash
    def self.face(namespace: '', **target)
      res = {}
      # flattens a hash
      target.each do |k, v|
        cur_nspace = build_namespace(namespace, k)
        if v.is_a? Hash
          res.update face(**v, namespace: cur_nspace)
          next
        end
        res[cur_nspace.to_sym] = v
      end
      res
    end

    def self.build_namespace(prev = '', cur = '')
      prev = "#{prev}_" unless prev.empty?
      "#{prev}#{cur}"
    end
  end
end
