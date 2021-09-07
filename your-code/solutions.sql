/*-------------------Challenge 1 ---------------------------- */

create temporary table step1
select sl.title_id as 'Title_ID', au.au_id as 'Author_ID', tl.price * sl.qty * (tl.royalty/100) * (tau.royaltyper/100) as 'Royalty', tl.advance as 'Advance'
from publishers.authors au 
inner join publishers.titleauthor tau on au.au_id = tau.au_id
left join  publishers.titles tl on tau.title_id = tl.title_id
left join  publishers.sales sl on  tl.title_id = sl.title_id


;
drop table step1;

create temporary table step2
select Title_ID, Author_ID, sum(Royalty) as 'royalties_each_title', Advance
from step1 
group by Title_ID, Author_ID
;


select*
from step2;

create temporary table step3
select Author_ID, sum(Advance + royalties_each_title) as 'Profits'
from step2 
group by Author_ID
order by Profits desc
limit 3
;


-- Challenge 2 ---------------------------------------
select Author_ID, sum(Advance + royalties_each_title) as 'Profits'
from(
	select Title_ID, Author_ID, sum(Royalty) as 'royalties_each_title', Advance
	from(
		select sl.title_id as 'Title_ID', au.au_id as 'Author_ID', tl.price * sl.qty * (tl.royalty/100) * (tau.royaltyper/100) as 'Royalty', tl.advance as 'Advance'
		from publishers.authors au 
		inner join publishers.titleauthor tau on au.au_id = tau.au_id
		left join  publishers.titles tl on tau.title_id = tl.title_id
		left join  publishers.sales sl on  tl.title_id = sl.title_id
		order by Author_ID desc
	) as stp2
	group by Title_ID, Author_ID) as stp3
    group by Author_ID
order by Profits desc
limit 3
;

-- Challenge 3 -----------------

create table most_profiting_authors
select Author_ID, Profits
from step3 ;

select*
from most_profiting_authors;










