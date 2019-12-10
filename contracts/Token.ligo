// Implementation of the FA1.2.1 specification in PascaLIGO
// https://gitlab.com/tzip/tzip/blob/master/Proposals/TZIP-0007/FA1.2.md

type amount is nat;

type account is record
    balance : amount;
    allowances: map(address, amount);
end

type action is
| Transfer of (address * address * amount)
| Approve of (address * amount)
| GetAllowance of (address * address * contract(amount))
| GetBalance of (address * contract(amount))
| GetTotalSupply of (unit * contract(amount))

type contract_storage is record
  totalSupply: amount;
  accounts: big_map(address, account);
end

function isAllowed (const source : address ; const value : amount ; var s : contract_storage) : bool is 
  begin
    var allowed: bool := False;
    if sender =/= source then block {
      // Checking if the sender is allowed to spend in name of source
      const src: account = get_force(source, s.accounts);
      const allowanceAmount: amount = get_force(sender, src.allowances);
      allowed := allowanceAmount >= value;
    };
    else allowed := True;
  end with allowed

// Transfer a specific amount of tokens from the accountFrom address to a destination address
// Pre conditions:
//  The sender address is the account owner or is allowed to spend x in the name of accountFrom
//  The accountFrom account has a balance higher than amount
// Post conditions:
//  The balance of accountFrom is decreased by amount
//  The balance of destination is increased by amount
function transfer (const accountFrom : address ; const destination : address ; const value : amount ; var s : contract_storage) : contract_storage is
 begin  
  // If accountFrom = destination transfer is not necessary
  if accountFrom = destination then skip;
  else block {
    // Is sender allowed to spend value in the name of source
    case isAllowed(accountFrom, value, s) of 
    | False -> failwith ("Sender not allowed to spend token from source")
    | True -> skip
    end;

    // Fetch src account
    const src: account = get_force(accountFrom, s.accounts);

    // Check that the source can spend that much
    if value > src.balance 
    then failwith ("Source balance is too low");
    else skip;

    // Update the source balance
    const srcBalance: int = src.balance - value;
    if srcBalance < 0 then failwith ("Balance cannot be negative");
    else src.balance := abs(srcBalance);

    s.accounts[accountFrom] := src;

    // Fetch dst account or add empty dst account to ledger
    var dst: account := record 
        balance = 0n;
        allowances = (map end : map(address, amount));
    end;
    case s.accounts[destination] of
    | None -> skip
    | Some(n) -> dst := n
    end;

    // Update the destination balance
    dst.balance := dst.balance + value;

    // Decrease the allowance amount if necessary
    if accountFrom =/= sender then block {
        const allowanceAmount: amount = get_force(sender, src.allowances);
        if allowanceAmount - value < 0 then failwith ("Allowance amount cannot be negative");
        else src.allowances[sender] := abs(allowanceAmount - value);
    } else skip;

    s.accounts[destination] := dst;
  }
 end with s

// Approve an amount to be spent by another address in the name of the sender
// Pre conditions:
//  The spender account is not the sender account
// Post conditions:
//  The allowance of spender in the name of sender is value
function approve (const spender : address ; const value : amount ; var s : contract_storage) : contract_storage is
 begin
  // If sender is the spender approving is not necessary
  if sender = spender then skip;
  else block {
    const src: account = get_force(sender, s.accounts);
    src.allowances[spender] := value;
    s.accounts[sender] := src; // Not sure if this last step is necessary
  }
 end with s

// View function that forwards the allowance amount of spender in the name of tokenOwner to a contract
// Pre conditions:
//  None
// Post conditions:
//  The state is unchanged
function getAllowance (const owner : address ; const spender : address ; const contr : contract(amount) ; var s : contract_storage) : list(operation) is
 begin
  const src: account = get_force(owner, s.accounts);
  const destAllowance: amount = get_force(spender, src.allowances);
 end with list [transaction(destAllowance, 0tz, contr)]

// View function that forwards the balance of source to a contract
// Pre conditions:
//  None
// Post conditions:
//  The state is unchanged
function getBalance (const source : address ; const contr : contract(amount) ; var s : contract_storage) : list(operation) is
 begin
  const src: account = get_force(source, s.accounts);
 end with list [transaction(src.balance, 0tz, contr)]

// View function that forwards the totalSupply to a contract
// Pre conditions:
//  None
// Post conditions:
//  The state is unchanged
function getTotalSupply (const contr : contract(amount) ; var s : contract_storage) : list(operation) is
  list [transaction(s.totalSupply, 0tz, contr)]

function main (const p : action ; const s : contract_storage) :
  (list(operation) * contract_storage) is
 block { 
   // Reject any transaction that try to transfer token to this contract
   if amount =/= 0tz then failwith ("This contract do not accept token");
   else skip;
  } with case p of
  | Transfer(n) -> ((nil : list(operation)), transfer(n.0, n.1, n.2, s))
  | Approve(n) -> ((nil : list(operation)), approve(n.0, n.1, s))
  | GetAllowance(n) -> (getAllowance(n.0, n.1, n.2, s), s)
  | GetBalance(n) -> (getBalance(n.0, n.1, s), s)
  | GetTotalSupply(n) -> (getTotalSupply(n.1, s), s)
 end
