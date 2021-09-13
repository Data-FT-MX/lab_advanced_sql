-- Challenge 1 - Most Profiting Authors  Autores más lucrativos

-- FIRST

SELECT titleauthor.title_ID, titleauthor.au_id, 
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) "sales_royalty"
FROM titleauthor 
JOIN titles ON titles.title_id = titleauthor.title_id
JOIN authors ON authors.au_id = titleauthor.au_id
JOIN sales ON sales.title_id = titleauthor.title_id
ORDER BY titleauthor.title_id;

-- SECOND
SELECT ro.title_ID, ro.au_id, SUM(sales_royalty) "Total Royalties"
FROM (
SELECT titleauthor.title_ID, titleauthor.au_id, 
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) "sales_royalty"
FROM titleauthor 
JOIN titles ON titles.title_id = titleauthor.title_id
JOIN authors ON authors.au_id = titleauthor.au_id
JOIN sales ON sales.title_id = titleauthor.title_id) as ro
group by ro.au_id, ro.title_id;

-- THIRD
SELECT ro.au_id, SUM(sales_royalty) "All_Royalties"
FROM (
SELECT titleauthor.title_ID, titleauthor.au_id, 
(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) "sales_royalty"
FROM titleauthor 
JOIN titles ON titles.title_id = titleauthor.title_id
JOIN authors ON authors.au_id = titleauthor.au_id
JOIN sales ON sales.title_id = titleauthor.title_id) as ro
Group by ro.au_id ORDER BY All_Royalties desc
LIMIT 3;


-- Challenge 2 - Alternative Solution

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

-- Challenge 3

CREATE TABLE publications.most_profiting_authors
SELECT ap.au_id, sum(ap.sales_royalty) + ap.advance profit
FROM author_profit ap
GROUP BY ap.au_id, ap.title_id
ORDER BY profit desc;
