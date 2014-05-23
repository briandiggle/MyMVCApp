CREATE procedure [dbo].[sp_GetMyProgressByClassType]
@ClassType as char
as

declare @sortseq int
declare @classref varchar(5)
declare @classname varchar(30)

set @sortseq=( select min(sortseq) from class where classtype=@ClassType)
set @classref = (select classref from class where sortseq = @sortseq  and classtype=@ClassType)
set @classname = (select classname from class where sortseq = @sortseq and classtype=@ClassType)

print 'sortseq =' + cast(@sortseq as varchar(5)) + ' classref=' + @classref + ' classname=' + @classname


create table #myprogress (
NumberClimbed int,
TotalHills int,
ClassRef varchar(5),
ClassName varchar(30) )

while @sortseq is not null
begin
	
	insert into #myprogress(NumberClimbed, TotalHills, ClassRef, ClassName)
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

    set @sortseq = (select min(sortseq) from class where sortseq > @sortseq and classtype=@ClassType)
	set @classref = (select classref from class where sortseq = @sortseq and classtype=@ClassType)
	set @classname = (select classname from class where sortseq = @sortseq and classtype=@ClassType)
	
	print 'sortseq =' + cast(@sortseq as varchar(5)) + ' classref=' + @classref + ' classname=' + @classname


end

select * from #myprogress order by classname asc


drop table #myprogress


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[sp_GetMyProgressByClassType] TO [guest]
    AS [dbo];

