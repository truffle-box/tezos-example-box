const storedValue: int = 0;

function main (const newValue : int;  const initialValue : int) : (list(operation) * int) is
  block { storedValue := newValue } with ((nil : list(operation)), storedValue)
