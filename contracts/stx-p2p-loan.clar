;; stx-p2p-loan.clar
;; Simple peer-to-peer STX lending contract

(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ALREADY-BORROWED (err u101))
(define-constant ERR-NO-LOAN (err u102))
(define-constant ERR-FAILED-TRANSFER (err u103))
(define-constant ERR-INSUFFICIENT-FUNDS (err u104))

;; Contract admin (deployer)
(define-constant contract-admin tx-sender)

;; Track lender deposits
(define-map lenders { lender: principal } { amount: uint })

;; Track borrower loans
(define-map borrowers { borrower: principal } { amount: uint , interest: uint })

;; Total pool balance
(define-data-var pool-balance uint u0)

;; --------------------------
;; FUNCTIONS
;; --------------------------

;; Deposit STX into the lending pool
(define-public (lend (amount uint))
  (if (<= amount u0)
      (err u200)
      (begin
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (let ((prev (default-to u0 (get amount (map-get? lenders { lender: tx-sender })))))
          (map-set lenders { lender: tx-sender } { amount: (+ prev amount) })
        )
        (var-set pool-balance (+ (var-get pool-balance) amount))
        (ok amount)
      )
  )
)

;; Borrow STX (simple fixed 10% interest)
(define-public (borrow (amount uint))
  (if (is-some (map-get? borrowers { borrower: tx-sender }))
      ERR-ALREADY-BORROWED
      (if (> amount (var-get pool-balance))
          ERR-INSUFFICIENT-FUNDS
          (begin
            (try! (stx-transfer? amount (as-contract tx-sender) tx-sender))
            (map-set borrowers { borrower: tx-sender } { amount: amount, interest: (/ (* amount u10) u100) })
            (var-set pool-balance (- (var-get pool-balance) amount))
            (ok amount)
          )
      )
  )
)

;; Repay borrowed STX with interest
(define-public (repay)
  (match (map-get? borrowers { borrower: tx-sender })
    loan
    (let (
          (total (+ (get amount loan) (get interest loan)))
        )
      (try! (stx-transfer? total tx-sender (as-contract tx-sender)))
      (map-delete borrowers { borrower: tx-sender })
      (var-set pool-balance (+ (var-get pool-balance) total))
      (ok total)
    )
    ERR-NO-LOAN
  )
)

;; Read-only: Check lender deposit
(define-read-only (get-lender (lender principal))
  (default-to u0 (get amount (map-get? lenders { lender: lender })))
)

;; Read-only: Check borrower loan
(define-read-only (get-borrower (borrower principal))
  (map-get? borrowers { borrower: borrower })
)

;; Read-only: Get pool balance
(define-read-only (get-pool)
  (ok (var-get pool-balance))
)
