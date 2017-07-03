# Heaps

I implemented a Heap data structure with an array in Ruby: Binary Min Heap and Binary Max Heap. Binary Max Heap can be implemented by specifying a specific Ruby Proc. I also implemented heapsort.

## Heapify down

To heapify down for a Min Heap, I needed to look at each node's children and swap places with the smallest child.
If working with a Max Heap, I would swap places with the biggest child. This would be an iterative process until
the node was no longer bigger (or smaller) than either of its children.

```ruby
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
```

The helper method "child_indices" returns an array of the child indices of the parent_idx. Each child index can be calculated as follows:

```Ruby
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
```


## Heapify up

Heapify up is simpler because each node only has one parent. To find the parent index:

```Ruby
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
```

Heapifying an element up or down takes O(log n) time. After writing heapify up/down, the heap structure can push new elements as well as extract the min/max. Pushing and extracting each take O(log n) time.

```ruby
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
```

## Heapsort

Heapsort, due to heapify, takes O(n log n) time. You multiply by a factor of n because each element in an array must be heapified.

To use O(1) space, we heapified the original array in place. No new data structures are creating during the sorting: a section of the array is partitioned off for heapifying.

Steps for heapsort
1. Heapify up from left to right
2. Extract the max and swap places with the last element, then heapify down the first element in the array.


```ruby
def heap_sort!
  prc = Proc.new {|a,b| -1 * (a<=>b)} #using BMH as a MaxHeap to have elements sorted from smallest to biggest

  1.upto(count) do |num|
    next if num == self.length #can't have index be the array length

    #line 40 changes the Array each iteration. You start at
    #index one because you can't heapify up an element at index 0.
    BinaryMinHeap.heapify_up(self, num, count, &prc)
  end

  #Array is now a heap.

  # Extract, starting right to left. Heapify down, since each [0] element will now be out of place.
right_hand = count - 1     #array[count - 1]
right_hand.downto(1) do |num|
  self[0], self[num] = self[num], self[0]
  BinaryMinHeap.heapify_down(self, 0, num, &prc)  #each iteration/number can be thought of as the heap_size you're working with.
end

self

end
```
