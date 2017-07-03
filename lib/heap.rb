#This BinaryMinHeap can be used as a BinaryMaxHeap, given the correct Proc.

class BinaryMinHeap
  def initialize(&prc)
    @store = Array.new
    self.prc = prc || Proc.new {|a, b| a<=> b}
    #BMH will have a property @prc, which you are setting with the attr_accessor.
  end

  def count
    @store.length
  end

  # Extract the smallest element
  def extract
    @store[-1], @store[0] = @store[0], @store[-1]
    val = @store.pop
    self.class.heapify_down(@store, 0, &prc)  #pass proc as a parameter
    val
  end

  def peek
    @store[0]
  end

  def push(val)
    @store.push(val)
    self.class.heapify_up(@store, (@store.length-1), &prc)
  end


  protected
  attr_accessor :prc, :store



  public

  #if you have parent_idx = 2, you want to return 7 and 8.
  def self.child_indices(len, parent_index)
    children = []
    if (parent_index * 2 + 1) < len
      children << (parent_index * 2 + 1)
    end

    if (parent_index * 2 + 2) < len
      children << (parent_index * 2 + 2)
    end
    children
  end

  def self.parent_index(child_index)
    parent = nil
    if child_index == 0
      raise "root has no parent"
    elsif child_index % 2 == 1
      parent = (child_index / 2)
    elsif child_index % 2 == 0
      parent = (child_index / 2 - 1)
    end
    parent
  end


  # if array[parent_idx] is bigger than children, swap places.
  def self.heapify_down(array, parent_idx, len = array.length, &prc)
    prc ||= Proc.new {|a,b| a<=>b}
    while (parent_idx < len)
      child_indices = self.child_indices(len, parent_idx)
      old_idx = parent_idx
      return array if child_indices.length == 0
      if (child_indices.length == 1)
        swap_idx = child_indices[0]
      else
        swap_idx = (prc.call(array[child_indices[0]], array[child_indices[1]]) == -1) ? child_indices[0] : child_indices[1]
      end

      if(prc.call(array[parent_idx], array[swap_idx]) == 1)
        array[parent_idx], array[swap_idx] = array[swap_idx], array[parent_idx]
        parent_idx = swap_idx
      end
      break if (old_idx == parent_idx)
    end
    array
  end


  #this is when you push a new element into an array. You need to heapify_up
  #if element is smaller than parent.
  def self.heapify_up(array, child_idx, len = array.length, &prc)
    prc ||= Proc.new {|a,b| a<=>b}
    while (child_idx > 0)
      old_idx = child_idx
      parent_idx = self.parent_index(child_idx)

      #if a is bigger than b, you want to heapify up.
      if (prc.call(array[parent_idx], array[child_idx]) == 1)
        array[parent_idx], array[child_idx] = array[child_idx], array[parent_idx]
        child_idx = parent_idx
      end
      break if (old_idx == child_idx)
    end
    array
  end
end
