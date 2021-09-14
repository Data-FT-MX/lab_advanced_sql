USE publications;
/* CHALLENGE ONE*/
/* STEP 1 */

DROP TABLE IF EXISTS title_author_royalty;
CREATE TEMPORARY TABLE title_author_royalty
SELECT
ti.title_id AS 'title_id',
au.au_id AS 'au_id',
sa.qty * ti.price * ti.royalty/100 * ta.royaltyper/100 AS 'royalty'
FROM titles ti
JOIN titleauthor ta ON ti.title_id = ta.title_id
JOIN authors au ON ta.au_id = au.au_id
JOIN sales sa ON sa.title_id = ti.title_id;

/* STEP 2 */

DROP TABLE IF EXISTS title_author_total_royalty;
CREATE TEMPORARY TABLE title_author_total_royalty
SELECT
tar.title_id,
tar.au_id,
SUM(tar.royalty) AS 'royalty'
FROM title_author_royalty tar
GROUP BY tar.title_id, tar.au_id;

/* STEP 3 */

SELECT 
tatr.au_id,
SUM(tatr.royalty) + SUM(ti.advance * ta.royaltyper/100) AS 'profit'
FROM title_author_total_royalty tatr
JOIN titles ti ON tatr.title_id = ti.title_id
JOIN titleauthor ta ON ti.title_id = ta.title_id
GROUP BY tatr.au_id
ORDER BY profit DESC LIMIT 3;

/* CHALLENGE TWO*/

CREATE TEMPORARY TABLE publications.author_profit
SELECT ta.au_id, ta.title_id, s.qty, t.price, t.advance, t.royalty, ta.royaltyper, t.price * s.qty * (t.royalty/100) * (ta.royaltyper/100) sales_royalty
FROM titleauthor ta
INNER JOIN titles t on ta.title_id = t.title_id
INNER JOIN sales s on ta.title_id = s.title_id;

SELECT ap.au_id, ap.title_id, sum(ap.sales_royalty) + ap.advance profit
FROM author_profit ap
GROUP BY ap.au_id, ap.title_id
ORDER BY profit DESC
LIMIT 3;

/* CHALLENGE THREE*/

CREATE TABLE publications.most_profiting_authors
SELECT ap.au_id, sum(ap.sales_royalty) + ap.advance profit
FROM author_profit ap
GROUP BY ap.au_id, ap.title_id
ORDER BY profit desc;