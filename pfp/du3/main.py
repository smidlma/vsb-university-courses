"""
Now, build an array composed from these triples.
The individual triples will be used to store values and to store references.
Internally, the array will be represented as a ternary tree composed from these triples.
In this tree, leaves are values stored in these triples and branches 
are references stored in these triples.

For such immutable array create:

    Constructor - a way to define an array of given size n (an array to store n values).
    Enumerator - a way to go trough the array and get all values.
    Indexer - a way how to get a value defined by its index (in range 0..n-1).
    Set method - a way, ho to change a value in the array based on its index. While it is an immutable array,
                 this method needs to return the new array that accommodated the change.
"""


class Node:
    def __init__(self) -> None:
        self.left = None
        self.middle = None
        self.right = None


class ImmutableArray:
    def __init__(self, size) -> None:
        self.size = size
        self.tree = None
        self.height = (size - (size % 3)) / 3 + size % 3
        print(self.height)
        self.init(size)

    def __iter__(self):
        self.iter_index = 0
        return self

    def __next__(self):
        if self.iter_index < self.size:
            x = self.get_value(self.iter_index)
            self.iter_index = self.iter_index + 1
            return x
        else:
            raise StopIteration

    def init(self):
        pass

    def set_value(self):
        pass

    def get_value(self, index):
        if index < 0 or index >= self.size:
            raise IndexError


def main():
    arr = ImmutableArray(9)


if __name__ == "__main__":
    main()
