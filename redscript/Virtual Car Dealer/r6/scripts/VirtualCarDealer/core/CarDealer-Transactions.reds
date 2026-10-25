module CarDealer.Transactions

public enum VehicleTradeKind {
  Purchase = 0,
  Sale = 1
}

public enum VehicleTradePhase {
  Prepared = 0,
  OwnershipChanged = 1,
  MoneyStarted = 2,
  MoneyApplied = 3,
  Compensating = 4,
  CompensationPending = 5,
  ReviewRequired = 6
}

public enum VehicleTradeResult {
  Rejected = 0,
  Completed = 1,
  RolledBack = 2,
  CompensationPending = 3,
  ReviewRequired = 4
}

public enum VehicleTradeFailure {
  None = 0,
  Ownership = 1,
  Money = 2,
  Compensation = 3,
  Interrupted = 4
}

public class VehicleTradeOperation extends IScriptable {
  public persistent let vehicleID: TweakDBID;
  public persistent let kind: VehicleTradeKind;
  public persistent let phase: VehicleTradePhase;
  public persistent let amount: Int32;
  public persistent let initialOwned: Bool;
  public persistent let wasSold: Bool;
  public persistent let moneyAttempted: Bool;
  public persistent let moneyReturned: Bool;
  public persistent let balanceBefore: Int32;
  public persistent let balanceAfter: Int32;
  public persistent let ownershipReturned: Bool;
  public persistent let failure: VehicleTradeFailure;
}

public abstract class VehicleTradeBackend extends IScriptable {
  public func Owns(id: TweakDBID) -> Bool;
  public func ChangeOwnership(id: TweakDBID, enable: Bool) -> Bool;
  public func GetBalance() -> Int32;
  public func ChangeMoney(amount: Int32, purchase: Bool) -> Bool;
  public func FinalizePurchase(id: TweakDBID) -> Void;
}

public class VehicleTradeProcessor extends IScriptable {
  public static func ClassifyMoney(returned: Bool, before: Int32, after: Int32, expected: Int64) -> VehicleTradeResult {
    let delta: Int64 = Cast<Int64>(after) - Cast<Int64>(before);
    if returned && Equals(delta, expected) {
      return VehicleTradeResult.Completed;
    };
    if !returned && Equals(delta, 0l) {
      return VehicleTradeResult.RolledBack;
    };
    return VehicleTradeResult.ReviewRequired;
  }

  public static func Execute(operation: ref<VehicleTradeOperation>, backend: ref<VehicleTradeBackend>) -> VehicleTradeResult {
    let purchase: Bool = Equals(operation.kind, VehicleTradeKind.Purchase);
    let targetOwned: Bool = purchase;
    let owned: Bool;
    let moneyResult: VehicleTradeResult;
    let expected: Int64 = Cast<Int64>(operation.amount);
    if purchase && operation.amount <= 0 || !purchase && operation.amount < 0 || Equals(operation.initialOwned, purchase) {
      return VehicleTradeResult.Rejected;
    };
    if NotEquals(backend.Owns(operation.vehicleID), operation.initialOwned) {
      return VehicleTradeResult.Rejected;
    };

    operation.ownershipReturned = backend.ChangeOwnership(operation.vehicleID, targetOwned);
    owned = backend.Owns(operation.vehicleID);
    if !operation.ownershipReturned && Equals(owned, operation.initialOwned) {
      operation.failure = VehicleTradeFailure.Ownership;
      return VehicleTradeResult.RolledBack;
    };
    if !operation.ownershipReturned {
      operation.phase = VehicleTradePhase.ReviewRequired;
      operation.failure = VehicleTradeFailure.Ownership;
      return VehicleTradeResult.ReviewRequired;
    };
    if NotEquals(owned, targetOwned) {
      operation.failure = VehicleTradeFailure.Ownership;
      return VehicleTradeProcessor.Compensate(operation, backend);
    };

    operation.phase = VehicleTradePhase.OwnershipChanged;
    operation.balanceBefore = backend.GetBalance();
    if !purchase && Equals(operation.amount, 0) {
      operation.balanceAfter = operation.balanceBefore;
      operation.moneyReturned = true;
      moneyResult = VehicleTradeResult.Completed;
    } else {
      if purchase {
        expected = -expected;
      };
      operation.phase = VehicleTradePhase.MoneyStarted;
      operation.moneyAttempted = true;
      operation.moneyReturned = backend.ChangeMoney(operation.amount, purchase);
      operation.balanceAfter = backend.GetBalance();
      moneyResult = VehicleTradeProcessor.ClassifyMoney(operation.moneyReturned, operation.balanceBefore, operation.balanceAfter, expected);
    };

    if Equals(moneyResult, VehicleTradeResult.ReviewRequired) {
      operation.phase = VehicleTradePhase.ReviewRequired;
      operation.failure = VehicleTradeFailure.Money;
      return moneyResult;
    };
    if Equals(moneyResult, VehicleTradeResult.RolledBack) {
      operation.failure = VehicleTradeFailure.Money;
      return VehicleTradeProcessor.Compensate(operation, backend);
    };

    operation.phase = VehicleTradePhase.MoneyApplied;
    if purchase {
      backend.FinalizePurchase(operation.vehicleID);
    };
    if NotEquals(backend.Owns(operation.vehicleID), targetOwned) {
      operation.phase = VehicleTradePhase.ReviewRequired;
      operation.failure = VehicleTradeFailure.Ownership;
      return VehicleTradeResult.ReviewRequired;
    };
    return VehicleTradeResult.Completed;
  }

  public static func Compensate(operation: ref<VehicleTradeOperation>, backend: ref<VehicleTradeBackend>) -> VehicleTradeResult {
    operation.phase = VehicleTradePhase.Compensating;
    if NotEquals(backend.Owns(operation.vehicleID), operation.initialOwned) {
      backend.ChangeOwnership(operation.vehicleID, operation.initialOwned);
    };
    if Equals(backend.Owns(operation.vehicleID), operation.initialOwned) {
      return VehicleTradeResult.RolledBack;
    };
    operation.phase = VehicleTradePhase.CompensationPending;
    operation.failure = VehicleTradeFailure.Compensation;
    return VehicleTradeResult.CompensationPending;
  }
}
