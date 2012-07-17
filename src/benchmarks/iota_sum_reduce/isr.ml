fun compute 0 = 0 | compute n = n + compute (n - 1)

fun main () =
  let val res = Array.tabulate (100000, compute)
  in print (String.concat [Int.toString (Array.sub (res, 99999)), "\n"])
  end
