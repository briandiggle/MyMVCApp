Namespace WalkingMVC
    Public Class HillController
        Inherits System.Web.Mvc.Controller

        '
        ' GET: /Hill

        Function Index() As ActionResult
            Return View()
        End Function

        '
        ' GET: /Hill/Details/5

        Function Details(ByVal id As Integer) As ActionResult
            Return View()
        End Function

        '
        ' GET: /Hill/Create

        Function Create() As ActionResult

            Return View()
        End Function

        '
        ' POST: /Hill/Create

        <HttpPost()> _
        Function Create(ByVal collection As FormCollection) As ActionResult
            Try

                Return RedirectToAction("Index")
            Catch
                Return View()
            End Try
        End Function

        '
        ' GET: /Hill/Delete/5

        Function Delete(ByVal id As Integer) As ActionResult
            Return View()
        End Function

        '
        ' POST: /Hill/Delete/5

        <HttpPost()> _
        Function Delete(ByVal id As Integer, ByVal collection As FormCollection) As ActionResult
            Try
               
                Return RedirectToAction("Index")
            Catch
                Return View()
            End Try
        End Function

        '
        ' GET: /Hill/Edit/5

        Function Edit(ByVal id As Integer) As ActionResult
            Return View()
        End Function

        '
        ' POST: /Hill/Edit/5

        <HttpPost()> _
        Function Edit(ByVal id As Integer, ByVal collection As FormCollection) As ActionResult
            Try


                Return RedirectToAction("Index")
            Catch
                Return View()
            End Try
        End Function
    End Class
End Namespace