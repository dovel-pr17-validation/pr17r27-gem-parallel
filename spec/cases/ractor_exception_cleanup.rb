# frozen_string_literal: true
require './spec/cases/helper'

class RaisingCallback
  def self.call(_item)
    raise "boom"
  end
end

before = ObjectSpace.each_object(Ractor).to_a
begin
  Parallel.map([1], in_ractors: 1, ractor: [RaisingCallback, :call])
rescue RuntimeError => e
  raise unless e.message == "boom"
end

assert_ractors_stopped(before)
print "OK"
