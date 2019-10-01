function main (const newValue : int;  const storedValue : int) : (list(operation) * int) is
  block { storedValue := newValue } with ((nil : list(operation)), storedValue)
