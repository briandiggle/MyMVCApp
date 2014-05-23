


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeleteWalk]
@WalkID as integer
AS
BEGIN

delete from walk_associatedfiles where walkid=@WalkID
delete from marker where walkid=@WalkID
delete from hillascent where walkid=@WalkID
delete from walks where walkid=@WalkID


END



