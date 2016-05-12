require 'rumbrl/ext/hash'

module Rumbrl
  # serializes & flattens hashes
  class Smash
    def self.flatten(target, namespace: '')
      target.each_with_object({}) do |(k, v), res|
        cur_namespace = build_namespace(namespace, k)

        if v.respond_to?(:to_log)
          res.update(flatten(v.to_log, namespace: cur_namespace))
        else
          res.update(cur_namespace.to_sym => v)
        end
      end
    end

    def self.build_namespace(prev = '', cur = '')
      prev = "#{prev}_" unless prev.empty?
      "#{prev}#{cur}"
    end
  end
end
