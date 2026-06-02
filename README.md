# DB_5786_8100_2119
## אליהו עבודי , אורי מגד

## מערכת מסעדה, מודול שולחנות

## תוכן עניינים

1. [מבוא](#מבוא)
2. [4 מסכים](#4-מסכים)
3. [סכמות מסד נתונים](#סכמות-מסד-נתונים)
4. [מתודולוגיות אכלוס נתונים](#מתודולוגיות-אכלוס-נתונים)
5. [גיבוי ושחזור נתונים](#גיבוי-ושחזור-נתונים)
6. [שלב ב — שאילתות SELECT כפולות (S1–S4)](#שלב-ב--שאילתות-select-כפולות-s1s4)
7. [שלב ב — שאילתות SELECT נוספות (S5–S8)](#שלב-ב--שאילתות-select-נוספות-s5s8)
8. [שלב ב — שאילתות DELETE](#שלב-ב--שאילתות-delete)
9. [שלב ב — שאילתות UPDATE](#שלב-ב--שאילתות-update)
10. [שלב ב — אילוצים (Constraints)](#שלב-ב--אילוצים-constraints)
11. [שלב ב — Rollback ו-Commit](#שלב-ב--rollback-ו-commit)
12. [שלב ב — אינדקסים (Indexes)](#שלב-ב--אינדקסים-indexes)
13. [שלב ג — אינטגרציה בין מערכות (Customer DB & Orders DB)](#שלב-ג--אינטגרציה-בין-מערכות-customer-db--orders-db)
14. [שלב ד — תכנות (PL/pgSQL Programming)](#שלב-ד--תכנות-plpgsql-programming)

---

## מבוא

ארכיטקטורת מסד נתונים יחסית (Relational Database) זו מתוכננת לרכז ולנהל את נתוני התפעול הליבתיים של מסעדה מודרנית. המערכת מתעדת נתונים בלתי משתנים אודות זהויות לקוחות, הזמנות סעודה כרונולוגיות, רשימות המתנה דינמיות ללקוחות מזדמנים, משוב סעודה איכותני, ופנקס תגמולי נאמנות מדורג. 

הפונקציונליות המרכזית מבטיחה כי הנהלת המסעדה תוכל לעקוב באופן רציף אחר מחזור החיים של הלקוח — החל מהזמנת שולחן ועד לצבירת נקודות נאמנות מבוססות עסקאות — תוך אכיפה קפדנית של שלמות כרונולוגית ואילוצים מתמטיים למניעת אנומליות בנתונים.

## 4 מסכים

## מסך הזמנות

![alt text](images/reservation_screen.png)

## מסך רשימת המתנה

![alt text](images/waitlist_screen.png)

## מסך נאמנות

![alt text](images/loyalty_screen.png)

## מסך משוב

![alt text](images/Feedback_screen.png)

## סכמות מסד נתונים

## תרשים ישויות-קשרים (ERD)

![alt text](images/Tables_Diagram.png)

## סכמת מסד נתונים (DSD)

![alt text](images/Relational_Schema.png)

## מתודולוגיות אכלוס נתונים

## Mockaroo

![alt text](images/Mockaroo.png)

## הכנסה ידנית (Manual Insert)

![alt text](images/Manual_Insert.png)

## סקריפט Python

![alt text](images/Python_Script.png)

## גיבוי ושחזור נתונים

![alt text](images/backup1.png)

![alt text](images/backup2.png)

![alt text](images/backup3.png)

---

# שלב ב — דוח שאילתות, אילוצים, טרנזקציות ואינדקסים

---

## שלב ב — שאילתות SELECT כפולות (S1–S4)

לכל אחת מ-4 השאילתות הבאות מוצגות שתי צורות כתיבה (Form A ו-Form B), כולל הסבר על ההבדל ביניהן ומה יותר יעיל.

---

### S1 — דוח חודשי של נפח הזמנות

**תיאור:** שאילתא זו מציגה את סך ההזמנות לפי חודש ושנה, כולל גודל קבוצה ממוצע, סך אורחים, ומספר ההזמנות שהושלמו, בוטלו, או סומנו כ-No-Show. השאילתא משמשת את מסך ניהול ההזמנות ולוח הבקרה של ההנהלה לצורך תכנון כוח אדם.

**צורה A — JOIN עם GROUP BY (יעילה יותר):**

```sql
SELECT
    EXTRACT(YEAR FROM r.datetime)   AS reservation_year,
    EXTRACT(MONTH FROM r.datetime)  AS reservation_month,
    COUNT(*)                        AS total_reservations,
    ROUND(AVG(r.party_size), 1)     AS avg_party_size,
    SUM(r.party_size)               AS total_guests,
    COUNT(CASE WHEN st.description = 'Completed' THEN 1 END) AS completed_count,
    COUNT(CASE WHEN st.description = 'Cancelled' THEN 1 END) AS cancelled_count,
    COUNT(CASE WHEN st.description = 'No-Show'   THEN 1 END) AS noshow_count
FROM RESERVATION r
JOIN STATUS_TYPE st ON r.status_ID = st.status_ID
GROUP BY
    EXTRACT(YEAR FROM r.datetime),
    EXTRACT(MONTH FROM r.datetime)
ORDER BY reservation_year DESC, reservation_month DESC;
```

**צילום הרצה:**

![S1 Form A — הרצה](images/s1a_run.png)

**צילום תוצאה:**

![S1 Form A — תוצאה](images/s1a_result.png)

---

**צורה B — שאילתות-משנה מתואמות ב-SELECT (פחות יעילה):**

```sql
SELECT
    r_agg.reservation_year,
    r_agg.reservation_month,
    r_agg.total_reservations,
    r_agg.avg_party_size,
    r_agg.total_guests,
    (SELECT COUNT(*)
     FROM RESERVATION r2
     WHERE r2.status_ID = (SELECT status_ID FROM STATUS_TYPE WHERE description = 'Completed')
       AND EXTRACT(YEAR FROM r2.datetime)  = r_agg.reservation_year
       AND EXTRACT(MONTH FROM r2.datetime) = r_agg.reservation_month
    ) AS completed_count,
    (SELECT COUNT(*)
     FROM RESERVATION r2
     WHERE r2.status_ID = (SELECT status_ID FROM STATUS_TYPE WHERE description = 'Cancelled')
       AND EXTRACT(YEAR FROM r2.datetime)  = r_agg.reservation_year
       AND EXTRACT(MONTH FROM r2.datetime) = r_agg.reservation_month
    ) AS cancelled_count
FROM (
    SELECT
        EXTRACT(YEAR FROM r.datetime)   AS reservation_year,
        EXTRACT(MONTH FROM r.datetime)  AS reservation_month,
        COUNT(*)                        AS total_reservations,
        ROUND(AVG(r.party_size), 1)     AS avg_party_size,
        SUM(r.party_size)               AS total_guests
    FROM RESERVATION r
    GROUP BY
        EXTRACT(YEAR FROM r.datetime),
        EXTRACT(MONTH FROM r.datetime)
) r_agg
ORDER BY reservation_year DESC, reservation_month DESC;
```

**צילום הרצה:**

![S1 Form B — הרצה](images/s1b_run.png)

**צילום תוצאה:**

![S1 Form B — תוצאה](images/s1b_result.png)

**הבדל ויעילות:**

צורה A מבצעת סריקה אחת של טבלת RESERVATION עם JOIN ל-STATUS_TYPE ומבצעת את כל האגרגציות (COUNT, AVG, SUM) במעבר יחיד. צורה B לעומתה משתמשת בשאילתות-משנה מתואמות (Correlated Subqueries) ב-SELECT — לכל שורת תוצאה (כל חודש/שנה) מתבצעת סריקה נוספת של טבלת RESERVATION. מדובר ב-N סריקות נפרדות לעומת סריקה אחת בצורה A, ולכן **צורה A יעילה יותר** באופן משמעותי, בייחוד עם כמויות נתונים גדולות.

---

### S2 — 10 הלקוחות המובילים לפי הזמנות ונאמנות

**תיאור:** שאילתא זו מזהה את הלקוחות הפעילים ביותר במערכת, כולל מספר ההזמנות שלהם, דירוג ממוצע של המשוב, נקודות נאמנות, ורמה (Tier). השאילתא מפעילה את מסך הנאמנות ואת הברכה האישית ללקוח.

**צורה A — JOIN-based (יעילה יותר):**

```sql
SELECT
    c.Customer_ID,
    c.first_name || ' ' || c.last_name    AS full_name,
    c.email,
    COUNT(DISTINCT r.reservation_ID)       AS total_reservations,
    COALESCE(ROUND(AVG(f.rating), 2), 0)   AS avg_rating,
    l.points                               AS loyalty_points,
    lt.level                               AS loyalty_tier
FROM CUSTOMER c
JOIN RESERVATION r   ON c.Customer_ID = r.Customer_ID
LEFT JOIN FEEDBACK f ON r.reservation_ID = f.reservation_ID
JOIN LOYALTY l       ON c.Customer_ID = l.Customer_ID
JOIN LOYALTY_TIER lt ON l.tier_id = lt.tier_id
WHERE c.is_active = 1
GROUP BY c.Customer_ID, c.first_name, c.last_name, c.email,
         l.points, lt.level
ORDER BY total_reservations DESC, avg_rating DESC
LIMIT 10;
```

**צילום הרצה:**

![S2 Form A — הרצה](images/s2a_run.png)

**צילום תוצאה:**

![S2 Form A — תוצאה](images/s2a_result.png)

---

**צורה B — שאילתות-משנה מתואמות (פחות יעילה):**

```sql
SELECT
    c.Customer_ID,
    c.first_name || ' ' || c.last_name    AS full_name,
    c.email,
    (SELECT COUNT(*)
     FROM RESERVATION r
     WHERE r.Customer_ID = c.Customer_ID
    ) AS total_reservations,
    COALESCE(
      (SELECT ROUND(AVG(f.rating), 2)
       FROM FEEDBACK f
       JOIN RESERVATION r ON f.reservation_ID = r.reservation_ID
       WHERE r.Customer_ID = c.Customer_ID
      ), 0
    ) AS avg_rating,
    l.points           AS loyalty_points,
    lt.level           AS loyalty_tier
FROM CUSTOMER c
JOIN LOYALTY l       ON c.Customer_ID = l.Customer_ID
JOIN LOYALTY_TIER lt ON l.tier_id = lt.tier_id
WHERE c.is_active = 1
ORDER BY total_reservations DESC, avg_rating DESC
LIMIT 10;
```

**צילום הרצה:**

![S2 Form B — הרצה](images/s2b_run.png)

**צילום תוצאה:**

![S2 Form B — תוצאה](images/s2b_result.png)

**הבדל ויעילות:**

צורה A מבצעת תוכנית ביצוע אחת שמצרפת (JOIN) את כל 5 הטבלאות בסריקה אחת, כאשר מנוע ה-DB יכול להשתמש ב-Hash Join או Merge Join. צורה B מריצה 2 שאילתות-משנה מתואמות נפרדות (ספירת הזמנות + ממוצע דירוג) עבור **כל שורת לקוח** — עם 500 לקוחות, זה עשוי לגרום ל-~1000 סריקות נוספות. **צורה A יעילה יותר** כי היא נמנעת מסריקות חוזרות.

---

### S3 — רשימת המתנה פעילה עם פרטי לקוח

**תיאור:** שאילתא זו מפעילה את מסך ניהול רשימת ההמתנה ומציגה לקוחות ברשימת ההמתנה שהם גם בעלי חשבון נאמנות, ממוינים לפי זמן הבקשה. מוצגים: מיקום, שם לקוח, גודל קבוצה, זמן כניסה, זמן המתנה משוער, סטטוס, ורמת נאמנות.

**צורה A — שימוש ב-IN (קריאה טובה יותר):**

```sql
SELECT
    w.waitlist_ID                        AS position,
    c.first_name || ' ' || c.last_name   AS customer_name,
    w.party_size,
    w.request_time                       AS time_joined,
    w.est_wait_time                      AS est_wait_min,
    st.description                       AS status,
    COALESCE(lt.level, 'No Loyalty')     AS loyalty_tier
FROM WAITLIST w
JOIN CUSTOMER c    ON w.Customer_ID = c.Customer_ID
JOIN STATUS_TYPE st ON w.status_ID = st.status_ID
LEFT JOIN LOYALTY l  ON c.Customer_ID = l.Customer_ID
LEFT JOIN LOYALTY_TIER lt ON l.tier_id = lt.tier_id
WHERE w.Customer_ID IN (
    SELECT Customer_ID FROM CUSTOMER WHERE is_active = 1
)
AND EXTRACT(YEAR FROM w.request_time) >= 2024
ORDER BY w.request_time ASC;
```

**צילום הרצה:**

![S3 Form A — הרצה](images/s3a_run.png)

**צילום תוצאה:**

![S3 Form A — תוצאה](images/s3a_result.png)

---

**צורה B — שימוש ב-EXISTS (יעילה יותר למאגרים גדולים):**

```sql
SELECT
    w.waitlist_ID                        AS position,
    c.first_name || ' ' || c.last_name   AS customer_name,
    w.party_size,
    w.request_time                       AS time_joined,
    w.est_wait_time                      AS est_wait_min,
    st.description                       AS status,
    COALESCE(lt.level, 'No Loyalty')     AS loyalty_tier
FROM WAITLIST w
JOIN CUSTOMER c    ON w.Customer_ID = c.Customer_ID
JOIN STATUS_TYPE st ON w.status_ID = st.status_ID
LEFT JOIN LOYALTY l  ON c.Customer_ID = l.Customer_ID
LEFT JOIN LOYALTY_TIER lt ON l.tier_id = lt.tier_id
WHERE EXISTS (
    SELECT 1 FROM CUSTOMER c2
    WHERE c2.Customer_ID = w.Customer_ID AND c2.is_active = 1
)
AND EXTRACT(YEAR FROM w.request_time) >= 2024
ORDER BY w.request_time ASC;
```

**צילום הרצה:**

![S3 Form B — הרצה](images/s3b_run.png)

**צילום תוצאה:**

![S3 Form B — תוצאה](images/s3b_result.png)

**הבדל ויעילות:**

צורה A משתמשת ב-IN אשר ממש את רשימת ה-Customer_ID הפעילים ורק אז מסננת. צורה B משתמשת ב-EXISTS שפועלת לפי עקרון "קצר-רשת" (Short-Circuit) — היא מפסיקה לסרוק את השאילתה הפנימית ברגע שמוצאת התאמה ראשונה לשורה הנוכחית, בעוד ש-IN חייבת לממש את כל תוצאות השאילתה הפנימית. **צורה B (EXISTS) יעילה יותר** כאשר הטבלה הפנימית גדולה, כי היא לא צריכה לבנות רשימה מלאה בזיכרון.

---

### S4 — פעילות נקודות נאמנות לפי סיבה ורבעון

**תיאור:** שאילתא זו מפרקת את עסקאות נקודות הנאמנות לפי סיבת עסקה ורבעון קלנדרי, ומציגה סיכומים וספירות. השאילתא מפעילה את הפאנל "עסקאות אחרונות" במסך הנאמנות. כוללת פילוח לפי שנה ורבעון עם EXTRACT.

**צורה A — JOIN עם GROUP BY (יעילה יותר):**

```sql
SELECT
    EXTRACT(YEAR FROM lt.created_at)      AS transaction_year,
    EXTRACT(QUARTER FROM lt.created_at)   AS transaction_quarter,
    rn.description                        AS reason,
    COUNT(*)                              AS transaction_count,
    SUM(lt.points_change)                 AS total_points,
    ROUND(AVG(lt.points_change), 1)       AS avg_points_per_txn
FROM LOYALTY_TRANSACTION lt
JOIN REASON rn  ON lt.reason_id = rn.reason_id
JOIN LOYALTY l  ON lt.loyalty_ID = l.loyalty_ID
GROUP BY
    EXTRACT(YEAR FROM lt.created_at),
    EXTRACT(QUARTER FROM lt.created_at),
    rn.description
HAVING COUNT(*) > 5
ORDER BY transaction_year DESC, transaction_quarter DESC, total_points DESC;
```

**צילום הרצה:**

![S4 Form A — הרצה](images/s4a_run.png)

**צילום תוצאה:**

![S4 Form A — תוצאה](images/s4a_result.png)

---

**צורה B — שאילתת-משנה מקוננת עם WHERE IN (פחות יעילה):**

```sql
SELECT
    EXTRACT(YEAR FROM lt.created_at)      AS transaction_year,
    EXTRACT(QUARTER FROM lt.created_at)   AS transaction_quarter,
    (SELECT rn.description FROM REASON rn WHERE rn.reason_id = lt.reason_id) AS reason,
    COUNT(*)                              AS transaction_count,
    SUM(lt.points_change)                 AS total_points,
    ROUND(AVG(lt.points_change), 1)       AS avg_points_per_txn
FROM LOYALTY_TRANSACTION lt
WHERE lt.reason_id IN (
    SELECT reason_id FROM REASON
)
GROUP BY
    EXTRACT(YEAR FROM lt.created_at),
    EXTRACT(QUARTER FROM lt.created_at),
    lt.reason_id
HAVING COUNT(*) > 5
ORDER BY transaction_year DESC, transaction_quarter DESC, total_points DESC;
```

**צילום הרצה:**

![S4 Form B — הרצה](images/s4b_run.png)

**צילום תוצאה:**

![S4 Form B — תוצאה](images/s4b_result.png)

**הבדל ויעילות:**

צורה A מבצעת סריקה אחת של LOYALTY_TRANSACTION עם JOIN ל-REASON ול-LOYALTY, כאשר ה-DB מקבץ ומאגרג במעבר יחיד. צורה B מסננת תחילה את LOYALTY_TRANSACTION לפי שם סיבה (שדורש JOIN ל-REASON), ואז השאילתה החיצונית סורקת שוב ומאגרגת. בנוסף, שאילתת-המשנה ב-SELECT (`SELECT rn.description...`) מורצת עבור כל שורת תוצאה. גישה דו-שלבית זו איטית יותר מהמעבר היחיד של צורה A. **צורה A יעילה יותר.**

---

## שלב ב — שאילתות SELECT נוספות (S5–S8)

---

### S5 — דירוג משוב ממוצע לפי יום בשבוע

**תיאור:** שאילתא זו מציגה אילו ימים בשבוע מקבלים את הדירוגים הטובים והגרועים ביותר מלקוחות, ומסייעת לייעל את כוח האדם ואיכות השירות. כוללת: ספירת ביקורות, דירוג ממוצע, דירוג נמוך/גבוה ביותר, וספירת ביקורות חיוביות ושליליות.

```sql
SELECT
    CASE EXTRACT(DOW FROM r.datetime)
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END                                   AS day_of_week,
    COUNT(f.feedback_ID)                  AS total_reviews,
    ROUND(AVG(f.rating), 2)              AS avg_rating,
    MIN(f.rating)                         AS lowest_rating,
    MAX(f.rating)                         AS highest_rating,
    COUNT(CASE WHEN f.rating >= 4 THEN 1 END) AS positive_reviews,
    COUNT(CASE WHEN f.rating <= 2 THEN 1 END) AS negative_reviews
FROM FEEDBACK f
JOIN RESERVATION r ON f.reservation_ID = r.reservation_ID
JOIN CUSTOMER c    ON r.Customer_ID = c.Customer_ID
GROUP BY EXTRACT(DOW FROM r.datetime)
ORDER BY avg_rating DESC;
```

**צילום הרצה:**

![S5 — הרצה](images/s5_run.png)

**צילום תוצאה:**

![S5 — תוצאה](images/s5_result.png)

---

### S6 — הזמנות שהושלמו ללא משוב

**תיאור:** שאילתא זו מזהה הזמנות שהושלמו אך טרם הוזן להן משוב, כדי שצוות המסעדה יוכל לשלוח מיילי בקשה לביקורת. משתמשת ב-LEFT JOIN עם IS NULL לאיתור רשומות חסרות.

```sql
SELECT
    r.reservation_ID,
    c.first_name || ' ' || c.last_name    AS customer_name,
    c.email,
    r.datetime                            AS reservation_date,
    EXTRACT(MONTH FROM r.datetime)        AS reservation_month,
    EXTRACT(YEAR FROM r.datetime)         AS reservation_year,
    r.party_size,
    st.description                        AS status
FROM RESERVATION r
JOIN CUSTOMER c     ON r.Customer_ID = c.Customer_ID
JOIN STATUS_TYPE st ON r.status_ID = st.status_ID
LEFT JOIN FEEDBACK f ON r.reservation_ID = f.reservation_ID
WHERE f.feedback_ID IS NULL
  AND st.description = 'Completed'
ORDER BY r.datetime DESC
LIMIT 50;
```

**צילום הרצה:**

![S6 — הרצה](images/s6_run.png)

**צילום תוצאה:**

![S6 — תוצאה](images/s6_result.png)

---

### S7 — פרופיל לקוח מלא עם עסקאות נאמנות

**תיאור:** עבור לקוח נתון (Customer_ID = 1), השאילתא מציגה את עסקאות הנאמנות האחרונות שלו כולל: סיבה, פירוט תאריך (יום, חודש, שנה), נקודות נוכחיות, רמה נוכחית, ומרחק בנקודות לרמה הבאה. השאילתא מפעילה את רשימת "העסקאות האחרונות" במסך הנאמנות.

```sql
SELECT
    c.first_name || ' ' || c.last_name              AS customer_name,
    lt_tier.level                                    AS current_tier,
    l.points                                         AS current_points,
    CASE
        WHEN lt_tier.level = 'Bronze'   THEN 2501 - l.points
        WHEN lt_tier.level = 'Silver'   THEN 5001 - l.points
        WHEN lt_tier.level = 'Gold'     THEN 7501 - l.points
        WHEN lt_tier.level = 'Platinum' THEN 0
    END                                              AS points_to_next_tier,
    rn.description                                   AS transaction_reason,
    lt_txn.points_change,
    EXTRACT(DAY FROM lt_txn.created_at)              AS txn_day,
    EXTRACT(MONTH FROM lt_txn.created_at)            AS txn_month,
    EXTRACT(YEAR FROM lt_txn.created_at)             AS txn_year
FROM CUSTOMER c
JOIN LOYALTY l           ON c.Customer_ID = l.Customer_ID
JOIN LOYALTY_TIER lt_tier ON l.tier_id = lt_tier.tier_id
JOIN LOYALTY_TRANSACTION lt_txn ON l.loyalty_ID = lt_txn.loyalty_ID
JOIN REASON rn           ON lt_txn.reason_id = rn.reason_id
WHERE c.Customer_ID = 1
ORDER BY lt_txn.created_at DESC
LIMIT 20;
```

**צילום הרצה:**

![S7 — הרצה](images/s7_run.png)

**צילום תוצאה:**

![S7 — תוצאה](images/s7_result.png)

---

### S8 — דירוג החודשים העמוסים ביותר (מגמות עונתיות)

**תיאור:** השאילתא מדרגת חודשים לפי סך האורחים שהתארחו לאורך כל השנים, וחושפת דפוסים עונתיים לצורך תכנון קיבולת. השאילתא משתמשת בפונקציית חלון RANK() לדירוג חודשים בתוך כל שנה.

```sql
SELECT
    EXTRACT(YEAR FROM r.datetime)            AS res_year,
    EXTRACT(MONTH FROM r.datetime)           AS res_month,
    COUNT(r.reservation_ID)                  AS total_reservations,
    SUM(r.party_size)                        AS total_guests,
    ROUND(AVG(r.party_size), 1)              AS avg_party_size,
    RANK() OVER (
        PARTITION BY EXTRACT(YEAR FROM r.datetime)
        ORDER BY SUM(r.party_size) DESC
    )                                        AS month_rank_by_guests
FROM RESERVATION r
JOIN STATUS_TYPE st ON r.status_ID = st.status_ID
WHERE st.description IN ('Confirmed', 'Completed')
GROUP BY
    EXTRACT(YEAR FROM r.datetime),
    EXTRACT(MONTH FROM r.datetime)
ORDER BY res_year DESC, month_rank_by_guests ASC;
```

**צילום הרצה:**

![S8 — הרצה](images/s8_run.png)

**צילום תוצאה:**

![S8 — תוצאה](images/s8_result.png)

---

## שלב ב — שאילתות DELETE

---

### D1 — מחיקת רשומות רשימת המתנה שפגו תוקף (מעל שנה)

**תיאור:** מחיקת רשומות רשימת המתנה בסטטוס 'Expired' שישנות מעל שנה. שומרת על טבלת רשימת ההמתנה רזה ויעילה.

```sql
DELETE FROM WAITLIST
WHERE status_ID = (SELECT status_ID FROM STATUS_TYPE WHERE description = 'Expired')
  AND request_time < CURRENT_DATE - INTERVAL '1 year';
```

**צילום מסד הנתונים לפני המחיקה:**

![D1 — לפני](images/d1_before.png)

**צילום הרצה:**

![D1 — הרצה](images/d1_run.png)

**צילום מסד הנתונים אחרי המחיקה:**

![D1 — אחרי](images/d1_after.png)

---

### D2 — מחיקת הזמנות שבוטלו לפני יותר משנתיים

**תיאור:** תחילה מוחקת משוב המקושר להזמנות שבוטלו לפני מעל שנתיים, ואז מוחקת את ההזמנות עצמן. מכבדת אילוצי Foreign Key על ידי מחיקת רשומות ילד תחילה.

```sql
-- שלב 1: מחיקת משוב המקושר להזמנות ישנות שבוטלו
DELETE FROM FEEDBACK
WHERE reservation_ID IN (
    SELECT r.reservation_ID
    FROM RESERVATION r
    JOIN STATUS_TYPE st ON r.status_ID = st.status_ID
    WHERE st.description = 'Cancelled'
      AND r.datetime < CURRENT_DATE - INTERVAL '2 years'
);

-- שלב 2: מחיקת ההזמנות הישנות שבוטלו עצמן
DELETE FROM RESERVATION
WHERE status_ID = (SELECT status_ID FROM STATUS_TYPE WHERE description = 'Cancelled')
  AND datetime < CURRENT_DATE - INTERVAL '2 years';
```

**צילום מסד הנתונים לפני המחיקה:**

![D2 — לפני](images/d2_before.png)

**צילום הרצה:**

![D2 — הרצה](images/d2_run.png)

**צילום מסד הנתונים אחרי המחיקה:**

![D2 — אחרי](images/d2_after.png)

---

### D3 — מחיקת עסקאות נאמנות ללקוחות מושבתים עם אפס נקודות

**תיאור:** מסירה רשומות עסקאות נאמנות עבור לקוחות שהושבתו (is_active = 0) ויש להם אפס נקודות. רשומות אלו אינן רלוונטיות עוד לפעולה.

```sql
DELETE FROM LOYALTY_TRANSACTION
WHERE loyalty_ID IN (
    SELECT l.loyalty_ID
    FROM LOYALTY l
    JOIN CUSTOMER c ON l.Customer_ID = c.Customer_ID
    WHERE c.is_active = 0
      AND l.points = 0
);
```

**צילום מסד הנתונים לפני המחיקה:**

![D3 — לפני](images/d3_before.png)

**צילום הרצה:**

![D3 — הרצה](images/d3_run.png)

**צילום מסד הנתונים אחרי המחיקה:**

![D3 — אחרי](images/d3_before.png)

---

## שלב ב — שאילתות UPDATE

---

### U1 — שדרוג אוטומטי של רמת נאמנות לפי נקודות

**תיאור:** מעדכנת אוטומטית את רמת הנאמנות של כל לקוח בהתאם ליתרת הנקודות שלו: Bronze (0–2500), Silver (2501–5000), Gold (5001–7500), Platinum (7501+).

```sql
UPDATE LOYALTY
SET tier_id = CASE
    WHEN points <= 2500 THEN (SELECT tier_id FROM LOYALTY_TIER WHERE level = 'Bronze')
    WHEN points <= 5000 THEN (SELECT tier_id FROM LOYALTY_TIER WHERE level = 'Silver')
    WHEN points <= 7500 THEN (SELECT tier_id FROM LOYALTY_TIER WHERE level = 'Gold')
    ELSE                     (SELECT tier_id FROM LOYALTY_TIER WHERE level = 'Platinum')
END,
last_Updated = CURRENT_DATE;
```

**צילום מסד הנתונים לפני העדכון:**

![U1 — לפני](images/u1_before.png)

**צילום הרצה:**

![U1 — הרצה](images/u1_run.png)

**צילום מסד הנתונים אחרי העדכון:**

![U1 — אחרי](images/u1_after.png)

---

### U2 — סימון הזמנות שאושרו בעבר כ-Completed

**תיאור:** מעדכנת אוטומטית הזמנות שתאריכן כבר עבר ועדיין מסומנות 'Confirmed' לסטטוס 'Completed'.

```sql
UPDATE RESERVATION
SET status_ID = (SELECT status_ID FROM STATUS_TYPE WHERE description = 'Completed')
WHERE datetime < CURRENT_DATE
  AND status_ID = (SELECT status_ID FROM STATUS_TYPE WHERE description = 'Confirmed');
```

**צילום מסד הנתונים לפני העדכון:**

![U2 — לפני](images/u2_before.png)

**צילום הרצה:**

![U2 — הרצה](images/u2_run.png)

**צילום מסד הנתונים אחרי העדכון:**

![U2 — אחרי](images/u2_after.png)

---

### U3 — השבתת לקוחות לא פעילים (ללא הזמנה מעל שנתיים)

**תיאור:** מגדירה is_active = 0 ללקוחות שלא ביצעו הזמנה מעל שנתיים. משתמשת בשאילתת-משנה NOT EXISTS לבדיקת פעילות אחרונה.

```sql
UPDATE CUSTOMER
SET is_active = 0
WHERE is_active = 1
  AND NOT EXISTS (
    SELECT 1
    FROM RESERVATION r
    WHERE r.Customer_ID = CUSTOMER.Customer_ID
      AND r.datetime >= CURRENT_DATE - INTERVAL '2 years'
  );
```

**צילום מסד הנתונים לפני העדכון:**

![U3 — לפני](images/u3_before.png)

**צילום הרצה:**

![U3 — הרצה](images/u3_run.png)

**צילום מסד הנתונים אחרי העדכון:**

![U3 — אחרי](images/u3_before.png)

---

## שלב ב — אילוצים (Constraints)

---

### אילוץ 1 — תאריך הזמנה חייב להיות לאחר תאריך היצירה

**תיאור השינוי:** הוספת אילוץ CHECK על טבלת RESERVATION המבטיח שהתאריך המתוכנן לסעודה (datetime) חייב להיות שווה או מאוחר יותר מתאריך יצירת ההזמנה (created_at). זה מונע יצירת הזמנות לתאריכים שכבר עברו יחסית לרגע היצירה.

```sql
ALTER TABLE RESERVATION
ADD CONSTRAINT chk_reservation_future_date
CHECK (datetime >= created_at);
```

**ניסיון הכנסת נתונים סותרים (ושגיאת הרצה):**

```sql
-- ניסיון ליצור הזמנה עם datetime לפני created_at — צפוי להיכשל
INSERT INTO RESERVATION (reservation_ID, Customer_ID, status_ID, party_size, datetime, created_at)
VALUES (99999, 1, 1, 4, '2023-01-01 12:00:00', '2025-06-01 10:00:00');
```

![אילוץ 1 — שגיאה](images/constraint1_error.png)

---

### אילוץ 2 — תגובת משוב חייבת להיות בעלת משמעות (לפחות 4 תווים)

**תיאור השינוי:** הוספת אילוץ CHECK על טבלת FEEDBACK המבטיח שאם לקוח משאיר תגובה, היא חייבת להכיל לפחות 4 תווים (לאחר חיתוך רווחים). תגובות כמו "Ok", "No" או שגיאות הקלדה של אות אחת נדחות. ערך NULL מותר (הלקוח לא חייב להשאיר תגובה).

```sql
ALTER TABLE FEEDBACK
ADD CONSTRAINT chk_meaningful_comment
CHECK (comment IS NULL OR LENGTH(TRIM(comment)) >= 4);
```

**ניסיון הכנסת נתונים סותרים (ושגיאת הרצה):**

```sql
-- ניסיון להכניס משוב עם תגובה קצרה מדי — צפוי להיכשל
INSERT INTO FEEDBACK (feedback_ID, reservation_ID, rating, comment, feedback_date)
VALUES (99999, 1, 5, 'Ok', CURRENT_DATE);
```

![אילוץ 2 — שגיאה](images/constraint2_error.png)

---

### אילוץ 3 — שם פרטי ושם משפחה לא יכולים להיות זהים

**תיאור השינוי:** הוספת אילוץ CHECK על טבלת CUSTOMER המבטיח ששם פרטי ושם משפחה של לקוח לא יהיו זהים (בהשוואה case-insensitive). מצב כזה מעיד בדרך כלל על שגיאת הזנת נתונים (למשל "John John").

```sql
ALTER TABLE CUSTOMER
ADD CONSTRAINT chk_names_different
CHECK (LOWER(first_name) <> LOWER(last_name));
```

**ניסיון הכנסת נתונים סותרים (ושגיאת הרצה):**

```sql
-- ניסיון להכניס לקוח עם שם פרטי ומשפחה זהים — צפוי להיכשל
INSERT INTO CUSTOMER (Customer_ID, first_name, last_name, phone, email, created_at, is_active)
VALUES (99999, 'John', 'John', '0501234567', 'john@example.com', CURRENT_DATE, 1);
```

![אילוץ 3 — שגיאה](images/constraint3_error.png)

---

## שלב ב — Rollback ו-Commit

---

### דוגמה 1: ROLLBACK — עדכון נקודות נאמנות וביטול השינוי

**תרחיש:** מנהל מוסיף בטעות 9999 נקודות לחשבון הנאמנות של לקוח 1. נציג את השינוי, ואז נבצע ROLLBACK לביטולו.

**שלב 1 — מצב BEFORE (לפני השינוי):**

```sql
SELECT c.first_name || ' ' || c.last_name AS customer_name, l.points, lt.level AS tier
FROM CUSTOMER c
JOIN LOYALTY l       ON c.Customer_ID = l.Customer_ID
JOIN LOYALTY_TIER lt ON l.tier_id = lt.tier_id
WHERE c.Customer_ID = 1;
```

![Rollback — שלב 1 (Before)](images/rollback_step1.png)


**שלב 2 — פתיחת טרנזקציה וביצוע UPDATE:**

```sql
BEGIN;

UPDATE LOYALTY
SET points = 9999, last_Updated = CURRENT_DATE
WHERE Customer_ID = 1;
```

**שלב 3 — מצב AFTER (לאחר העדכון, לפני Rollback):**

```sql
SELECT c.first_name || ' ' || c.last_name AS customer_name, l.points, lt.level AS tier
FROM CUSTOMER c
JOIN LOYALTY l       ON c.Customer_ID = l.Customer_ID
JOIN LOYALTY_TIER lt ON l.tier_id = lt.tier_id
WHERE c.Customer_ID = 1;
```

![Rollback — שלב 3 (After Update)](images/rollback_step3.png)

**שלב 4 — ביצוע ROLLBACK:**

```sql
ROLLBACK;
```

**שלב 5 — מצב RESTORED (לאחר הביטול):**

```sql
SELECT c.first_name || ' ' || c.last_name AS customer_name, l.points, lt.level AS tier
FROM CUSTOMER c
JOIN LOYALTY l       ON c.Customer_ID = l.Customer_ID
JOIN LOYALTY_TIER lt ON l.tier_id = lt.tier_id
WHERE c.Customer_ID = 1;
```

![Rollback — שלב 5 (Restored)](images/rollback_step5.png)

---

### דוגמה 2: COMMIT — עדכון סטטוס הזמנה ושמירת השינוי

**תרחיש:** מארח מאשר הזמנה ממתינה (ID = 1). נעדכן את הסטטוס ל-'Confirmed', נבצע COMMIT ונוודא שהשינוי נשמר.

**שלב 1 — מצב BEFORE (לפני השינוי):**

```sql
SELECT r.reservation_ID, c.first_name || ' ' || c.last_name AS customer_name,
       r.datetime, r.party_size, st.description AS status
FROM RESERVATION r
JOIN CUSTOMER c     ON r.Customer_ID = c.Customer_ID
JOIN STATUS_TYPE st ON r.status_ID = st.status_ID
WHERE r.reservation_ID = 1;
```

![Commit — שלב 1 (Before)](images/commit_step1.png)

**שלב 2 — פתיחת טרנזקציה וביצוע UPDATE:**

```sql
BEGIN;


UPDATE RESERVATION
SET status_ID = (SELECT status_ID FROM STATUS_TYPE WHERE description = 'Confirmed')
WHERE reservation_ID = 1;
```

**שלב 3 — מצב AFTER (לאחר העדכון, לפני Commit):**

```sql
SELECT r.reservation_ID, c.first_name || ' ' || c.last_name AS customer_name,
       r.datetime, r.party_size, st.description AS status
FROM RESERVATION r
JOIN CUSTOMER c     ON r.Customer_ID = c.Customer_ID
JOIN STATUS_TYPE st ON r.status_ID = st.status_ID
WHERE r.reservation_ID = 1;
```

![Commit — שלב 3 (After Update)](images/commit_step3.png)

**שלב 4 — ביצוע COMMIT:**

```sql
COMMIT;
```

**שלב 5 — מצב FINAL (לאחר ה-Commit — השינוי קבוע):**

```sql
SELECT r.reservation_ID, c.first_name || ' ' || c.last_name AS customer_name,
       r.datetime, r.party_size, st.description AS status
FROM RESERVATION r
JOIN CUSTOMER c     ON r.Customer_ID = c.Customer_ID
JOIN STATUS_TYPE st ON r.status_ID = st.status_ID
WHERE r.reservation_ID = 1;
```

![Commit — שלב 5 (Final)](images/commit_step3.png)

---

## שלב ב — אינדקסים (Indexes)

---

### אינדקס 1 — `idx_reservation_customer` על RESERVATION(Customer_ID)

**תיאור:** שאילתות SELECT רבות (S1, S2, S3, S6, S7, S8) מבצעות JOIN בין RESERVATION ל-CUSTOMER. אינדקס על Customer_ID מאיץ את חיפוש ההתאמות.

```sql
CREATE INDEX IF NOT EXISTS idx_reservation_customer
ON RESERVATION (Customer_ID);
```

**זמן ריצה לפני הוספת האינדקס:**

![אינדקס 1 — לפני](images/index1_before.png)

**זמן ריצה לאחר הוספת האינדקס:**

![אינדקס 1 — אחרי](images/index1_after.png)

---

### אינדקס 2 — `idx_reservation_datetime` על RESERVATION(datetime)

**תיאור:** שאילתות S1, S6, S8, ו-U2 כולן מסננות או מקבצות לפי תאריך ההזמנה (datetime). אינדקס על עמודה זו משפר את ביצועי GROUP BY וסריקות טווח (range scans).

```sql
CREATE INDEX IF NOT EXISTS idx_reservation_datetime
ON RESERVATION (datetime);
```

**זמן ריצה לפני הוספת האינדקס:**

![אינדקס 2 — לפני](images/index2_before.png)

**זמן ריצה לאחר הוספת האינדקס:**

![אינדקס 2 — אחרי](images/index2_after.png)

---

### אינדקס 3 — `idx_loyalty_txn_created` על LOYALTY_TRANSACTION(created_at)

**תיאור:** שאילתא S4 מקבצת לפי EXTRACT(YEAR/QUARTER) מ-created_at. אינדקס על עמודה זו מאיץ את האגרגציה מבוססת התאריך.

```sql
CREATE INDEX IF NOT EXISTS idx_loyalty_txn_created
ON LOYALTY_TRANSACTION (created_at);
```

**זמן ריצה לפני הוספת האינדקס:**

![אינדקס 3 — לפני](images/index3_before.png)

**זמן ריצה לאחר הוספת האינדקס:**

![אינדקס 3 — אחרי](images/index3_after.png)

---

### הסבר תוצאות האינדקסים

האינדקסים משפיעים על ביצועים בכך שהם מאפשרים למנוע מסד הנתונים לגשת ישירות לשורות הרלוונטיות במקום לבצע **Full Table Scan** (סריקה מלאה של הטבלה). ללא אינדקס, מנוע ה-DB חייב לעבור על כל שורה בטבלה כדי למצוא התאמות. עם אינדקס, הוא משתמש במבנה נתונים מסוג **B-Tree** שמאפשר חיפוש לוגריתמי (O(log n)) במקום ליניארי (O(n)).

בפרט:
- **אינדקס על Customer_ID:** מאיץ פעולות JOIN כי ה-DB יכול לאתר את כל ההזמנות של לקוח מסוים ללא סריקת הטבלה המלאה.
- **אינדקס על datetime:** מאיץ שאילתות עם סינון טווח תאריכים ו-GROUP BY, כי הנתונים כבר ממוינים באינדקס.
- **אינדקס על created_at:** מאיץ את פירוק התאריך (EXTRACT) ב-GROUP BY, כי ה-DB יכול לסרוק את האינדקס בסדר כרונולוגי.

> **הערה:** השיפור בולט יותר ככל שהטבלה גדולה יותר. עם כ-40,000+ רשומות, ההבדל בזמני הריצה ניכר.

---

# שלב ג — אינטגרציה בין מערכות (Customer DB & Orders DB)

## תתרשימי הDSD ERD
![ERD](images/combined.png)
![DSD](images/combinedDSD.png)

## החלטות שנעשו בשלב האינטגרציה
1. **שימוש ב-Foreign Data Wrapper (FDW):** במקום לאחד את המסדים למסד אחד ולשבור את ארכיטקטורת המיקרו-שירותים, הוחלט להשתמש ב-FDW המאפשר לשאילתות במסד הלקוחות לגשת לנתונים במסד ההזמנות מרחוק.
2. **מודל הרשאות מוגבל (Least Privilege):** הוחלט ליצור משתמש ייעודי לקריאה בלבד (`customer_team_reader`) במסד ההזמנות. משתמש זה קיבל הרשאה אך ורק לעמודות שאינן רגישות (לדוגמה, הסתרת עמודת `tax` במסך הלקוחות).
3. **קשר לוגי (Soft Key) ומחיקות רכות (Soft Deletes):** מכיוון שלא ניתן לאכוף Foreign Key פיזי בין מסדים שונים, הוגדר קשר לוגי בין `customer_id` שבטבלת ה-ORDER לטבלת ה-CUSTOMER. כדי להבטיח שלמות נתונים, הוספנו מנגנון "מחיקה רכה" בעזרת טריגר המעדכן את עמודת `deleted_at` ומונע מחיקה פיזית של לקוחות, וכך נמנע יצירת יתומים (Orphans). 
4. **הזנת נתונים חסרים (Backfill):** נמצאו הזמנות יתומות במסד ההזמנות שלא היה להן לקוח מתאים. הוחלט ליצור סקריפט אוטומטי שממלא נתוני לקוחות "דמי" (Dummy) כדי לתקן את ימות הנתונים ההיסטוריים.

## הסבר מילולי של התהליך והפקודות
תהליך האינטגרציה חולק למספר שלבים שנשמרו בקובץ `Integrate.sql`:

1. **הגדרת החיבור:** הרצת הפקודות במסד הלקוחות כדי להגדיר את שרת ההזמנות כיעד:
```sql
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER orders_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'db2', port '5432', dbname 'Orders_db2');
```

2. **ייבוא סכמות:** ייבוא הטבלאות ממסד ההזמנות לתוך סכמה חדשה במסד הלקוחות:
```sql
CREATE SCHEMA IF NOT EXISTS remote_orders;

IMPORT FOREIGN SCHEMA public
FROM SERVER orders_server INTO remote_orders;
```

3. **אבטחה:** הרצת הרשאות קריאה ספציפיות במסד ההזמנות, ולאחר מכן הגדרת מיפוי משתמשים במסד הלקוחות:
**במסד ההזמנות (Provider):**
```sql
CREATE USER customer_team_reader WITH PASSWORD 'reader_pass';
GRANT USAGE ON SCHEMA public TO customer_team_reader;
GRANT SELECT (order_id, table_id, customer_id, order_time, order_status) ON "ORDER" TO customer_team_reader;
GRANT SELECT (bill_id, order_id, final_amount, bill_time) ON bill TO customer_team_reader;
```
**במסד הלקוחות (Consumer):**
```sql
CREATE USER MAPPING FOR "MyUser"
SERVER orders_server
OPTIONS (user 'customer_team_reader', password 'reader_pass');
```

4. **טריגר למחיקה רכה:** הוספת עמודת `deleted_at` לטבלת הלקוחות והפעלת פונקציית טריגר המונעת מחיקה פיזית ומונעת הזמנות יתומות:
```sql
ALTER TABLE customer ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP NULL;

CREATE OR REPLACE FUNCTION soft_delete_customer()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE customer 
    SET deleted_at = CURRENT_TIMESTAMP, is_active = 0 
    WHERE customer_id = OLD.customer_id;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_soft_delete_customer ON customer;
CREATE TRIGGER trigger_soft_delete_customer
BEFORE DELETE ON customer
FOR EACH ROW EXECUTE FUNCTION soft_delete_customer();
```

## מבטים ושאילתות (Views & Queries)

### מבט 1: סיכום נאמנות לקוחות (מנקודת המבט של מחלקת הלקוחות המקורית)
**תיאור:** מבט המחבר בין טבלת `customer` לטבלת `loyalty` (שתי טבלאות מקומיות במסד הלקוחות). מציג את נתוני הקשר של הלקוח יחד עם הסטטוס הפעיל שלו, סך הנקודות והרמה שלו.
**קוד יצירת המבט:**
```sql
CREATE OR REPLACE VIEW v_customer_loyalty_summary AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    l.points,
    l.tier_id,
    c.is_active
FROM customer c
JOIN loyalty l ON c.customer_id = l.customer_id;
```
**שליפת נתונים:**
```sql
SELECT * FROM v_customer_loyalty_summary LIMIT 10;
```
![alt text](images/view1.png)

#### שאילתא 1.1: מציאת לקוחות פעילים עם מעל 100 נקודות
**תיאור:** מסננת את המבט ומציגה רק לקוחות שהם פעילים וצברו מעל 100 נקודות נאמנות.
**קוד השאילתא:**
```sql
SELECT first_name, last_name, points 
FROM v_customer_loyalty_summary 
WHERE points > 100 AND is_active = 1;
```
**פלט:** מציגה רשימת שמות ונקודות.
![alt text](images/view1-1.png)

#### שאילתא 1.2: חישוב ממוצע נקודות לפי רמה
**תיאור:** מבצעת קיבוץ (GROUP BY) על המבט כדי לחשב את ממוצע הנקודות בכל רמת נאמנות (tier_id).
**קוד השאילתא:**
```sql
SELECT tier_id, AVG(points) as avg_points 
FROM v_customer_loyalty_summary 
GROUP BY tier_id 
ORDER BY tier_id;
```
**פלט:** מציגה מזהה רמה וממוצע נקודות.
![alt text](images/view1-2.png)

---

### מבט 2: סיכום חשבונות הזמנה (מנקודת המבט של מחלקת ההזמנות)
**תיאור:** מבט המחבר בין טבלת `ORDER` לטבלת `bill` (שתיהן ממסד ההזמנות). מספק סיכום של סטטוס ההזמנה, התשלום הכולל, הנחות והסכום הסופי לתשלום.
**קוד יצירת המבט:**
```sql
CREATE OR REPLACE VIEW v_order_billing_summary AS
SELECT 
    o.order_id,
    o.order_status,
    o.order_time,
    b.total_amount,
    b.discount_amount,
    b.final_amount
FROM "ORDER" o
JOIN bill b ON o.order_id = b.order_id;

```
**שליפת נתונים:**
```sql
SELECT * FROM v_order_billing_summary LIMIT 10;
```
![alt text](images/view2.png)

#### שאילתא 2.1: ממוצע סכום סופי להזמנות שהושלמו
**תיאור:** מפעילה פונקציית אגרגציה על המבט כדי למצוא את ההכנסה הממוצעת להזמנה מתוך אלו שהושלמו בהצלחה.
**קוד השאילתא:**
```sql
SELECT AVG(final_amount) as avg_completed_amount 
FROM v_order_billing_summary 
WHERE order_status = 'Completed';
```
**פלט:** מציגה ערך ממוצע כספי.
![alt text](images/view2-1.png)


#### שאילתא 2.2: איתור הזמנות עם הנחות
**תיאור:** מסננת את המבט ומציגה רק הזמנות שבהן סכום ההנחה (discount_amount) גדול מאפס.
**קוד השאילתא:**
```sql
SELECT order_id, total_amount, discount_amount, final_amount 
FROM v_order_billing_summary 
WHERE discount_amount > 0;
```
**פלט:** מציגה את פרטי החשבון המלאים להזמנות המוזלות.

---

### מבט 3: היסטוריית הזמנות לקוח (שילוב בין-מחלקתי - אינטגרציה)
**תיאור:** מבט המדגים את האינטגרציה המוצלחת! הוא מחבר את טבלת `customer` (ממסד הלקוחות) עם טבלת `remote_orders."ORDER"` (ממסד ההזמנות המרוחק דרך ה-FDW). מציג אילו לקוחות ביצעו אילו הזמנות בזמן אמת.
**קוד יצירת המבט:**
```sql
CREATE OR REPLACE VIEW v_cross_db_customer_orders AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_status,
    o.order_time
FROM customer c
JOIN remote_orders."ORDER" o ON c.customer_id = o.customer_id;
```
**שליפת נתונים:**
```sql
SELECT * FROM v_cross_db_customer_orders LIMIT 10;
```
![alt text](images/view3.png)

#### שאילתא 3.1: ספירת הזמנות לכל לקוח
**תיאור:** מבצעת קיבוץ על בסיס שם הלקוח וסופרת כמה הזמנות קיימות על שמו במערכת ההזמנות המרוחקת.
**קוד השאילתא:**
```sql
SELECT first_name, last_name, COUNT(order_id) as total_orders 
FROM v_cross_db_customer_orders 
GROUP BY first_name, last_name 
ORDER BY total_orders DESC;
```
**פלט:** מציגה רשימת לקוחות וסך ההזמנות שביצעו.
![alt text](images/view3-1.png)

#### שאילתא 3.2: איתור לקוחות עם הזמנות מבוטלות
**תיאור:** שולפת מתוך המבט את שמות הלקוחות שסטטוס ההזמנה שלהם במערכת המרוחקת הוגדר כ-'Cancelled'. משתמשת ב-DISTINCT כדי למנוע כפילויות.
**קוד השאילתא:**
```sql
SELECT DISTINCT first_name, last_name 
FROM v_cross_db_customer_orders 
WHERE order_status = 'Cancelled';
```
**פלט:** מציגה שמות לקוחות שיש להם ביטולים.

![alt text](images/view3-2.png)

---

# שלב ד — תכנות (PL/pgSQL Programming)

בשלב זה נתנסה בכתיבת תוכניות PL/pgSQL על טבלאות בסיס הנתונים שלנו. התוכניות אינן טרוויאליות וכוללות פונקציות, פרוצדורות, טריגרים ותוכניות ראשיות (Routines).

להלן פירוט של שתי התוכניות הראשיות (Main Programs) שפותחו במסגרת שלב זה:

### תוכנית ראשית 1: שגרת תחזוקה יומית (Daily Maintenance Routine)

**תיאור השגרה:**
שגרה זו משמשת לביצוע פעולות תחזוקה יומיות במערכת הלקוחות והנאמנות. היא מבצעת שתי פעולות עיקריות:
1. **חישוב ציון משוב ממוצע:** היא מזמנת את הפונקציה `fn_calculate_avg_feedback_score(p_customer_id)` עבור לקוח מספר 1, המחשבת בצורה דינמית את ממוצע הציונים שהלקוח נתן במשובים שלו בעזרת סמן מפורש (Explicit Cursor) מפרמטר.
2. **עיבוד והענקת תגמולי נאמנות:** היא מזמנת את הפרוצדורה `pr_process_loyalty_rewards()` הסורקת את הלקוחות הפעילים בעזרת סמן (Cursor), ומזהה לקוחות שביצעו מעל 3 הזמנות אך צברו פחות מ-500 נקודות. לקוחות אלו משודרגים ב-100 נקודות בונוס והעסקה מתועדת בטבלת היסטוריית התנועות.

**קוד התוכנית הראשית (`Maintenance_Routine.sql`):**
```sql
DO $$ 
DECLARE
    v_avg_score NUMERIC;
BEGIN
    RAISE NOTICE 'Starting Daily Maintenance Job...';
    
    -- Call Function 2
    v_avg_score := fn_calculate_avg_feedback_score(1);
    RAISE NOTICE 'Customer 1 Avg Feedback Score: %', v_avg_score;
    
    -- Call Procedure 1
    CALL pr_process_loyalty_rewards();
    RAISE NOTICE 'Loyalty rewards processed successfully.';
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Maintenance Job Failed: %', SQLERRM;
END $$;
```

---

### תוכנית ראשית 2: שגרת הפקת דוחות ופינוי תורים (Reporting Routine)

**תיאור השגרה:**
שגרה זו מיועדת להרצה תקופתית עבור הפקת דוחות אינטגרטיביים וטיפול ברשומות פגות תוקף ברשימת ההמתנה. היא מבצעת שתי פעולות עיקריות:
1. **טיפול בתורים פגי תוקף:** היא מזמנת את הפרוצדורה `pr_resolve_stale_waitlist()` שמאתרת רשומות ברשימת ההמתנה (Waitlist) שהסטטוס שלהן הוא "Waiting" והן ממתינות מעל שעתיים. הפרוצדורה מעבירה את הסטטוס שלהן ל-"Expired" ומפצה את הלקוחות ב-50 נקודות נאמנות כפיצוי על ההמתנה הממושכת.
2. **הפקת דוח הזמנות חוצה-מסדים (אינטגרטיבי):** היא מזמנת את הפונקציה `fn_get_customer_remote_orders(p_customer_id)` שמחזירה סמן התייחסות (`REFCURSOR`) המצביע על רשימת ההזמנות של הלקוח ממסד הנתונים המרוחק (`Orders_DB`) דרך ה-FDW. התוכנית הראשית פותחת את הסמן בתוך הטרנזקציה, רצה בלולאה על התוצאות, מדפיסה את פרטי כל הזמנה וסכומה הסופי, וסוגרת את הסמן בצורה מבוקרת.

**קוד התוכנית הראשית (`Reporting_Routine.sql`):**
```sql
DO $$ 
DECLARE
    v_refcursor refcursor;
    v_order_record RECORD;
BEGIN
    RAISE NOTICE 'Starting Customer Report Generation...';
    
    -- Call Procedure 2
    CALL pr_resolve_stale_waitlist();
    RAISE NOTICE 'Stale waitlists resolved.';
    
    -- Architecture Note: Strict transaction boundary maintained for Ref Cursor
    -- Call Function 1
    v_refcursor := fn_get_customer_remote_orders(1);
    
    RAISE NOTICE 'Remote Orders for Customer 1:';
    LOOP
        FETCH v_refcursor INTO v_order_record;
        EXIT WHEN NOT FOUND;
        
        RAISE NOTICE 'Order ID: %, Status: %, Final Amount: %', 
                     v_order_record.order_id, 
                     v_order_record.order_status, 
                     v_order_record.final_amount;
    END LOOP;
    
    CLOSE v_refcursor;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Report Generation Failed: %', SQLERRM;
END $$;
```

