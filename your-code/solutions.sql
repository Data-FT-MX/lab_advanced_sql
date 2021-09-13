/* Challenge 1 */

CREATE TEMPORARY TABLE publications.royalties
SELECT a.au_id, t.title_id, ((ti.price * s.qty * ti.royalty / 100) * (t.royaltyper / 100)) as sales_royalty
FROM publications.authors a 
INNER JOIN publications.titleauthor t ON a.au_id = t.au_id
LEFT JOIN publications.titles ti ON t.title_id = ti.title_id
INNER JOIN publications.sales s ON ti.title_id = s.title_id;

/* Challenge 2 */

CREATE TEMPORARY TABLE publications.total_profits
SELECT r.title_id, r_au_id, sum(r.sales_royalty) as advance
FROM publications.royalties r
GROUP BY r.au_id, r.title_id; 

/* Challenge 2 */
SELECT tp.au_id, tp.advance + tp.sales_royalty as total_profits
FROM publications.total_profits tp
ORDER BY total_profits DESC
LIMIT 3;

/* Challenge 3 */
CREATE TEMPORARY TABLE publications.most_profiting_authors
SELECT tp.au_id, tp.advance + tp.sales_royalty as total_profits
FROM publications.total_profits tp
ORDER BY total_profits DESC;
