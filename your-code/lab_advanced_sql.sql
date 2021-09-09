/* CHALLENGE 1 */
/* TEMPORARY QUESTIONS */

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

/* CHALLENGE 2 */
/* SUBQUERIES */

SELECT 
	tatr.au_id,
    SUM(tatr.royalty) + SUM(ti.advance * ta.royaltyper/100) AS 'profit'
FROM
	(SELECT
		tar.title_id,
		tar.au_id,
		SUM(tar.royalty) AS 'royalty'
	FROM

		(SELECT
			ti.title_id AS 'title_id',
			au.au_id AS 'au_id',
			sa.qty * ti.price * ti.royalty/100 * ta.royaltyper/100 AS 'royalty'
		FROM titles ti
		JOIN titleauthor ta ON ti.title_id = ta.title_id
		JOIN authors au ON ta.au_id = au.au_id
		JOIN sales sa ON sa.title_id = ti.title_id
        ) AS tar
	GROUP BY tar.title_id, tar.au_id
) AS tatr
JOIN titles ti ON tatr.title_id = ti.title_id
JOIN titleauthor ta ON ti.title_id = ta.title_id
group by tatr.au_id
ORDER BY profit DESC LIMIT 3;

/* CHALLENGE 3 */

CREATE TEMPORARY TABLE most_profiting_authors
SELECT 
	tatr.au_id,
    SUM(tatr.royalty) + SUM(ti.advance * ta.royaltyper/100) AS 'profit'
from title_author_total_royalty tatr
JOIN titles ti ON tatr.title_id = ti.title_id
JOIN titleauthor ta ON ti.title_id = ta.title_id
GROUP BY tatr.au_id
ORDER BY profit DESC;