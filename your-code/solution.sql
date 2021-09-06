# Challenge 1
select query2.au_id as 'Author ID',query2.au_lname as 'Last Name',query2.au_fname as 'First Name',sum(query2.advance+query2.royalties) as Profit
from(
	select query1.title_id,query1.au_id,query1.au_lname,query1.au_fname,sum(query1.sales_royalty) as royalties,query1.advance
	from(
		select ti.title_id,au.au_id,au.au_lname,au.au_fname,ti.price*sa.qty*ti.royalty/100*tia.royaltyper/100 as sales_royalty,ti.advance
		from publications.titleauthor tia
		left join publications.authors au on tia.au_id=au.au_id
		left join publications.titles ti on tia.title_id=ti.title_id
		left join publications.sales sa on ti.title_id=sa.title_id
	)as query1
	group by query1.title_id,query1.au_id
) as query2
group by query2.au_id
order by profit desc
limit 3;
-- ------------------------------------------------------------------
# Challenge 2
create temporary table publications.table1
select ti.title_id,au.au_id,au.au_lname,au.au_fname,ti.price*sa.qty*ti.royalty/100*tia.royaltyper/100 as sales_royalty,ti.advance
from publications.titleauthor tia
left join publications.authors au on tia.au_id=au.au_id
left join publications.titles ti on tia.title_id=ti.title_id
left join publications.sales sa on ti.title_id=sa.title_id;

create temporary table publications.table2
select title_id,au_id,au_lname,au_fname,sum(sales_royalty) as royalties,advance
from publications.table1
group by title_id,au_id;

create temporary table publications.table3
select au_id,au_lname as 'Last Name',au_fname as 'First Name',sum(advance+royalties) as Profit
from publications.table2
group by au_id
order by profit desc
limit 3;
-- --------------------------------------------------------------------------------------------------------------------------------
# Challenge 3
create table most_profiting_authors
select au_id,Profit
from publications.table3;