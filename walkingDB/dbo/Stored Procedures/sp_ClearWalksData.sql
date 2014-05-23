

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ClearWalksData]
AS
BEGIN

delete from  walk_associatedfiles
delete from hillascent
delete from marker_observation
delete from marker
delete from walks
update hills set hillclimbed= 0, hillclimbeddate = null

END


