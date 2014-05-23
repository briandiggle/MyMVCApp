CREATE procedure dbo.sp_GetMyProgress
as

declare @sortseq int
declare @classref varchar(5)
declare @classname varchar(30)

set @sortseq=1
set @classref = (select classref from class where sortseq = @sortseq)
set @classname = (select classname from class where sortseq = @sortseq)

create table #myprogress (
NumberClimbed int,
TotalHills int,
ClassRef varchar(5),
ClassName varchar(30) )

while @sortseq is not null
begin

	set @sortseq = (select min(sortseq) from class where sortseq > @sortseq)
	set @classref = (select classref from class where sortseq = @sortseq)
	set @classname = (select classname from class where sortseq = @sortseq)
	
	insert into #myprogress(numberclimbed, totalhills, classref, classname)
	  select 
		(select count(Hillnumber)
		from hills
		where firstclimbeddate is not null
		and hillnumber in ( select hillnumber from classlink where classref=@classref))

		
	, 
		
		(
		select count(Hillnumber)
		from hills
		where  hillnumber in ( select hillnumber from classlink where classref=@classref )
		) 
	,

	@classref,
	@classname

	

end

select * from #myprogress order by classname asc


drop table #myprogress


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[sp_GetMyProgress] TO [guest]
    AS [dbo];

