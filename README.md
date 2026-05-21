# Decentralized Cloud Storage Grid

This repository provides an expert-level implementation of a decentralized storage marketplace. It enables users to store data across a distributed network of nodes, ensuring redundancy, availability, and cryptographic integrity.

### Core Architecture
* **Storage Market:** A dynamic auction system where users post "Storage Deals" and nodes bid to host the data.
* **Proof of Retrievability (PoR):** Nodes must provide periodic cryptographic proofs that they still possess the data without revealing the data itself.
* **Slashing & Collateral:** Nodes must stake tokens to participate. If a node fails a challenge, its collateral is slashed and used to fund data migration.
* **Chunking & Encryption:** Data is fragmented and encrypted client-side before being distributed to the grid.

### Security
* **Merkle Inclusion Proofs:** Used to verify that specific data segments are part of a larger file.
* **Time-Lock Contracts:** Payments are released to providers incrementally over the life of the storage deal.
