select ti.title_id,au.au_id, (ti.price * sa.qty * ti.royalty/100 )* (tia.royaltyper/100),ti.advance as 'Advance'
from lab_select.titleauthor tia
left join lab_select.authors au on tia.au_id=au.au_id
left join lab_select.titles ti on tia.title_id=ti.title_id
left join lab_select.sales sa on ti.title_id=sa.title_id;

select royal.au_id,royal.title_id, sum(royal.royalty) as 'total_royalty', Advance
from(
	select ti.title_id,au.au_id, (ti.price * sa.qty * ti.royalty/100 )* (tia.royaltyper/100) as 'royalty',ti.advance as 'Advance'
	from lab_select.titleauthor tia
	left join lab_select.authors au on tia.au_id=au.au_id
	left join lab_select.titles ti on tia.title_id=ti.title_id
	left join lab_select.sales sa on ti.title_id=sa.title_id) as royal
group by royal.au_id,royal.title_id;

select pro.au_id,sum(pro.Advance + pro.total_royalty) as 'profit'
from(
	select royal.au_id,royal.title_id, sum(royal.royalty) as 'total_royalty', Advance
	from(
		select ti.title_id,au.au_id, (ti.price * sa.qty * ti.royalty/100 )* (tia.royaltyper/100) as 'royalty',ti.advance as 'Advance'
		from lab_select.titleauthor tia
		left join lab_select.authors au on tia.au_id=au.au_id
		left join lab_select.titles ti on tia.title_id=ti.title_id
		left join lab_select.sales sa on ti.title_id=sa.title_id) as royal
	group by royal.au_id,royal.title_id
    ) as pro
group by pro.au_id
order by profit desc
limit 3;


# challenge 3
create table most_profiting_authors
select profit.au_id, profit.profit
from(
	select pro.au_id,sum(pro.Advance + pro.total_royalty) as 'profit'
	from(
		select royal.au_id,royal.title_id, sum(royal.royalty) as 'total_royalty', Advance
		from(
			select ti.title_id,au.au_id, (ti.price * sa.qty * ti.royalty/100 )* (tia.royaltyper/100) as 'royalty',ti.advance as 'Advance'
			from lab_select.titleauthor tia
			left join lab_select.authors au on tia.au_id=au.au_id
			left join lab_select.titles ti on tia.title_id=ti.title_id
			left join lab_select.sales sa on ti.title_id=sa.title_id) as royal
		group by royal.au_id,royal.title_id
		) as pro
	group by pro.au_id
	order by profit desc
	limit 3
    ) as profit;
    
select*
from most_profiting_authors;








