import UIKit

//var str = "Hello, playground"

func bubblesort(arr: Array<Int>) -> Array<Int>{
    var nums = arr;
    let n = arr.count
    var didSwap = true
    while didSwap {
        didSwap = false
        
        for i in 0..<(n - 1) {
            if nums[i] > nums[i+1] {
                let tmp = nums[i]
                nums[i] = nums[i+1]
                nums[i+1] = tmp
                didSwap = true
            }
        }
    }
    return nums
}


func fibonacci(N: Int) -> Array<Int>{
    var fib = [Int](repeating: 1, count: N) // an array with N 1s in it
    for i in 2..<N {
        fib[i] = fib[i - 1] + fib[i - 2]
    }
    return fib
}



bubblesort(arr: [2,1,0,15,2,3])
fibonacci(N: 10)
