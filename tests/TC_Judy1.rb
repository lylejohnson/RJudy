require 'test/unit'
require 'judy'

include Judy

class TC_Judy1 < Test::Unit::TestCase
  def set_up
    @array = Judy1.new
  end
  
  def fill(array)
    0.upto(2**32 - 1) { |bit| array.set(bit) }
  end

  def test_set
    assert_equal(true,  @array.set(0))
    assert_equal(false, @array.set(0))
  end
  
  def test_unset
    assert_equal(false, @array.unset(0))
    assert_equal(true,  @array.set(0))
    assert_equal(true,  @array.unset(0))
  end
  
  def test_test
    assert_equal(true,  @array.set(0))
    assert_equal(true,  @array.test(0))
    assert_equal(true,  @array.unset(0))
    assert_equal(false, @array.test(0))
  end
  
  def test_count_noargs
    assert_equal(0, @array.count)
    @array.set(0)
    @array.set(3)
    @array.set(6)
    assert_equal(3, @array.count)
#   fill(@array) 
#   assert_equal(2**32, @full_array.count)
  end
  
  def test_count_twoargs
    assert_equal(0, @array.count(0, 6))
    @array.set(0)
    @array.set(3)
    @array.set(6)
    assert_equal(2, @array.count(0, 5))
    assert_equal(3, @array.count(0, 6))
  end
  
  def test_by_count
    assert_equal(true, @array.set(0))
    assert_equal(true, @array.set(2))
    assert_equal(true, @array.set(42))
    assert_equal(0, @array.by_count(1))
    assert_equal(2, @array.by_count(2))
    assert_equal(42, @array.by_count(3))
  end
  
  def test_free_array
    assert_equal(0, @array.free_array)
  end
  
  def test_mem_used
    assert(0, @array.mem_used)
    0.upto(10) do |i|
      @array.set(i)
    end
    assert(@array.mem_used > 0)
  end
  
  def test_first_index
    assert_nil(@array.first_index)
    @array.set(2)
    @array.set(4)
    @array.set(6)
    assert_equal(2, @array.first_index)
    assert_equal(2, @array.first_index(0))
    assert_equal(4, @array.first_index(3))
  end
  
  def test_next_index
    @array.set(2)
    @array.set(4)
    assert_equal(2, @array.next_index(0))
    assert_equal(2, @array.next_index(1))
    assert_equal(4, @array.next_index(2))
    assert_equal(4, @array.next_index(3))
    assert_nil(@array.next_index(4))
  end
  
  def test_last_index
    assert_nil(@array.last_index)
    @array.set(4)
    @array.set(6)
    assert_equal(6, @array.last_index)
    assert_equal(6, @array.last_index(-1))
    assert_equal(4, @array.last_index(5))
  end
  
  def test_prev_index
    @array.set(4)
    @array.set(6)
    assert_equal(6, @array.prev_index(7))
    assert_equal(4, @array.prev_index(6))
    assert_equal(4, @array.prev_index(5))
    assert_nil(@array.prev_index(4))
  end
  
  def test_first_empty_index
    @array.set(1)
    assert_equal(0, @array.first_empty_index)
    assert_equal(0, @array.first_empty_index(0))
    assert_equal(2, @array.first_empty_index(1))
    @array.set(2**32 - 1)
    assert_nil(@array.first_empty_index(2**32 - 1))
  end
  
  def test_next_empty_index
    @array.set(0)
    assert_equal(1, @array.next_empty_index(0))
    @array.set(2**32 - 1)
    assert_nil(@array.next_empty_index(2**32 - 2))
  end
  
  def test_last_empty_index
    @array.set(5)
    assert_equal(2**32 - 1, @array.last_empty_index)
    assert_equal(2**32 - 1, @array.last_empty_index(-1))
    assert_equal(4, @array.last_empty_index(5))
    @array.set(0)
    assert_nil(@array.last_empty_index(0))
  end
  
  def test_prev_empty_index
    @array.set(0)
    @array.set(2)
    assert_equal(1, @array.prev_empty_index(2))
    assert_nil(@array.prev_empty_index(1))
  end
  
  def test_each_index
    @array.set(1)
    @array.set(3)
    @array.set(5)
    sum = 0
    @array.each_index { |i| sum = sum + i }
    assert_equal(1+3+5, sum)
  end
  
  def test_each_empty_index
  end
  
  # Uncomment this one if you've got some time on your hands ;)
  def test_full?
    assert(!@array.full?)
#   fill(@array)
#   assert(@array.full?)
  end
  
  def test_to_a
    assert_equal([], @array.to_a)
    @array.set(0)
    @array.set(1)
    @array.set(2)
    @array.set(4)
    assert_equal([1, 1, 1, 0, 1], @array.to_a)
  end
  
  def test_to_s
    assert_equal("", @array.to_s)
    @array.set(0)
    @array.set(1)
    @array.set(2)
    @array.set(4)
    assert_equal("10111", @array.to_s)
  end
end
