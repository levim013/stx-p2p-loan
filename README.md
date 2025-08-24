# STX P2P Loan Smart Contract

A decentralized peer-to-peer lending protocol built on Stacks blockchain that enables users to lend and borrow STX tokens with fixed interest rates.

## Features

- **Lending**: Users can deposit STX tokens into the lending pool
- **Borrowing**: Users can borrow STX with 10% fixed interest rate
- **Repayment**: Borrowers can repay their loans with interest
- **Balance Checking**: View pool balance, lender deposits, and borrower loans

## Contract Functions

### Public Functions

- `(lend (amount uint))`: Deposit STX into the lending pool
- `(borrow (amount uint))`: Borrow STX from the pool with 10% interest
- `(repay)`: Repay borrowed STX with accrued interest

### Read-only Functions

- `(get-lender (lender principal))`: Check lender's deposited amount
- `(get-borrower (borrower principal))`: Check borrower's loan details
- `(get-pool)`: Get total pool balance

## Error Codes

- `ERR-NOT-AUTHORIZED (u100)`: Unauthorized access
- `ERR-ALREADY-BORROWED (u101)`: Borrower already has an active loan
- `ERR-NO-LOAN (u102)`: No active loan found
- `ERR-FAILED-TRANSFER (u103)`: STX transfer failed
- `ERR-INSUFFICIENT-FUNDS (u104)`: Insufficient funds in pool

## Development

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet)
- Node.js
- Git

### Installation

```bash
git clone https://github.com/yourusername/stx-p2p-loan
cd stx-p2p-loan
clarinet contract new stx-p2p-loan
```

### Testing

```bash
clarinet test
```
