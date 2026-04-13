Project Title: Integrated Restaurant Reservation and Loyalty Management System

1. System Objective
The primary objective of this system is to provide a centralized, relational data architecture to manage front-of-house restaurant operations and customer retention programs. The system is designed to eliminate data redundancy, enforce strict chronological and mathematical data constraints, and provide an auditable trail of all customer interactions, from initial booking to post-meal feedback and reward accumulation.

2. Target Audience
The system is designed to serve two primary user classifications:

Restaurant Administration and Staff: Personnel utilizing the system to manage seating capacities, monitor waitlist queues, track customer feedback, and audit loyalty program liabilities.

Registered Patrons: End-users who interact with the system to schedule dining times, submit experiential reviews, and accumulate or redeem loyalty points based on their tier status.

3. Core Functional Requirements
To satisfy the business objectives, the system must support the following core operational modules:

Customer Identity Management: The system must securely store unique patron profiles, ensuring no duplication of contact credentials (email and phone) to maintain absolute account integrity.

Operational Scheduling: The system must facilitate the booking of future reservations with verifiable chronological logic, ensuring bookings cannot be made in the past. It must also manage a dynamic walk-in waitlist with estimated seating times.

Status Tracking: All reservations and waitlist entries must be dynamically linked to a standardized, universally updatable status dictionary (e.g., Pending, Seated, Cancelled).

Quality Assurance (Feedback): The system must allow verified diners to submit quantitative ratings and qualitative comments linked strictly to a specific, historical reservation.

Tiered Loyalty Ledger: The system must maintain an accurate, non-negative mathematical balance of reward points for active users. It must automatically categorize users into specific benefit tiers and maintain an immutable, timestamped audit log of every individual point transaction and the specific reason for that transaction.

4. Database Entity Architecture
To execute the functional requirements, the relational database is normalized to the Third Normal Form (3NF) and consists of the following interconnected entities:

Core Entities: CUSTOMER (User Identity).

Transactional Entities: RESERVATION (Scheduled bookings), WAITLIST (Walk-in queues), FEEDBACK (Post-dining reviews).

Loyalty Entities: LOYALTY (Aggregate point balances), LOYALTY_TRANSACTION (Chronological ledger of point changes).

Categorical Lookup Entities (ENUMs): STATUS_TYPE (Operational states), LOYALTY_TIER (Membership classifications), REASON (Transaction justifications).