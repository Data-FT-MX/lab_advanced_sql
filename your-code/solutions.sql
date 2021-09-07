-- CHALLENGE #1 -------------------------------------------------

# Usamos tablas temporales

USE publications;

-- STEP 1 -----------------------------------------------------
DROP TABLE publications.royalty_autor;

CREATE TEMPORARY TABLE royalty_autor
SELECT au.au_id as 'author_id', ti.title_id as 'title_id',
ti.advance as 'advance',
ti.price * sa.qty * (ti.royalty/100) * (ta.royaltyper/100) as 'royalty_each_autor'
FROM authors au
INNER JOIN titleauthor ta ON au.au_id = ta.au_id
LEFT JOIN titles ti ON ta.title_id = ti.title_id
LEFT JOIN sales sa ON ti.title_id = sa.title_id;

-- STEP 2 -----------------------------------------------------
DROP TABLE publications.total_royalties_title_author;

CREATE TEMPORARY TABLE total_royalties_title_author
SELECT title_id, author_id, advance, SUM(royalty_each_autor) AS 'sum_per_title'
FROM royalty_autor
GROUP BY title_id, author_id;

-- STEP 3 -----------------------------------------------------
#SELECT * FROM total_royalties_title_author;

SELECT author_id, SUM(sum_per_title + advance) as 'profit'
FROM total_royalties_title_author
GROUP BY author_id
ORDER BY profit DESC
LIMIT 3;

-- CHALLENGE #2 -------------------------------------------------

# Usamos subquerys
# Para ello unimos los querys de las tablas temporales en un solo query

SELECT trta.author_id, SUM(trta.sum_per_title + trta.advance) as 'profit'
FROM (
	SELECT ra.title_id, ra.author_id, ra.advance, SUM(ra.royalty_each_autor) AS 'sum_per_title'
	FROM (
		SELECT au.au_id as 'author_id', ti.title_id as 'title_id',
		ti.advance as 'advance',
		ti.price * sa.qty * (ti.royalty/100) * (ta.royaltyper/100) as 'royalty_each_autor'
		FROM authors au
		INNER JOIN titleauthor ta ON au.au_id = ta.au_id
		LEFT JOIN titles ti ON ta.title_id = ti.title_id
		LEFT JOIN sales sa ON ti.title_id = sa.title_id
    ) as ra # royalty_autor
	GROUP BY ra.title_id, ra.author_id
) as trta #total_royalties_title_author
GROUP BY trta.author_id
ORDER BY profit DESC
LIMIT 3;

-- CHALLENGE #3 -------------------------------------------------
DROP TABLE publications.most_profiting_authors;

CREATE TABLE most_profiting_authors
SELECT author_id, SUM(sum_per_title + advance) as 'profit'
FROM total_royalties_title_author
GROUP BY author_id
ORDER BY profit DESC
LIMIT 3;

SELECT * FROM most_profiting_authors;