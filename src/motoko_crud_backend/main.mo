import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import Option "mo:base/Option";

actor User {
  public type UserId = Nat32;

  public type Users = {
    firstname : Text;
    lastname : Text;
    balance : Nat;
  };

  private stable var id : UserId = 0;
  private stable var users : Trie.Trie<UserId, Users> = Trie.empty();

  public func created(user : Users) : async UserId {
    let user_id = id;
    
    id += 1;
    users := Trie.replace(
      users,
      key(user_id),
      Nat32.equal,
      ?user,
    ).0;

    return user_id;
  };

  public func read(user_id : UserId) : async ?Users {
    let result = Trie.find(users, key(user_id), Nat32.equal);
    return result;
  };

  public func readAll() : async [(UserId, Users)] {
    let result = Iter.toArray(Trie.iter(users));
    return result;
  };

  public func update(user_id : UserId, userInput : Users) : async Bool {
    let result = Trie.find(users, key(user_id), Nat32.equal);
    
    let data = Option.isSome(result);

    if(data) {
      users := Trie.replace(
        users,
        key(user_id),
        Nat32.equal,
        ?userInput,
      ).0;
    };

    return data;
  };

  private func key(x : UserId) : Trie.Key<UserId> {
    return {hash = x; key = x};
  };

};



