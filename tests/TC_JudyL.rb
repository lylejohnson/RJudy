require 'test/unit'
require 'judy'

include Judy

class TC_JudyL < Test::Unit::TestCase
  def set_up
    @array = JudyL.new
  end

  def fill(array)
    0.upto(2**32 - 1) { |i| @array[i] = 1 }
  end
    
  def test_insert
    assert_equal("foo", (@array[1] = "foo"))
  end
  
  def test_delete_at
    @array[1] = "foo"
    assert_nil(@array.delete_at(0))
    assert_equal("foo", @array.delete_at(1))
  end
  
  def test_get
    assert_nil(@array[0])
    @array[0] = 42
    assert_equal(42, @array[0])
  end
  
  def test_count
#   fill(@array)
#   assert_equal(2**32, @array.count)
  end
  
  def test_by_count
    @array[1] = "fee"
    @array[3] = "fi"
    @array[5] = "fo"
    @array[7] = "fum"
    assert_equal(1, @array.by_count(1))
    assert_equal(3, @array.by_count(2))
    assert_equal(5, @array.by_count(3))
    assert_equal(7, @array.by_count(4))
    assert_nil(@array.by_count(5))
    assert_nil(@array.by_count(0))
  end
  
  def test_free_array
    assert_equal(0, @array.free_array)
    0.upto(100) { |i| @array[i] = Time.now }
    GC.start
    assert(@array.free_array > 0)
  end
  
  def test_mem_used
    assert_equal(0, @array.mem_used)
    0.upto(100) { |i| @array[i] = Time.now }
    assert(@array.mem_used > 0)
    @array.free_array
    assert_equal(0, @array.mem_used)
  end
  
  def test_first_index
    assert_nil(@array.first_index)
    @array[1] = "fee"
    assert_equal(1, @array.first_index)
  end
  
  def test_next_index
    assert_nil(@array.next_index(0))
    @array[1] = "fee"
    assert_equal(1, @array.next_index(0))
  end
  
  def test_last_index
    assert_nil(@array.last_index)
    @array[1] = "fee"
    @array[3] = "fi"
    assert_equal(3, @array.last_index)
    assert_equal(3, @array.last_index(3))
    assert_equal(1, @array.last_index(2))
    assert_nil(@array.last_index(0))
  end
  
  def test_prev_index
    assert_nil(@array.prev_index(2))
    @array[1] = "foo"
    assert_equal(1, @array.prev_index(2))
    assert_nil(@array.prev_index(1))
  end
  
  def test_first_empty_index
    assert_equal(0, @array.first_empty_index)
    assert_equal(0, @array.first_empty_index(0))
  end
  
  def test_next_empty_index
    assert_equal(1, @array.next_empty_index(0))
  end
  
  def test_last_empty_index
    assert_equal(2**32 - 1, @array.last_empty_index)
    assert_equal(2**32 - 1, @array.last_empty_index(2**32 - 1))
  end
  
  def test_prev_empty_index
    assert_equal(2**32 - 2, @array.prev_empty_index(2**32 - 1))
  end
  
  def test_first
    assert_nil(@array.first)
    @array[39] = "fee"
    assert_equal("fee", @array.first)
  end
  
  def test_last
    assert_nil(@array.last)
    @array[39] = "fee"
    assert_equal("fee", @array.last)
  end
  
  def test_each
    101.upto(200) { |i| @array[i] = i - 100 }
    sum = 0
    @array.each { |v| sum += v }
    assert_equal(5050, sum)
  end
  
  def test_each_index
    1.upto(100) { |i| @array[i] = "bleh" }
    GC.start
    sum = 0
    @array.each_index { |i| sum += i }
    assert_equal(5050, sum)
  end
  
  def test_each_empty_index
#   @array.each_empty_index { |i| }
  end
  
  def test_clear
    0.upto(100) { |i| @array[i] = Time.now }
    @array.clear
    assert_equal(0, @array.nitems)
  end
  
  def test_empty?
    assert(@array.empty?)
    @array[0] = 0
    assert(!@array.empty?)
  end
  
  def test_nitems
    0.upto(100) { |i| @array[i] = Time.now }
    assert_equal(101, @array.nitems)
  end
  
  def test_include?
    1.upto(99) { |i| @array[i] = i }
    assert(@array.include?(99))
    assert(!@array.include?(0))
    assert(!@array.include?(100))
  end
  
  # Uncomment this one if you've got some time on your hands ;)
  def test_full?
    assert(!@array.full?)
#   fill(@array)
#   assert(@array.full?)
  end
  
  def test_to_a
    @array[1] = 1
    @array[3] = 3
    @array[5] = 5
    assert_kind_of(Array, @array.to_a)
    assert_equal([nil, 1, nil, 3, nil, 5], @array.to_a)
  end
  
  def test_to_s
    assert_equal("", @array.to_s)
    @array[1] = 1
    @array[3] = 3
    @array[5] = 5
    assert_equal("135", @array.to_s)
  end
end
